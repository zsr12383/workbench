# 진행 안내

workbench를 설치한 프로젝트에서 무엇을 어떤 순서로 부르는지 정리했다. 이 파일은 설치해도 작업 폴더에 복사되지 않는다. 작업 중에는 `less /tmp/kit/GUIDE.md`로 본다.

## 0. 가볍게 가는 길

시간이 빠듯하거나 단계 사이에서 자꾸 막히면 왼쪽 칸만 쓴다.

| 꼭 쓴다 | 필요할 때만 | 생략해도 된다 |
| --- | --- | --- |
| AGENTS.md 규칙 | B의 `$unknowns scan` 한 번 | B 세션 자체(A 하나로 진행) |
| PROMPTS: 부트스트랩 → 기본 품질과 범위 밖 → 설계·분해 → 계획 반영 → 마무리 점검 | `$review-gate quick` 1~2번(막히면 `/review`) | `$oss-scout`(필요한 부품이 확실할 때만) |
| `$interview` | `$handoff`(맥락이 무거울 때) | `/goal` |
| `$spec-check`(관문 A·C) | | 표적 조사 `$unknowns` |
| `$explain`(마지막 20분) | | |

- 스킬 이름이 기억나지 않으면 말로 부른다: "인터뷰 스킬의 재진술만", "적대적 리뷰어 하나만".
- 막히면 "원인부터 찾고, 가설을 하나씩 검증해"라고 한다.

## 1. 셋업 (작업을 시작한 직후)

터미널은 셋을 연다. 1번은 서버 전용, A는 메인 Codex, B는 곁일 Codex다. 아래는 1번에서, 작업 폴더(Codex를 띄울 폴더가 정해져 있으면 그 폴더)로 `cd`한 뒤 친다. A·B의 `codex`도 그 폴더에서 띄운다. kit은 /tmp/kit에 받고 작업 폴더에는 clone하지 않는다. 작업 폴더가 그대로 결과물이다.

```bash
git clone --depth 1 https://github.com/zsr12383/workbench /tmp/kit
bash /tmp/kit/env-check.sh --install    # 도구, 레지스트리, GitHub 남은 한도, npm·pip 설치
git rev-parse --git-dir >/dev/null 2>&1 || git init -q             # 저장소가 아니면 만든다
git config user.email >/dev/null || git config user.email dev@localhost
git config user.name >/dev/null || git config user.name dev        # 커밋 이름이 없으면 커밋이 실패한다
bash /tmp/kit/install.sh .              # 화면이 있는 프로젝트면 --profile ui
```

git 저장소와 커밋 이름은 Codex를 띄우기 전에 맞춘다. 저장소가 아닌 폴더는 Codex가 읽기 전용으로 시작할 수 있다.

| 순서 | 어디서 | 할 일 | 보여야 할 것 |
| --- | --- | --- | --- |
| 1 | A | `codex` → 폴더 신뢰 → `/status` → `/model`(추론 강도 Medium) → `/skills` | 승인 정책·샌드박스·모델, 남은 사용 한도, 스킬 8개 |
| 2 | A | docs/PROMPTS.md의 '부트스트랩' | SPEC에 필수조건, 첫 커밋, `git status` 깨끗 |
| 3 | B | `codex` → `/model` → 'B 탭 시작' + `$unknowns scan` | docs/research/에 결과 파일 |
| 4 | A | `$interview` → 첫 라운드 질문을 담당자에게 | 질문 3개 이하 |

