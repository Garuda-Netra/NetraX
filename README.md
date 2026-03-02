# NetraX
> A professional tool for authorized penetration testing that captures webcam images and GPS coordinates from a target device by serving a believable decoy page over an internet-exposed tunnel.
 

## About the Project
**NetraX** spins up a local PHP web server, wraps it in a public tunnel (Ngrok or Cloudflare), and hands you a shareable link. When the target opens the link and grants camera/location permission, the tool quietly collects front-camera snapshots and GPS coordinates in real time — all organized neatly under the `data/` directory.
This project is intended **exclusively for authorized security testing and educational purposes**. Never use it on anyone without explicit written permission.


## Features
- **Front-camera capture** — continuously grabs snapshots from the target's webcam or phone front camera
- **GPS location tracking** — captures latitude, longitude, accuracy, and a live Google Maps link
- **Gift claim lure** — decoy templates include a "Claim Your Celebration Gift" form that collects Full Name, Email, Phone, Date of Birth, Aadhaar, and Delivery Address for identity verification
- **CSRF protection** — per-session tokens on the gift form prevent cross-site request forgery
- **Centralized data storage** — all logs, location files, captures, and submissions are organized inside `/data/`
- **Three decoy templates:**
  - Season's Greetings page
  - YouTube Live Stream page
  - Online Conference / Conference Room page
- **Dual tunnel support** — Ngrok and Cloudflare Tunnel
- **Cross-platform** — Kali Linux, Ubuntu, Parrot OS, Termux (Android), macOS (Intel & Apple Silicon), Windows (WSL)
- **Auto-install for cloudflared** — if the binary is missing, the script downloads and configures it automatically
- **Cleanup script** — removes all captured images, logs, form submissions, and temporary files in one command
- **Architecture auto-detection** — x86\_64, x86, ARM64, ARMv7, Apple Silicon (M1/M2/M3)
---


## How Cloudflare Tunnel (cloudflared) Works in NetraX
When you choose the **CloudFlare Tunnel** option, NetraX uses a tool called **`cloudflared`** — a small, free binary made by Cloudflare — to create what is called a "Quick Tunnel". Here is what happens step by step:
1. NetraX starts a PHP web server locally on your machine at `http://127.0.0.1:3333`.
2. `cloudflared` opens a secure outbound connection to Cloudflare's edge network (no firewall rules or port forwarding needed on your end).
3. Cloudflare hands you a temporary public URL like `https://random-name.trycloudflare.com`.
4. You share that URL. When the target visits it, their traffic is routed through Cloudflare straight to your local PHP server.
5. The PHP server captures their IP, camera, and GPS data as they interact with the decoy page.
**Why cloudflared instead of just ngrok?**
Cloudflare Quick Tunnels are completely free with no account required, work behind NAT and firewalls, and are generally more reliable in mobile/hotspot environments.
**Does it touch your system?**
No. NetraX downloads `cloudflared` directly into the project folder only. It never modifies system paths, package managers, or any global configuration.
---

## Installing cloudflared
### Option A — Let NetraX handle it automatically (recommended)
You do not have to do anything. When you run `bash netraX.sh` and choose the CloudFlare Tunnel option, the script will:
1. Check if `cloudflared` is already present locally or on your `PATH`.
2. If it is not found, automatically download the correct binary for your OS and CPU architecture.
3. Make the binary executable.
4. Validate that it actually runs before starting the tunnel.
If the download fails for any reason you will see a clear error message with manual steps — nothing will break silently.
### Option B — Install it yourself before running
If you prefer to set it up in advance (or if the auto-install cannot reach the internet), here is how:
#### Linux / Termux (Android)
```bash

# x86_64 (most common on desktops/servers/WSL)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared

# ARM64 (Raspberry Pi 4, newer ARM servers, Termux on modern Android)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64 -O cloudflared

# ARMv7 (older Raspberry Pi, some Android)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm -O cloudflared

# Make it executable — this step is required
chmod +x cloudflared

# Make it executable - this step is required to run netraX.sh
chmod + netraX.sh
```

#### macOS
```bash
# Apple Silicon (M1 / M2 / M3)
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-arm64.tgz -O cloudflared.tgz
tar -xzf cloudflared.tgz && rm cloudflared.tgz
chmod +x cloudflared
chmod + netraX.sh

# Intel Mac
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-darwin-amd64.tgz -O cloudflared.tgz
tar -xzf cloudflared.tgz && rm cloudflared.tgz
chmod +x cloudflared
chmod + netraX.sh
```

