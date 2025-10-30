#!/bin/bash

# This script fetches the last 15 workflow runs for the current branch
# from the GitHub API, formats them as a YAML list of objects, and sets
# them as a multi-line output variable for GitHub Actions.

EOF_MARKER=$(mktemp -u XXXXXXXXXX)

echo "build_list_yaml<<${EOF_MARKER}" >> $GITHUB_OUTPUT

# Fetch workflow runs for the current branch from the GitHub API
curl -s -H "Authorization: Bearer $1" \
     -H "Accept: application/vnd.github.v3+json" \
     "https://api.github.com/repos/${{ github.repository }}/actions/workflows/ci-flow.yml/runs?per_page=50" \
     | jq -r '
        .workflow_runs | .[] | select(.head_branch == "${{ github.ref_name }}") | limit(15; .[]) |
        "    - number: \(.run_number)\n      date: \"\(.created_at | fromdate | strftime("%d-%m-%Y %H:%M"))\"\n      status: \"\(.conclusion)\"\n      hash: \"\(.head_sha | .[:7])\""
       ' >> $GITHUB_OUTPUT

echo "${EOF_MARKER}" >> $GITHUB_OUTPUT