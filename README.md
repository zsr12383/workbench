# workbench

Codex와 함께 과제를 진행할 때 쓰는 작업 규칙, 문서 양식, 스킬 묶음이다. 단계별 진행 순서와 막힐 때 할 일은 [GUIDE.md](GUIDE.md)에 있다. 설치 스크립트는 파일을 복사만 하고 네트워크를 쓰지 않는다.

## 사용법

Codex를 켜기 전에 터미널에서 직접 친다. 그래야 첫 세션부터 AGENTS.md와 스킬이 읽힌다.

```bash
git clone --depth 1 <이 저장소 주소> /tmp/kit
bash /tmp/kit/env-check.sh --install         # 도구·네트워크·설치 확인
bash /tmp/kit/install.sh .                    # 기본: 규칙 + 문서 양식 + 스킬 8개
bash /tmp/kit/install.sh . --profile ui       # 화면이 있는 과제면
codex                                         # 그다음 /status, /model, /skills 확인
```

Codex 설정(권한·웹 검색·사용자 정의 에이전트)은 기본값 그대로 쓴다. 환경에 따라 설정 변경이 제한되거나 기록될 수 있기 때문이다. 바꿔도 된다고 확인된 환경에서만 아래를 쓴다.

```bash
bash /tmp/kit/install.sh . --with-profile --with-agents   # 그 뒤 codex -p full
```

Codex가 이미 켜져 있었다면 설치 뒤 `/new`로 새 세션을 연다.

터미널은 셋을 쓴다. 서버 전용 하나, 메인 Codex(A) 하나, 곁일 Codex(B) 하나. B는 새 터미널에서 `codex`를 띄우고 docs/PROMPTS.md의 'B 탭 시작'으로 연다. B는 코드를 고치거나 커밋하지 않고 조사·리뷰·설명 준비만 한다. Codex 서브에이전트는 끝날 때까지 부른 세션을 막기 때문에, 오래 걸리는 곁일은 B에서 돌린다.

## 들어 있는 것

| 경로 | 내용 | 호출 |
| --- | --- | --- |
| `env-check.sh` | OS·자원, 설치된 도구, 전역 패키지, 레지스트리·GitHub 한도, `--install`이면 npm·pip 설치 확인 | `bash env-check.sh` |
| `kit/AGENTS.md` | 작업 규칙 20줄 + 프로젝트 섹션 + 세션 둘(A 메인, B 곁일) + 문서·스킬 안내 | 세션 시작 때 자동으로 읽힘 |
| `kit/docs/` | SPEC, PLAN, DECISIONS, EXPLAIN, HANDOFF, REVIEW, INTERVIEW, REFERENCES, PROMPTS 양식(B 탭 시작·제출 점검 지시문 포함), research/ | — |
| `kit/skills/interview` | 실무자 인터뷰: 상태별 질문 라운드, 답 분류에 따른 다음 질문, 확장·수렴, 재진술 확인. 결과는 SPEC·DECISIONS·INTERVIEW.md | `$interview` |
| `kit/skills/unknowns` | (B 탭) 모르는 것 목록 → 기술 사실만 조사, 시나리오 사실은 실무자 질문으로 넘김 → 네 종류로 분류해 docs/research/에 날짜·출처와 함께 | `$unknowns scan`, `$unknowns` |
| `kit/skills/oss-scout` | 키 없이 오픈소스 찾기(웹 검색, GitHub 검색 API, npm, ecosyste.ms), /tmp/refs에 받아 서브에이전트로 나눠 읽기, REFERENCES.md | `$oss-scout` |
| `kit/skills/handoff` | `docs/HANDOFF.md` 작성 후 새 세션으로 | `$handoff` |
| `kit/skills/spec-check` | SPEC 성공 기준·기본 품질·제약마다 증거 대조, 고치지 않음 | `$spec-check` |
| `kit/skills/review-gate` | 부모 기록 없는 읽기 전용 리뷰어(요구·엣지 high, 적대적 high, 입력·인증·외부 호출을 건드리면 보안 medium) 병렬, 결과는 docs/REVIEW.md. `quick`은 1개 | `$review-gate` |
| `kit/skills/explain` | 작업 설명 준비: 예상 질문 6개, 3단 답, 외울 카드 | `$explain` |
| `kit/codex-agents/` | 위 리뷰어 3개의 Codex 사용자 정의 에이전트(강도 고정, 읽기 전용 샌드박스). `--with-agents`로 `$CODEX_HOME/agents/`에 설치. 설정 변경이 허용된 환경에서만 | — |
| `kit/codex-profile/full.config.toml` | Codex 프로필: Full Access, 승인 없음, live 웹 검색, Medium, 동시 서브에이전트 4. `--with-profile`로 `$CODEX_HOME`에 넣고 `codex -p full`로 시작. 설정 변경이 허용된 환경에서만 | — |
| `vendor/mattpocock/skills/grill-me` | 질문 라운드로 계획·결정 굳히기 | `$grill-me` |
| `vendor/addyosmani/skills/frontend-ui-engineering` | UI 구현 기준: 로딩·오류·빈 상태, 접근성, 반응형 (`ui`) | `$frontend-ui-engineering` |
| `vendor/impeccable/ui-slop-avoid.md` | 피할 AI 티 25개 (`ui`) | 문서 |
| 나머지 `vendor/` | frontend-design(자동), web-design-guidelines, doubt-driven, constraint-driven, idea-refine, codebase-design, writing-for-agents, react-best-practices (`all`, 평소용) | frontend-design 외 수동 |

수동 스킬은 Claude Code용 `disable-model-invocation: true`와 Codex용 `agents/openai.yaml`의 `allow_implicit_invocation: false`를 함께 갖는다. 평소 Claude Code에서 쓸 때는 `--target claude`.

`all`은 평소용이다. 시간이 짧은 과제에서는 리뷰가 겹치거나(doubt-driven), 도구를 새로 설치하거나(constraint-driven), 과제와 맞지 않는다(idea-refine, codebase-design). 운영 배포 체크리스트(shipping-and-launch)와 운영 계측(observability)은 배포 단계가 없고 외부 전송이 막힌 작업 환경을 전제로 넣지 않았다.

## 라이선스

`kit/`은 이 저장소 주인의 것이다. `vendor/`의 각 폴더는 원 저작자의 라이선스를 따르며, 출처 커밋과 바꾼 점은 `THIRD_PARTY_NOTICES.md`에 있다.
