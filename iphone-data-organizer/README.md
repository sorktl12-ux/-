# iPhone 데이터 정리 (Mac 연동)

맥북과 iCloud를 연결해 **iPhone 안의 데이터를 Mac에서 정리**하는 도구입니다.  
Cursor Cloud Agent(My Machines)로 맥북에서 자동 실행할 수 있습니다.

## 무엇이 정리되나?

| 데이터 위치 | Mac에서 정리 | 방법 |
|-------------|:------------:|------|
| iCloud Drive 파일 (카카오톡, 다운로드 등) | ✅ | `organize-icloud.sh` |
| iCloud 동기화 사진 | ✅ | `organize-photos.sh` |
| USB 연결 사진/동영상 (DCIM) | ✅ | `import-iphone-usb.sh` |
| iPhone **내 iPhone** 로컬 파일 | ⚠️ | [iPhone 단축어](docs/iphone-shortcut-guide.md) 필요 |
| 카카오톡 채팅 내부 캐시 | ❌ | 앱 샌드박스 — 접근 불가 |
| 다른 앱 데이터 | ❌ | 앱별 제한 |

## 빠른 시작 (맥북)

### 1. 사전 준비 (iPhone)

1. **설정 → [이름] → iCloud → iCloud Drive** 켜기
2. **설정 → 사진 → iCloud 사진** 켜기 (사진 정리용, 선택)
3. 파일 앱에서 **iCloud Drive → Downloads** 폴더 생성

### 2. 맥북 설치

```bash
git clone https://github.com/sorktl12-ux/-.git
cd -/iphone-data-organizer
./install.sh
```

### 3. Cursor My Machines 연결

맥북 Cursor 터미널:

```bash
curl https://cursor.com/install -fsS | bash
agent worker start
```

iPhone Cursor 앱에서 에이전트 시작 시 **My Machines → 맥북** 선택.

### 4. 상태 확인

```bash
./scripts/device-check.sh
```

### 5. 정리 실행

```bash
# 먼저 시뮬레이션 (실제 이동 없음)
DRY_RUN=true ./scripts/full-organize.sh

# 실제 실행
./scripts/full-organize.sh
```

iPhone USB 연결 시 사진도 함께 가져옵니다 (신뢰 허용 필요).

### 6. iPhone 단축어 (내 iPhone 데이터)

Mac으로 접근 불가한 **내 iPhone** 저장소는 단축어로 보완:

→ [docs/iphone-shortcut-guide.md](docs/iphone-shortcut-guide.md)

## 정리 결과 위치

```
iCloud Drive/
├── Downloads/          ← 카카오톡 등에서 모은 파일
└── Organized/          ← 확장자별 자동 분류
    ├── Documents/
    ├── Images/
    ├── Videos/
    ├── Audio/
    ├── Archives/
    └── Misc/
```

iPhone **파일 앱 → iCloud Drive → Organized** 에서 확인됩니다.

## Cursor 에이전트로 실행

iPhone Cursor 앱에서 이렇게 지시하세요:

> 맥북 My Machines에서 `iphone-data-organizer/scripts/full-organize.sh` 실행해줘

## 설정 변경

```bash
cp config/defaults.env.example config/defaults.env
# 경로, 중복 정책 등 수정
```

| 변수 | 설명 |
|------|------|
| `DUPLICATE_POLICY` | `skip` / `rename` / `delete` |
| `DRY_RUN` | `true`면 로그만 |
| `ENABLE_USB_IMPORT` | USB 사진 가져오기 |

## 스크립트 목록

| 스크립트 | 기능 |
|----------|------|
| `device-check.sh` | iCloud, USB, worker 상태 점검 |
| `organize-icloud.sh` | iCloud 파일 수집·분류 |
| `import-iphone-usb.sh` | USB 사진/동영상 가져오기 |
| `organize-photos.sh` | 사진 앱 앨범 정리 |
| `remove-duplicate-files.sh` | 중복 파일 제거 |
| `full-organize.sh` | 위 전체 실행 |

## 제한 사항

- **카카오톡 자동 파일명 접두사**: iOS에 끄는 설정 없음 → 저장 시 이름 직접 확인
- **채팅방 안 파일**: 파일 앱에 저장하지 않으면 Mac에서 접근 불가
- **전체 디스크 접근**: 사진 앱 자동화 시 Mac에서 권한 필요
- **pymobiledevice3**: iPhone 잠금 해제 + USB 신뢰 필요

## 문제 해결

| 증상 | 해결 |
|------|------|
| iCloud 폴더 비어 있음 | iPhone iCloud Drive 켜기, 동기화 대기 |
| USB 인식 안 됨 | 케이블 교체, 잠금 해제, '신뢰' 탭 |
| worker 없음 | `agent worker start` 후 Cursor 앱에서 My Machines 선택 |
| 사진 앱 오류 | 시스템 설정 → 개인정보 → 전체 디스크 접근 → 터미널 허용 |
