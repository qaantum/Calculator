# How to Push to GitHub - Secure Guide

## Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `ciphio` (or your preferred name)
3. Set to **Private**
4. **DO NOT** initialize with README (we already have one)
5. Click "Create repository"

## Step 2: Create Personal Access Token

1. Go to https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Name it: "Ciphio CLI"
4. Select scopes: **`repo`** (full control of private repositories)
5. Click "Generate token"
6. **COPY THE TOKEN** - you won't see it again!

## Step 3: Push to GitHub

```bash
cd /Users/qaantum/Desktop/Project

# Add your GitHub repository as remote
git remote add origin https://github.com/YOUR_USERNAME/ciphio.git

# Push to GitHub
git push -u origin main
```

When prompted for credentials:
- **Username**: Your GitHub username
- **Password**: Paste the Personal Access Token (not your actual password)

## Step 4: Save Credentials (Optional)

To avoid entering credentials every time:

```bash
# Tell Git to remember credentials
git config --global credential.helper osxkeychain
```

---

## Alternative: Using SSH Keys (More Secure)

### Setup SSH Key

```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
# Press Enter 3 times (default location, no passphrase)

# Copy SSH key to clipboard
pbcopy < ~/.ssh/id_ed25519.pub
```

### Add SSH Key to GitHub

1. Go to https://github.com/settings/keys
2. Click "New SSH key"
3. Title: "MacBook"
4. Paste the key (already in clipboard)
5. Click "Add SSH key"

### Push Using SSH

```bash
cd /Users/qaantum/Desktop/Project

# Add remote using SSH
git remote add origin git@github.com:YOUR_USERNAME/ciphio.git

# Push
git push -u origin main
```

---

## Troubleshooting

### "branch 'main' doesn't exist"
```bash
git branch -M main
git push -u origin main
```

### "remote origin already exists"
```bash
git remote remove origin
# Then add it again
```

### "failed to push some refs"
```bash
git pull origin main --rebase
git push -u origin main
```

---

## What You're Pushing

Your initial commit includes:
- ✅ Complete iOS app (Swift + SwiftUI)
- ✅ Complete Android app (Kotlin + Jetpack Compose)
- ✅ Business strategy documents
- ✅ Launch plans and milestones
- ✅ Feature parity documentation
- ✅ Properly configured .gitignore

**Repository will be private** - only you can see it.

