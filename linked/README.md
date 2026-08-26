# Linked Cursor projects

## 연결됨

| 사이드바/이름 | GitHub | 경로 | 상태 |
|---------------|--------|------|------|
| 허브 / `-` | https://github.com/sorktl12-ux/- | `/workspace` | hub |
| beatlink | https://github.com/sorktl12-ux/beatlink | `linked/beatlink/` | linked (public) |

## 토큰 필요 (private)

| 이름 | GitHub | 경로 |
|------|--------|------|
| beat-drop / BeatDrop | https://github.com/sorktl12-ux/beat-drop | `linked/beat-drop/` (clone 대기) |

Environment Secrets에 `GITHUB_TOKEN` (classic PAT, `repo` scope) 추가 후:

```bash
export GITHUB_TOKEN=…   # 또는 Environment Secret으로 주입
./shared/bin/link-repos.sh
```

## 메일 서비스 (GitHub 없음)

| 사이드바 | 설명 |
|----------|------|
| 아침브리핑 | Gmail `[아침 운세]` + 카카오 나와의 채팅 → `shared/morning-briefing/` |

## URL 미확인

| 사이드바 | 상태 |
|----------|------|
| english-call | GitHub/Origin URL 채팅에 붙여넣기 필요 |

목록: `linked/registry.json` · 동기화: `./shared/bin/link-repos.sh`
