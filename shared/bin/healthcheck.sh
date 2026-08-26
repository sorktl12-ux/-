#!/usr/bin/env bash
# Health check for shared hub on this computer
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ok=0; fail=0
check() {
  local name="$1"; shift
  if "$@"; then echo "OK  $name"; ok=$((ok+1)); else echo "FAIL $name"; fail=$((fail+1)); fi
}
check "shared/README" test -f "$ROOT/shared/README.md"
check "shared/PROFILE" test -f "$ROOT/shared/PROFILE.md"
check "shared/MEMORY" test -f "$ROOT/shared/MEMORY.md"
check "shared/CAPABILITIES" test -f "$ROOT/shared/CAPABILITIES.md"
check "AGENTS.md" test -f "$ROOT/AGENTS.md"
check "calendar scripts" test -f "$ROOT/google-calendar-sync/scripts/sync_from_gmail.py"
check "iphone scripts" test -f "$ROOT/iphone-data-organizer/scripts/full-organize.sh"
check "GOOGLE_CLIENT_ID" test -n "${GOOGLE_CLIENT_ID:-}"
check "GOOGLE_REFRESH_TOKEN" test -n "${GOOGLE_REFRESH_TOKEN:-}"
# Chrome CDP optional
if curl -s -m 1 http://127.0.0.1:9222/json/version >/dev/null 2>&1; then
  echo "OK  Chrome CDP"
  ok=$((ok+1))
else
  echo "WARN Chrome CDP (optional)"
fi
echo "--- result ok=$ok fail=$fail ---"
# secrets missing is expected until user adds them; don't hard-fail hub structure
struct_fail=0
test -f "$ROOT/shared/README.md" || struct_fail=1
test -f "$ROOT/shared/MEMORY.md" || struct_fail=1
exit $struct_fail
