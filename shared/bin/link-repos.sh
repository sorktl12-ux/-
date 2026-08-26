#!/usr/bin/env bash
# Clone/update all repos listed in linked/registry.json that have a github URL.
# Uses GITHUB_TOKEN (classic PAT, repo scope) when set — required for private repos.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
export ROOT
REG="$ROOT/linked/registry.json"
mkdir -p "$ROOT/linked"

if ! command -v python3 >/dev/null; then
  echo "python3 required"; exit 1
fi

python3 - <<'PY'
import json, os, subprocess, urllib.parse

root = os.environ["ROOT"]
reg = json.load(open(os.path.join(root, "linked", "registry.json")))
token = (os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN") or "").strip()

def auth_url(url: str) -> str:
    if not token:
        return url
    if "://" not in url:
        return url
    scheme, rest = url.split("://", 1)
    if "@" in rest.split("/", 1)[0]:
        return url
    return f"{scheme}://x-access-token:{urllib.parse.quote(token, safe='')}@{rest}"

for r in reg["repos"]:
    url = r.get("github")
    path = r.get("path") or f"linked/{r['name']}"
    status = r.get("status")
    if path == "." or status == "hub":
        print(f"SKIP hub {r['name']}")
        continue
    if status == "mail_service":
        print(f"MAIL  {r['name']} (no git clone; see {path})")
        continue
    if not url:
        print(f"NEED_URL {r['name']} aliases={r.get('sidebar_aliases')}")
        continue
    dest = os.path.join(root, path)
    git_dir = os.path.join(dest, ".git")
    base = url if url.endswith(".git") else url + ".git"
    clone_url = auth_url(base)
    if os.path.isdir(git_dir) or os.path.isfile(git_dir):
        print(f"UPDATE {r['name']}")
        subprocess.call(["git", "-C", dest, "fetch", "--depth", "1", "origin"])
        rc = subprocess.call(["git", "-C", dest, "pull", "--ff-only"])
        if rc != 0:
            subprocess.call(["git", "-C", dest, "checkout", "main"])
    else:
        print(f"CLONE  {r['name']} -> {path} ({r.get('visibility') or 'unknown'})")
        parent = os.path.dirname(dest)
        if parent:
            os.makedirs(parent, exist_ok=True)
        if os.path.exists(dest) and not os.listdir(dest):
            os.rmdir(dest)
        try:
            subprocess.check_call(["git", "clone", "--depth", "1", clone_url, dest])
        except subprocess.CalledProcessError:
            if r.get("visibility") == "private" and not token:
                print(f"FAIL   {r['name']}: private — set GITHUB_TOKEN (repo scope) and re-run")
            else:
                print(f"FAIL   {r['name']}: clone failed (auth or missing repo)")
print("OK link-repos")
PY