- 지시문은 에디터에서 docs/PROMPTS.md를 열어 복사하고, 터미널에는 Ctrl+Shift+V로 붙인다.
- 부트스트랩이 규칙·문서 뼈대·제공 데이터를 첫 커밋으로 남긴다. 추적 안 된 파일이 남으면 B의 리뷰·점검이 '작업 트리 변경 중'으로 보고 테스트를 건너뛴다.
- 승인 창에서는 '이 세션 동안 허용'이나 '이 명령으로 시작하는 것은 항상 허용'을 고른다.
- Codex가 일하는 중에 Enter로 보낸 말은 바로 끼어든다. 끝난 뒤에 보내려면 대기열 키(기본 Tab)를 쓴다.
- 추론 강도는 Medium이 기본이다. 계획과 어려운 디버깅만 High로 올리고, Extra High는 막혔을 때만 쓴다(토큰이 약 2배). 올리기 전에 완료 조건이나 검증 명령이 빠지지 않았는지 먼저 본다.

## 2. 단계 흐름

| 단계 | A (메인) | B (곁일) | 남는 것 |
| --- | --- | --- | --- |
| 정의 | `$interview` 라운드. 답은 `[실무자] …`, 내 생각은 `[내 메모] …`로 붙여 넣는다 | 인터뷰 2라운드쯤 `$unknowns`(INTERVIEW.md 기준). README가 짧을수록 일찍 | INTERVIEW.md, SPEC 초안 |
| 범위 합의 | `/plan`에서 PROMPTS의 '기본 품질과 범위 밖' → 고르기 → 'Yes, implement'(문서만 고친다) → `$spec-check` | SPEC 초안이 나오면 `$unknowns` | SPEC, docs/research/ |
| 설계·분해 | `/plan`에서 PROMPTS의 '설계·분해'(research/·REFERENCES도 읽는다) → 'No, stay' → Shift+Tab, '계획 반영' | 비싼 부품이 보이면 설계·분해 전에 `$oss-scout <부품>`. 런타임이 미정이면 "브라우저·Node 각 1개" | PLAN.md, DECISIONS.md, REFERENCES.md |
| 첫 동작판 | '작업 지시 틀'로 작업 1(끝까지 도는 가장 얇은 판): 테스트 → 커밋(EXPLAIN 4줄을 같은 커밋에) → PROMPTS '프로젝트 맥락 반영' | — | 처음부터 끝까지 돌아가는 최소판 |
| 중간 점검 | 지적은 PLAN의 새 작업으로 | `$review-gate quick` | REVIEW.md |
| 반복 구현 | PLAN 작업 반복. 맥락이 무거우면 커밋 직후 `$handoff` → `/new` | 새로 모르는 게 생기면 `$unknowns` | 커밋들 |
| 기능 동결 | 새 기능을 더하지 않는다. `$spec-check`, 리뷰 지적 수정 | `$review-gate` | REVIEW.md |
| 정리 | PROMPTS '결과 문서'(README가 요구한 문서, 실행 방법) → 최종 커밋 | `$explain` | QA-PREP.md |
| 작업을 끝마치기 10분 전 | PROMPTS의 '마무리 점검' → 미리보기에서 핵심 흐름 → 에디터 '저장됨' 확인 | 종료 | — |

- B는 코드·SPEC·PLAN·DECISIONS·EXPLAIN을 고치지 않고 커밋하지 않는다. 커밋은 A만 하고, B가 쓴 docs 파일도 A의 다음 커밋에 함께 들어간다.
- B는 곁일 하나가 끝나면 `/new`로 새로 시작한다. 이전 곁일의 결과는 파일에 있고, 한 세션에 곁일이 쌓이면 요청마다 그 맥락을 다시 보내 토큰이 크게 는다.
- `/plan`은 스킬이 아니라 모드 전환이다. `/plan`만 치고 Enter → 지시문 붙여넣기. Plan 모드는 파일을 쓰지 않고 객관식 질문 창으로 묻는다. 계획이 나오면 'Implement this plan?'에서 'No, stay in Plan mode'를 고르고 Shift+Tab으로 Default에 돌아와 문서 반영을 시킨다('Yes'는 바로 코딩을 시작한다).
- B의 조사 결과 중 '넘길 질문'은 인터뷰가 라운드마다 알아서 집어 간다. 나머지(제약·결정 지점)는 '설계·분해' 지시문이 research/를 함께 읽어 반영하므로 따로 붙이지 않는다. PLAN이 생긴 뒤 새로 나온 B 결과만 파일 끝의 'A에 줄 지시문'을 A에 붙인다.
- 정리 단계에서는 QA-PREP.md 맨 위의 외울 카드를 소리 내 읽어 본다.

