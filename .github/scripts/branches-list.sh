#!/bin/bash

# This script fetches all remote branches, formats them as a YAML list,
# and sets them as a multi-line output variable for GitHub Actions.

# Using mktemp -u for a robust, unique delimiter string
PAGES_REPO_PATH=$1
PROJECT_NAME=$2
PROJECT_PATH="$PAGES_REPO_PATH/$PROJECT_NAME"

if [ -d "$PROJECT_PATH" ]; then
  ls -1 "$PROJECT_PATH" | grep -v '^main$'
else
  echo ""
fi