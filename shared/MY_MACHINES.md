# 기본 실행 환경: 맥북 (My Machines)

설원도 선호: **가상 Cloud Desktop이 아니라 맥북에서** 브라우저·터미널·파일이 보이게 실행.

이 문서는 그 기본값을 고정한다. 새 에이전트는 가능하면 항상 My Machines를 고른다.

## 맥북 트윈 채팅 (폰 Cloud → PC)

폰에서 연 「아이폰 맥북 제어」를 맥에서 이어받으려면:

1. `bash shared/bin/mac-bootstrap.sh`
2. `agent worker start --name "MacBook"`
3. 새 에이전트에서 **My Machines → MacBook**
4. `shared/HANDOFF_MAC.md` 섹션 C 프롬프트 복붙

상세: `shared/HANDOFF_MAC.md`

## 왜 지금 이 채팅은 가상 PC인가

이미 시작된 Cloud Agent(`usePrivateWorker: false`)는 세션 중간에 맥북으로 옮길 수 없다.  
맥북에서 보이게 하려면 **worker를 켠 뒤 새 에이전트**를 시작해야 한다.

## 맥북 한 번 설정

```bash
# 1) CLI
curl https://cursor.com/install -fsS | bash
agent --version
agent login

# 2) 이 허브 레포 폴더에서 worker 상시 실행
cd /path/to/sorktl12-ux/-   # 또는 작업할 레포 checkout
agent worker start --name "MacBook"
```

worker 터미널은 끄지 않는다. 여러 레포면 레포마다 worker를 따로 켠다.

## 새 작업 시작할 때

1. [cursor.com/agents](https://cursor.com/agents) 또는 Cursor 맥 앱
2. **Run on / Environment** → **My Machines → MacBook**
3. 그다음 지시

아이폰 앱에서 시작할 때도 같은 머신(MacBook)을 고른다.

## Slack / GitHub에서 맥북으로 보내기

```
@Cursor worker=MacBook …
@cursoragent worker=MacBook …
```

## 이 허브에서의 규칙

- 기본 런타임 선호: **MacBook My Machines**
- Cloud 가상 Desktop은 My Machines가 불가능할 때만
- iPhone 파일·단축어·로컬 Chrome은 맥북 worker에서만 가능
