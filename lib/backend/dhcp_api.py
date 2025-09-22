from flask import Flask, jsonify, request
from flask_cors import CORS
import subprocess
import json

app = Flask(__name__)
CORS(app)

# Default scope matches lease data
SCOPE_ID = "192.168.1.0"

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
    scope_id = request.args.get("scope", SCOPE_ID)  # Use query param
    leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [scope_id])
    # Optional: Make /api/leases always return a list for consistency
    if isinstance(leases, dict) and 'IPAddress' in leases:
        leases = [leases]
    return jsonify(leases)

@app.route("/api/scopeinfo", methods=["GET"])
def get_scope_info():
    scope_id = request.args.get("scope", SCOPE_ID)
    scope = run_powershell("C:\\dhcp_api\\get_scopeinfo.ps1", [scope_id])
    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [scope_id])

    # New: Handle single lease (dict) by wrapping in list
    if isinstance(all_leases, dict) and 'IPAddress' in all_leases:
        all_leases = [all_leases]

    if isinstance(all_leases, list):
        active_leases = [l for l in all_leases if l.get('AddressState') == 'Active']
        if isinstance(scope, dict):
            scope['NumberOfLeases'] = len(active_leases)
        else:
            scope = {'NumberOfLeases': len(active_leases)}
    else:
        if isinstance(scope, dict):
            scope['NumberOfLeases'] = 0
        else:
            scope = {'NumberOfLeases': 0}
    return jsonify(scope)

@app.route("/api/dashboard", methods=["GET"])
def get_dashboard():
    scope_id = request.args.get("scope", SCOPE_ID)
    scope = run_powershell("C:\\dhcp_api\\get_scopeinfo.ps1", [scope_id])
    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [scope_id])

    # New: Handle single lease (dict) by wrapping in list
    if isinstance(all_leases, dict) and 'IPAddress' in all_leases:
        all_leases = [all_leases]

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
    pool_range = ""
    active_scope = f"{scope_id}/24"  # Default CIDR
    if isinstance(scope, dict):
        pool_size = scope.get("PoolSize", 0)
        pool_range = scope.get("PoolRange", "")  # String like "192.168.1.11 - 192.168.1.99"
        subnet_mask = scope.get("SubnetMask", "")
        scope_id_from_scope = scope.get("Network", scope_id)
        if subnet_mask and scope_id_from_scope:
            bit_count = sum(bin(int(x)).count("1") for x in subnet_mask.split("."))
            active_scope = f"{scope_id_from_scope}/{bit_count}"

    dashboard = {
        "serverStatus": "Online" if active_count > 0 or pool_size > 0 else "Offline",
        "activeScope": active_scope,
        "gateway": scope.get("Gateway", "") if isinstance(scope, dict) else "",
        "numberOfLeases": active_count,
        "poolSize": pool_size,
        "poolRange": pool_range,
        "sample": sample
    }
    return jsonify(dashboard)

@app.route("/api/relay", methods=["GET"])
def get_relay():
    scope_id = request.args.get("scope", SCOPE_ID)
    # Hardcoded for single relay; update for multi-relay if needed
    relay_ip = "192.168.1.1" if scope_id == "192.168.1.0" else "192.168.2.1"
    remote_dhcp_ip = "192.168.1.201"

    all_leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [scope_id])

    # New: Handle single lease (dict) by wrapping in list
    if isinstance(all_leases, dict) and 'IPAddress' in all_leases:
        all_leases = [all_leases]

    if isinstance(all_leases, list):
        active_leases = [l for l in all_leases if l.get('AddressState') == 'Active']
        client_macs = [l.get('ClientId', '') for l in active_leases]
    else:
        client_macs = []

    relay_data = {
        "relayAgentIp": relay_ip,
        "scopeId": scope_id,
        "remoteDhcpServerIp": remote_dhcp_ip,
        "macOfClients": client_macs
    }
    return jsonify(relay_data)

@app.route("/api/scopes", methods=["GET"])
def get_scopes():
    scopes = run_powershell("C:\\dhcp_api\\get_scopes.ps1")
    return jsonify(scopes)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)