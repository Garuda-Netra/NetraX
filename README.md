# NetraX

> A professional phishing tool for authorized penetration testing, captures webcam images and GPS location from a target device by delivering a believable lure page over an internet-exposed tunnel.

---

## About the Project

**NetraX** hosts a fake webpage on a built-in PHP server and exposes it over the internet via **Ngrok** or **CloudFlare Tunnel**. When a target visits the link and grants camera/location permission, the tool silently captures front-camera snapshots and GPS coordinates in real time.

This project is intended **exclusively for authorized security testing and educational purposes**.

---

## Features

- **Front-camera capture** â€” continuously grabs snapshots from the target's webcam or phone front camera
- **GPS location tracking** â€” captures latitude, longitude, accuracy, and a live Google Maps link
- **Gift claim lure** â€” decoy templates include a "Claim Your Celebration Gift" form that collects Full Name, Email, Phone, Date of Birth, Aadhaar, and Delivery Address for identity verification
- **CSRF protection** â€” per-session tokens on the gift form prevent cross-site request forgery
- **Centralized data storage** â€” all logs, location files, captures, and submissions are organized inside `/data/`
- **Three decoy templates:**
  - Season's Greetings page
  - YouTube Live Stream page
  - Online Conference / Conference Room page
- **Dual tunnel support** â€” Ngrok and CloudFlare Tunnel
- **Cross-platform** â€” Kali Linux, Ubuntu, Parrot OS, Termux (Android), macOS (Intel & Apple Silicon), Windows (WSL)
- **Cleanup script** â€” removes all captured images, logs, form submissions, and temporary files in one command
- **Architecture auto-detection** â€” x86\_64, x86, ARM64, ARMv7, Apple Silicon (M1/M2/M3)

---

## Installation

### Prerequisites

Ensure the following packages are installed before running:

```bash
apt-get -y install php wget unzip
```

### Clone & Run

```bash
git clone https://github.com/Garuda-Netra/NetraX
cd NetraX
bash netraX.sh
```

---

## Usage

```bash
bash netraX.sh
```

On launch, the tool will prompt you to:

1. **Choose a tunnel server** â€” `[01] Ngrok` or `[02] CloudFlare Tunnel`
2. **Choose a decoy template** â€” Season's Greetings, YouTube Streaming, or Online Conference
3. Provide any required input (festival name, YouTube video ID, etc.)

The tool then:
- Starts a local PHP server on `127.0.0.1:3333`
- Launches the selected tunnel and retrieves a public URL
- Displays the shareable link â€” send it to the target
- Waits and prints captured IP, camera images, and GPS location as they arrive

### Clean Up Logs & Captured Files

```bash
bash cleanup.sh
```

> Wipes all `.log` files, generated index files, captured `cam*.png` images, all files inside `data/` (ip_logs, location_logs, form submissions, camera captures, event flags), and clears `saved_locations/`.

---

## ðŸ”¹ Gift Request Form

Each decoy template includes a **"Claim Your Celebration Gift"** section that prompts the target to enter their own details to receive a gift. The form collects:

| Field | Validation |
|---|---|
| Full Name | Required, min. 2 characters |
| Email Address | Required, valid format |
| Phone Number | Required, 10â€“15 digits |
| **Date of Birth** | Required, valid past date, within 120 years |
| Aadhaar Number | Required, exactly 12 digits |
| Delivery Address | Required, min. 10 characters |
| Gift Message | Optional |

A notice displayed on the form reads:
> *"We collect these details only to verify that you are an authorized person. After successful verification, we will proceed with sending your gift."*

Submitted data is appended to `data/gift_requests.txt` and echoed to the server log. Validation is enforced on both the client side (inline JS) and server side (`gift_handler.php`). The form is protected by a CSRF token issued by `get_csrf_token.php`.

---

## Project Structure

```
NetraX/
 netraX.sh                   # Main launcher script
 cleanup.sh                  # Cleanup utility (wipes all captured data)
 template.php                # Loading/splash page (IP + location capture)
 index.php                   # Generated entry-point (created at runtime)
 ip.php                      # Records target IP and User-Agent
 post.php                    # Receives and saves captured webcam images
 location.php                # Receives and saves GPS coordinates
 debug_log.php               # Internal debug logger (filtered output)
 gift_handler.php            # Gift form backend: validates & saves submissions
 get_csrf_token.php          # Issues per-session CSRF tokens for the gift form
 GreetingsPortal.html        # Decoy template: Season's Greetings
 LiveStreamYT.html           # Decoy template: YouTube Streaming
 VirtualMeeting.html         # Decoy template: Online Conference
 saved.ip.txt                # Appended IP capture log
 saved_locations/            # Archived GPS coordinate files
 data/                       # â˜… Centralized data store
     ip_logs.txt             #   IP + User-Agent log
     location_logs.txt       #   Master GPS location log
     location_<ts>.txt       #   Per-hit timestamped location files
     form_submissions.txt    #   Gift form submissions
     other_logs.txt          #   Debug / misc logs
     .flag_ip                #   Event flag: new IP hit (auto-deleted)
     .flag_location          #   Event flag: new location (auto-deleted)
     .flag_cam               #   Event flag: new camera capture (auto-deleted)
      camera_captures/        #   Captured webcam images (cam<ts>.png)
```

---

## ðŸ”¹ Tested Platforms

| Platform        | Status    |
|-----------------|-----------|
| Kali Linux      | Tested |
| Ubuntu          | Tested |
| Parrot Sec OS   | Tested |
| Termux (Android)| Tested |
| macOS (Intel)   | Tested |
| macOS (M1/M2/M3)| Tested |
| Windows (WSL)   | Tested |

---

## ðŸ”¹ Changelog

| Version | Highlights |
|---------|------------|
| **2.1** | Gift form flow changed to "receive" model â€” targets enter their own details; Date of Birth field added with client- and server-side validation; verification notice added; CSRF protection on gift form |
| **2.0** | Added GPS location tracking, Google Maps integration, accuracy reporting, improved loading screen |
| **1.9** | Enhanced CPU architecture detection (ARM, ARM64, x86, x86\_64, Apple Silicon) |
| **1.8** | Added CloudFlare Tunnel support; removed deprecated Serveo tunnel |
| **1.7** | Fixed Termux home directory issue; added ARM64 & Apple Silicon support |
| **1.6** | Fixed ngrok direct link generation |
| **1.5** | Added Online Conference decoy template |
| **1.4** | Updated ngrok authtoken handling |
| **1.3** | Fixed ngrok direct link |

---

## ðŸ”¹ Disclaimer

> **This tool is provided for educational and authorized penetration testing purposes only.**
>
> - You must have **explicit written permission** from the target system owner before use.
> - Unauthorized use against any individual or system **is illegal** and may result in criminal prosecution.
> - The author and contributors accept **no liability** for any misuse, damage, or illegal activity arising from the use of this tool.
> - By using NetraX, you agree that you are solely responsible for your actions and any consequences thereof.

---

## ðŸ”¹ Author

```
--------------------------------------------------
NetraX
Created, Developed & Maintained by GarudaNetra
GitHub: https://github.com/Garuda-Netra
--------------------------------------------------
```
