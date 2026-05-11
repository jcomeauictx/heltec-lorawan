#!/bin/bash
# https://meshtastic.org/docs/meshtasticd/installation/debian/
SUSE=https://download.opensuse.org/repositories/
if [[ "$(. /etc/os-release && echo $NAME)" == Raspbian* ]]; then
  echo -n "ERROR: Raspberry Pi OS (32-bit) detected," >&2
  echo " please use the Raspbian repos." >&2
else
  echo "deb $SUSE/network:/Meshtastic:/beta/Debian_13/ /" | \
    sudo tee /etc/apt/sources.list.d/network:Meshtastic:beta.list
  curl -fsSL $SUSE/network:Meshtastic:beta/Debian_13/Release.key | \
    gpg --dearmor | \
    sudo tee /etc/apt/trusted.gpg.d/network_Meshtastic_beta.gpg
  sudo apt update
  sudo apt install meshtasticd
fi
