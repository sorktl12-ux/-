#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"
load_config
require_macos

log "=== 사진 앱 정리 (iCloud 사진 동기화) ==="

if [[ ! -d "${PHOTOS_LIBRARY:-$HOME/Pictures/Photos Library.photoslibrary}" ]]; then
  warn "사진 라이브러리를 찾을 수 없습니다."
  warn "iPhone: 설정 > 사진 > iCloud 사진 켜기 후 Mac 사진 앱과 동기화하세요."
  exit 0
fi

# AppleScript로 카카오톡 관련 스크린샷/사진 앨범 정리
osascript <<'APPLESCRIPT' || warn "사진 앱 자동화 실패 — 전체 디스크 접근 권한이 필요할 수 있습니다."
tell application "Photos"
  activate
  -- 카카오톡 앨범이 없으면 생성
  set albumName to "KakaoTalk-정리"
  set albumExists to false
  repeat with a in albums
    if name of a is albumName then
      set albumExists to true
      exit repeat
    end if
  end repeat
  if not albumExists then
    make new album named albumName
  end if
end tell
APPLESCRIPT

log "사진 앱에서 'KakaoTalk-정리' 앨범이 생성되었습니다."
log "iCloud 사진이 켜져 있으면 iPhone에도 동기화됩니다."
log ""
log "수동 정리 팁:"
log "  1. 사진 앱 > 앨범 > 미디어 유형 > 스크린샷"
log "  2. 검색: 'KakaoTalk' 또는 '카카오'"
log "  3. 불필요한 항목 삭제 후 '최근 삭제된 항목' 비우기"
