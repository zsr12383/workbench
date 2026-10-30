#!/usr/bin/env bash
# Copy workbench (rules, doc templates, skills) into a project. No network access.
#
#   ./install.sh <project-dir> [--profile core|ui|all] [--target codex|claude] [--force]
#
#   --profile core  (default) AGENTS.md + docs/ templates + interview, unknowns, oss-scout, handoff, spec-check, review-gate,
#                   explain, grill-me
#   --profile ui    core + frontend-ui-engineering, ui-slop-avoid.md
#   --profile all   ui + frontend-design, web-design-guidelines, doubt-driven, constraint-driven, idea-refine,
#                   codebase-design, writing-for-agents, react-best-practices (everyday use)
#   --target codex  (default) skills -> <project>/.agents/skills, references -> <project>/.agents/references
#   --target claude skills -> <project>/.claude/skills, references -> <project>/.claude/references
#   --with-agents   (codex) copy the reviewer roles to $CODEX_HOME/agents/ (fixed effort, read-only sandbox)
#   --with-profile  (codex) copy full.config.toml to $CODEX_HOME; start Codex with `codex -p full`
#                   Both change Codex settings: use them only where that is explicitly allowed.
#   --force         overwrite existing AGENTS.md, docs/*.md and skills (default: keep what is there)
set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT="" PROFILE="core" TARGET="codex" FORCE=0 AGENTS=0 PROFILE_FILE=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="$2"; shift 2 ;;
    --target)  TARGET="$2"; shift 2 ;;
    --force)   FORCE=1; shift ;;
    --with-agents) AGENTS=1; shift ;;
    --with-profile) PROFILE_FILE=1; shift ;;
    -h|--help) sed -n '2,15p' "$0"; exit 0 ;;
    *) [ -z "$PROJECT" ] && PROJECT="$1" || { echo "unexpected argument: $1" >&2; exit 2; }; shift ;;
  esac
done
[ -n "$PROJECT" ] || { echo "usage: $0 <project-dir> [--profile core|ui|all] [--target codex|claude] [--force]" >&2; exit 2; }
[ -d "$PROJECT" ] || { echo "not a directory: $PROJECT" >&2; exit 2; }
PROJECT="$(cd "$PROJECT" && pwd)"

case "$TARGET" in
  codex)  BASE="$PROJECT/.agents" ;;
  claude) BASE="$PROJECT/.claude" ;;
  *) echo "unknown target: $TARGET" >&2; exit 2 ;;
esac
SKILLS="$BASE/skills" REFS="$BASE/references"

core=(kit/skills/interview kit/skills/unknowns kit/skills/oss-scout kit/skills/handoff kit/skills/spec-check kit/skills/review-gate
      kit/skills/explain vendor/mattpocock/skills/grill-me)
ui=(vendor/addyosmani/skills/frontend-ui-engineering)
rest=(vendor/anthropics/skills/frontend-design vendor/vercel/skills/web-design-guidelines
      vendor/addyosmani/skills/doubt-driven-development vendor/addyosmani/skills/constraint-driven-development
      vendor/addyosmani/skills/idea-refine vendor/mattpocock/skills/codebase-design
      vendor/mattpocock/skills/writing-for-agents vendor/vercel/skills/react-best-practices)
case "$PROFILE" in
  core) pick=("${core[@]}") ;;
  ui)   pick=("${core[@]}" "${ui[@]}") ;;
  all)  pick=("${core[@]}" "${ui[@]}" "${rest[@]}") ;;
  *) echo "unknown profile: $PROFILE" >&2; exit 2 ;;
esac

put() {  # put <src-file> <dst-file>
  if [ -e "$2" ] && [ "$FORCE" -eq 0 ]; then echo "  keep   ${2#"$PROJECT"/}"; return; fi
  mkdir -p "$(dirname "$2")"; cp "$1" "$2"; echo "  write  ${2#"$PROJECT"/}"
}

