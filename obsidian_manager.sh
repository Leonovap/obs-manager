#!/bin/bash

#Obsidian manager
chmod +x bin/*.sh
chmod +x config/*.conf




# What OS was used
if  [[ $(uname -a ) == *"Android"* ]]; then
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/vedroid.conf"
else
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/linux.conf"
fi

echo "$VAULT_PATH"


