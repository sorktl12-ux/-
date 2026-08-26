#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"
load_config
require_macos

log "=== iCloud Drive 데이터 정리 시작 ==="

ensure_dir "$DOWNLOADS_FOLDER"
ensure_dir "$ORGANIZED_ROOT"

# 카카오톡 관련 폴더 → Downloads 로 이동
if [[ ${#KAKAOTALK_FOLDERS[@]} -gt 0 ]]; then
  for folder in "${KAKAOTALK_FOLDERS[@]}"; do
    if [[ -d "$folder" ]]; then
      log "카카오톡 폴더 정리: $folder"
      while IFS= read -r -d '' file; do
        safe_move "$file" "$DOWNLOADS_FOLDER"
      done < <(find "$folder" -maxdepth 1 -type f -print0 2>/dev/null || true)
    fi
  done
fi

# iCloud Drive 루트에 흩어진 일반 파일 → Downloads
if [[ -d "$ICLOUD_DRIVE" ]]; then
  while IFS= read -r -d '' file; do
    safe_move "$file" "$DOWNLOADS_FOLDER"
  done < <(find "$ICLOUD_DRIVE" -maxdepth 1 -type f -print0 2>/dev/null || true)
fi

# Downloads 안 파일을 확장자별 하위 폴더로 분류
declare -A CATEGORY_MAP=(
  ["pdf"]="Documents/PDF"
  ["doc"]="Documents/Word" ["docx"]="Documents/Word"
  ["xls"]="Documents/Excel" ["xlsx"]="Documents/Excel"
  ["ppt"]="Documents/PowerPoint" ["pptx"]="Documents/PowerPoint"
  ["txt"]="Documents/Text" ["md"]="Documents/Text"
  ["jpg"]="Images" ["jpeg"]="Images" ["png"]="Images" ["gif"]="Images" ["heic"]="Images" ["webp"]="Images"
  ["mp4"]="Videos" ["mov"]="Videos" ["m4v"]="Videos"
  ["mp3"]="Audio" ["m4a"]="Audio" ["wav"]="Audio"
  ["zip"]="Archives" ["rar"]="Archives" ["7z"]="Archives" ["tar"]="Archives" ["gz"]="Archives"
)

if [[ -d "$DOWNLOADS_FOLDER" ]]; then
  while IFS= read -r -d '' file; do
    ext="${file##*.}"
    ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
    sub="${CATEGORY_MAP[$ext_lower]:-Misc}"
    target="$ORGANIZED_ROOT/$sub"
    safe_move "$file" "$target"
  done < <(find "$DOWNLOADS_FOLDER" -maxdepth 1 -type f -print0 2>/dev/null || true)
fi

log "=== iCloud Drive 정리 완료 ==="
log "결과 위치: $ORGANIZED_ROOT"
log "iPhone의 파일 앱 > iCloud Drive 에서 동기화됩니다."
