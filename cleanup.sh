#!/bin/bash
# --------------------------------------------------
# NetraX — Cleanup Utility
# Removes all captured data, logs, and temp files
# Created, Developed & Maintained by GarudaNetra
# --------------------------------------------------

GREEN="\e[1;92m"
YELLOW="\e[1;93m"
RESET="\e[0m"

printf "${YELLOW}\n[*] NetraX Cleanup — starting...${RESET}\n\n"

# ── 1. Cloudflare / tunnel logs ─────────────────────────────
printf "${GREEN}[+]${RESET} Removing tunnel logs...\n"
rm -f .cloudflared.log
rm -f *.log

# ── 2. Generated index files ────────────────────────────────
printf "${GREEN}[+]${RESET} Removing generated index files...\n"
rm -f index.php
rm -f index2.html
rm -f index3.html

# ── 3. Root-level stale files (legacy guard) ─────────────────
printf "${GREEN}[+]${RESET} Removing any legacy root-level files...\n"
rm -f ip.txt
rm -f location_*.txt
rm -f current_location.txt current_location.bak
rm -f cam*.png
rm -f LocationLog.log LocationError.log Log.log
rm -f saved.locations.txt

# ── 4. /data/ directory contents ─────────────────────────────
printf "${GREEN}[+]${RESET} Clearing data/ip_logs.txt...\n"
rm -f data/ip_logs.txt

printf "${GREEN}[+]${RESET} Clearing data/location_logs.txt...\n"
rm -f data/location_logs.txt

printf "${GREEN}[+]${RESET} Removing data/location_*.txt individual files...\n"
rm -f data/location_*.txt

printf "${GREEN}[+]${RESET} Clearing data/other_logs.txt...\n"
rm -f data/other_logs.txt

printf "${GREEN}[+]${RESET} Clearing data/form_submissions.txt...\n"
rm -f data/form_submissions.txt

printf "${GREEN}[+]${RESET} Removing camera captures from data/camera_captures/...\n"
if [ -d "data/camera_captures" ]; then
    rm -f data/camera_captures/*.png
fi

printf "${GREEN}[+]${RESET} Removing event flag files...\n"
rm -f data/.flag_ip data/.flag_location data/.flag_cam

# ── 5. data/saved_locations/ ────────────────────────────────
printf "${GREEN}[+]${RESET} Clearing data/saved_locations/ directory...\n"
if [ -d "data/saved_locations" ]; then
    rm -f data/saved_locations/*
fi

# ── 6. data/saved_ip.txt ─────────────────────────────────────
printf "${GREEN}[+]${RESET} Clearing data/saved_ip.txt...\n"
rm -f data/saved_ip.txt

printf "\n${YELLOW}[*] Cleanup completed successfully!${RESET}\n\n"