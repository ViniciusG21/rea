#!/bin/bash
# Prepares Claude Code cloud sessions: submodules and locked npm dependencies.
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(dirname "$0")/../..}"

git submodule update --init --recursive

# Reinstall only when node_modules is missing or older than the lockfile, so a
# cached container skips the install and npm never rewrites package-lock.json.
if [ ! -f node_modules/.package-lock.json ] || [ package-lock.json -nt node_modules/.package-lock.json ]; then
  npm ci --no-audit --no-fund
fi
