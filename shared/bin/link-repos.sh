#!/usr/bin/env bash
# Clone/update all known Cursor project repos under linked/
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LINKED="$ROOT/linked"
mkdir -p "$LINKED"

repos=(
  "beatlink|https://github.com/sorktl12-ux/beatlink.git"
)

for entry in "${repos[@]}"; do
  name="${entry%%|*}"
  url="${entry#*|}"
  dest="$LINKED/$name"
  if [[ -d "$dest/.git" ]]; then
    echo "UPDATE $name"
    git -C "$dest" fetch --depth 1 origin 2>/dev/null || true
    git -C "$dest" pull --ff-only 2>/dev/null || git -C "$dest" checkout main 2>/dev/null || true
  else
    echo "CLONE  $name"
    git clone --depth 1 "$url" "$dest"
  fi
done

echo "--- linked ---"
ls -1 "$LINKED"
echo "OK link-repos"
