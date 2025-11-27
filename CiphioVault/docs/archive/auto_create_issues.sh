#!/bin/bash

# Auto-create GitHub issues when making changes
# This script can be called by the AI assistant after making changes

COMMIT_MSG="$1"
COMMIT_HASH="${2:-$(git rev-parse --short HEAD)}"

if [ -z "$COMMIT_MSG" ]; then
    echo "Usage: ./auto_create_issues.sh \"Commit message\" [commit_hash]"
    exit 1
fi

# Determine issue type and labels based on commit message
if echo "$COMMIT_MSG" | grep -qiE "(fix|bug|error|issue|problem)"; then
    LABEL="bug"
    TITLE_PREFIX="Fix: "
elif echo "$COMMIT_MSG" | grep -qiE "(feat|feature|add|implement|new)"; then
    LABEL="enhancement"
    TITLE_PREFIX="Feature: "
elif echo "$COMMIT_MSG" | grep -qiE "(refactor|improve|clean|update|optimize)"; then
    LABEL="refactor"
    TITLE_PREFIX="Refactor: "
else
    LABEL="enhancement"
    TITLE_PREFIX="Update: "
fi

# Create title from commit message (first line, max 80 chars)
TITLE=$(echo "$COMMIT_MSG" | head -1 | cut -c1-80)
TITLE="${TITLE_PREFIX}${TITLE}"

# Create description
DESCRIPTION="## Description
${COMMIT_MSG}

## Related Commit
\`${COMMIT_HASH}\`

## Changes Made
See commit ${COMMIT_HASH} for detailed changes.

## Verification
- [ ] Code compiles successfully
- [ ] No new warnings introduced
- [ ] Functionality verified"

# Try to create issue
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "Creating issue with GitHub CLI..."
    ./create_issue.sh "$TITLE" "$DESCRIPTION" "$LABEL"
elif [ -n "$GITHUB_TOKEN" ] && command -v python3 &> /dev/null; then
    echo "Creating issue with Python script..."
    python3 create_issue.py "$TITLE" "$DESCRIPTION" "$LABEL"
else
    echo "⚠️  Cannot create issue automatically."
    echo "Set up authentication:"
    echo "  1. Install GitHub CLI: brew install gh && gh auth login"
    echo "  2. Or set GITHUB_TOKEN environment variable"
    echo ""
    echo "Issue details saved to: issue_${COMMIT_HASH}.md"
    cat > "issue_${COMMIT_HASH}.md" << EOF
# ${TITLE}

${DESCRIPTION}

**Labels:** ${LABEL}
**Commit:** ${COMMIT_HASH}
EOF
    echo "You can create this issue manually at:"
    echo "https://github.com/qaantum/ciphio-vault/issues/new"
fi

