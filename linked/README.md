# Linked Cursor projects (이 컴퓨터에서 연결)

Cursor로 작업한 GitHub 레포를 한곳에서 쓰도록 연결한 목록입니다.
에이전트는 시작 시 `shared/` + 이 폴더를 함께 봅니다.

## 등록된 레포 (GitHub에서 확인된 것)

| 이름 | URL | 이 허브에서의 경로 | 용도 |
|------|-----|-------------------|------|
| `-` (허브) | https://github.com/sorktl12-ux/- | `/workspace` 루트 | 공유 메모리·캘린더·아이폰 도구 |
| `beatlink` | https://github.com/sorktl12-ux/beatlink | `linked/beatlink/` | BeatLink 사이트 (Supabase/Vercel) |

## 왼쪽 폴더인데 GitHub에 안 보이는 것

예: `english-call`, 아침브리핑, 긱스(루이) 감시 등

→ Cursor 채팅/에이전트만 있고 **공개 Git 레포가 없거나 비공개**일 수 있습니다.  
비공개면 URL을 알려주시면 `linked/`에 추가합니다.

## Environment에 레포 묶기 (웹)

https://cursor.com/dashboard/cloud-agents#environments  
→ 이 Environment → Repositories에 추가:

1. `github.com/sorktl12-ux/-`
2. `github.com/sorktl12-ux/beatlink`

## 로컬에서 동기화

```bash
./shared/bin/link-repos.sh
```
