DHCP-demo

A demo application for monitoring DHCP server scopes and leases with a mobile Flutter app (client) and a Flask API (backend) connected to PowerShell scripts.

📂 Project Structure
DHCP-demo/
│
├── apiService/
│   └── apiServices.dart       # Flutter client API service
│
├── mobile/                    # Flutter mobile app
│   └── lib/
│       └── config/
│           └── ApiConfig.dart # Configurable IP & port for API
│
├── dhcp_api/                  # Backend folder
│   ├── dhcp_api.py            # Flask server
│   ├── get_leases.ps1         # PowerShell script to fetch leases
│   ├── get_scopeinfo.ps1      # PowerShell script to fetch scope info
│   └── get_scopes.ps1         # PowerShell script to fetch available scopes

📱 App Features

- Dashboard View
+ Displays DHCP server status (Online/Offline), running scopes, connected clients, and quick stats.

- Lease List
+ Shows all active leases with details such as IP address, MAC, and state.

- Scope Info
+ Displays pool size, available range, subnet mask, gateway, and active lease count.

- DORA Flow (Discover, Offer, Request, Acknowledge)
+ Visual animation illustrating how DHCP works between client and server.

⚙️ Configuration
- API Configuration (Backend)
Edit dhcp_api.py and configure your default Scope ID:

# Default scope matches lease data
SCOPE_ID = "192.168.1.0"


👉 Change this to match the scope you want to display (e.g., "192.168.2.0").
You can also pass the scope dynamically as a query parameter:

http://<server-ip>:5001/api/leases?scope=192.168.1.0


▶️ Running the Project
Backend (Flask API)

Install dependencies:
  pip install flask flask-cors
  
Run the API:
  python dhcp_api.py
  
The API will start on:
  http://0.0.0.0:5001


🌐 Networking Setup

To allow the host PC to access the API URL:

Inside Windows Server, add a network adapter.

Set the adapter to Bridged Mode so the server is reachable in the same network.

Allow API traffic by disabling the firewall (for testing only):
Run in PowerShell (as Administrator):

Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False


⚠️ Note: Turning off the firewall is only recommended for local testing. For production, configure proper firewall rules instead.

🔧 Troubleshooting

If API fetching doesn’t work and the console seems stuck, press Ctrl + C in the command prompt running the Flask server, then restart it.

Double-check:

Correct Scope ID is set in dhcp_api.py.

API host IP address & port are set correctly in the Flutter app.

The network adapter is set to Bridged Mode.

The firewall is disabled (or properly configured to allow port 5001).
