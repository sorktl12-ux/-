#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "$0")/lib/common.sh"
load_config
require_macos

TARGET_DIR="${1:-$ORGANIZED_ROOT}"

log "=== 중복 파일 검사: $TARGET_DIR ==="

[[ -d "$TARGET_DIR" ]] || die "폴더가 없습니다: $TARGET_DIR"

if ! command -v fdupes &>/dev/null; then
  warn "fdupes 미설치. install.sh 실행 후 다시 시도하세요."
  exit 1
fi

if [[ "$DRY_RUN" == "true" ]]; then
  log "[dry-run] 중복 목록만 표시"
  fdupes -r "$TARGET_DIR" 2>/dev/null | head -100 || true
else
  log "중복 파일 삭제 (각 그룹에서 첫 번째만 유지)"
  fdupes -rdN "$TARGET_DIR" 2>/dev/null || warn "중복 없음 또는 검사 실패"
fi

log "=== 중복 검사 완료 ==="
