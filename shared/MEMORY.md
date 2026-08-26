# 공유 메모리 (에이전트 간)

비밀번호·토큰·쿠키는 적지 않는다. 최신이 위로.

## 2026-08-26 (문서 작업 폴더 위치)

- 바탕화면에 `Namuwiki_*` 같은 임시 문서/나무위키 작업 폴더를 만들지 않는다.
- 앞으로 문서성 작업 폴더는 `~/Downloads/문서` 아래에 만든다.

## 2026-08-26 (맥 트윈 상태)

- API로 My Machines 에이전트 생성은 되지만 run이 **CREATING**에 고착 (worker `isInUse=false`).
- 온라인 worker는 `profile-maintain` 전용 (`~/profile-maintain @ MOON MacBookPro`).
- **우회**: cursor.com/agents UI에서 New Agent → Environment 드롭다운에서 맥 머신 직접 선택 + HANDOFF 프롬프트.
- Cloud 쪽: `GITHUB_TOKEN` 시크릿 동작 확인, `link-repos`로 private 6개 동기화 OK, environment install 재제안함.

## 2026-08-26 (맥 트윈 생성 성공)

- API로 My Machines 트윈 생성됨: `아이폰 맥북 제어 (Mac)`
- URL: https://cursor.com/agents/bc-bbd7ad47-277d-4fa2-9e0e-c850179caa68
- env: machine `MacBook`, branch `cursor/iphone-mac-data-organizer-c10a`
- 채팅에 API 키가 노출됐으므로 Dashboard에서 해당 키 재발급/삭제 권장 (로컬에는 저장만).

## 2026-08-26 (트윈 자동 생성 준비)

- `shared/bin/launch-mac-twin.sh` 추가: `CURSOR_API_KEY` + Mac worker(`MacBook`) 있으면 API로 트윈 에이전트 생성.
- 블로커(본인만): 맥에서 `agent worker start --name MacBook` + Environment Secret `CURSOR_API_KEY`.
- 이 Cloud 세션만으로는 맥북 프로세스를 켤 수 없음.

## 2026-08-26 (맥북 트윈 핸드오프)

- 사용자 요청: 「아이폰 맥북 제어」채팅을 PC(맥) 버전으로 복제하고 데이터 공유.
- Cloud 세션은 복제 불가 → `shared/HANDOFF_MAC.md` + `shared/bin/mac-bootstrap.sh`로 **My Machines 트윈** 생성.
- 트윈 첫 메시지(복붙)는 HANDOFF_MAC.md 섹션 C.
- 공유 소스: 이 레포 `shared/` · `linked/` · AGENTS.md · .cursor/rules.

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
