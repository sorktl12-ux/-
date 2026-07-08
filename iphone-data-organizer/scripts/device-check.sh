#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"
load_config
require_macos

log "=== Mac + iPhone 연동 상태 점검 ==="
echo ""

# macOS
log "✓ macOS: $(sw_vers -productVersion)"

# iCloud Drive
if [[ -d "$ICLOUD_DRIVE" ]]; then
  log "✓ iCloud Drive: $ICLOUD_DRIVE"
  du -sh "$ICLOUD_DRIVE" 2>/dev/null | awk '{print "  용량:", $1}' || true
else
  warn "✗ iCloud Drive 없음 — iPhone: 설정 > [이름] > iCloud > iCloud Drive 켜기"
fi

# pymobiledevice3
if command -v pymobiledevice3 &>/dev/null; then
  log "✓ pymobiledevice3 설치됨"
  if pymobiledevice3 usbmux list 2>/dev/null | grep -q "Identifier"; then
    log "✓ iPhone USB 연결됨"
    pymobiledevice3 usbmux list 2>/dev/null | head -20
  else
    warn "○ iPhone USB 미연결 (선택: USB 케이블 + '이 컴퓨터 신뢰')"
  fi
else
  warn "○ pymobiledevice3 미설치 — ./install.sh 실행"
fi

# Photos
if [[ -d "${PHOTOS_LIBRARY:-$HOME/Pictures/Photos Library.photoslibrary}" ]]; then
  log "✓ 사진 라이브러리 발견"
else
  warn "○ 사진 라이브러리 없음"
fi

# Cursor worker
if pgrep -f "agent worker" &>/dev/null || pgrep -f "cursor.*worker" &>/dev/null; then
  log "✓ Cursor worker 프로세스 실행 중"
else
  warn "○ Cursor worker 미실행 — 'agent worker start' 필요"
fi

echo ""
log "=== 점검 완료 ==="
