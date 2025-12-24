import json
import os

langs = ['es', 'fr', 'de', 'zh', 'it', 'pt', 'ru', 'ja', 'ko', 'ar', 'hi', 'tr', 'vi', 'th', 'nl', 'pl', 'id', 'sv']
source_path = 'lib/l10n/app_en.arb'

def load_json(path):
    try:
        with open(path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return {}

def save_json(path, data):
    with open(path, 'w') as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

# Load source (English)
source_data = load_json(source_path)
if not source_data:
    print("Failed to load source ARB")
    exit(1)

for lang in langs:
    target_path = f'lib/l10n/app_{lang}.arb'
    target_data = load_json(target_path)
    
    updated = False
    for key, value in source_data.items():
        if key not in target_data:
            target_data[key] = value # Use English as fallback
            updated = True
            
    if updated:
        save_json(target_path, target_data)
        print(f"Updated {target_path}")
    else:
        print(f"No changes for {target_path}")
