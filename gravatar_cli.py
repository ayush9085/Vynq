#!/usr/bin/env python3
"""
Gravatar CLI Tool for Vynk
Uploads and sets the Gravatar avatar for an email address via Gravatar v3 REST API.

Usage:
  python3 gravatar_cli.py --email welcome@vynk.space --image landing/public/vynk_icon_grad.png --token <GRAVATAR_BEARER_TOKEN>
  python3 gravatar_cli.py --check welcome@vynk.space
"""

import sys
import argparse
import hashlib
import requests
from pathlib import Path

def get_email_hash(email: str) -> str:
    cleaned = email.strip().lower()
    return hashlib.sha256(cleaned.encode('utf-8')).hexdigest()

def check_gravatar(email: str):
    email_hash = get_email_hash(email)
    url = f"https://www.gravatar.com/avatar/{email_hash}?d=404"
    print(f"Checking Gravatar for email: {email}")
    print(f"SHA256 Hash: {email_hash}")
    print(f"Gravatar URL: https://www.gravatar.com/avatar/{email_hash}")
    
    resp = requests.head(url)
    if resp.status_code == 200:
        print("🟢 Gravatar is ACTIVE for this email!")
    elif resp.status_code == 404:
        print("🟡 No custom Gravatar found yet for this email.")
    else:
        print(f"Status response code: {resp.status_code}")

def upload_gravatar(email: str, image_path: str, token: str):
    path = Path(image_path)
    if not path.exists():
        print(f"❌ Error: Image file not found at '{image_path}'")
        sys.exit(1)

    email_hash = get_email_hash(email)
    url = "https://api.gravatar.com/v3/me/avatars"
    headers = {
        "Authorization": f"Bearer {token}"
    }

    print(f"Uploading avatar image '{image_path}' to Gravatar for '{email}'...")

    with open(path, "rb") as f:
        files = {
            "image": (path.name, f, "image/png")
        }
        params = {
            "selected_email_hash": email_hash,
            "select_avatar": "true"
        }

        try:
            res = requests.post(url, headers=headers, files=files, params=params)
            if res.status_code in (200, 201):
                data = res.json()
                print("✅ Success! Avatar uploaded and selected for Gravatar.")
                print(f"Avatar Details: {data}")
            else:
                print(f"❌ Gravatar API error ({res.status_code}): {res.text}")
        except Exception as e:
            print(f"❌ Exception occurred: {e}")

def main():
    parser = argparse.ArgumentParser(description="Gravatar CLI Tool for Vynk")
    parser.add_argument("--check", type=str, help="Check if a Gravatar exists for an email")
    parser.add_argument("--email", type=str, help="Target email address (e.g., welcome@vynk.space)")
    parser.add_argument("--image", type=str, default="landing/public/vynk_icon_grad.png", help="Path to avatar image PNG/JPG")
    parser.add_argument("--token", type=str, help="Gravatar OAuth Bearer token")

    args = parser.parse_args()

    if args.check:
        check_gravatar(args.check)
        return

    if not args.email:
        print("Usage error: --email parameter is required.")
        print("Example: python3 gravatar_cli.py --email welcome@vynk.space --token <YOUR_TOKEN>")
        sys.exit(1)

    if not args.token:
        print(f"Checking current Gravatar status for {args.email}...\n")
        check_gravatar(args.email)
        print("\nTo upload a new avatar via Gravatar API:")
        print(f"1. Generate an Access Token at https://gravatar.com/connect/developer")
        print(f"2. Run: python3 gravatar_cli.py --email {args.email} --image {args.image} --token <YOUR_GRAVATAR_TOKEN>")
        return

    upload_gravatar(args.email, args.image, args.token)

if __name__ == "__main__":
    main()
