# Gmail → Google Calendar (자동 로그인)

한 번 OAuth를 연결하면, 이후 에이전트는 **비밀번호 없이** Gmail/캘린더에 접속합니다.

## 왜 비밀번호 자동 입력은 안 되나

Google은 비밀번호·쿠키로 봇이 로그인하는 것을 막습니다 (2FA, 캡차, 보안 정책).  
대신 **OAuth refresh token**을 Cursor 시크릿에 저장하면, 스크립트가 자동으로 access token을 갱신합니다.

```
[1회] Google Cloud에서 앱 만들고 → 브라우저에서 "허용"
        ↓
시크릿에 GOOGLE_REFRESH_TOKEN 저장
        ↓
[이후] 에이전트가 자동 로그인 → 메일 읽기 / 캘린더 쓰기
```

## 1회 설정

1. [Gmail API](https://console.cloud.google.com/apis/library/gmail.googleapis.com) · [Calendar API](https://console.cloud.google.com/apis/library/calendar-json.googleapis.com) 사용 설정
2. [사용자 인증 정보](https://console.cloud.google.com/apis/credentials) → OAuth 클라이언트 ID → **데스크톱 앱**
3. Cursor 환경 시크릿에 저장:
   - `GOOGLE_CLIENT_ID`
   - `GOOGLE_CLIENT_SECRET`
4. 채팅에 **「OAuth 준비됨」** 이라고 보내면 에이전트가 승인 화면을 엽니다  
   또는 직접:

```bash
cd google-calendar-sync
pip install -r requirements.txt
python scripts/oauth_setup.py
```

5. 출력된 `GOOGLE_REFRESH_TOKEN` 을 Cursor 시크릿에 추가

## 이후 자동 실행

```bash
python scripts/sync_from_gmail.py
# 또는
DRY_RUN=1 python scripts/sync_from_gmail.py
```

시크릿이 있으면 로그인 화면 없이 동작합니다.

## 시크릿 목록

| 이름 | 설명 |
|------|------|
| `GOOGLE_CLIENT_ID` | OAuth 클라이언트 ID |
| `GOOGLE_CLIENT_SECRET` | OAuth 시크릿 |
| `GOOGLE_REFRESH_TOKEN` | 1회 승인 후 발급 (자동 로그인 핵심) |

비밀번호는 저장하지 마세요.
