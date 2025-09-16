from flask import Flask, jsonify
from flask_cors import CORS
import subprocess
import json

app = Flask(__name__)
CORS(app)

# Updated ScopeId based on your relay setup (LAN subnet)
SCOPE_ID = "192.168.2.0"

def run_powershell(script, args=None):
    """Run PowerShell script and return parsed JSON"""
    try:
        cmd = ["powershell", "-ExecutionPolicy", "Bypass", "-File", script]
        if args:
            cmd.extend(args)
        result = subprocess.check_output(cmd, stderr=subprocess.STDOUT)
        output = result.decode().strip()
        if not output:
            return []
        return json.loads(output)
    except subprocess.CalledProcessError as e:
        return {"error": e.output.decode()}
    except json.JSONDecodeError as e:
        return {"error": f"JSON decode error: {str(e)}"}

@app.route("/api/test", methods=["GET"])
def test():
    return jsonify({"status": "ok"})

@app.route("/api/leases", methods=["GET"])
def get_leases():
    leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [SCOPE_ID])
    return jsonify(leases)

@app.route("/api/scopeinfo", methods=["GET"])
def get_scope_info():
    scope = run_powershell("C:\\dhcp_api\\get_scopeinfo.ps1", [SCOPE_ID])
    # Add active lease count to scopeinfo
    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [SCOPE_ID])
    if isinstance(all_leases, list):
        active_leases = [l for l in all_leases if l.get('AddressState') == 'Active']
        scope['NumberOfLeases'] = len(active_leases)
    else:
        scope['NumberOfLeases'] = 0
    return jsonify(scope)

@app.route("/api/dashboard", methods=["GET"])
def get_dashboard():
    scope = run_powershell("C:\\dhcp_api\\get_scopeinfo.ps1", [SCOPE_ID])
    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [SCOPE_ID])

    # Active leases
    if isinstance(all_leases, list):
        active_leases = [l for l in all_leases if l.get('AddressState') == 'Active']
        active_count = len(active_leases)
        sample = active_leases[:3]
    else:
        active_count = 0
        sample = []

    # Pool size & range
    pool_size = 0
    pool_range = {"start": "", "end": ""}
    if isinstance(scope, dict):
        pool_size = scope.get("PoolSize", 0)

        pool_start = scope.get("PoolStart", {}).get("IPAddressToString")
        pool_end = scope.get("PoolEnd", {}).get("IPAddressToString")
        if pool_start and pool_end:
            pool_range = {"start": pool_start, "end": pool_end}

    # Active scope with CIDR mask if possible
    active_scope = SCOPE_ID + "/24"
    if isinstance(scope, dict):
        subnet_mask = scope.get("SubnetMask", {}).get("IPAddressToString")
        scope_id = scope.get("ScopeId", {}).get("IPAddressToString")
        if subnet_mask and scope_id:
            # Convert subnet mask (e.g. 255.255.255.0) -> prefix length (/24)
            bit_count = sum(bin(int(x)).count("1") for x in subnet_mask.split("."))
            active_scope = f"{scope_id}/{bit_count}"

    dashboard = {
        "serverStatus": "Online" if active_count > 0 or pool_size > 0 else "Offline",
        "activeScope": active_scope,
        "gateway": scope.get("Gateway", "") if isinstance(scope, dict) else "",
        "numberOfLeases": active_count,
        "poolSize": pool_size,
        "poolRange": pool_range,   # <--- NEW
        "sample": sample           # <--- keep some sample leases if needed
    }
    return jsonify(dashboard)

@app.route("/api/relay", methods=["GET"])
def get_relay():
    # Hardcoded based on your ipconfig/setup (adjust if dynamic)
    relay_ip = "192.168.2.1"  # Relay agent's LAN IP (giaddr)
    remote_dhcp_ip = "192.168.1.201"  # DHCP server's relay-facing IP

    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [SCOPE_ID])
    if isinstance(all_leases, list):
        active_leases = [l for l in all_leases if l.get('AddressState') == 'Active']
        client_macs = [l.get('ClientId', '') for l in active_leases]
    else:
        client_macs = []

    relay_data = {
        "relayAgentIp": relay_ip,
        "remoteDhcpServerIp": remote_dhcp_ip,
        "macOfClients": client_macs  # List of active client MACs via relay
    }
    return jsonify(relay_data)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)