echo "workbench -> $PROJECT (profile=$PROFILE, target=$TARGET)"
# A task repo may ship its own AGENTS.md: keep it and append the kit rules under it instead of skipping them.
if [ -e "$PROJECT/AGENTS.md" ] && [ "$FORCE" -eq 0 ]; then
  if grep -q '^# 작업 규칙' "$PROJECT/AGENTS.md"; then echo "  keep   AGENTS.md (kit rules already there)"
  else printf '\n\n' >> "$PROJECT/AGENTS.md"; cat "$KIT/kit/AGENTS.md" >> "$PROJECT/AGENTS.md"; echo "  append AGENTS.md (kit rules under the existing file)"; fi
else
  put "$KIT/kit/AGENTS.md" "$PROJECT/AGENTS.md"
fi
for f in "$KIT"/kit/docs/*.md; do put "$f" "$PROJECT/docs/$(basename "$f")"; done
put "$KIT/kit/docs/research/README.md" "$PROJECT/docs/research/README.md"

mkdir -p "$SKILLS"
for s in "${pick[@]}"; do
  name="$(basename "$s")"
  if [ -e "$SKILLS/$name" ] && [ "$FORCE" -eq 0 ]; then echo "  keep   ${SKILLS#"$PROJECT"/}/$name"; continue; fi
  rm -rf "${SKILLS:?}/$name"; cp -R "$KIT/$s" "$SKILLS/$name"; echo "  skill  ${SKILLS#"$PROJECT"/}/$name"
  # Codex validates SKILL.md frontmatter strictly; its manual-invocation switch lives in agents/openai.yaml.
  if [ "$TARGET" = codex ]; then sed -i '/^disable-model-invocation: true$/d' "$SKILLS/$name/SKILL.md"; fi
done

# addyosmani skills link to ../../references/*.md, which resolves to $BASE/references from $BASE/skills/<name>/.
if printf '%s\n' "${pick[@]}" | grep -q '^vendor/addyosmani/'; then
  for f in "$KIT"/vendor/addyosmani/references/*.md; do put "$f" "$REFS/$(basename "$f")"; done
fi

# User-level files: loaded without trusting the project, outside the read-only .codex/ of the workspace.
CODEX_DIR="${CODEX_HOME:-$HOME/.codex}"
if [ "$AGENTS" -eq 1 ] || [ "$PROFILE_FILE" -eq 1 ]; then
  if [ "$TARGET" != codex ]; then echo "  skip   --with-agents/--with-profile are for --target codex"
  else
    if [ "$AGENTS" -eq 1 ]; then for f in "$KIT"/kit/codex-agents/*.toml; do put "$f" "$CODEX_DIR/agents/$(basename "$f")"; done; fi
    if [ "$PROFILE_FILE" -eq 1 ]; then put "$KIT/kit/codex-profile/full.config.toml" "$CODEX_DIR/full.config.toml"; fi
  fi
fi

if [ "$PROFILE" != "core" ]; then
  put "$KIT/vendor/impeccable/ui-slop-avoid.md" "$PROJECT/docs/ui-slop-avoid.md"
  if ! grep -q '^## UI' "$PROJECT/AGENTS.md"; then
    cat >> "$PROJECT/AGENTS.md" <<'EOF'

## UI
- 화면이 있으면 계획 단계에서 화면 방향(주요 화면, 색 4~6개, 글꼴 역할, 레이아웃)을 SPEC에 짧게 적는다.
- UI 구현은 $frontend-ui-engineering 기준. 완료 조건에 로딩·오류·빈 상태, 접근성(label, alt, 키보드)을 넣는다.
- docs/ui-slop-avoid.md의 AI 티를 피한다.
EOF
    echo "  append AGENTS.md (## UI)"
  fi
fi

[ ! -e "$PROJECT/AGENTS.override.md" ] || echo "  note   AGENTS.override.md exists and hides AGENTS.md from Codex: merge or rename it"
if command -v git >/dev/null; then
  git -C "$PROJECT" rev-parse --git-dir >/dev/null 2>&1 || echo "  note   not a git repository yet: git init before starting Codex"
  [ -n "$(git -C "$PROJECT" config user.email 2>/dev/null)" ] || echo "  note   git user.email is not set: commits will fail until it is"
fi

echo "done. Start Codex now (or /new if it was already running) so AGENTS.md and the skills are loaded; check with /skills."
