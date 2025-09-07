#!/usr/bin/env bash

set -euo pipefail

# ------------------------------------------------------------
#  Lava • Launcher (macOS/Linux)
# ------------------------------------------------------------
#  - Creates a local `plugins/` directory
#  - Checks for Docker availability
#  - Starts services via: docker compose up -d
# ------------------------------------------------------------

bold="\033[1m"; dim="\033[2m"; red="\033[31m"; green="\033[32m"; yellow="\033[33m"; cyan="\033[36m"; reset="\033[0m"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

echo -e "${bold}${cyan}▶ Lava Launcher${reset}"
echo -e "${dim}Preparing your environment…${reset}\n"

echo -e "${bold}1) Ensure plugins directory${reset}"
mkdir -p "$script_dir/plugins"
echo -e "${green}✓${reset} Created/verified: ${bold}$script_dir/plugins${reset}\n"

echo -e "${bold}2) Check Docker availability${reset}"
if ! command -v docker >/dev/null 2>&1; then
  echo -e "${red}✖ Docker not found on PATH.${reset}"
  echo -e "Install Docker: ${yellow}https://docs.docker.com/get-docker/${reset}"
  exit 1
fi
echo -e "${green}✓${reset} Docker detected: $(docker --version | head -n1)\n"

echo -e "${bold}3) Ensure stack.env${reset}"
if [ ! -f "$script_dir/stack.env" ]; then
  echo -e "${yellow}⚠${reset} 'stack.env' not found."
  read -r -p "Enter TOKEN (the value you just copied from the Discord Developer Portal): " TOKEN
  # Write minimal stack.env with only TOKEN populated; others left empty
  cat > "$script_dir/stack.env" <<EOF
TOKEN=${TOKEN}
SPOTIFY_CLIENT_ID=
SPOTIFY_CLIENT_SECRET=
API_HOST=
API_PORT=

# LOGGING_LEVEL_ROOT=INFO
# LOGGING_LEVEL_LAVALINK=INFO
EOF
  echo -e "${green}✓${reset} Created ${bold}stack.env${reset}"
else
  echo -e "${green}✓${reset} Found ${bold}stack.env${reset}"
fi
echo

echo -e "${bold}4) Start services${reset}"
echo -e "${dim}$ docker compose up -d${reset}"
if ! docker compose up -d; then
  echo -e "\n${red}✖ Failed to start services with 'docker compose'.${reset}"
  echo -e "Ensure Docker Desktop is running and try again."
  exit 1
fi

echo -e "\n${green}✓${reset} Services are starting in the background."
echo -e "${dim}Helpful commands:${reset}"
echo -e "  • View status:     ${bold}docker compose ps${reset}"
echo -e "  • Follow logs:     ${bold}docker compose logs -f${reset}"
echo -e "  • Stop services:   ${bold}docker compose down${reset}"

exit 0
