# 이 컴퓨터에서 사용 가능한 기능 (공유)

## 1. Google 캘린더 / Gmail

| 기능 | 경로 | 상태 |
|------|------|------|
| 메일→캘린더 동기화 스크립트 | `google-calendar-sync/scripts/sync_from_gmail.py` | OAuth 시크릿 있으면 API로 자동 |
| OAuth 1회 설정 | `google-calendar-sync/scripts/oauth_setup.py` | 시크릿 준비 후 실행 |
| Chrome UI로 일정 생성 | Cloud Agent Chrome + Calendar TEMPLATE URL | **2026-08-26에 실행 완료** |

### 이미 캘린더에 넣은 내용 (2026)

- 2학기 학사일정 (`[학사] …`) — 7월~12월
- 목요일 시간표 (`[목] …`) — 개강 후~기말 전, 추석·중간·기말 목요일 제외
- 검증: 2025/2027에는 `[학사]`/`[목]` 없음

### 목요일 정규 블록 (참고)

| 시간 | 내용 | 장소 |
|------|------|------|
| 11:00–12:00 | 개인레슨-랩A · 양가호 | 예술관 2층 연습실16 |
| 12:00–13:00 | 개인레슨-랩A · 길지호 | 예술관 2층 연습실16 |
| 13:00–17:00 | 뮤직프로덕션 계열 1-A 전공실기IV | — |
| 18:00–19:00 | 개인레슨-랩A · 남현우 | 예술관 2층 연습실16 |
| 19:00–20:00 | 개인레슨-랩A · 박민준 | 예술관 2층 연습실16 |

## 2. 아침 브리핑

| 기능 | 경로 | 상태 |
|------|------|------|
| 포맷·공유 규칙 | `shared/morning-briefing/README.md` | 문서화됨 |
| 전달 채널 | Gmail 자가수신 + 카카오 「나와의 채팅」 | 운영 중 (레포 아님) |

다른 에이전트는 당일 브리핑 요약을 `shared/MEMORY.md`에서 읽는다.

## 3. iPhone + Mac 데이터 정리

| 기능 | 경로 |
|------|------|
| 전체 실행 | `iphone-data-organizer/scripts/full-organize.sh` |
| iCloud 정리 | `organize-icloud.sh` |
| USB 가져오기 | `import-iphone-usb.sh` |
| 단축어 가이드 | `docs/iphone-shortcut-guide.md` |

실행 위치: **맥북** (My Machines). Cloud VM만으로는 iPhone 저장소 직접 접근 불가.

## 4. Cursor / 에이전트 운영

| 기능 | 설명 |
|------|------|
| Cloud Agent | 이 VM에서 코드·브라우저·캘린더 UI |
| Remote Control / My Machines | 맥북에서 도구 실행 |
| iPhone Cursor 앱 | 지시·리뷰용 리모컨 (실행 환경 아님) |

## 5. 연결된 다른 Cursor 레포

| 레포 | 경로 | 상태 | 할 수 있는 일 |
|------|------|------|----------------|
| beatlink | `linked/beatlink/` | linked (public) | 사이트·Supabase·Vercel |
| beat-drop | `linked/beat-drop/` | **needs GITHUB_TOKEN** | private; PAT 후 clone |

동기화: `./shared/bin/link-repos.sh`  
목록: `linked/README.md` / `linked/registry.json`

## 6. 아직 URL이 없는 사이드바 항목

- `english-call` — GitHub/Origin URL 필요
- 긱스(루이) 감시 — URL 또는 대상 사이트 필요
