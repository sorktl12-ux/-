#!/usr/bin/env bash
# Clone/update all repos listed in linked/registry.json that have a github URL
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
REG="$ROOT/linked/registry.json"
LINKED="$ROOT/linked"
mkdir -p "$LINKED"

if ! command -v python3 >/dev/null; then
  echo "python3 required"; exit 1
fi

python3 - <<PY
import json, os, subprocess
root = "$ROOT"
reg = json.load(open("$REG"))
for r in reg["repos"]:
    url = r.get("github")
    path = r.get("path") or f"linked/{r['name']}"
    if path == ".":
        print(f"SKIP hub {r['name']}")
        continue
    if not url:
        print(f"NEED_URL {r['name']} aliases={r.get('sidebar_aliases')}")
        continue
    dest = os.path.join(root, path)
    git_dir = os.path.join(dest, ".git")
    if os.path.isdir(git_dir) or os.path.isfile(git_dir):
        print(f"UPDATE {r['name']}")
        subprocess.call(["git", "-C", dest, "fetch", "--depth", "1", "origin"])
        rc = subprocess.call(["git", "-C", dest, "pull", "--ff-only"])
        if rc != 0:
            subprocess.call(["git", "-C", dest, "checkout", "main"])
    else:
        print(f"CLONE  {r['name']} -> {path}")
        os.makedirs(os.path.dirname(dest) or ".", exist_ok=True)
        if os.path.exists(dest) and not os.listdir(dest):
            os.rmdir(dest)
        subprocess.check_call(["git", "clone", "--depth", "1", url, dest])
print("OK link-repos")
PY
