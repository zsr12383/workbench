#!/usr/bin/env bash
# Print what this sandbox offers: OS, resources, toolchains, reachable registries.
#
#   bash env-check.sh            # read-only checks
#   bash env-check.sh --install  # also try an npm and a pip install under /tmp (needs network)
set -u

sec() { printf '\n== %s\n' "$1"; }
ver() {  # ver <cmd> [args...]: first line of its version output, or "-" when missing
  local c="$1"; shift
  # stdin closed and a timeout: corepack shims (yarn, pnpm) may otherwise prompt to download
  if command -v "$c" >/dev/null 2>&1; then printf '%-9s %s\n' "$c" "$(timeout 5 "$c" "$@" </dev/null 2>&1 | head -1)"
  else printf '%-9s -\n' "$c"; fi
}

sec system
head -2 /etc/os-release 2>/dev/null
echo "cpu $(nproc 2>/dev/null)"
free -h 2>/dev/null | sed -n '2p'
df -h . 2>/dev/null | tail -1
echo "cwd $(pwd)"

sec tools
for c in node npm npx pnpm yarn bun deno python3 pip3 uv poetry git jq rg curl wget sqlite3 psql docker make gcc; do ver "$c" --version; done
ver go version
ver java -version
ver rustc --version

sec 'global packages'
command -v npm >/dev/null 2>&1 && npm ls -g --depth=0 2>/dev/null | tail -n +2
command -v python3 >/dev/null 2>&1 && python3 -m pip list 2>/dev/null | tail -n +3 | head -40

# Downloads only: HTTP status of each registry, and the GitHub quota left for this IP (not counted against it).
sec 'network'
for u in https://registry.npmjs.org/ https://pypi.org/simple/ https://github.com https://repos.ecosyste.ms/api/v1/hosts/GitHub; do
  printf '%-46s %s\n' "$u" "$(curl -s -o /dev/null -m 8 -w '%{http_code}' "$u")"
done
curl -s -m 8 https://api.github.com/rate_limit | python3 -c '
import json, sys
r = json.load(sys.stdin)["resources"]
print("github core %s/%s  search %s/%s" % (r["core"]["remaining"], r["core"]["limit"], r["search"]["remaining"], r["search"]["limit"]))
' 2>/dev/null || echo "github api unreachable"

if [ "${1:-}" = "--install" ]; then
  sec 'install tests (/tmp)'
  (mkdir -p /tmp/envcheck-npm && cd /tmp/envcheck-npm && npm init -y >/dev/null \
    && npm i --no-audit --no-fund --silent is-number@7 \
    && node -e "console.log('npm ok', require('is-number')(5))") || echo "npm install failed"
  (python3 -m venv /tmp/envcheck-py && /tmp/envcheck-py/bin/pip install -q six \
    && /tmp/envcheck-py/bin/python -c "import six; print('pip ok', six.__version__)") || echo "pip install failed"
fi
