#!/bin/bash

PAGES_REPO_PATH=$1
PROJECT_NAME=$2
BRANCH_NAME=$3
BRANCH_PATH="$PAGES_REPO_PATH/$PROJECT_NAME/$BRANCH_NAME"

if [ -d "$BRANCH_PATH" ]; then
  ls -1 "$BRANCH_PATH" | grep -E '^[0-9]+$' | sort -rn
else
  echo ""
fi