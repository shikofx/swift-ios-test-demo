#!/bin/bash

# $1 - Путь к склонированному репозиторию github-pages
# $2 - Имя проекта (например, owner/repo-name)

PAGES_REPO_PATH=$1
PROJECT_NAME=$2
PROJECT_PATH="$PAGES_REPO_PATH/$PROJECT_NAME"

if [ ! -d "$PROJECT_PATH" ]; then
  exit 0
fi

# Перебираем все папки-ветки, кроме 'main'
for branch_dir in $(ls -1 "$PROJECT_PATH" | grep -v '^main$'); do
  BRANCH_FULL_PATH="$PROJECT_PATH/$branch_dir"
  
  # Находим последний билд (папку с самым большим числовым именем)
  LATEST_BUILD=$(ls -1 "$BRANCH_FULL_PATH" | grep -E '^[0-9]+$' | sort -rn | head -n 1)
  
  if [ -n "$LATEST_BUILD" ]; then
    # Читаем оригинальное имя ветки из branch-info.json
    ORIGINAL_BRANCH_NAME=$(cat "$BRANCH_FULL_PATH/branch-info.json" | python3 -c "import sys, json; print(json.load(sys.stdin)['branch_name'])")
    
    # Формируем YAML-объект
    echo "  - name: \"$ORIGINAL_BRANCH_NAME\""
    echo "    url: \"/$PROJECT_NAME/$branch_dir/$LATEST_BUILD/index.html\""
  fi
done