#!/bin/bash

# GIT utils
janitor_function(){
echo "Running git janitor..."

if ! git -C "$VAULT_PATH" fsck --full --no-reflogs --unreachable ; then
    echo -e "Something went wrong :c\n FSCK FAILED!"
    exit 1
fi

git -C "$VAULT_PATH" reflog expire --expire=now --all
git -C "$VAULT_PATH" gc --prune=now --aggressive

echo "Janitor finished cleaning."   
}


# PULL_PUSH MENUE

pull_push_function(){
        
   echo "PUSH OR PULL(PS(push)/PU(pull))"
        read -r INPUT
                INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
                if [[ -z "$INPUT"  || "$INPUT" == "pu" || "$INPUT" == "pull"  ]] ;then
                        autopull_function
                elif [[ "$INPUT" = "ps" || "$INPUT" = "push"  ]]; then
                    echo "Are you sure you want to commit and push(Yes/no)?"
                    read -r SHURESHOT
                    SHURESHOT=$(echo "$SHURESHOT" | tr '[:upper:]' '[:lower:]' )
                        if [[ "$SHURESHOT" == "y" || "$SHURESHOT" == "yes" ]] ; then
                          autocommit_function
                        elif [[ "$SHURESHOT" == "n" || "$SHURESHOT" == "no" ]]; then
                          menu
                        else 
                          echo "Invalid input, returning to MENU!" 
                          menu
                        fi
                else
                    echo "Invalid input. Try again"
                    pull_push_function
                fi

}

#AUTOPULL

autopull_function(){
git -C "$VAULT_PATH" pull
echo "SUCCESSFULLY PULLED USER-CHAN!"
}

###AUTOCOMMIT
autocommit_function(){
    if ! ping -c 1 github.com &> /dev/null; then
        echo -e "Network connection failed!\n Pushing to the GITHUB repository failed! ."
            
    fi
    sleep 5
    git -C "$VAULT_PATH" add . || exit 1
    git -C "$VAULT_PATH" commit -m "Autocommit from OBS-manager $(date +%Y-%m-%d)" || exit 1
    
    if ! git -C "$VAULT_PATH" push -u origin main ; then
        janitor_function
    else echo "Autocommit was sucsessful!!!" 
    fi
}


###CLONE FUNCTION IS WORKING
reclone_function() {
    # Path check
    if [[ ! -d "$CLONE_DIR" ]]; then
        echo "Repo does not exist: $CLONE_DIR"
    fi

#Old vault delete
    if [[ -d "$VAULT_PATH" ]]; then
        echo "Deleting old Vault..."
        rm -rf "$VAULT_PATH" || {
            echo "Error: Failed to delete $VAULT_PATH"
        }
    fi

#Gitclone
    echo "Cloning repo $GIT_REPO в $CLONE_DIR..."
    if git -C "$CLONE_DIR" clone -b main "$GIT_REPO"; then
        #SCRIPT_DIR=$(dirname "$(realpath "$0")")
        git -C "$VAULT_PATH" checkout main
        echo "Repo successfully cloned!"

        local repo_name=$(basename "$GIT_REPO" .git)


        if [[ -d "$CLONE_DIR/$repo_name" ]]; then
            echo "Vault path is: $CLONE_DIR/$repo_name"
        else
            echo "Repo directory not found :c"
        fi
    else
        echo "Failed to clone repo!"
    fi
}



#Archive functions


archive_trackers_function(){
    CURRENT_YEAR=$(date +%Y)
    LAST_MONTH=$(date -d "last month" +%m)
    ARCHIVE_PATH="$A_TRACKER_PATH/$LAST_MONTH-$CURRENT_YEAR"
    RESULT_FILE_NAME="$LAST_MONTH-$CURRENT_YEAR-Results.md"    
        cd "$VAULT_PATH/Trackers" || exit 1
        cat *-"$LAST_MONTH"-*.md >> "$RESULT_FILE_NAME"
            if [ ! -d "$ARCHIVE_PATH" ]; then
                mkdir -p "$ARCHIVE_PATH"
            fi
                mv *-"${LAST_MONTH}"-*.md "$ARCHIVE_PATH" 2>/dev/null
                mv "$RESULT_FILE_NAME" "$DEST_SRC"
}


