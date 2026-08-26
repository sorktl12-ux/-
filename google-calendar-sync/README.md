# Gmail → Google Calendar 동기화

`sorktl12@gmail.com`으로 보낸 **목요일 시간표** / **2학기 학사일정** 메일을 읽어
Google Calendar에 이벤트를 넣습니다. iPhone Google Calendar 앱에도 동기화됩니다.

## 필요 시크릿

| 이름 | 설명 |
|------|------|
| `GOOGLE_CLIENT_ID` | OAuth Desktop 클라이언트 ID |
| `GOOGLE_CLIENT_SECRET` | OAuth 클라이언트 시크릿 |
| `GOOGLE_REFRESH_TOKEN` | `gmail.readonly` + `calendar` 스코프 리프레시 토큰 |

## 실행

```bash
cd google-calendar-sync
pip install -r requirements.txt
python scripts/sync_from_gmail.py
```

드라이런:

```bash
DRY_RUN=1 python scripts/sync_from_gmail.py
```

## 동작

1. Gmail에서 본인 발신 메일 중 시간표/학사일정 관련 최근 메일 검색
2. 본문에서 이벤트·목요일 반복 일정 파싱
3. Google Calendar `primary`에 생성 (이미 있으면 스킵)
