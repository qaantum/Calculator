# Setup Automatic Issue Creation

This guide will help you set up automatic GitHub issue creation so that issues are created automatically when changes are made.

## Quick Setup (Choose One)

### Option 1: GitHub CLI (Recommended - Easiest)

```bash
# Install GitHub CLI
brew install gh

# Authenticate (opens browser)
gh auth login

# Verify it works
gh auth status
```

That's it! The scripts will now work automatically.

### Option 2: Personal Access Token

1. **Create a Token:**
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Name it: "Ciphio Vault Issue Creation"
   - Select scope: `repo` (full control of private repositories)
   - Click "Generate token"
   - **Copy the token immediately** (you won't see it again!)

2. **Set the Token:**
   ```bash
   # Temporary (current session only)
   export GITHUB_TOKEN=your_token_here
   
   # Permanent (add to ~/.zshrc)
   echo 'export GITHUB_TOKEN=your_token_here' >> ~/.zshrc
   source ~/.zshrc
   ```

3. **Verify:**
   ```bash
   python3 create_issue.py "Test" "Testing issue creation" "enhancement"
   ```

## Testing

Once set up, test with:

```bash
# Test with GitHub CLI
./create_issue.sh "Test Issue" "This is a test" "enhancement"

# Or test with Python
python3 create_issue.py "Test Issue" "This is a test" "enhancement"
```

## How It Works

When I (the AI assistant) make changes:

1. **I'll automatically call** `./auto_create_issues.sh` after significant changes
2. **The script will:**
   - Analyze the commit message
   - Determine appropriate labels (bug, enhancement, refactor)
   - Create a well-formatted issue
   - Link it to the commit

3. **You can also manually create issues:**
   ```bash
   ./create_issue.sh "Your Title" "Your Description" "bug"
   ```

## Manual Issue Creation

If authentication isn't set up, you can still create issues manually:

1. Go to: https://github.com/qaantum/ciphio-vault/issues/new
2. Choose a template (Bug Report, Feature Request, or Refactor)
3. Copy content from generated `issue_*.md` files
4. Submit

## Troubleshooting

### "gh: command not found"
```bash
brew install gh
```

### "GitHub CLI not authenticated"
```bash
gh auth login
```

### "GITHUB_TOKEN not set"
```bash
export GITHUB_TOKEN=your_token_here
# Or add to ~/.zshrc for permanent setup
```

### "Permission denied" errors
- Make sure your token has `repo` scope
- Or authenticate with `gh auth login` which handles permissions automatically

## Next Steps

1. **Set up authentication** (choose Option 1 or 2 above)
2. **Test it** with a simple issue
3. **I'll start creating issues automatically** for future changes!

Once set up, I'll create issues like:
- ✅ Bug fixes → "Fix: [description]" with `bug` label
- ✅ New features → "Feature: [description]" with `enhancement` label  
- ✅ Code improvements → "Refactor: [description]" with `refactor` label

