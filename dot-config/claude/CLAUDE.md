# Global Instructions

- Be extremely concise in all responses. No filler, no padding, no trailing summaries.
- Commit messages follow Conventional Commits, with the first word after the type capitalised. Example: `feat: Add new thing` (not `fix: add new thing`).
- Always use subagents (Agent tool) when a task would benefit — broad exploration (>3 queries), independent parallel work, planning, or anything matching a specialized agent. Launch independent agents in a single message for concurrency.
- The home directory `/Users/willsawyerrrr` is itself the user-scope "project". When I mention user scope while working here, I mean this directory and its config files (e.g., `${XDG_CONFIG_HOME}/claude/CLAUDE.md`, `${XDG_CONFIG_HOME}/claude/settings.json`). It is not a regular project repo.
- Prefer `${XDG_CONFIG_HOME}/claude/CLAUDE.md` over auto-memory for global configuration and persistent preferences — it is tracked in dotfiles.
- Address all minor concerns (nits, polish, small cleanups) before shipping rather than deferring them to follow-ups. Don't hesitate to block on nits — surfacing them is wanted, not unwelcome.
- After making code changes, run the project's pre-commit hooks (e.g. `pre-commit run --files <changed>` or the project's equivalent) to verify formatting and linting before reporting the task complete.
