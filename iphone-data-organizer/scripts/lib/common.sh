#!/usr/bin/env bash
# shellcheck disable=SC2034
set -euo pipefail

ORGANIZER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG_FILE="${CONFIG_FILE:-$ORGANIZER_ROOT/config/defaults.env}"

log() { printf '[%s] %s\n' "$(date '+%H:%M:%S')" "$*"; }
warn() { printf '[%s] WARN: %s\n' "$(date '+%H:%M:%S')" "$*" >&2; }
die() { printf '[%s] ERROR: %s\n' "$(date '+%H:%M:%S')" "$*" >&2; exit 1; }

load_config() {
  if [[ -f "$CONFIG_FILE" ]]; then
    # shellcheck source=/dev/null
    source "$CONFIG_FILE"
  else
    warn "설정 파일 없음: $CONFIG_FILE (예제 파일 복사 후 수정하세요)"
    ICLOUD_DRIVE="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
    DOWNLOADS_FOLDER="${ICLOUD_DRIVE}/Downloads"
    ORGANIZED_ROOT="${ICLOUD_DRIVE}/Organized"
    DUPLICATE_POLICY="skip"
    DRY_RUN="${DRY_RUN:-false}"
    ENABLE_USB_IMPORT="true"
    IPHONE_IMPORT_ROOT="${HOME}/Pictures/iPhone Import"
    KAKAOTALK_FOLDERS=()
  fi

  DOWNLOADS_FOLDER="${DOWNLOADS_FOLDER:-$ICLOUD_DRIVE/Downloads}"
  ORGANIZED_ROOT="${ORGANIZED_ROOT:-$ICLOUD_DRIVE/Organized}"
  DUPLICATE_POLICY="${DUPLICATE_POLICY:-skip}"
  DRY_RUN="${DRY_RUN:-false}"
}

ensure_dir() {
  local dir="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] mkdir -p $dir"
  else
    mkdir -p "$dir"
  fi
}

safe_move() {
  local src="$1"
  local dest_dir="$2"
  local basename
  basename="$(basename "$src")"
  local dest="$dest_dir/$basename"

  ensure_dir "$dest_dir"

  if [[ -e "$dest" ]]; then
    case "$DUPLICATE_POLICY" in
      delete)
        warn "중복 삭제: $dest"
        [[ "$DRY_RUN" == "true" ]] || rm -f "$dest"
        ;;
      rename)
        local i=1
        local stem ext
        stem="${basename%.*}"
        ext="${basename##*.}"
        if [[ "$stem" == "$ext" ]]; then ext=""; else ext=".${ext}"; fi
        while [[ -e "$dest" ]]; do
          dest="$dest_dir/${stem}_${i}${ext}"
          ((i++))
        done
        ;;
      skip|*)
        warn "중복 건너뜀: $basename -> $dest_dir"
        return 0
        ;;
    esac
  fi

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[dry-run] mv '$src' -> '$dest'"
  else
    mv "$src" "$dest"
    log "이동: $basename -> $dest_dir"
  fi
}

require_macos() {
  [[ "$(uname -s)" == "Darwin" ]] || die "이 스크립트는 macOS에서만 실행할 수 있습니다."
}
