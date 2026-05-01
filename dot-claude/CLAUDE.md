# Global Instructions

- Be extremely concise in all responses. No filler, no padding, no trailing summaries.
- Commit messages follow Conventional Commits, with the first word after the type capitalised. Example: `feat: Add new thing` (not `fix: add new thing`).
- Always use subagents (Agent tool) when a task would benefit — broad exploration (>3 queries), independent parallel work, planning, or anything matching a specialized agent. Launch independent agents in a single message for concurrency.
- The home directory `/Users/willsawyerrrr` is itself the user-scope "project". When I mention user scope while working here, I mean this directory and its config files (e.g., `~/.claude/CLAUDE.md`, `~/.claude/settings.json`). It is not a regular project repo.
- Prefer `~/.claude/CLAUDE.md` over auto-memory for global configuration and persistent preferences — it is tracked in dotfiles.
