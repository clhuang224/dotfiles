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
tool="$(jq -r '.toolName // empty' <<<"$input")"
[[ -n "$tool" ]] || decide deny "The command guard could not read the tool name."
[[ "$tool" == "bash" ]] || exit 0

command="$(jq -r '
  .toolArgs
  | (if type == "string" then (try fromjson catch null) else . end)
  | if type == "object" then (.command // "") else "" end
' <<<"$input")"
[[ -n "${command//[[:space:]]/}" ]] ||
  decide deny "The command guard could not read the shell command."

command="$(perl -0pe 's/\\\n/ /g; s/\n/;/g; s/[ \t]+/ /g' <<<"$command")"

matches() { grep -Eq -- "$1" <<<"$command"; }
unquoted="${command//[\"\']/}"
matches_unquoted() { grep -Eq -- "$1" <<<"$unquoted"; }

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
if matches_unquoted "gh repo (edit|delete|archive|rename)${end}"; then
  decide deny "Repository settings are changed by the user on GitHub."
fi
if matches_unquoted 'gh api [^;&|]*(rulesets|/protection)'; then
  decide deny "Branch protection is changed by the user on GitHub."
fi
if matches_unquoted "gh auth token${end}"; then
  decide deny "The GitHub token must not be printed."
fi
if matches_unquoted "${home}/\.npmrc"; then
  decide deny "~/.npmrc holds registry tokens and must not be read."
fi

if matches "${git}push${end}"; then
  decide ask "Every push needs the user's approval."
fi
if matches_unquoted "gh pr merge${end}"; then
  decide ask "Merging a pull request needs the user's approval."
fi
if matches "${git}reset${args} --hard${end}"; then
  decide ask "Discarding work needs the user's approval."
fi
if matches "${git}branch${args} -D${end}"; then
  decide ask "Deleting a branch needs the user's approval."
fi
