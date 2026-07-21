# Heidi Instructions

Scoped to Heidi work under `~/heidi`. The global conventions in `~/.config/claude/CLAUDE.md` still apply.

## Pushing & PRs

- Pushing branches and managing PRs are auto-allowed in settings, but treat them as requiring explicit confirmation in conversation — only push or open a PR after we have discussed and agreed to it in the current turn. The permission removal is for friction, not blanket authorisation.

## Linear

- Never include Linear issue IDs in code (e.g. comments, identifiers, strings). They belong in commit messages, branch names, and PR/Slack metadata, not in the code itself.
- Convey Linear issue metadata (status, assignee, priority, estimate, labels, project, cycle, relations, etc.) through Linear's native issue attributes — never in the issue description. The description is for the substance of the issue only.

## Notion

- When creating a Notion document, always put the session UUID, project name, and (if set) session name in the header so I can navigate back to the originating Claude session when reviewing the doc later.

## Requesting PR review

When I ask to "request PR review" (or similar), post a Slack message to `#eng-scribe` via the Slack MCP (`slack_send_message`) with this format. Note `#eng-scribe` is a **private** channel, so search with `channel_types: "public_channel,private_channel"`.

**Each element must be separated by a BLANK line (double `\n`), not a single newline.** The Slack MCP renders standard markdown, where a single newline is a soft-wrap (collapses to a space) — so `<PR URL>\nPR title` renders as the title jammed onto the URL line. Put an empty line between every element so each lands on its own line:

```
<PR URL>

PR title

[SCR-XXXX: Issue title hyperlinked to issue]   (only if a Linear issue exists)

@reviewer
```

Elements, in order:

1. Bare PR URL (so Slack unfurls it).
2. PR title as plain text.
3. (Optional) Linear issue hyperlinked to the issue — only if one is linked. The link text must include the issue ID prefix, formatted `SCR-XXXX: Issue title`.
4. Reviewer mentions.

## Hubert (AI code review)

Hubert is Heidi's AI code reviewer — "the code surgeon" — running as a GitHub app on pull requests. It's defined in the `token-factory` repo and configured per-repository via the `.token-factory` directory at that repo's root (this is where PR size limits, code-owner scoping, etc. live).

Whenever you're driving a PR, keep an eye out for Hubert's review. Hubert auto-reviews every opened PR. Hubert is another agent, and communicating with him is your job — he is **the only actor whose comments you respond to**. The rule against replying to humans still holds; leave human conversations to me.

When Hubert reviews:

1. Evaluate every comment on its merits.
2. Address the reasonable ones; for those you can't justify, push back **politely and gently** rather than complying.
3. Respond to each comment and resolve it — both the ones you addressed and the ones you pushed back on.
4. Once all comments are handled, re-request review with a **new top-level comment tagging Hubert** and asking for another pass.

**Aiming for auto-approval.** On small tasks — especially chores — deliberately aim for Hubert's auto-approval. Two conditions:

- Work only in directories we own as code owners.
- Stay within the PR size restrictions (configured per project in `dot-token-factory`).

**Hubert-driven development (HDD).** Landing a large-scale change as a series of small PRs, each deliberately sized to fit Hubert's size constraints, so the whole thing gets auto-approved in small, safe slices.
