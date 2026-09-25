# Global Codex CLI preferences

These apply across all projects for this user, regardless of repo-local `AGENTS.md` files (which add project-specific rules on top, they don't replace these).

## Language

- Use **English** for everything written into a repo: commit messages, PR descriptions, code comments, README, agent instruction files (`AGENTS.md`, `CLAUDE.md`, etc.), and other project docs.
- Use **Traditional Chinese (zh-TW)** only for:
  - Talking to the user (chat replies, questions, summaries).
  - Docs that explicitly target Chinese readers, e.g. `README-zhTW.md`.
- When writing Chinese, follow the [Chinese Copywriting Guidelines](https://github.com/sparanoid/chinese-copywriting-guidelines) — in particular, put a space between Chinese and English words or numbers (盤古之白), e.g. `在 GitHub 上建立 3 個 issue`.

## Commits

- Use **Conventional Commits** format (`feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`, etc.).
- Keep commits **small and atomic** — one logical change per commit. Don't batch unrelated changes into a single commit.
- Keep changes **scoped to the task**. Don't refactor, rename, reformat, or "clean up" unrelated code along the way; if something else looks worth changing, mention it instead.
- When a commit fixes a security alert (e.g. a Dependabot or code scanning alert), the commit message MUST reference the related **GHSA ID** (e.g. `GHSA-xxxx-xxxx-xxxx`). If the GHSA ID is missing or unknown, **ask the user for it before committing** — don't commit without it or make one up.
- Every commit message MUST end with this exact trailer line:

  ```
  Co-authored-by: Codex [model] ([context size]) <noreply@openai.com>
  ```

  If you're not sure of the context size, omit it along with its parentheses (`Co-authored-by: Codex [model] <noreply@openai.com>`). If you're not sure of the model, **ask the user before committing** — don't guess.

## Git

- **Ask before** any hard-to-reverse Git operation: `git push` (especially `--force`), amending or rebasing commits that are already pushed, `git reset --hard`, discarding uncommitted changes, or deleting branches.
- Never skip Git hooks (`--no-verify`) unless the user explicitly asks.

## TypeScript

- Enable **strict mode** (`"strict": true` in `tsconfig.json`) on new TypeScript projects. Don't relax it for convenience.
- When a type is a union of a few string literals, keep the literal values in **English**. If there's a corresponding Chinese display label, handle it through a separate map/lookup (e.g. `Record<Status, string>`) instead of using Chinese text as the literal values themselves.
- Don't use `any`; use `unknown` and narrow it, or write a proper type. If `@ts-ignore` / `@ts-expect-error` is truly needed, add a comment explaining why (prefer `@ts-expect-error`).

## Testing

- Prefer **Vitest** over Jasmine/Karma for new JS/TS projects where there's a choice.

## Angular

- For new Angular projects, default to **standalone components + Signals**, not NgModules.
