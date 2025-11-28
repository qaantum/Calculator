#!/usr/bin/env python3
"""
Create a GitHub issue using the GitHub API.
Works without GitHub CLI - just needs a GitHub Personal Access Token.

Usage:
    python3 create_issue.py "Title" "Description" [labels]

Environment:
    Set GITHUB_TOKEN environment variable with your Personal Access Token.
    Create one at: https://github.com/settings/tokens
"""

import os
import sys
import json
import urllib.request
import urllib.parse

REPO = "qaantum/ciphio-vault"
GITHUB_API = "https://api.github.com"

def create_issue(title, description, labels=None):
    """Create a GitHub issue."""
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("❌ Error: GITHUB_TOKEN environment variable not set")
        print("Create a token at: https://github.com/settings/tokens")
        print("Then run: export GITHUB_TOKEN=your_token_here")
        return False
    
    if labels is None:
        labels = ["enhancement"]
    elif isinstance(labels, str):
        labels = [l.strip() for l in labels.split(",")]
    
    url = f"{GITHUB_API}/repos/{REPO}/issues"
    data = {
        "title": title,
        "body": description,
        "labels": labels
    }
    
    req = urllib.request.Request(url, method="POST")
    req.add_header("Authorization", f"token {token}")
    req.add_header("Accept", "application/vnd.github.v3+json")
    req.add_header("Content-Type", "application/json")
    
    try:
        with urllib.request.urlopen(req, data=json.dumps(data).encode()) as response:
            result = json.loads(response.read())
            print(f"✅ Issue created successfully!")
            print(f"   Issue #{result['number']}: {result['html_url']}")
            return True
    except urllib.error.HTTPError as e:
        error_body = e.read().decode()
        print(f"❌ Failed to create issue: {e.code}")
        print(f"   {error_body}")
        return False
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 create_issue.py \"Title\" \"Description\" [labels]")
        print("Example: python3 create_issue.py \"Fix bug\" \"Description here\" \"bug,urgent\"")
        sys.exit(1)
    
    title = sys.argv[1]
    description = sys.argv[2]
    labels = sys.argv[3] if len(sys.argv) > 3 else "enhancement"
    
    success = create_issue(title, description, labels)
    sys.exit(0 if success else 1)