## 3. 부르는 말

| 스킬 | 탭 | 예 |
| --- | --- | --- |
| `$interview` | A | `$interview`. 답을 붙일 때 `[실무자] …`, `[내 메모] …` |
| `$unknowns` | B | `$unknowns scan`, 인터뷰 뒤 `$unknowns`, 주제 하나면 `$unknowns <주제>` |
| `$grill-me` | A | `$grill-me 질문은 5개까지, 문서에 답이 있으면 먼저 찾아라` |
| `$oss-scout` | B | `$oss-scout <필요한 것 한 문장>` |
| `$spec-check` | A·B | `$spec-check` |
| `$review-gate` | B | `$review-gate quick`, `$review-gate` |
| `$handoff` | A | `$handoff` → `/new` → "docs/HANDOFF.md부터 읽고 이어가라" |
| `$explain` | B | `$explain` |

스킬 뒤에 붙인 말은 스킬 절차보다 우선한다. 바꾼 것은 결과 맨 위 '인자 반영:' 줄에 나온다. 예: `$interview 실무자 없음, 문서만으로`, `$explain 질문 10개, 답은 3문장`, `$spec-check C1~C3만`, `$unknowns scan 데이터 형식만`, `$review-gate quick 보안 관점으로`.

## 4. 막힐 때

| 증상 | 할 일 |
| --- | --- |
| 승인 창이 자주 뜬다 | 의존성 설치는 초반에 한 번 승인해 끝낸다. 자주 쓰는 명령(`ls`, `cat`, `sed -n`, `rg`, `git status`·`diff`·`log`·`add`·`commit`, 테스트 명령)은 '이 명령으로 시작하는 것은 항상 허용'으로 등록한다. `.git`은 샌드박스에서 읽기 전용이라 커밋마다 승인을 묻는다 |
| 방금 변경을 되돌리고 싶다 | Esc 되감기는 대화만 되돌리고 파일은 그대로다. 커밋 전이면 `git restore <파일>`(새 파일은 `git status`로 보고 지운다), 커밋 뒤면 `git revert <해시>`. 그다음 Codex에 "되돌렸다"고 알린다 |
| `$review-gate`가 돌지 않는다 | B에서 `/review` → 커밋을 고르거나 "`<기준>..<끝>` diff를 SPEC 기준으로 보라"고 직접 지시. 결과는 REVIEW.md에 옮긴다 |
| 맡긴 작업이 멈춘 것 같다 | 승인 대기인지 먼저 본다. 승인 창은 기다리기만 해서는 진행되지 않는다 |
| 읽기 명령까지 실패한다(샌드박스 오류) | 승인해서 실행한다. 계속 막히면 필요한 파일을 내가 열어 보여 준다 |
| `$이름`에 반응이 없다 | `/skills`로 확인하고, 없으면 `/new`. 그래도 안 되면 "`.agents/skills/<이름>/SKILL.md`를 읽고 따라라" |
| 미리보기가 안 열린다 | 서버 오류·종료 → 실제 포트 → 0.0.0.0 바인딩 → 경로 순서로 본다. `ss -ltnp \| grep <포트>`가 `127.0.0.1`이면 localhost에만 열린 것이다. 'Blocked request'나 400 Invalid HTTP_HOST면 아래 표의 Host 허용 설정이다 |
| 화면은 뜨는데 데이터가 안 온다 | 화면이 `http://localhost:<포트>`로 API를 부르고 있다. 브라우저는 내 PC라 샌드박스의 localhost에 닿지 않는다. Codex에 "API 주소를 같은 출처의 상대 경로(`/api/…`)로 바꾸고 dev 서버 프록시(또는 한 서버에서 함께 서빙)로 넘겨라" |
| 요구 문서가 README가 아니다(PDF·docx·xlsx) | Codex가 바로 읽지 못할 수 있다. 1번 터미널에서 텍스트로 뽑아 docs/에 둔다: PDF `pdftotext <파일> docs/요구.txt`(없으면 내가 열어서 복사), docx·xlsx `unzip -p <파일> word/document.xml \| sed 's/<[^>]*>/ /g' > docs/요구.txt`(xlsx는 `xl/sharedStrings.xml`). 지시문의 'README'는 그 파일로 읽는다 |
| 맥락이 무겁다 | 커밋 직후라면 `$handoff` → `/new`, 작업 도중이면 `/compact` |
| 결정이 모호하다 | 되돌리기 비싼 것(범위, 구조, 데이터 모델, 제약)만 묻는다. 싼 것은 기본값으로 진행하고 DECISIONS에 가정으로 남긴다 |
| 외부 코드가 필요하다 | /tmp/refs에 받는다. 작업 폴더에는 넣지 않는다 |
| 작업 폴더 밖에 쓸 수 없다 | kit을 `.workbench`에 clone → `bash .workbench/install.sh .` → `echo .workbench >> .git/info/exclude`. 이 안내는 `less .workbench/GUIDE.md`로 보고, 마무리 점검 때 `rm -rf .workbench` |

