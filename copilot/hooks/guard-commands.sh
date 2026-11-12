#!/usr/bin/env bash
set -euo pipefail

decide() {
  printf '{"permissionDecision":"%s","permissionDecisionReason":"%s"}\n' "$1" "$2"
  exit 0
}

command -v jq >/dev/null || decide deny "Install jq so the command guard can run."

input="$(cat)"
jq -e 'type == "object"' >/dev/null 2>&1 <<<"$input" ||
  decide deny "The command guard could not read the tool call."
[[ "$(jq -r '.toolName // empty' <<<"$input")" == "bash" ]] || exit 0

command="$(jq -r '
  .toolArgs
  | (if type == "string" then (try fromjson catch null) else . end)
  | if type == "object" then (.command // "") else "" end
' <<<"$input")"
[[ -n "${command//[[:space:]]/}" ]] ||
  decide deny "The command guard could not read the shell command."

command="$(perl -0pe 's/\\\n/ /g; s/\n/;/g; s/[ \t]+/ /g' <<<"$command")"

matches() { grep -Eq -- "$1" <<<"$command"; }

end='( |$|[;&|)])'
args='( [^;&|]*)?'
git_options="( +(-C|-c) +(\"[^\"]*\"|'[^']*'|[^ ;&|]+)| +--?[A-Za-z][A-Za-z-]*(=[^ ;&|]+)?)*"
git="(^|[^[:alnum:]_./-])git${git_options} +"
home='(~|\$HOME|\$\{HOME\}|/Users/[^/ ]+|/home/[^/ ]+)'

if matches "${git}push${args} (--force[^ ;&|]*|-[A-Za-z]*f[A-Za-z]*|\+[^ ;&|]+)${end}"; then
  decide deny "Force pushes are blocked. Ask the user to run it."
fi
if matches "${git}[a-z-]+${args} --no-verify${end}" ||
  matches "${git}commit${args} -[A-Za-z]*n[A-Za-z]*${end}"; then
  decide deny "Git hooks must run. Fix what the hook reports instead."
fi
if matches "gh repo (edit|delete|archive|rename)${end}"; then
  decide deny "Repository settings are changed by the user on GitHub."
fi
if matches 'gh api [^;&|]*(rulesets|/protection)'; then
  decide deny "Branch protection is changed by the user on GitHub."
fi
if matches "gh auth token${end}"; then
  decide deny "The GitHub token must not be printed."
fi
if matches "${home}/\.npmrc"; then
  decide deny "~/.npmrc holds registry tokens and must not be read."
fi

if matches "${git}push${end}"; then
  decide ask "Every push needs the user's approval."
fi
if matches "gh pr merge${end}"; then
  decide ask "Merging a pull request needs the user's approval."
fi
if matches "${git}reset${args} --hard${end}"; then
  decide ask "Discarding work needs the user's approval."
fi
if matches "${git}branch${args} -D${end}"; then
  decide ask "Deleting a branch needs the user's approval."
fi
