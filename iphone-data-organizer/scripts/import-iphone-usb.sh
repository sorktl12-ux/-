#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"
load_config
require_macos

log "=== USB 연결 iPhone 데이터 가져오기 ==="

if [[ "${ENABLE_USB_IMPORT:-true}" != "true" ]]; then
  log "USB 가져오기 비활성화됨 (ENABLE_USB_IMPORT=false)"
  exit 0
fi

ensure_dir "$IPHONE_IMPORT_ROOT"

# pymobiledevice3 설치 확인
if ! command -v pymobiledevice3 &>/dev/null; then
  warn "pymobiledevice3 미설치. install.sh 를 먼저 실행하세요."
  warn "대안: Image Capture 앱으로 사진 수동 가져오기"
  exit 1
fi

# 연결된 기기 확인
if ! pymobiledevice3 usbmux list 2>/dev/null | grep -q "Identifier"; then
  die "iPhone이 USB로 연결되지 않았거나 '이 컴퓨터를 신뢰'가 필요합니다."
fi

DEVICE_NAME="$(pymobiledevice3 usbmux list 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for d in data:
        print(d.get('DeviceName', 'iPhone'))
        break
except Exception:
    print('iPhone')
" 2>/dev/null || echo "iPhone")"

IMPORT_DIR="$IPHONE_IMPORT_ROOT/$(date '+%Y-%m-%d_%H%M%S')_${DEVICE_NAME// /_}"
ensure_dir "$IMPORT_DIR"

log "기기: $DEVICE_NAME"
log "가져오기 경로: $IMPORT_DIR"

# 사진/동영상 AFC 가져오기 (DCIM)
if [[ "$DRY_RUN" == "true" ]]; then
  log "[dry-run] pymobiledevice3 afc pull /DCIM $IMPORT_DIR/DCIM"
else
  if pymobiledevice3 afc pull /DCIM "$IMPORT_DIR/DCIM" 2>/dev/null; then
    log "DCIM(사진/동영상) 가져오기 완료"
  else
    warn "DCIM 가져오기 실패 — Image Capture 앱 사용을 권장합니다."
  fi
fi

# 가져온 파일을 Organized 로 분류
export CONFIG_FILE
export DRY_RUN
export ORGANIZED_ROOT
DOWNLOADS_FOLDER="$IMPORT_DIR"
ICLOUD_DRIVE="$IMPORT_DIR"

# 임시로 import 폴더 내 파일 분류
if [[ -d "$IMPORT_DIR/DCIM" ]]; then
  while IFS= read -r -d '' file; do
    ext="${file##*.}"
    ext_lower="$(echo "$ext" | tr '[:upper:]' '[:lower:]')"
    case "$ext_lower" in
      jpg|jpeg|png|heic|gif|webp) sub="Images/iPhone-USB" ;;
      mp4|mov|m4v) sub="Videos/iPhone-USB" ;;
      *) sub="Misc/iPhone-USB" ;;
    esac
    safe_move "$file" "$ORGANIZED_ROOT/$sub"
  done < <(find "$IMPORT_DIR/DCIM" -type f -print0 2>/dev/null || true)
fi

log "=== USB 가져오기 완료 ==="