### MCP

MCP가 없어도 web_search, `npm view <패키지> version`, `--help`, `node_modules/<패키지>/README.md`로 충분하다. 붙일 때는 환경이 정한 방법으로 등록한다.

| MCP | 쓰나 | 이유 |
| --- | --- | --- |
| Context7 (`https://mcp.context7.com/mcp`) | 쓴다 | 키 없이 라이브러리 문서를 찾는다 |
| grep.app (`https://mcp.grep.app`) | 선택 | 키 없는 공개 코드 검색. `$oss-scout`에서 다른 구현을 찾을 때만 |
| Playwright, 브라우저 조작류 | 쓰지 않는다 | 에이전트가 화면을 직접 조작한다. E2E는 테스트 파일로 |
| GitHub | 쓰지 않는다 | 개인 토큰이 필요하다 |
| 개인 계정 커넥터(Notion, 메일·드라이브 등), 배포(Vercel 등) | 쓰지 않는다 | 개인 계정이 필요하거나 작업물을 밖으로 보낸다 |
| DeepWiki처럼 다른 AI가 답을 만드는 서버 | 쓰지 않는다 | 다른 AI 모델을 거친다 |

### 서버를 0.0.0.0으로 띄우기

미리보기는 바깥에서 서버 포트로 들어오기 때문에, localhost에만 열린 서버는 보이지 않을 수 있다. 서버는 1번 터미널에서 띄우고 탭을 닫지 않는다.

| 종류 | 명령 |
| --- | --- |
| Vite | `npm run dev -- --host 0.0.0.0 --port 3000` + vite.config에 `server: { allowedHosts: true }`(없으면 미리보기 Host를 막아 'Blocked request' 화면) |
| Next.js | `npx next dev -H 0.0.0.0 -p 3000`. 화면이 비고 콘솔에 cross-origin 차단이 뜨면 next.config의 `allowedDevOrigins`에 미리보기 호스트 |
| Node·Express | `app.listen(3000, '0.0.0.0')` |
| 정적 파일 | `python3 -m http.server 3000 --bind 0.0.0.0` |
| FastAPI | `uvicorn main:app --host 0.0.0.0 --port 8000` |
| Flask | `flask run --host 0.0.0.0 --port 5000` |
| Django | `python manage.py runserver 0.0.0.0:8000` + settings.py `ALLOWED_HOSTS = ['*']`(없으면 400 Invalid HTTP_HOST) |
| Streamlit | `streamlit run app.py --server.address 0.0.0.0 --server.headless true`(첫 실행의 이메일 입력 대기를 건너뛴다, 포트 8501) |
