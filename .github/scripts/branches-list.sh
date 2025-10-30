#!/bin/bash

# This script fetches all remote branches, formats them as a YAML list,
# and sets them as a multi-line output variable for GitHub Actions.

# Using mktemp -u for a robust, unique delimiter string
EOF_MARKER=$(mktemp -u XXXXXXXXXX)

echo "branch_list_yaml<<${EOF_MARKER}" >> $GITHUB_OUTPUT
git ls-remote --heads origin | awk '{print $2}' | sed 's|refs/heads/||' | grep -v '^main$' | sed 's/^/    - /' >> $GITHUB_OUTPUT
echo "${EOF_MARKER}" >> $GITHUB_OUTPUT