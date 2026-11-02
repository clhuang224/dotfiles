PR title guideline: prefer `<type>: <short summary>` or `<type>(<scope>): <short summary>`, such as `feat(claude): add a /team skill`.

## Related

Use `Closes #...`, `Fixes #...`, or `Part of #...` as needed.

- Part of #

## Summary

Describe what the agents will do differently after this PR, and why.

## What Changed

-

## Validation

List the checks you ran for this PR. If something was intentionally not run, note that here with a short reason.

- [ ] The three instruction files (`claude/CLAUDE.md`, `codex/AGENTS.md`, `copilot/global.instructions.md`) change together, or the change is tool-specific
- [ ] The command guardrails block and ask about the same commands in every tool, and README.md lists them
- [ ] Each symlink in README.md points at its file in this repo
- [ ] Tried the changed behavior in the affected tool

## Scope Notes

Call out anything intentionally left out of this PR, tools not covered yet, or setup each machine still needs.

## Reviewer Notes

Share the most important review context, tradeoffs, or files that deserve extra attention.
