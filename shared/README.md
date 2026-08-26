# Shared Agent Hub (이 컴퓨터 공통 두뇌)

이 저장소의 **모든 Cursor 에이전트**는 작업을 시작하기 전에 이 폴더를 읽는다.
아침 브리핑 · 프로필 · 캘린더 · 아이폰 정리 · english-call 등 **기능끼리 정보를 공유**하기 위한 중심이다.

## 필수 읽기 순서

1. `shared/PROFILE.md` — 사용자·계정·기기
2. `shared/CAPABILITIES.md` — 이 컴퓨터에서 가능한 기능
3. `shared/MEMORY.md` — 최근 처리 결과·결정 사항
4. `shared/CONVENTIONS.md` — 캘린더 태그, 파일 경로 규칙
5. 관련 도구 폴더 (`google-calendar-sync/`, `iphone-data-organizer/`)

## 다른 왼쪽 폴더(english-call 등)와 연결

왼쪽의 다른 에이전트/폴더는 **기본적으로 분리**되어 있다.
서로 쓰려면 아래 중 하나를 한다:

| 방법 | 설명 |
|------|------|
| **A. 같은 Environment** | Cursor Environment에 이 레포 + english-call 레포를 함께 등록 |
| **B. 이 레포를 서브모듈/복사** | 다른 프로젝트에 `shared/` 를 포함 |
| **C. 같은 My Machines** | 맥북 worker 하나에서 여러 에이전트가 동일 파일·브라우저 사용 |

Environment 저장 후, 다른 에이전트 채팅에서:

> `shared/MEMORY.md` 와 `shared/PROFILE.md` 읽고 이어서 작업해줘

## 새 작업을 끝낼 때마다

에이전트는 `shared/MEMORY.md`에 **무엇을 했는지** 한 줄 이상 추가한다.
비밀번호·토큰은 적지 않는다.
