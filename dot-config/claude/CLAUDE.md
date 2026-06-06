# Global Instructions

## Communication & conventions

- Be extremely concise in all responses. No filler, no padding, no trailing summaries.
- Never ask me to run a command you have the tools to run yourself. Only ask when it genuinely requires my hands (interactive auth flows, TTY input the harness can't provide, actions outside the sandbox).
- Don't ask whether to do something I've already documented. If a rule in CLAUDE.md or memory dictates the action, just take it.
- Responses are read by a human, not piped to another tool. Bullets and headings aid scannability — keep them. Tighten _within_ each bullet: short clauses, no preamble, no restating the question, no closing summary.
- Commit messages follow Conventional Commits, with the first word after the type capitalised. Example: `feat: Add new thing` (not `fix: add new thing`).
- Branch names use a Conventional Commits type as a prefix followed by `/` (e.g. `feat/add-new-thing`).

## How to work

- Always use subagents (Agent tool) when a task would benefit — broad exploration (>3 queries), independent parallel work, planning, or anything matching a specialized agent. Launch independent agents in a single message for concurrency.
- Address all minor concerns (nits, polish, small cleanups) before shipping rather than deferring them to follow-ups. Don't hesitate to block on nits — surfacing them is wanted, not unwelcome.
- After making code changes, run the project's pre-commit hooks (e.g. `pre-commit run --files <changed>` or the project's equivalent) to verify formatting and linting before reporting the task complete.
- Pushing branches and managing PRs are auto-allowed in settings, but treat them as requiring explicit confirmation in conversation — only push or open a PR after we have discussed and agreed to it in the current turn. The permission removal is for friction, not blanket authorisation.
- When creating a Notion document, always put the session UUID, project name, and (if set) session name in the header so I can navigate back to the originating Claude session when reviewing the doc later.

## Global config

Anything global (preferences, conventions, workflows that apply across all projects) goes in `${XDG_CONFIG_HOME}/claude/CLAUDE.md`, not auto-memory — it is tracked in dotfiles and syncs across machines.

Working directory `~` is a strong signal that a request is about global config. `~/dotfiles` is a weaker signal — it's a real project with its own `CLAUDE.md` covering repo-management concerns, so requests there are often project-scoped.

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
