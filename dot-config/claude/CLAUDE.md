# Global Instructions

## Communication & conventions

- Be extremely concise everywhere — responses, code, and documents alike. No filler, no padding, no trailing summaries; no redundant comments, dead abstractions, or verbose prose.
- Never narrate the instructions or conventions you're following (no "per my working conventions...", "as documented...", etc.). Just follow them silently and do the work.
- Never ask me to run a command you have the tools to run yourself — including `aws sso login`, which generally completes without my intervention. Only ask when a command genuinely cannot run without me (e.g. TTY input the harness can't provide).
- Don't ask whether to do something I've already documented. If a rule in CLAUDE.md or memory dictates the action, just take it.
- Responses are read by a human, not piped to another tool. Bullets and headings aid scannability — keep them. Tighten _within_ each bullet: short clauses, no preamble, no restating the question, no closing summary.
- Commit messages follow Conventional Commits, with the first word after the type capitalised. Example: `feat: Add new thing` (not `fix: add new thing`).
- Branch names use a Conventional Commits type as a prefix followed by `/` (e.g. `feat/add-new-thing`).
- Never include Linear issue IDs in code (e.g. comments, identifiers, strings). They belong in commit messages, branch names, and PR/Slack metadata, not in the code itself.
- Convey Linear issue metadata (status, assignee, priority, estimate, labels, project, cycle, relations, etc.) through Linear's native issue attributes — never in the issue description. The description is for the substance of the issue only.
- In code (docstrings, comments), inline code spans use single backticks, never double.
- A method's behaviour belongs in that method's own docstring, not in its class's docstring. Class docstrings describe the class; keep per-method detail on the method.
- Never title a commit as "address review" or similar. A change addressing PR review feedback must be committed as though its purpose stands on its own, independent of the review — structure and message it exactly as you would have if you'd decided to make it unprompted. If it's worth making, it's worth describing on its own terms.
- Never include historical or evolution framing in code, docs, commit messages, or PR descriptions — no "now", "no longer", "previously", "used to", "instead of the old…", or comparisons to a prior approach. Describe only the current state, as though it had always been so.

## How to work

- Always use subagents (Agent tool) when a task would benefit — broad exploration (>3 queries), independent parallel work, planning, or anything matching a specialized agent. Launch independent agents in a single message for concurrency.
- Address all minor concerns (nits, polish, small cleanups) before shipping rather than deferring them to follow-ups. Don't hesitate to block on nits — surfacing them is wanted, not unwelcome.
- After making code changes, run the project's pre-commit hooks (e.g. `pre-commit run --files <changed>` or the project's equivalent) to verify formatting and linting before reporting the task complete.
- Commit completed work by default — don't wait to be asked. Only hold off on *pushing* when you're genuinely unsure it's ready. When a PR is already under review, add a new commit rather than folding or amending into reviewed commits, so the review history stays intact.
- Pushing branches and managing PRs are auto-allowed in settings, but treat them as requiring explicit confirmation in conversation — only push or open a PR after we have discussed and agreed to it in the current turn. The permission removal is for friction, not blanket authorisation.
- Always name worktrees after their branches.
- When creating a Notion document, always put the session UUID, project name, and (if set) session name in the header so I can navigate back to the originating Claude session when reviewing the doc later.
- Avoid the `-f` flag on `rm` — it suppresses my review and slows me down. Default to plain `rm` (or `rm -r`); only use `-f` where it's genuinely necessary.
- Never reply to comments (PR/issue/review, Notion, etc.) — I handle all comment replies myself. Do the underlying work and report what changed in-chat. Exception: an explicit per-instance instruction to post a specific message (e.g. "tag X and say re-review") — then post only that exact message.
- Before the first push of a branch or opening a PR, rebase onto the latest `main` and push an up-to-date version. Once a PR is already open, accept falling behind `main` — don't rebase + force-push, because rewriting history makes the PR harder to review.
- When history genuinely is being rewritten — resolving conflicts, an intended rebase, amend, or squash — force-push it (use `--force-with-lease`). The "don't force-push" rule above only protects an already-open PR that has merely fallen behind `main`.
- If git signing or a push fails because the SSH agent is unreachable or refusing ("agent refused operation", "communication with agent failed", "Permission denied (publickey)"), stop and notify me on my phone (via a push notification) to unlock my machine, then wait — never fall back to `--no-gpg-sign` or retry blindly. Commits must be signed (`commit.gpgsign=true`, SSH key).

## Global config

Anything global (preferences, conventions, workflows that apply across all projects) goes in `${XDG_CONFIG_HOME}/claude/CLAUDE.md`, not auto-memory — it is tracked in dotfiles and syncs across machines.

Working directory `~` is a strong signal that a request is about global config. `~/dotfiles` is a weaker signal — it's a real project with its own `CLAUDE.md` covering repo-management concerns, so requests there are often project-scoped.

