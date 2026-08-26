#!/usr/bin/env python3
"""Read self-sent schedule emails and upsert Google Calendar events."""

from __future__ import annotations

import base64
import os
import re
import sys
from datetime import date, datetime, timedelta
from email.utils import parsedate_to_datetime
from typing import Any
from zoneinfo import ZoneInfo

from google.auth.transport.requests import Request
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

SCOPES = [
    "https://www.googleapis.com/auth/gmail.readonly",
    "https://www.googleapis.com/auth/calendar",
]
TZ = ZoneInfo("Asia/Seoul")
DRY_RUN = os.environ.get("DRY_RUN", "").lower() in ("1", "true", "yes")
CALENDAR_ID = os.environ.get("GOOGLE_CALENDAR_ID", "primary")
YEAR_HINT = int(os.environ.get("SCHEDULE_YEAR", datetime.now(TZ).year))

# Keywords to find the emails the user mentioned
GMAIL_QUERIES = [
    'from:me to:me (시간표 OR 목요일 OR 학사일정 OR "2학기" OR 학사)',
    "from:me subject:(시간표 OR 학사일정 OR 목요일)",
]


def get_credentials() -> Credentials:
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
            "Missing secrets: "
            + ", ".join(missing)
            + "\nAdd them to Cursor environment secrets, then re-run."
        )
    creds = Credentials(
        token=None,
        refresh_token=refresh_token,
        token_uri="https://oauth2.googleapis.com/token",
        client_id=client_id,
        client_secret=client_secret,
        scopes=SCOPES,
    )
    creds.refresh(Request())
    return creds


def gmail_body(payload: dict[str, Any]) -> str:
    if payload.get("body", {}).get("data"):
        return base64.urlsafe_b64decode(payload["body"]["data"]).decode(
            "utf-8", errors="replace"
        )
    parts = payload.get("parts") or []
    texts: list[str] = []
    for part in parts:
        mime = part.get("mimeType", "")
        if mime == "text/plain" and part.get("body", {}).get("data"):
            texts.append(
                base64.urlsafe_b64decode(part["body"]["data"]).decode(
                    "utf-8", errors="replace"
                )
            )
        elif mime.startswith("multipart/"):
            texts.append(gmail_body(part))
        elif mime == "text/html" and part.get("body", {}).get("data") and not texts:
            html = base64.urlsafe_b64decode(part["body"]["data"]).decode(
                "utf-8", errors="replace"
            )
            texts.append(re.sub(r"<[^>]+>", " ", html))
    return "\n".join(texts)


def fetch_candidate_emails(gmail) -> list[dict[str, Any]]:
    seen: set[str] = set()
    messages: list[dict[str, Any]] = []
    for q in GMAIL_QUERIES:
        resp = (
            gmail.users()
            .messages()
            .list(userId="me", q=q, maxResults=20)
            .execute()
        )
        for item in resp.get("messages", []):
            mid = item["id"]
            if mid in seen:
                continue
            seen.add(mid)
            full = (
                gmail.users()
                .messages()
                .get(userId="me", id=mid, format="full")
                .execute()
            )
            headers = {
                h["name"].lower(): h["value"]
                for h in full.get("payload", {}).get("headers", [])
            }
            body = gmail_body(full.get("payload", {}))
            messages.append(
                {
                    "id": mid,
                    "subject": headers.get("subject", ""),
                    "date": headers.get("date", ""),
                    "snippet": full.get("snippet", ""),
                    "body": body,
                }
            )
    # Prefer most recent first
    def sort_key(m: dict[str, Any]) -> datetime:
        try:
            return parsedate_to_datetime(m["date"]).astimezone(TZ)
        except Exception:
            return datetime.min.replace(tzinfo=TZ)

    messages.sort(key=sort_key, reverse=True)
    return messages


