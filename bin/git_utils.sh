#!/bin/bash

autocommit(){
if ! ping -c 1 github.com &> /dev/null; then
    notify "Нет интернета. Git-операции невозможны."
    exit 1
fi

git add .
git commit -m "Autocommit from OBS-manager $(date +%Y-%m-%d)"

if ! git push -u origin main ; then
janitor
else echo "Autocommit was sucsessful!!!" 
fi
}

janitor(){
echo "Running git janitor..."

git fsck --full --no-reflogs --unreachable
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "Janitor finished cleaning."   
}