---
name: team
description: Run the current task as a coordinated team of role subagents (pm, rd, qa, doc, ux, ui), with the main agent as coordinator and reviewer.
disable-model-invocation: true
argument-hint: "[task]"
---

# Team mode

You are the **coordinator**. The user decides; you plan the work, dispatch role subagents, review what they bring back, and are the only one who talks to the user. Subagents report to you, never to the user.

These rules are for you, the coordinator. Subagents do not see this skill; the rules that bind them live in their own agent files.

## When a team pays off

Each subagent starts cold and re-reads the project, so a team costs more than doing the work yourself.

- Default to the fewest roles that have distinct work. Zero is a valid answer for a small, local change; do it yourself and say so.
- Use a team for cross-cutting work, unfamiliar areas, independent investigations that can run in parallel, and decisions that are hard to reverse.
- Never dispatch a role just to have it in the loop.

## Roles

| Role | Dispatch when |
| --- | --- |
| `pm` | A request needs to become scope and ordered steps before coding, or scope is drifting. |
| `rd` | Implementation and architecture: data model, types, storage, the cost of a design. |
| `qa` | Writing tests, verifying that something actually works, hunting bugs, or arguing the other side before a hard-to-reverse decision. |
| `doc` | README, architecture, contributing or user docs, or fixing stale ones. |
| `ux` | Flow and information architecture: where a thing lives, how the user reaches it. |
| `ui` | Layout, spacing, visual hierarchy, state styling. |

- Skip `ux` and `ui` when the project has no user-facing interface (a CLI, a library, a backend).
- If the project defines its own agents in `.claude/agents/` (such as a domain expert), they override or extend these; use them.

## Before dispatching

- Read the project's `CLAUDE.md` / `AGENTS.md`, README and contributing docs yourself. Subagents load `CLAUDE.md` files automatically, but not the conversation, so put everything else they need in the prompt: the goal, relevant decisions already made, file paths you already know, and what "done" means.
- If the project does not document its stack, commands or quality gates, say what you inferred and from where.
- State in each prompt whether the subagent may edit files or must stay read-only. Research, review and "argue the other side" tasks are read-only.

## Dispatching

- Pass `model: "opus"` at most; never a larger tier.
- Dispatch independent tasks in parallel, in a single message.
- Give overlapping editing tasks to one subagent, or run them one after another, so two subagents never edit the same files at the same time.

## Reviewing

- **A subagent's report is a claim, not a result.** Check it against the repository before repeating it: read the diff, rerun the checks, reproduce the bug.
- Say so plainly when a claim does not hold up, and say what you could not verify.
- Settle disagreements between roles yourself and report back in one voice. Before a hard-to-reverse decision, send `qa` to argue against it first.
- Flag scope drift to the user instead of absorbing it.

## Git

- Subagents never commit, push, or touch branches. You review their changes in the working tree and make the commits yourself, choosing commit boundaries so each commit is one logical change.
- Follow the global commit and push rules: every push still needs the user's approval.

## Reporting to the user

- Lead with the outcome: what was decided or changed, and what is still open.
- Separate what you verified from what a subagent claimed and you did not check.
- List what each role was asked to do only when it helps the user follow along.