def pick_schedule_emails(messages: list[dict[str, Any]]) -> tuple[dict | None, dict | None]:
    thursday = None
    academic = None
    for m in messages:
        blob = f"{m['subject']}\n{m['body']}\n{m['snippet']}"
        if thursday is None and re.search(r"목요일|시간표", blob):
            thursday = m
        if academic is None and re.search(r"학사일정|2\s*학기|학사", blob):
            academic = m
        if thursday and academic:
            break
    return thursday, academic


DATE_PATTERNS = [
    # 2026-09-01, 2026.9.1, 2026/09/01
    re.compile(
        r"(?P<y>20\d{2})[./-](?P<m>\d{1,2})[./-](?P<d>\d{1,2})"
    ),
    # 9월 1일, 09월01일
    re.compile(r"(?P<m>\d{1,2})\s*월\s*(?P<d>\d{1,2})\s*일"),
    # 9/1, 09-01 (assume YEAR_HINT)
    re.compile(r"(?<!\d)(?P<m>\d{1,2})[./-](?P<d>\d{1,2})(?!\d)"),
]

TIME_RANGE = re.compile(
    r"(?P<h1>\d{1,2}):(?P<m1>\d{2})\s*[-~–]\s*(?P<h2>\d{1,2}):(?P<m2>\d{2})"
)
TIME_SINGLE = re.compile(r"(?P<h>\d{1,2}):(?P<m>\d{2})")


def parse_date_token(token: str, default_year: int) -> date | None:
    for pat in DATE_PATTERNS:
        m = pat.search(token)
        if not m:
            continue
        gd = m.groupdict()
        y = int(gd.get("y") or default_year)
        mo = int(gd["m"])
        d = int(gd["d"])
        try:
            return date(y, mo, d)
        except ValueError:
            continue
    return None


def parse_events_from_text(text: str, source: str) -> list[dict[str, Any]]:
    """Heuristic line parser for Korean academic/schedule emails."""
    events: list[dict[str, Any]] = []
    lines = [ln.strip() for ln in text.splitlines() if ln.strip()]
    for ln in lines:
        # Skip pure headers
        if len(ln) < 4:
            continue
        d = parse_date_token(ln, YEAR_HINT)
        if not d:
            continue
        # Title: remove date tokens
        title = ln
        for pat in DATE_PATTERNS:
            title = pat.sub(" ", title)
        title = re.sub(r"\s+", " ", title).strip(" -–·|:：")
        if not title or len(title) < 2:
            title = f"일정 ({d.isoformat()})"

        tr = TIME_RANGE.search(ln)
        if tr:
            start = datetime(
                d.year,
                d.month,
                d.day,
                int(tr.group("h1")),
                int(tr.group("m1")),
                tzinfo=TZ,
            )
            end = datetime(
                d.year,
                d.month,
                d.day,
                int(tr.group("h2")),
                int(tr.group("m2")),
                tzinfo=TZ,
            )
            events.append(
                {
                    "summary": title,
                    "start": start,
                    "end": end,
                    "all_day": False,
                    "source": source,
                }
            )
            continue

        # All-day academic events
        events.append(
            {
                "summary": title,
                "start": d,
                "end": d + timedelta(days=1),
                "all_day": True,
                "source": source,
            }
        )
    return events


THURSDAY_LINE = re.compile(
    r"(?P<title>.+?)\s+"
    r"(?P<h1>\d{1,2}):(?P<m1>\d{2})\s*[-~–]\s*(?P<h2>\d{1,2}):(?P<m2>\d{2})"
)


def parse_thursday_recurring(text: str, source: str) -> list[dict[str, Any]]:
    """Extract weekly Thursday class blocks; apply until semester end if found."""
    blocks: list[dict[str, Any]] = []
    for ln in text.splitlines():
        ln = ln.strip()
        if not ln:
            continue
        # Prefer lines that look like class schedule
        m = THURSDAY_LINE.search(ln)
        if not m:
            continue
        title = m.group("title").strip(" -–·|:：")
        title = re.sub(r"목요일|시간표", "", title).strip(" -–·|:：")
        if not title:
            title = "목요일 수업"
        blocks.append(
            {
                "summary": title,
                "h1": int(m.group("h1")),
                "m1": int(m.group("m1")),
                "h2": int(m.group("h2")),
                "m2": int(m.group("m2")),
                "source": source,
            }
        )
    return blocks


