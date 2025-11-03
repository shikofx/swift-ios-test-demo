#!/bin/bash
set -e

# === Входные переменные из GitHub Actions ===
GH_PAGES_REPO_PATH=$1
ARTIFACTS_PATH=$2
BRANCH_NAME=$3
RUN_NUMBER=$4
COMMIT_SHA=$5
ACTOR=$6
WORKFLOW_CONCLUSION=$7
PROJECT_NAME=$8

# 1. Подготовка путей и имен
# Имя проекта берется из имени репозитория, чтобы сделать скрипт универсальным
SANITIZED_BRANCH_NAME=$(echo "$BRANCH_NAME" | sed 's/\//-/g')

BRANCH_PATH="$GH_PAGES_REPO_PATH/$PROJECT_NAME/$SANITIZED_BRANCH_NAME"
BUILD_PATH="$BRANCH_PATH/$RUN_NUMBER"
REPORTS_PATH="$BUILD_PATH/reports"

echo "GitHub Pages Repo Path: $GH_PAGES_REPO_PATH"
echo "Branch Name: $BRANCH_NAME"
echo "Sanitized Branch Name: $SANITIZED_BRANCH_NAME"
echo "Run Number: $RUN_NUMBER"
echo "Destination Build Path: $BUILD_PATH"

# 2. Создание структуры папок
echo "Creating directory structure at $REPORTS_PATH..."
mkdir -p "$REPORTS_PATH"

# 3. Создание branch-info.json (если его нет)
BRANCH_INFO_FILE="$BRANCH_PATH/branch-info.json"
if [ ! -f "$BRANCH_INFO_FILE" ]; then
  echo "Creating branch-info.json for branch '$BRANCH_NAME'..."
  cat <<EOF > "$BRANCH_INFO_FILE"
{
  "branch_name": "$BRANCH_NAME"
}
EOF
else
  echo "branch-info.json already exists."
fi

# 4. Создание build-meta.json
echo "Creating build-meta.json..."
BUILD_META_FILE="$BUILD_PATH/build-meta.json"

cat <<EOF > "$BUILD_META_FILE"
{
  "build_number": $RUN_NUMBER,
  "commit_sha": "${COMMIT_SHA:0:7}",
  "timestamp": "$(date -u +'%Y-%m-%dT%H:%M:%SZ')",
  "author": "$ACTOR",
  "status": "$WORKFLOW_CONCLUSION",
  "reports": {
    "allure": "reports/allure/index.html",
    "swiftlint": "reports/swiftlint/index.html",
    "swiftformat": "reports/swiftformat/index.html",
    "coverage": "reports/coverage/index.html"
  }
}
EOF

# 5. Создание index.md для страницы билда
echo "Creating index.md for the build page..."
BUILD_INDEX_FILE="$BUILD_PATH/index.md"

cat <<EOF > "$BUILD_INDEX_FILE"
---
layout: swift-dashboard
title: "Build #$RUN_NUMBER - $BRANCH_NAME"
iframe_path: "reports/allure/index.html"
---
EOF

# 5. Перемещение артефактов
echo "Moving artifacts from $ARTIFACTS_PATH to $REPORTS_PATH..."
# Используем || true чтобы пайплайн не падал, если какой-то артефакт отсутствует
mv "$ARTIFACTS_PATH/allure-report" "$REPORTS_PATH/allure" || true
mv "$ARTIFACTS_PATH/swiftlint-report" "$REPORTS_PATH/swiftlint" || true
mv "$ARTIFACTS_PATH/swiftformat-report" "$REPORTS_PATH/swiftformat" || true
mv "$ARTIFACTS_PATH/coverage-report" "$REPORTS_PATH/coverage" || true

echo "Data preparation complete."