# Linked Cursor projects

## 자동 연결됨 (GitHub 공개)

| 사이드바/이름 | GitHub | 경로 |
|---------------|--------|------|
| 허브 / `-` | https://github.com/sorktl12-ux/- | `/workspace` |
| beatlink | https://github.com/sorktl12-ux/beatlink | `linked/beatlink/` |

## URL 필요 (왼쪽에는 보이지만 GitHub URL을 모름)

| 사이드바 이름 | 상태 |
|---------------|------|
| 아침브리핑 | `registry.json`에 자리만 만듦 — **GitHub URL 필요** |
| english-call | 同上 |

목록 파일: `linked/registry.json`  
동기화: `./shared/bin/link-repos.sh`

## 전부 연결하는 방법

1. Cursor 왼쪽 Repositories에 보이는 **이름 + GitHub URL**을 채팅에 붙여넣기  
2. 에이전트가 `registry.json`에 넣고 submodule/clone 후 Environment repos에도 추가
