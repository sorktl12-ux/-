# 공유 메모리 (에이전트 간)

비밀번호·토큰·쿠키는 적지 않는다. 최신이 위로.

## 2026-08-26 (런타임 선호: 맥북)

- 사용자: 가상 Desktop으로 진행한 방식은 불편. **앞으로는 맥북에서 직접 보이게** 처리할 것.
- 이 세션은 Cloud VM이라 mid-flight 전환 불가 → 맥북에서 `agent worker start --name MacBook` 후 **새 에이전트**에서 My Machines 선택.
- 상세: `shared/MY_MACHINES.md`

## 2026-08-26 (GitHub 로그인 성공 → 전체 레포 연결)

- Agent Chrome에서 GitHub `sorktl12-ux` 로그인 완료.
- 계정 레포 6개 확인·연결: `-`, `beatlink`, `beat-drop`, `english-call`, `profile-maintain`, `beatlink1`.
- Private는 `linked/`에 clone (gitignore). `link-repos.sh` + local/`GITHUB_TOKEN`으로 갱신.
- 아침브리핑은 계속 메일 서비스 (`shared/morning-briefing/`).
- classic PAT `cursor-agent-link-repos` 생성됨 → 이 VM 로컬에만 저장. 새 에이전트용 Environment Secret `GITHUB_TOKEN` 권장.

## 2026-08-26 (캘린더)

- `[학사]` 20/20, `[목]` 13일×5블록. 2026만.
- snapshot: `snapshot-20260826-aab98861-9e97-45b6-9bb4-3a904543b2ec`
