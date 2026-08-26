#!/usr/bin/env bash
# Launch a MacBook My Machines twin of「아이폰 맥북 제어」via Cloud Agents API.
# Requires: CURSOR_API_KEY, and a running `agent worker start --name MacBook` on the Mac.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
API_KEY="${CURSOR_API_KEY:-}"
if [[ -z "$API_KEY" && -f "$HOME/.config/sorktl12/cursor_api_key" ]]; then
  API_KEY="$(tr -d ' \n\r' < "$HOME/.config/sorktl12/cursor_api_key")"
fi
if [[ -z "$API_KEY" && -f "$ROOT/.local/CURSOR_API_KEY" ]]; then
  API_KEY="$(tr -d ' \n\r' < "$ROOT/.local/CURSOR_API_KEY")"
fi
if [[ -z "$API_KEY" ]]; then
  echo "MISSING CURSOR_API_KEY — add Environment Secret or ~/.config/sorktl12/cursor_api_key"
  exit 2
fi

PROMPT=$(ROOT="$ROOT" python3 - <<'PY'
import os, re
from pathlib import Path
text = Path(os.environ["ROOT"], "shared", "HANDOFF_MAC.md").read_text(encoding="utf-8")
m = re.search(r"### C\..*?\n```\n(.*?)```", text, re.S)
print((m.group(1).strip() if m else "Read shared/HANDOFF_MAC.md and continue as Mac twin."))
PY
)

PAYLOAD=$(PROMPT="$PROMPT" python3 - <<'PY'
import json, os
print(json.dumps({
  "name": "아이폰 맥북 제어 (Mac)",
  "prompt": {"text": os.environ["PROMPT"]},
  "env": {"type": "machine", "name": "MacBook"},
  "repos": [{
    "url": "https://github.com/sorktl12-ux/-",
    "startingRef": "cursor/iphone-mac-data-organizer-c10a"
  }],
  "workOnCurrentBranch": True,
  "autoCreatePR": False
}, ensure_ascii=False))
PY
)

echo "POST /v1/agents → My Machines MacBook …"
RESP=$(curl -sS --request POST \
  --url "https://api.cursor.com/v1/agents" \
  -u "${API_KEY}:" \
  --header "Content-Type: application/json" \
  --data "$PAYLOAD")
echo "$RESP" | python3 -m json.tool 2>/dev/null || echo "$RESP"
echo "$RESP" | python3 -c 'import sys,json; d=json.load(sys.stdin); a=d.get("agent") or {}; print("URL", a.get("url")); print("ID", a.get("id")); print("STATUS", a.get("status"))' 2>/dev/null || true
