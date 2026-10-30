---
name: handoff
description: 지금 대화를 다음 세션이 이어받을 인계 문서 docs/HANDOFF.md로 압축한다. 사용자가 $handoff로 부를 때만 쓴다.
disable-model-invocation: true
---

지금 대화를 요약해 새 세션이 바로 이어서 일할 수 있게 `docs/HANDOFF.md`를 덮어쓴다. 저장소 안에 두는 이유는 인계 기록도 작업 이력이기 때문이다.

쓸 항목(30줄 이내):

- 목표: SPEC의 어느 성공 기준을 향하고 있나
- 끝난 것: 커밋 해시와 한 줄 요약
- 지금 상태: 마지막으로 실행한 테스트·실행 명령과 결과
- 남은 작업과 다음 한 걸음: PLAN의 작업 번호
- 결정과 이유: 새로 정한 것만, 나머지는 docs/DECISIONS.md를 가리킨다
- 함정: 이번 세션에서 헛돈 것, 다시 밟지 말 것
- 다음 세션이 쓸 스킬: 예) $spec-check, $review-gate

규칙:

- SPEC·PLAN·DECISIONS·커밋·diff에 이미 있는 내용은 옮기지 말고 경로로 가리킨다.
- API 키, 비밀번호, 개인정보는 쓰지 않는다.
- 사용자가 인자를 주면 다음 세션의 초점으로 보고 거기에 맞춘다.
- 쓴 뒤 커밋하고, 사용자에게 "/new 후 'docs/HANDOFF.md부터 읽고 이어가라'"를 안내한다.

출처: mattpocock/skills의 handoff(MIT)를 바탕으로, 저장 위치를 저장소 안으로 바꾸고 항목을 정했다.
