# 진행 안내

workbench를 설치한 과제에서 무엇을 어떤 순서로 부르는지 정리했다. 이 파일은 설치해도 작업 폴더에 복사되지 않는다. 작업 중에는 `less /tmp/kit/GUIDE.md`로 본다.

## 1. 셋업 (작업을 시작한 직후)

터미널은 셋을 연다. 1번은 서버 전용, A는 메인 Codex, B는 곁일 Codex다. 아래는 1번에서 친다.

```bash
git clone --depth 1 https://github.com/zsr12383/workbench /tmp/kit
bash /tmp/kit/env-check.sh --install    # 도구, 레지스트리, GitHub 남은 한도, npm·pip 설치
bash /tmp/kit/install.sh .              # 화면이 있는 과제면 --profile ui
```

| 순서 | 어디서 | 할 일 | 보여야 할 것 |
| --- | --- | --- | --- |
| 1 | A | `codex` → 폴더 신뢰 → `/status` → `/model`(추론 강도 Medium) → `/skills` | 승인 정책·샌드박스·모델, 스킬 8개 |
| 2 | A | docs/PROMPTS.md의 '부트스트랩' | SPEC에 필수조건, 모르는 것 3개 이하 |
| 3 | B | `codex` → `/model` → 'B 탭 시작' + `$unknowns scan` | docs/research/에 결과 파일 |
| 4 | A | `$interview` → 첫 라운드 질문을 담당자에게 | 질문 3개 이하 |

- 지시문은 에디터에서 docs/PROMPTS.md를 열어 복사하고, 터미널에는 Ctrl+Shift+V로 붙인다.
- 부트스트랩이 끝나면 A가 규칙·문서 뼈대를 첫 커밋으로 남긴다.
- 승인 창에서는 '이 세션 동안 허용'이나 '이 명령으로 시작하는 것은 항상 허용'을 고른다.

## 2. 단계 흐름

| 단계 | A (메인) | B (곁일) | 남는 것 |
| --- | --- | --- | --- |
| 정의 | `$interview` 라운드. 답은 `[실무자] …`, 내 생각은 `[내 메모] …`로 붙여 넣는다 | scan 결과 정리 | INTERVIEW.md, SPEC 초안 |
| 범위 합의 | `/plan`에서 PROMPTS의 '기본 품질과 범위 밖' → SPEC 확정 → `$spec-check` | SPEC 초안이 나오면 `$unknowns` | SPEC, docs/research/ |
| 설계·분해 | `/plan` → 승인 → docs/PLAN.md로 옮겨 커밋. B 결과는 PROMPTS의 'B 결과를 A에 반영' | 가져다 쓸 코드가 필요하면 `$oss-scout` | PLAN.md, DECISIONS.md, REFERENCES.md |
| 첫 동작판 | 작업 하나씩: 테스트 → 커밋(EXPLAIN 4줄을 같은 커밋에) | — | 처음부터 끝까지 돌아가는 최소판 |
| 중간 점검 | 지적은 PLAN의 새 작업으로 | `$review-gate quick` | REVIEW.md |
| 반복 구현 | PLAN 작업 반복. 맥락이 무거우면 커밋 직후 `$handoff` → `/new` | 새로 모르는 게 생기면 `$unknowns` | 커밋들 |
| 기능 동결 | 새 기능을 더하지 않는다. `$spec-check`, 리뷰 지적 수정 | `$review-gate` | REVIEW.md |
| 정리 | README·EXPLAIN 정리, 최종 커밋 | `$explain` | QA-PREP.md |
| 작업을 끝마치기 10분 전 | PROMPTS의 '제출 점검' → 미리보기에서 핵심 흐름 → 에디터 '저장됨' 확인 | 종료 | — |

- B는 코드·SPEC·PLAN·DECISIONS·EXPLAIN을 고치지 않고 커밋하지 않는다. 커밋은 A만 한다.
- 결정이 몰리는 설계는 `/plan`에서 한다. 객관식 질문 창으로 선택지와 추천을 받을 수 있다.
- 정리 단계에서는 QA-PREP.md 맨 위의 외울 카드를 소리 내 읽어 본다.

## 3. 부르는 말

| 스킬 | 탭 | 예 |
| --- | --- | --- |
| `$interview` | A | `$interview`. 답을 붙일 때 `[실무자] …`, `[내 메모] …` |
| `$unknowns` | B | `$unknowns scan`, 나중에 `$unknowns` |
| `$grill-me` | A | `$grill-me 질문은 5개까지, 문서에 답이 있으면 먼저 찾아라` |
| `$oss-scout` | B | `$oss-scout <필요한 것 한 문장>` |
| `$spec-check` | A·B | `$spec-check` |
| `$review-gate` | B | `$review-gate quick`, `$review-gate` |
| `$handoff` | A | `$handoff` → `/new` → "docs/HANDOFF.md부터 읽고 이어가라" |
| `$explain` | B | `$explain` |

## 4. 막힐 때

| 증상 | 할 일 |
| --- | --- |
| 승인 창이 자주 뜬다 | 의존성 설치는 초반에 한 번 승인해 끝낸다. 자주 쓰는 명령(`ls`, `cat`, `sed -n`, `rg`, `git status`·`diff`·`log`, 테스트 명령)은 '이 명령으로 시작하는 것은 항상 허용'으로 등록한다 |
| 맡긴 작업이 멈춘 것 같다 | 승인 대기인지 먼저 본다. 승인 창은 기다리기만 해서는 진행되지 않는다 |
| 읽기 명령까지 실패한다(샌드박스 오류) | 승인해서 실행한다. 계속 막히면 필요한 파일을 내가 열어 보여 준다 |
| `$이름`에 반응이 없다 | `/skills`로 확인하고, 없으면 `/new`. 그래도 안 되면 "`.agents/skills/<이름>/SKILL.md`를 읽고 따라라" |
| 미리보기가 안 열린다 | 서버 오류·종료 → 실제 포트 → 0.0.0.0 바인딩 → 경로 순서로 본다. `ss -ltnp \| grep <포트>`가 `127.0.0.1`이면 localhost에만 열린 것이다 |
| 맥락이 무겁다 | 커밋 직후라면 `$handoff` → `/new`, 작업 도중이면 `/compact` |
| 결정이 모호하다 | 되돌리기 비싼 것(범위, 구조, 데이터 모델, 제약)만 묻는다. 싼 것은 기본값으로 진행하고 DECISIONS에 가정으로 남긴다 |
| 외부 코드가 필요하다 | /tmp/refs에 받는다. 작업 폴더에는 넣지 않는다 |

### 서버를 0.0.0.0으로 띄우기

미리보기는 바깥에서 서버 포트로 들어오기 때문에, localhost에만 열린 서버는 보이지 않을 수 있다. 서버는 1번 터미널에서 띄우고 탭을 닫지 않는다.

| 종류 | 명령 |
| --- | --- |
| Vite | `npm run dev -- --host 0.0.0.0 --port 3000` |
| Next.js | `npx next dev -H 0.0.0.0 -p 3000` |
| Node·Express | `app.listen(3000, '0.0.0.0')` |
| 정적 파일 | `python3 -m http.server 3000 --bind 0.0.0.0` |
| FastAPI | `uvicorn main:app --host 0.0.0.0 --port 8000` |
| Flask | `flask run --host 0.0.0.0 --port 5000` |
| Django | `python manage.py runserver 0.0.0.0:8000` |
| Streamlit | `streamlit run app.py --server.address 0.0.0.0` |
