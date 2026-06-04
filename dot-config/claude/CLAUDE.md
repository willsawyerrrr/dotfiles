# Global Instructions

- Be extremely concise in all responses. No filler, no padding, no trailing summaries.
- Responses are read by a human, not piped to another tool. Bullets and headings aid scannability — keep them. Tighten _within_ each bullet: short clauses, no preamble, no restating the question, no closing summary.
- Commit messages follow Conventional Commits, with the first word after the type capitalised. Example: `feat: Add new thing` (not `fix: add new thing`).
- Branch names use a Conventional Commits type as a prefix followed by `/` (e.g. `feat/add-new-thing`).
- Always use subagents (Agent tool) when a task would benefit — broad exploration (>3 queries), independent parallel work, planning, or anything matching a specialized agent. Launch independent agents in a single message for concurrency.
- The home directory `~` and the dotfiles repo `~/dotfiles` are both the user-scope "project". When I mention user scope while working in either, I mean global config that applies to me as a user, not to a specific repo (e.g., `${XDG_CONFIG_HOME}/claude/CLAUDE.md`, `${XDG_CONFIG_HOME}/claude/settings.json`, or their dotfiles sources under `dot-config/`). Treat anything global-sounding in the dotfiles repo as user scope, even though the working directory looks like a regular project. Neither is a regular project repo for the purposes of "user scope".
- Prefer `${XDG_CONFIG_HOME}/claude/CLAUDE.md` over auto-memory for global configuration and persistent preferences — it is tracked in dotfiles.
- Address all minor concerns (nits, polish, small cleanups) before shipping rather than deferring them to follow-ups. Don't hesitate to block on nits — surfacing them is wanted, not unwelcome.
- After making code changes, run the project's pre-commit hooks (e.g. `pre-commit run --files <changed>` or the project's equivalent) to verify formatting and linting before reporting the task complete.
- Pushing branches and managing PRs are auto-allowed in settings, but treat them as requiring explicit confirmation in conversation — only push or open a PR after we have discussed and agreed to it in the current turn. The permission removal is for friction, not blanket authorisation.
- When creating a Notion document, always put the session UUID, project name, and (if set) session name in the header so I can navigate back to the originating Claude session when reviewing the doc later.

## Workflows

### Requesting PR review

When I ask to "request PR review" (or similar), post a Slack message to `#eng-scribe` via the Slack MCP (`slack_send_message`) with this format:

```
<PR URL>
PR title
[Linear issue title hyperlinked to issue]   (only if a Linear issue exists)
@reviewer ...
```

Lines, in order:

1. Bare PR URL (so Slack unfurls it).
2. PR title as plain text.
3. (Optional) Linear issue title hyperlinked to the issue — only if one is linked.
4. Reviewer mentions.
