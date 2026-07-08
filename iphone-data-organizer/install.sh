#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== iPhone 데이터 정리 도구 설치 (macOS) ==="

[[ "$(uname -s)" == "Darwin" ]] || { echo "macOS에서만 실행 가능합니다."; exit 1; }

# Homebrew
if ! command -v brew &>/dev/null; then
  echo "Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "패키지 설치 중..."
brew install python3 fdupes 2>/dev/null || brew install python3 fdupes

# pymobiledevice3
if ! command -v pymobiledevice3 &>/dev/null; then
  echo "pymobiledevice3 설치 중..."
  pip3 install --user pymobiledevice3 2>/dev/null || pip3 install pymobiledevice3
  export PATH="$HOME/Library/Python/3.*/bin:$PATH"
fi

# 설정 파일
if [[ ! -f "$SCRIPT_DIR/config/defaults.env" ]]; then
  cp "$SCRIPT_DIR/config/defaults.env.example" "$SCRIPT_DIR/config/defaults.env"
  echo "설정 파일 생성: config/defaults.env"
fi

# 실행 권한
chmod +x "$SCRIPT_DIR"/scripts/*.sh
chmod +x "$SCRIPT_DIR"/install.sh

echo ""
echo "=== 설치 완료 ==="
echo ""
echo "다음 단계:"
echo "  1. iPhone: 설정 > [이름] > iCloud > iCloud Drive 켜기"
echo "  2. iPhone: 설정 > 사진 > iCloud 사진 켜기 (선택)"
echo "  3. iPhone을 USB로 연결하고 '이 컴퓨터 신뢰' 탭"
echo "  4. Cursor My Machines: agent worker start"
echo "  5. ./scripts/device-check.sh 로 상태 확인"
echo "  6. ./scripts/full-organize.sh --dry-run 후 실제 실행"
echo ""
