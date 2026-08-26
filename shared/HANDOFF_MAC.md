# 핸드오프: 「아이폰 맥북 제어」→ 맥북 PC 트윈

폰에서 만든 Cloud 채팅을 **맥북 My Machines 채팅**으로 이어받기 위한 패키지.  
데이터 공유의 단일 소스 = 이 GitHub 허브 레포 `sorktl12-ux/-` 의 `shared/` + `linked/`.

## 원본 세션

| 항목 | 값 |
|------|-----|
| 이름 | 아이폰 맥북 제어 |
| URL | https://cursor.com/agents/bc-019f419b-a00a-7934-a2b3-cab8404cc10a |
| 출처 | mobile → Cloud VM (가상 Desktop) |
| 브랜치 | `cursor/iphone-mac-data-organizer-c10a` |
| PR | https://github.com/sorktl12-ux/-/pull/1 |

## 맥북에서 트윈 만들기 (필수)

### A. 레포 + worker

```bash
# 원하는 폴더에서 (레포 이름이 "-"라서 폴더명을 hub로 권장)
git clone https://github.com/sorktl12-ux/-.git hub
cd hub
git fetch origin
git checkout cursor/iphone-mac-data-organizer-c10a
git pull origin cursor/iphone-mac-data-organizer-c10a
bash shared/bin/mac-bootstrap.sh

# CLI + worker (창 유지)
curl https://cursor.com/install -fsS | bash
agent login
agent worker start --name "MacBook"
```

worker Connected 후, API 키가 있으면 Cloud 에이전트가 `bash shared/bin/launch-mac-twin.sh`로 트윈을 자동 생성할 수 있다.
Environment Secret: `CURSOR_API_KEY` (https://cursor.com/dashboard/api) + 선택 `GITHUB_TOKEN`.

### B. 새 에이전트 (PC / cursor.com)

1. https://cursor.com/agents 또는 Cursor **맥 앱**
2. 레포: `sorktl12-ux/-`
3. **Run on → My Machines → MacBook**
4. 이름 예: `아이폰 맥북 제어 (Mac)`
5. 첫 메시지에 아래 **복붙 프롬프트** 사용

### C. 첫 메시지 (복붙)

```
너는 「아이폰 맥북 제어」Cloud 채팅의 맥북 트윈이다.
반드시 shared/HANDOFF_MAC.md, shared/MEMORY.md, shared/PROFILE.md, shared/CAPABILITIES.md, shared/MY_MACHINES.md, linked/registry.json 을 읽고 이어서 작업해라.
런타임은 이 맥북(My Machines)이다. Agent 가상 Desktop Chrome이 아니라 이 Mac의 Chrome/파일을 사용해라.
이미 끝난 것: 2026 캘린더 [학사]/[목], GitHub 레포 6개 연결, 공유 허브.
기본 규칙: 비밀번호는 MEMORY에 적지 말 것. 작업 후 MEMORY에 한 줄 추가.
지금 확인: 맥북 Chrome으로 Gmail 받은편지함 최근 메일 5개를 보여줘.
```

## 공유되는 데이터

| 경로 | 내용 |
|------|------|
| `shared/PROFILE.md` | 사용자·계정·선호 |
| `shared/MEMORY.md` | 최근 결정·상태 |
| `shared/CAPABILITIES.md` | 가능 기능 |
| `shared/MY_MACHINES.md` | 맥북 기본 런타임 |
| `shared/morning-briefing/` | 아침 브리핑 포맷 |
| `linked/registry.json` | 전 레포 목록 |
| `linked/beatlink/` 등 | submodule/clone |
| `google-calendar-sync/` | 캘린더 도구 |
| `iphone-data-organizer/` | 아이폰 정리 |
| `.cursor/rules/` · `AGENTS.md` | 모든 에이전트 공통 지시 |

## 공유되지 않는 것 (맥에서 다시)

- Cloud VM Chrome 쿠키/세션 → 맥 Chrome은 본인 로그인 상태 사용
- VM 로컬 PAT 파일 → Environment Secret `GITHUB_TOKEN` 또는 맥 `~/.config/sorktl12/github_token`
- 이 Cloud 채팅 대화 전문 → 위 복붙 + MEMORY가 대체

## 폰에서 계속 지시할 때

폰 Cursor로도 **같은 MacBook worker**를 고르면 맥에서 실행된다.  
Cloud(가상)를 고르면 또 가상 Desktop이 된다.
