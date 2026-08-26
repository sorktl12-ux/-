# 공통 규칙

## 캘린더

- 타임존: `Asia/Seoul`
- 태그: `[학사]`, `[목]`
- 기본 범위: **현재 연도만** (사용자가 다른 연도 요청 시에만 예외)
- 삭제 대상: 우리가 넣은 태그 중 연도가 틀린 것

## 파일·스크립트

- 공유 문서: 항상 `shared/` 업데이트
- 실행 스크립트는 기능 폴더에 두고, CAPABILITIES에 링크

## 보안

- 비밀번호·refresh token·쿠키를 git에 커밋하지 않음
- 시크릿은 Cursor Environment Secrets만 사용

## 에이전트 시작 체크리스트

```
[ ] shared/PROFILE.md 읽음
[ ] shared/MEMORY.md 최근 항목 확인
[ ] 이번 작업이 캘린더/메일/아이폰이면 CAPABILITIES 해당 섹션 확인
[ ] 작업 후 MEMORY.md에 결과 기록
```
