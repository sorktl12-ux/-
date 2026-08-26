# Linked Cursor projects

GitHub `sorktl12-ux` 계정 레포 **6개 전부** 허브에 연결됨.

| 사이드바/이름 | GitHub | 경로 | 공개 |
|---------------|--------|------|------|
| 허브 `-` | https://github.com/sorktl12-ux/- | `/workspace` | public |
| beatlink | https://github.com/sorktl12-ux/beatlink | `linked/beatlink/` | public (submodule) |
| beat-drop | https://github.com/sorktl12-ux/beat-drop | `linked/beat-drop/` | private |
| english-call | https://github.com/sorktl12-ux/english-call | `linked/english-call/` | private |
| profile-maintain (긱스/루이) | https://github.com/sorktl12-ux/profile-maintain | `linked/profile-maintain/` | private |
| beatlink1 | https://github.com/sorktl12-ux/beatlink1 | `linked/beatlink1/` | private |

## 메일 서비스 (GitHub 없음)

| 사이드바 | 설명 |
|----------|------|
| 아침브리핑 | Gmail `[아침 운세]` → `shared/morning-briefing/` |

## 동기화

```bash
./shared/bin/link-repos.sh
```

Private clone에는 `GITHUB_TOKEN`(classic, `repo`) 필요. 이 Agent VM에는 로컬 토큰이 설정되어 있음. 새 Cloud Agent에서는 Environment Secret `GITHUB_TOKEN`을 넣으면 됨.

목록: `linked/registry.json`