notes_archive_function(){
    CURRENT_YEAR=$(date +%Y)
    LAST_MONTH=$(date -d "last month" +%m)
    ARCHIVE_PATH="$A_NOTES_PATH/$LAST_MONTH-$CURRENT_YEAR"
    RESULT_FILE="$LAST_MONTH-$CURRENT_YEAR-Summary.md"    
        cd "$VAULT_PATH/Daily_Notes" || exit 1
        cat *-"$LAST_MONTH"-*.md >> "$RESULT_FILE"
            if [ ! -d "$ARCHIVE_PATH" ]; then
                mkdir -p "$ARCHIVE_PATH"
            fi
            mv *-"${LAST_MONTH}"-*.md "$ARCHIVE_PATH" 2>/dev/null
            mv "$RESULT_FILE" "$DEST_SRC"
}

# FUNCTIONS for everyday tracker function

today(){
 
 #date
 TODAY=$(date +"%Y-%m-%d")
 YESTERDAY=$(date -d "yesterday" +"%Y-%m-%d")
 
 #FILES
    SOURCE_FILE="${TRACKER_PATH}/${TODAY} Трекер привычек и состояний.md"   
    OLD_FILE="${TRACKER_DEST}/${YESTERDAY} Трекер привычек и состояний.md"

        # COPY AND COPY CHECK
        if [ -f "$SOURCE_FILE" ]; then
                cp "$SOURCE_FILE" "$TRACKER_DEST"
                echo "File copied: $SOURCE_FILE → $TRACKER_DEST"
        else
                echo "Source file did not found $SOURCE_FILE"
                exit 1
        fi


 #REMOVE AND CHECK
if [ -f "$OLD_FILE" ]; then
    if rm "$OLD_FILE"; then
        echo "Старый трекер удалён: $OLD_FILE"
    else
        echo "Ошибка при удалении файла: $OLD_FILE"
    fi
else
    echo "Старый трекер не найден: $OLD_FILE(пропускаем удаление)"
fi

echo "Tracker was sent! ^^"
        

}

yesterday(){
 
 #date
 TODAY=$(date -d "yesterday" +"%Y-%m-%d")
 YESTERDAY=$(date -d "2 days ago" +"%Y-%m-%d")
 
 #FILES
    SOURCE_FILE="${TRACKER_PATH}/${TODAY} Трекер привычек и состояний.md"   
    OLD_FILE="${TRACKER_DEST}/${YESTERDAY} Трекер привычек и состояний.md"

        # COPY AND COPY CHECK
        if [ -f "$SOURCE_FILE" ]; then
                cp "$SOURCE_FILE" "$TRACKER_DEST"
                echo "File copied: $SOURCE_FILE → $TRACKER_DEST"
        else
                echo "Source file did not found $SOURCE_FILE"
                exit 1
        fi


 #REMOVE AND CHECK
if [ -f "$OLD_FILE" ]; then
    if rm "$OLD_FILE"; then
        echo "Старый трекер удалён: $OLD_FILE"
    else
        echo "Ошибка при удалении файла: $OLD_FILE"
    fi
else
    echo "Старый трекер не найден: $OLD_FILE(пропускаем удаление)"
fi

echo "Tracker was sent! ^^"
        

}


#
everytracker_function(){
        
   echo "Choose the everyday option(no input for today)"
        read -r INPUT
                INPUT=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')
                if [ -z "$INPUT" ] ;then
                        today
                else 
                        yesterday
                fi

}


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
#Obsidian manager
chmod +x ${SCRIPT_DIR}/config/*.conf


# What OS was used and reading proper config file!
if  [[ $(uname -a ) == *"Android"* ]]; then
        source "${SCRIPT_DIR}/config/vedroid.conf"
else
        source "${SCRIPT_DIR}/config/linux.conf"
fi


#MENU FUNCTION

menu(){

while true; do
echo -e "***OBSIDIAN MANAGER***"
echo -e "1. Autocommit\n2. Remove trash\n3. Reclone\n4. Copy everyday tracker\n5. Archive trackers\n6. Archive everyday notes\n7. Exit script"
read -p "Enter your choice: " MENU_PICK

case "$MENU_PICK" in

    1) pull_push_function ;;
    2) janitor_function ;;
    3) reclone_function ;;
    4) everytracker_function;;
    5) archive_trackers_function ;;
    6) notes_archive_function ;;
    7) echo "Exiting... ^_^"; exit 0 ;;
    *) echo "Invalid option, please try again!" ;;
    esac
done

}

menu ;