#### Windows (WSL / Git Bash / MSYS2)
```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe -O cloudflared.exe
chmod +x cloudflared.exe
chmod +x netraX.sh
```

> **Important:** Always run `chmod +x cloudflared` (or `chmod +x cloudflared.exe` on Windows) after downloading.
> Without the execute permission the script cannot launch the binary and the tunnel will not start.

### Verifying the Installation
After downloading, confirm that cloudflared is working correctly:
```bash
./cloudflared --version
```
You should see output similar to:
```
cloudflared version 2024.x.x (built ...)
```
If you see a **"Permission denied"** error, you forgot to run `chmod +x cloudflared`.
If you see **"cannot execute binary file"**, you downloaded the wrong architecture — re-download the correct one for your CPU.
To also verify that the tunnel command is available:
```bash
./cloudflared tunnel --help
```
---
## Full Project Setup
### Prerequisites
Make sure the following are installed on your system:
```bash

# Debian / Ubuntu / Kali / Parrot / Termux
apt-get -y install php wget

# macOS (Homebrew)
brew install php wget
```

> `unzip` is no longer required for cloudflared — the script uses `wget` or `curl` directly.
### Clone and Run
```bash
git clone https://github.com/Garuda-Netra/NetraX
cd NetraX
chmod +x cloudflared
chmod +x netraX.sh
bash netraX.sh
```
---
## Usage
```bash
bash netraX.sh
```

On launch the tool will walk you through a short menu:
1. **Choose a tunnel** — `[01] Ngrok` or `[02] CloudFlare Tunnel`
2. **Choose a decoy template** — Season's Greetings, YouTube Streaming, or Online Conference
3. Enter any template-specific details (festival name, YouTube video ID, etc.)
The tool then:
- Starts a PHP server on `127.0.0.1:3333`
- Launches the tunnel and waits up to 30 seconds for a public URL
- Prints the shareable link — send it to your test target
- Listens and prints captured IP, camera images, and GPS data as they arrive


# When prompted:
#   Choose a Port Forwarding option: 2        <- select CloudFlare Tunnel
#   Choose a template: 3                      <- select Online Conference
```
The script will output something like:
```
[+] cloudflared ready -- cloudflared version 2024.x.x
[+] Starting PHP server...
[+] Starting cloudflared tunnel...
[+] Waiting for tunnel URL (up to 30s)...
[*] Direct link: https://some-random-name.trycloudflare.com
[*] Waiting targets, Press Ctrl + C to exit...


### Clean Up Logs and Captured Files
```bash
chmod +x cleanup.sh
bash cleanup.sh
```

> Wipes all `.log` files, generated index files, captured `cam*.png` images, all files inside `data/`
> (ip_logs, location_logs, form submissions, camera captures, event flags), and clears `saved_locations/`.
---


---
## Tested Platforms
| Platform         | Status   |
|------------------|----------|
| Kali Linux       | Tested   |
| Ubuntu           | Tested   |
| Parrot Sec OS    | Tested   |
| Termux (Android) | Tested   |
| macOS (Intel)    | Tested   |
| macOS (M1/M2/M3) | Tested   |
| Windows (WSL)    | Tested   |
---


## Changelog
| Version | Highlights |
|---------|------------|
| **2.2** | Extracted `install_cloudflared()` as standalone function; added system PATH check; curl fallback downloader; binary validation before tunnel start; beginner-friendly README rewrite |
| **2.1** | Gift form flow changed to "receive" model — targets enter their own details; Date of Birth field added with client- and server-side validation; verification notice added; CSRF protection on gift form |
| **2.0** | Added GPS location tracking, Google Maps integration, accuracy reporting, improved loading screen |
| **1.9** | Enhanced CPU architecture detection (ARM, ARM64, x86, x86\_64, Apple Silicon) |
| **1.8** | Added CloudFlare Tunnel support; removed deprecated Serveo tunnel |
| **1.7** | Fixed Termux home directory issue; added ARM64 and Apple Silicon support |
| **1.5** | Added Online Conference decoy template |
---


## Disclaimer
> **This tool is provided for educational and authorized penetration testing purposes only.**
> - You must have **explicit written permission** from the target system owner before use.
> - Unauthorized use against any individual or system **is illegal** and may result in criminal prosecution.
> - The author and contributors accept **no liability** for any misuse, damage, or illegal activity arising from the use of this tool.
> - By using NetraX, you agree that you are solely responsible for your actions and any consequences thereof.
---
## Author
```
--------------------------------------------------
NetraX
Created, Developed & Maintained by GarudaNetra
GitHub: https://github.com/Garuda-Netra
--------------------------------------------------
```
