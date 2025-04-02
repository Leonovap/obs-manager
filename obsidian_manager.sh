#!/bin/bash

#Obsidian manager
chmod +x bin/*.sh
chmod +x config/*.conf




# What OS was used
if  [[ $(uname -a ) == *"Android"* ]]; then
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/vedroid.conf"
source "${SCRIPT_DIR}/bin/git_utils.sh"
else
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/config/linux.conf"
source "${SCRIPT_DIR}/bin/git_utils.sh"
fi



#MENU FUNCTION

menu(){

while true; do
echo -e "***OBSIDIAN MANAGER***"
echo -e "1. Autocommit\n2. Remove trash\n3. Reclone\n4. Copy everyday tracker\n5. Archive trackers\n6. Archive everyday notes\n7. Exit script"
read -p "Enter your choice: " MENU_PICK

case "$MENU_PICK" in

    1) autocommit ;;
    2) janitor ;;
    3) reclone ;;
    4) Tracker_everyday ;;
    5) Tracker_archive ;;
    6) Notes_archive ;;
    7) echo "Exiting... ^_^"; exit 0 ;;
    *) echo "Invalid option, please try again!" ;;
    esac
done

}

menu ;

