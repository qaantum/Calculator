# GitHub Setup Instructions

## ✅ Step 1: Create GitHub Repository (Do This Now!)

### Option A: Create via GitHub Website (Easiest)

1. **Go to GitHub:** https://github.com/new
2. **Repository Name:** `ciphio` (or `ciphio-app`)
3. **Description:** "Secure text encryption + password manager for iOS & Android. Privacy-first, offline-capable."
4. **Visibility:** 
   - ✅ **PRIVATE** (Recommended for now - keep code private until launch)
   - ⚠️ Public (Only if you want open source - not recommended for proprietary app)
5. **DO NOT** initialize with README, .gitignore, or license (we already have these)
6. **Click:** "Create repository"

### Option B: Create via GitHub CLI (If you have it installed)

```bash
gh repo create ciphio --private --source=. --remote=origin --push
```

---

## ✅ Step 2: Push Your Code to GitHub

After creating the repository on GitHub, you'll see instructions. Follow these:

```bash
# Navigate to your project
cd /Users/qaantum/Desktop/Project

# Add GitHub as remote (replace YOUR_USERNAME with your actual GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/ciphio.git

# Set main branch name (GitHub uses 'main', not 'master')
git branch -M main

# Push your code to GitHub
git push -u origin main
```

**That's it!** Your code is now safely backed up on GitHub. 🎉

---

## 🔐 Important Security Notes

### ❌ NEVER Commit These Files (Already in .gitignore):

- `android/keystore.properties` - Contains signing keys
- `android/app/google-services.json` - Google services config
- `ios/GoogleService-Info.plist` - Apple services config
- `*.key`, `*.pem`, `*.p12` - Any private keys
- `.env`, `secrets.json` - Any secrets

### ✅ Safe to Commit:

- All source code (.kt, .swift files)
- Documentation (.md files)
- Build configurations (gradle, xcodeproj)
- Assets and resources
- Tests

---

## 📝 Daily Git Workflow (After Setup)

### When You Make Changes:

```bash
cd /Users/qaantum/Desktop/Project

# See what changed
git status

# Stage all changes
git add .

# Commit with descriptive message
git commit -m "Added browser extension support"

# Push to GitHub
git push
```

### Good Commit Message Examples:

```
✅ "Added dark web monitoring feature"
✅ "Fixed crash on iOS when deleting password"
✅ "Improved onboarding flow UX"
✅ "Updated app store screenshots"
✅ "Performance: Optimized password list rendering"
❌ "changes"
❌ "fix"
❌ "update"
```

---

## 🌿 Git Branching Strategy (Optional but Recommended)

### For Organized Development:

```bash
# Main branch (production-ready code)
main

# Development branch (active development)
git checkout -b develop

# Feature branches (new features)
git checkout -b feature/browser-extension
git checkout -b feature/cloud-sync

# Bug fix branches
git checkout -b fix/ios-crash-on-delete

# Release branches
git checkout -b release/v1.1.0
```

### Workflow:

```
1. Create feature branch from develop
2. Work on feature
3. Commit regularly
4. Merge back to develop when done
5. Test on develop
6. Merge to main when ready for release
```

---

## 🔄 Keeping GitHub Updated

### After Every Work Session:

```bash
# Quick save everything
git add .
git commit -m "Describe what you did"
git push

# Examples:
git commit -m "Completed M1: Pre-launch materials ready"
git commit -m "Created app store screenshots"
git commit -m "Submitted iOS app for review"
```

---

## 📦 Backing Up Locally (Belt + Suspenders)

### In Addition to GitHub:

1. **Time Machine** (macOS): Automatic local backups
2. **External Hard Drive**: Manual copy once a week
3. **Cloud Storage**: Dropbox/Google Drive copy (be careful with secrets!)

### Quick Backup Script:

```bash
# Create a backup
cd /Users/qaantum/Desktop
tar -czf ciphio-backup-$(date +%Y%m%d).tar.gz Project/

# Move to backup location
mv ciphio-backup-*.tar.gz ~/Backups/
```

---

## 🚨 Emergency Recovery

### If Something Goes Wrong:

```bash
# Undo last commit (keep changes)
git reset --soft HEAD~1

# Undo last commit (discard changes) - BE CAREFUL!
git reset --hard HEAD~1

# See commit history
git log --oneline

# Go back to specific commit
git checkout <commit-hash>

# Restore specific file from GitHub
git checkout origin/main -- path/to/file.swift
```

---

## 📊 Useful Git Commands

### Check Repository Status:

```bash
# What changed?
git status

# Who changed what?
git blame path/to/file.swift

# See all changes
git log --oneline --graph --all

# See what changed in last commit
git show

# See differences before committing
git diff
```

### Working with Remote:

```bash
# See remote URL
git remote -v

# Update from GitHub (pull latest)
git pull

# Push to GitHub
git push

# Force push (DANGEROUS - use carefully)
git push --force  # Only if you're sure!
```

---

## 🎯 Milestones to Commit

### Document Your Progress:

```bash
# After completing each milestone
git commit -m "Milestone M1 Complete: Pre-launch ready"
git commit -m "Milestone M2 Complete: Apps live on stores!"
git commit -m "Milestone M3 Complete: 1,000 downloads achieved"
git tag -a v1.0.0 -m "Launch version 1.0.0"
git push --tags
```

---

## 🔗 GitHub Repository Settings (After Creating)

### Recommended Settings:

1. **Settings → General:**
   - ✅ Disable Wiki (you have .md docs)
   - ✅ Disable Projects (unless you use them)
   - ✅ Enable Issues (for bug tracking)

2. **Settings → Branches:**
   - ✅ Add branch protection rule for `main`
   - ✅ Require pull request reviews (if working with team)

3. **Settings → Collaborators:**
   - Add team members if any
   - Set appropriate permissions

4. **Settings → Secrets:**
   - Add any CI/CD secrets if needed later
   - NEVER commit secrets to code!

---

## 📱 GitHub Mobile App (Optional)

Download GitHub mobile app to:
- Monitor repository activity
- Review PRs on the go
- Get notifications
- Quick code review

---

## ✅ Verification Checklist

After pushing to GitHub, verify:

- [ ] Go to https://github.com/YOUR_USERNAME/ciphio
- [ ] You see all your files
- [ ] README.md displays correctly
- [ ] No sensitive files visible (check .gitignore worked)
- [ ] Repository is private (if you chose private)
- [ ] Clone to another location to test:
  ```bash
  cd ~/Desktop
  git clone https://github.com/YOUR_USERNAME/ciphio.git ciphio-test
  cd ciphio-test
  # Verify files are all there
  ```

---

## 🎉 You're All Set!

Your code is now:
- ✅ Version controlled with Git
- ✅ Backed up on GitHub
- ✅ Ready to push updates anytime
- ✅ Recoverable if anything goes wrong

**Next Steps:**
1. Push to GitHub now (follow Step 2 above)
2. Start working on Milestone M1 tasks
3. Commit regularly (at least daily)
4. Push to GitHub at end of each work session

---

## 💡 Pro Tips

1. **Commit often:** Every logical change should be a commit
2. **Push daily:** At minimum, push at end of each day
3. **Write good messages:** Future you will thank you
4. **Branch for experiments:** Create branches for risky changes
5. **Tag releases:** Tag v1.0.0, v1.1.0, etc.
6. **Use GitHub Issues:** Track bugs and features
7. **Keep .gitignore updated:** Add new secret files as needed

---

**Questions?** Check: https://docs.github.com/en/get-started

**Ready to launch! 🚀**

