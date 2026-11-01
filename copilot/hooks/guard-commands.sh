#!/usr/bin/env bash
set -euo pipefail

decide() {
  printf '{"permissionDecision":"%s","permissionDecisionReason":"%s"}\n' "$1" "$2"
  exit 0
}

command -v jq >/dev/null || decide deny "Install jq so the command guard can run."

input="$(cat)"
[[ "$(jq -r '.toolName // empty' <<<"$input")" == "bash" ]] || exit 0

command="$(jq -r '
  .toolArgs
  | (if type == "string" then (fromjson? // {}) else . end)
  | .command // empty
' <<<"$input")"

matches() { grep -Eq -- "$1" <<<"$command"; }

git_push='git( -C [^ ]+)? push( |$)'

if matches "${git_push}(.* )?(--force|-f( |$)|\\+[^ ])"; then
  decide deny "Force pushes are blocked. Ask the user to run it."
fi
if matches '--no-verify'; then
  decide deny "Git hooks must run. Fix what the hook reports instead."
fi
if matches 'gh repo (edit|delete|archive|rename)'; then
  decide deny "Repository settings are changed by the user on GitHub."
fi
if matches 'gh api .*(rulesets|/protection)'; then
  decide deny "Branch protection is changed by the user on GitHub."
fi
if matches 'gh auth token'; then
  decide deny "The GitHub token must not be printed."
fi
if matches '\.npmrc'; then
  decide deny "~/.npmrc holds registry tokens and must not be read."
fi

if matches "$git_push"; then
  decide ask "Every push needs the user's approval."
fi
if matches 'gh pr merge'; then
  decide ask "Merging a pull request needs the user's approval."
fi
if matches 'git reset --hard'; then
  decide ask "Discarding work needs the user's approval."
fi
if matches 'git branch -D'; then
  decide ask "Deleting a branch needs the user's approval."
fi