def find_semester_range(academic_text: str) -> tuple[date, date]:
    """Guess 2nd semester window from academic calendar text."""
    dates = []
    for ln in academic_text.splitlines():
        d = parse_date_token(ln, YEAR_HINT)
        if d:
            dates.append(d)
    if dates:
        # Prefer dates in Aug–Dec of YEAR_HINT / YEAR_HINT+1 Jan–Feb
        fall = [
            d
            for d in dates
            if (d.year == YEAR_HINT and d.month >= 8)
            or (d.year == YEAR_HINT + 1 and d.month <= 2)
        ]
        if fall:
            return min(fall), max(fall)
        return min(dates), max(dates)
    # Default Korean 2nd semester window
    return date(YEAR_HINT, 9, 1), date(YEAR_HINT + 1, 2, 28)


def thursdays_between(start: date, end: date) -> list[date]:
    d = start
    while d.weekday() != 3:  # Thursday
        d += timedelta(days=1)
        if d > end:
            return []
    out = []
    while d <= end:
        out.append(d)
        d += timedelta(days=7)
    return out


def event_fingerprint(ev: dict[str, Any]) -> str:
    if ev["all_day"]:
        return f"{ev['summary']}|{ev['start']}|allday"
    return f"{ev['summary']}|{ev['start'].isoformat()}|{ev['end'].isoformat()}"


def existing_keys(calendar, time_min: datetime, time_max: datetime) -> set[str]:
    keys: set[str] = set()
    page_token = None
    while True:
        resp = (
            calendar.events()
            .list(
                calendarId=CALENDAR_ID,
                timeMin=time_min.isoformat(),
                timeMax=time_max.isoformat(),
                singleEvents=True,
                maxResults=2500,
                pageToken=page_token,
            )
            .execute()
        )
        for item in resp.get("items", []):
            summary = item.get("summary", "")
            start = item.get("start", {})
            end = item.get("end", {})
            if "date" in start:
                keys.add(f"{summary}|{start['date']}|allday")
            else:
                keys.add(f"{summary}|{start.get('dateTime')}|{end.get('dateTime')}")
        page_token = resp.get("nextPageToken")
        if not page_token:
            break
    return keys


def to_calendar_body(ev: dict[str, Any]) -> dict[str, Any]:
    body: dict[str, Any] = {
        "summary": ev["summary"],
        "description": f"Synced from Gmail ({ev.get('source', 'email')})",
        "reminders": {"useDefault": True},
    }
    if ev["all_day"]:
        body["start"] = {"date": ev["start"].isoformat()}
        body["end"] = {"date": ev["end"].isoformat()}
    else:
        body["start"] = {
            "dateTime": ev["start"].isoformat(),
            "timeZone": "Asia/Seoul",
        }
        body["end"] = {
            "dateTime": ev["end"].isoformat(),
            "timeZone": "Asia/Seoul",
        }
    return body


