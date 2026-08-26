# 공유 메모리 (에이전트 간)

비밀번호·토큰·쿠키는 적지 않는다. 최신이 위로.

## 2026-08-26 (전체 연결 시도 — 권한 한계)

- Gmail·공개 GitHub 기준으로 **존재하는 Cursor GitHub 레포는 3개**: `-`, `beatlink`, `beat-drop`(private).
- 공개 2개 연결 완료. `beat-drop`은 에이전트 기본 토큰으로 clone 불가 → **GITHUB_TOKEN** 요청함.
- **아침브리핑**은 GitHub 레포가 아님: `[아침 운세]` 자가메일 + 카카오 나와의 채팅. 허브에 `shared/morning-briefing/` 문서화.
- `english-call` / 긱스(루이): GitHub·메일에서 URL 미발견 → 사용자 붙여넣기 대기.
- `list-cloud-agents`는 이 Environment에서 본 에이전트 1개만 보임.
- `link-repos.sh`가 `GITHUB_TOKEN` 있으면 private도 clone 하도록 갱신.

## 2026-08-26 (레포 연결)

- GitHub **공개** 레포 연결: `-`(허브) + `beatlink` → `linked/beatlink` 서브모듈.
- Environment install이 서브모듈·link-repos 실행.

## 2026-08-26 (캘린더)

- **캘린더 완료**: `[학사]` 20/20, `[목]` 13일×5블록 전부 (누락 0). 2026만.
- snapshot: `snapshot-20260826-aab98861-9e97-45b6-9bb4-3a904543b2ec`

## 선택 미완료

- `GITHUB_TOKEN` → `beat-drop` clone + Environment repos에 beatlink/beat-drop
- `english-call` Git URL
- `GOOGLE_*` OAuth / My Machines
