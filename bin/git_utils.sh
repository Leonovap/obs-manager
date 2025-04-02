#!/bin/bash


janitor(){
echo "Running git janitor..."

git fsck --full --no-reflogs --unreachable
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo "Janitor finished cleaning."   
}

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


reclone(){

reclone() {
    # Проверка существования пути
    if [[ ! -d "$CLONE_DIR" ]]; then
        echo "Ошибка: директория для клонирования не существует: $CLONE_DIR"
        return 1
    fi

    # Удаляем старое хранилище
    if [[ -d "$VAULT_PATH" ]]; then
        echo "Удаляем старое хранилище..."
        rm -rf "$VAULT_PATH" || {
            echo "Ошибка при удалении $VAULT_PATH"
            return 1
        }
    fi

    # Клонируем репозиторий
    echo "Клонируем репозиторий $GIT_REPO в $CLONE_DIR..."
    if git -C "$CLONE_DIR" clone "$GIT_REPO"; then
        echo "Репозиторий успешно клонирован!"
        
        # Проверяем, что клонирование создало нужную папку
        local repo_name=$(basename "$GIT_REPO" .git)
        if [[ -d "$CLONE_DIR/$repo_name" ]]; then
            echo "Хранилище доступно по пути: $CLONE_DIR/$repo_name"
        else
            echo "Предупреждение: не удалось определить путь к клонированному репозиторию"
        fi
    else
        echo "Ошибка при клонировании репозитория!"
        return 1
    fi
}
}


