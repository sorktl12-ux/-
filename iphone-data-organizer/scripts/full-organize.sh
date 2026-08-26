#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

DRY_RUN="${DRY_RUN:-false}"
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN="true" && shift
export DRY_RUN

log "=========================================="
log "  iPhone 데이터 정리 (Mac 연동) 전체 실행"
log "  DRY_RUN=$DRY_RUN"
log "=========================================="
echo ""

"$SCRIPT_DIR/device-check.sh" || true
echo ""

"$SCRIPT_DIR/organize-icloud.sh"
echo ""

if [[ "${ENABLE_USB_IMPORT:-true}" == "true" ]]; then
  "$SCRIPT_DIR/import-iphone-usb.sh" || warn "USB 가져오기 건너뜀"
  echo ""
fi

"$SCRIPT_DIR/organize-photos.sh" || true
echo ""

"$SCRIPT_DIR/remove-duplicate-files.sh" || true
echo ""

log "=========================================="
log "  전체 정리 완료"
log "  iPhone에서 파일 앱 > iCloud Drive > Organized 확인"
log "  iPhone Shortcut도 함께 실행하면 '내 iPhone' 데이터도 정리됩니다"
log "=========================================="
