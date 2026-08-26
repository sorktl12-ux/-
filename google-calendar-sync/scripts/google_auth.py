#!/usr/bin/env python3
"""Shared Google credentials helper — refresh token = automatic login."""

from __future__ import annotations

import os

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials

SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar",
]


def get_credentials(scopes: list[str] | None = None) -> Credentials:
    scopes = scopes or SCOPES
    client_id = os.environ.get("GOOGLE_CLIENT_ID")
    client_secret = os.environ.get("GOOGLE_CLIENT_SECRET")
    refresh_token = os.environ.get("GOOGLE_REFRESH_TOKEN")
    missing = [
        n
        for n, v in [
            ("GOOGLE_CLIENT_ID", client_id),
            ("GOOGLE_CLIENT_SECRET", client_secret),
            ("GOOGLE_REFRESH_TOKEN", refresh_token),
        ]
        if not v
    ]
    if missing:
        raise SystemExit(
            "Automatic Google login needs secrets: "
            + ", ".join(missing)
            + "\nRun scripts/oauth_setup.py once after adding CLIENT_ID/SECRET, "
            "then store GOOGLE_REFRESH_TOKEN."
        )
    creds = Credentials(
        token=None,
        refresh_token=refresh_token,
        token_uri="https://oauth2.googleapis.com/token",
        client_id=client_id,
        client_secret=client_secret,
        scopes=scopes,
    )
    creds.refresh(Request())
    return creds
