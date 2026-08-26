#!/usr/bin/env python3
"""One-time Google OAuth. Saves refresh token for automatic future logins."""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

from google_auth_oauthlib.flow import InstalledAppFlow

SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar",
]

OUT = Path(os.environ.get("GOOGLE_TOKEN_OUT", "/tmp/google-oauth-result.json"))


def main() -> int:
    client_id = os.environ.get("GOOGLE_CLIENT_ID", "").strip()
    client_secret = os.environ.get("GOOGLE_CLIENT_SECRET", "").strip()
    if not client_id or not client_secret:
        print(
            "Set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET first "
            "(Cursor environment secrets), then re-run."
        )
        return 1

    client_config = {
        "installed": {
            "client_id": client_id,
            "client_secret": client_secret,
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "redirect_uris": ["http://localhost"],
        }
    }

    # Console / copy-paste flow works well on headless / remote desktops
    flow = InstalledAppFlow.from_client_config(client_config, scopes=SCOPES)
    print("Opening browser for Google consent…")
    print("If the browser does not open, copy the printed URL manually.")
    creds = flow.run_local_server(
        port=0,
        prompt="consent",
        access_type="offline",
        open_browser=True,
    )

    if not creds.refresh_token:
        print(
            "No refresh_token returned. Revoke prior grants at "
            "https://myaccount.google.com/permissions then re-run with prompt=consent."
        )
        return 1

    payload = {
        "GOOGLE_CLIENT_ID": client_id,
        "GOOGLE_CLIENT_SECRET": client_secret,
        "GOOGLE_REFRESH_TOKEN": creds.refresh_token,
        "scopes": SCOPES,
    }
    OUT.write_text(json.dumps(payload, indent=2))
    print()
    print("=== SUCCESS ===")
    print(f"Saved: {OUT}")
    print()
    print("Add this Cursor environment secret:")
    print(f"  GOOGLE_REFRESH_TOKEN={creds.refresh_token}")
    print()
    print("After that, Gmail/Calendar scripts log in automatically.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
