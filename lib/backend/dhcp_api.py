from flask import Flask, jsonify
from flask_cors import CORS
import subprocess
import json

app = Flask(__name__)
CORS(app)

# Fixed ScopeId (replace with your active scope ID)
SCOPE_ID = "192.168.253.0"

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
    return jsonify(scope)

@app.route("/api/dashboard", methods=["GET"])
def get_dashboard():
    scope = run_powershell("C:\\dhcp_api\\get_scopeinfo.ps1", [SCOPE_ID])
    leases = run_powershell("C:\\dhcp_api\\get_leases.ps1", [SCOPE_ID])

    if isinstance(leases, dict) and "error" in leases:
        leases_summary = {"activeCount": 0, "totalCount": 0, "sample": []}
    else:
        leases_summary = {
            "activeCount": len(leases),
            "totalCount": scope.get("PoolSize", 0) if isinstance(scope, dict) else 0,
            "sample": leases[:3] if isinstance(leases, list) else []
        }

    dashboard = {
        "serverStatus": "Online" if leases_summary["activeCount"] >= 0 else "Offline",
        "scope": scope,
        "leases": leases_summary
    }
    return jsonify(dashboard)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001, debug=True)