# 이 컴퓨터에서 사용 가능한 기능 (공유)

## 1. Google 캘린더 / Gmail

| 기능 | 경로 | 상태 |
|------|------|------|
| 메일→캘린더 동기화 | `google-calendar-sync/` | OAuth 시크릿 있으면 API |
| Chrome UI 일정 생성 | Agent Chrome | **2026-08-26 완료** (`[학사]`/`[목]`) |

## 2. 아침 브리핑

| 기능 | 경로 | 상태 |
|------|------|------|
| 포맷·공유 규칙 | `shared/morning-briefing/` | 메일 서비스 (레포 아님) |

## 3. iPhone + Mac 데이터 정리

| 기능 | 경로 |
|------|------|
| 전체 실행 | `iphone-data-organizer/scripts/full-organize.sh` |
| 단축어 가이드 | `iphone-data-organizer/docs/iphone-shortcut-guide.md` |

실행: **맥북 My Machines**.

## 4. 연결된 Cursor 레포 (전부)

| 레포 | 경로 | 할 수 있는 일 |
|------|------|----------------|
| beatlink | `linked/beatlink/` | 공개 사이트·Supabase·Vercel |
| beat-drop | `linked/beat-drop/` | Beat Drop 대회 앱 (Next.js, private) |
| english-call | `linked/english-call/` | 매일 영어 회화 전화 (Expo/iPhone) |
| profile-maintain | `linked/profile-maintain/` | 나무위키 루이(긱스) 프로필 유지 |
| beatlink1 | `linked/beatlink1/` | beatlink 관련 private |

동기화: `./shared/bin/link-repos.sh`

## 5. Cursor / 에이전트

| 방식 | 언제 |
|------|------|
| **맥북 My Machines** | **기본** — Chrome/파일이 맥북에 바로 보임 (`shared/MY_MACHINES.md`) |
| Cloud 가상 Desktop | My Machines 불가할 때만 |
| iPhone Cursor 앱 | 지시·리뷰 리모컨 |
