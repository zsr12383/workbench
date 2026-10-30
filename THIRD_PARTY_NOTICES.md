# Third-party notices

`vendor/` holds skills copied from the projects below. Each folder keeps its upstream license file.
Changes from upstream are listed per item; everything else is unchanged.

| Folder | Upstream (commit) | License | Changes |
| --- | --- | --- | --- |
| `vendor/anthropics/skills/frontend-design` | [anthropics/skills](https://github.com/anthropics/skills) `ca45fc496a34` | Apache-2.0 (`LICENSE.txt`) | Added `agents/openai.yaml` |
| `vendor/vercel/skills/web-design-guidelines` | [vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills) `1a2c79d4e6c4` (skill, MIT per README) + [vercel-labs/web-interface-guidelines](https://github.com/vercel-labs/web-interface-guidelines) `434b7f913646` (`rules.md` = `command.md`, MIT, `LICENSE`) | MIT | Reads the pinned `rules.md` instead of fetching it on every run; manual invocation; `agents/openai.yaml` |
| `vendor/vercel/skills/react-best-practices` | vercel-labs/agent-skills `1a2c79d4e6c4` | MIT (skill frontmatter, README) | Manual invocation; `agents/openai.yaml` |
| `vendor/addyosmani/skills/*`, `vendor/addyosmani/references/*` | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) `eb07f19f52c2` | MIT (`LICENSE`) | Only 4 skills and 2 references kept; manual invocation; `agents/openai.yaml`; idea-refine names the question tool for both Claude Code and Codex |
| `vendor/mattpocock/skills/*` | [mattpocock/skills](https://github.com/mattpocock/skills) `5beb35b040e3` | MIT (`LICENSE`) | `grill-me` carries the body of `grilling` (upstream grill-me only calls grilling through Claude Code's Skill tool) and looks facts up directly instead of dispatching a sub-agent, which blocks the calling Codex session; instructions added at invocation override the procedure; manual invocation; `agents/openai.yaml` |
| `vendor/impeccable/ui-slop-avoid.md` | [pbakaus/impeccable](https://github.com/pbakaus/impeccable) `5e745ace7e15`, `crates/live/assets/antipatterns.json` | Apache-2.0 (`LICENSE`, `NOTICE.md`) | Extracted the 25 "slop" rule names and descriptions not already covered by frontend-design |
| `kit/skills/handoff` | Based on mattpocock/skills `handoff` | MIT | Rewritten: writes `docs/HANDOFF.md` inside the repo with fixed sections |
