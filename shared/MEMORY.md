# 공유 메모리 (에이전트 간)

비밀번호·토큰·쿠키는 적지 않는다. 최신이 위로.

## 2026-08-26 (점검)

- Environment **연결됨** (`9f91a6b7-a123-11f1-b532-320a589b8025`, draft build 진행).
- `shared/bin/healthcheck.sh` 추가: 허브 파일 OK, Chrome CDP OK, OAuth 시크릿만 미등록.
- 캘린더 재검증: 2027 `[학사]`/`[목]` = 0, 2026-08-27 존재 확인.
- GitHub 공개 레포: `sorktl12-ux/-`, `sorktl12-ux/beatlink` 만 보임. `english-call` 공개 레포 없음(비공개/에이전트명일 수 있음).

## 2026-08-26

- Gmail Chrome 로그인 완료 (`sorktl12@gmail.com`).
- 메일 첨부 이미지에서 **목요일 시간표** + **2학기 학사일정** 파싱.
- Google Calendar primary에 `[학사]` / `[목]` 일정 등록 (2026만).
- 연도 검증: 2025·2027 주에 우리 태그 일정 0건.
- 누락 재시도: 성탄절 + 목요일 15건 보완, 실패 0.
- iPhone 데이터 정리 도구·Gmail sync 스크립트를 이 레포에 추가 (PR #1 브랜치).
- 사용자 요청: 왼쪽 폴더(english-call 등)와 **정보 공유** → `shared/` 허브 신설.
- GenSpark MoA를 Cursor에 심는 것: 불가. Cursor는 `/best-of-n`·병렬 에이전트 사용.

## 미완료 / 다음 에이전트용

- [x] Environment 초안 연결 (draft build)
- [ ] Environment **Save**(사용자) — 다른 에이전트 부팅에 반영
- [ ] `GOOGLE_*` OAuth 시크릿 등록 → API 자동 로그인
- [ ] 맥북 `agent worker start` (iPhone 파일 정리 실실행)
- [ ] english-call Git URL을 Environment repos에 추가 (비공개면 URL 필요)