def main() -> int:
    print("Connecting to Google APIs…")
    creds = get_credentials()
    gmail = build("gmail", "v1", credentials=creds, cache_discovery=False)
    calendar = build("calendar", "v3", credentials=creds, cache_discovery=False)

    messages = fetch_candidate_emails(gmail)
    print(f"Found {len(messages)} candidate email(s)")
    for m in messages[:10]:
        print(f"  - [{m['date']}] {m['subject'][:80]}")

    thursday_mail, academic_mail = pick_schedule_emails(messages)
    if not thursday_mail and not academic_mail:
        print(
            "Could not find Thursday schedule or academic calendar emails.\n"
            "Forward/paste the email text, or adjust GMAIL_QUERIES."
        )
        return 1

    all_events: list[dict[str, Any]] = []

    academic_text = academic_mail["body"] if academic_mail else ""
    if academic_mail:
        print(f"\nAcademic calendar email: {academic_mail['subject']}")
        all_events.extend(
            parse_events_from_text(academic_text, academic_mail["subject"])
        )

    semester_start, semester_end = find_semester_range(
        academic_text or (thursday_mail["body"] if thursday_mail else "")
    )
    print(f"Semester window: {semester_start} → {semester_end}")

    # Academic date set for "특이사항" — skip Thursday classes on these days
    special_days = {
        ev["start"]
        for ev in all_events
        if ev["all_day"] and isinstance(ev["start"], date)
    }

    if thursday_mail:
        print(f"Thursday schedule email: {thursday_mail['subject']}")
        blocks = parse_thursday_recurring(
            thursday_mail["body"], thursday_mail["subject"]
        )
        if not blocks:
            # Fallback: treat timed lines without requiring title pattern
            for ln in thursday_mail["body"].splitlines():
                tr = TIME_RANGE.search(ln)
                if not tr:
                    continue
                title = TIME_RANGE.sub("", ln).strip(" -–·|:：") or "목요일 일정"
                blocks.append(
                    {
                        "summary": title,
                        "h1": int(tr.group("h1")),
                        "m1": int(tr.group("m1")),
                        "h2": int(tr.group("h2")),
                        "m2": int(tr.group("m2")),
                        "source": thursday_mail["subject"],
                    }
                )
        print(f"  Parsed {len(blocks)} Thursday time block(s)")
        for day in thursdays_between(semester_start, semester_end):
            if day in special_days:
                print(f"  Skip Thursday {day} (학사 특이사항)")
                continue
            for b in blocks:
                start = datetime(
                    day.year, day.month, day.day, b["h1"], b["m1"], tzinfo=TZ
                )
                end = datetime(
                    day.year, day.month, day.day, b["h2"], b["m2"], tzinfo=TZ
                )
                all_events.append(
                    {
                        "summary": b["summary"],
                        "start": start,
                        "end": end,
                        "all_day": False,
                        "source": b["source"],
                    }
                )

    # Deduplicate within batch
    unique: dict[str, dict[str, Any]] = {}
    for ev in all_events:
        unique[event_fingerprint(ev)] = ev
    events = list(unique.values())
    print(f"\nTotal events to sync: {len(events)}")

    if not events:
        print("No events parsed. Paste the email body for manual mapping.")
        if thursday_mail:
            print("--- Thursday body preview ---")
            print(thursday_mail["body"][:2000])
        if academic_mail:
            print("--- Academic body preview ---")
            print(academic_mail["body"][:2000])
        return 1

    time_min = datetime.combine(semester_start, datetime.min.time(), TZ)
    time_max = datetime.combine(
        semester_end + timedelta(days=1), datetime.min.time(), TZ
    )
    existing = existing_keys(calendar, time_min, time_max)

    created = skipped = 0
    for ev in sorted(
        events,
        key=lambda e: (
            e["start"].isoformat()
            if hasattr(e["start"], "isoformat")
            else str(e["start"])
        ),
    ):
        fp = event_fingerprint(ev)
        # Also match existing with timezone-normalized datetime strings loosely
        if fp in existing or any(
            ev["summary"] in k and str(ev["start"])[:10] in k for k in existing
        ):
            skipped += 1
            continue
        body = to_calendar_body(ev)
        if DRY_RUN:
            print(f"[dry-run] CREATE {body['summary']} | {body['start']}")
            created += 1
            continue
        calendar.events().insert(calendarId=CALENDAR_ID, body=body).execute()
        print(f"CREATE {body['summary']} | {body['start']}")
        created += 1

    print(f"\nDone. created={created} skipped={skipped} dry_run={DRY_RUN}")
    print("Check Google Calendar on phone — sync may take a minute.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
