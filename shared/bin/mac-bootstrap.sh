#!/usr/bin/env bash
# Bootstrap this hub on the MacBook and print My Machines twin steps.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

echo "== hub pull =="
git fetch origin || true
git status -sb || true

echo "== submodules + linked repos =="
git submodule update --init --recursive 2>/dev/null || true
chmod +x shared/bin/*.sh 2>/dev/null || true
bash shared/bin/link-repos.sh || true

echo
echo "== next: start My Machines worker =="
echo "  agent login"
echo "  agent worker start --name \"MacBook\""
echo
echo "== then open a NEW agent on cursor.com/agents =="
echo "  Repo: sorktl12-ux/-"
echo "  Run on: My Machines → MacBook"
echo "  Paste first message from shared/HANDOFF_MAC.md section C"
echo
echo "HANDOFF: $ROOT/shared/HANDOFF_MAC.md"
test -f shared/HANDOFF_MAC.md && echo "HANDOFF_OK"
