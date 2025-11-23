# GitHub Issue Creation Workflow

This document explains how to create GitHub issues when making changes to the codebase.

## Quick Start

### Option 1: Using the Helper Script (Recommended)

After GitHub CLI is installed and authenticated:

```bash
# Create an issue for a bug fix
./create_issue.sh "Fix deprecation warning in PremiumManager" "Removed deprecated enablePendingPurchases() call" "bug"

# Create an issue for a feature
./create_issue.sh "Add dark mode support" "Implement dark theme toggle in settings" "enhancement"

# Create an issue for a refactor
./create_issue.sh "Refactor crypto service" "Improve error handling in encryption" "refactor"
```

### Option 2: Using GitHub CLI Directly

```bash
gh issue create \
  --title "Your Issue Title" \
  --body "Issue description" \
  --label "bug,enhancement"
```

### Option 3: Manual Creation via GitHub Web UI

1. Go to: https://github.com/qaantum/ciphio-vault/issues/new
2. Choose a template (Bug Report, Feature Request, or Refactor)
3. Fill in the details
4. Submit

## Setup GitHub CLI

1. **Install GitHub CLI** (if not already installed):
   ```bash
   brew install gh
   ```

2. **Authenticate**:
   ```bash
   gh auth login
   ```
   Follow the prompts to authenticate with GitHub.

3. **Verify**:
   ```bash
   gh auth status
   ```

## When to Create Issues

### Automatically (via AI Assistant)
When I make significant changes, I can automatically create an issue with:
- Clear title describing the change
- Description of what was changed and why
- Appropriate labels (bug, enhancement, refactor, etc.)

### Manually
You can create issues for:
- Bugs you discover
- Features you want to add
- Code improvements needed
- Documentation updates

## Issue Labels

Common labels used:
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `refactor` - Code improvement without changing functionality
- `documentation` - Documentation improvements
- `question` - Further information is requested
- `wontfix` - This will not be worked on

## Best Practices

1. **Clear Titles**: Use descriptive titles that explain what the issue is about
2. **Detailed Descriptions**: Include context, steps to reproduce (for bugs), and expected behavior
3. **Labels**: Use appropriate labels to categorize issues
4. **Link to Commits**: Reference related commits in issue descriptions
5. **Close Issues**: When a change fixes an issue, reference it in the commit message: `Fixes #123`

## Example: Creating an Issue for a Change

When I fix a bug, I can run:
```bash
./create_issue.sh \
  "Fix: Remove deprecated enablePendingPurchases()" \
  "Removed deprecated \`enablePendingPurchases()\` call from BillingClient builder. This method is no longer needed in Billing Library 7.1.1 as pending purchases are enabled by default.

Related commit: 392118e" \
  "bug"
```

## Integration with Commits

You can reference issues in commit messages:
- `Fixes #123` - Closes the issue when merged
- `Closes #123` - Same as Fixes
- `Resolves #123` - Same as Fixes
- `Refs #123` - References the issue without closing it

