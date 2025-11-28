#!/bin/bash

# Script to create a GitHub issue for changes
# Usage: ./create_issue.sh "Issue Title" "Issue Description" [labels]

REPO="qaantum/ciphio-vault"
TITLE="$1"
DESCRIPTION="$2"
LABELS="${3:-enhancement}"

if [ -z "$TITLE" ]; then
    echo "Usage: ./create_issue.sh \"Issue Title\" \"Issue Description\" [labels]"
    exit 1
fi

# Check if gh CLI is installed, fallback to Python script
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI (gh) is not installed. Trying Python fallback..."
    if command -v python3 &> /dev/null; then
        python3 "$(dirname "$0")/create_issue.py" "$TITLE" "$DESCRIPTION" "$LABELS"
        exit $?
    else
        echo "Neither GitHub CLI nor Python3 is available."
        echo "Install GitHub CLI: brew install gh && gh auth login"
        echo "Or install Python and set GITHUB_TOKEN environment variable"
        exit 1
    fi
fi

# Create the issue
gh issue create \
    --repo "$REPO" \
    --title "$TITLE" \
    --body "$DESCRIPTION" \
    --label "$LABELS"

if [ $? -eq 0 ]; then
    echo "✅ Issue created successfully!"
else
    echo "❌ Failed to create issue"
    exit 1
fi

