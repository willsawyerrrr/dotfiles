# CLAUDE.md

Shared conventions across willsawyerrrr.dev projects.

## Repo layout

Each repo is a bare + per-branch-worktree layout (`.bare` plus a worktree per
branch); `main` stays checked out in `main/`. Every piece of work happens in
its own dedicated worktree named after its branch, keeping parallel work from
colliding on git state.

## Workflow

- Feature work on branches → PRs; keep `main` releasable.
- One feature per pull request. Each distinct change ships in its own branch
  and PR, even when several are requested in quick succession. Never bundle
  two unrelated changes together just because one was asked for while another
  was already in motion — open a separate branch and PR for a request that
  arrives mid-flight rather than folding it into work in progress.
- PR titles are user-facing copy: keep the Conventional Commit `type(scope):`
  prefix, but phrase the description for someone using the app, not for an
  implementer, and make it read as a self-contained sentence.
- Merge PRs via GitHub auto-merge (`gh pr merge --auto`), not by polling for
  CI to go green. Enable it once the PR is open; GitHub merges the moment the
  required checks pass.
- Keep documentation in sync with the code. When a change alters behaviour,
  scope, or a workflow, update the affected docs (`docs/` and the project's
  `CLAUDE.md`) as part of the same change, so `main` is never merged with
  stale docs.
- Every repo's CI defines one aggregate job named `CI Status` that `needs`
  every other job (`if: always()`, failing if any dependency failed or was
  cancelled). Every repo guards `main` with a repository ruleset (never classic
  branch protection) that requires a pull request (no approvals needed, squash
  merges only) and only the `CI Status` check, blocks force pushes and
  deletion, and lets the repository admin role bypass.
- Every project runs the same runtime major in CI, local development and
  production. Production (the host's newest supported runtime, e.g. Vercel's
  Node) sets the version; pin it everywhere (`.nvmrc`, `engines`, CI
  `setup-node`, type packages) and configure Dependabot to ignore majors
  beyond it.
- Track every change in Linear, including repo-settings changes (rulesets,
  branch protection, merge settings) that need no branch or PR: file the
  issue, record what was changed in its description, and mark it Done.
- Claude drives everything in these repos — code, docs, CI, config — and owns
  the git and PR lifecycle autonomously: branching, committing, pushing, and
  opening, updating, and merging pull requests, all without per-turn
  confirmation.
- A defect or gap found along the way gets fixed, not raised as a question.
  Never park it as an optional follow-up for someone to approve: open its own
  branch and PR for it and say what was done. Report findings — the reasoning
  behind a decision, a trade-off taken, something deliberately left alone and
  why — but report them as work already in hand, not as a menu. Ask only
  where the answer is genuinely the user's to give and no default is
  defensible: what the app should do, which of several valid behaviours is
  wanted, or an outward-facing act with consequences beyond the repo.
- Delegate work to subagents rather than doing it inline, reserving the main
  thread for orchestration and conversation. Launch independent subagents
  concurrently.
- Track all work in Linear. Before starting, find or create the issue in the
  project's Linear project; keep its status current (In Progress → In Review
  → Done) and attach the PRs. Work found along the way gets its own issue.
  Dependabot pull requests are the exception: they need no Linear issue.
- Prefix each subagent's name with the ID of the Linear issue it's working
  on, e.g. `WSD-123: <description>`.

## Portfolio

- The public portfolio is `willsawyerrrr.dev`, served by the `dashboard`
  project; there is no separate portfolio repo.
- To list a project, add the `portfolio` topic to its GitHub repository
  (`gh repo edit willsawyerrrr/<repo> --add-topic portfolio`). It appears
  within an hour.
- The page shows a project only when it has a public link: its live app if
  public, else its GitHub repository if public. A private repo with a public
  live app shows the app link and nothing else.
- Display names are always title case (`Phone Claude`, `Loopr`). To override
  the derived name, description or icon, add an entry to `projects` in
  `dashboard`'s `src/data/links.ts`; a private repo needs a description there.
- Project icons live in `dashboard`'s `public/project-icons/`.

## Bundle IDs

- All bundle IDs are `dev.willsawyerrrr.<kebab-cased-application-name>` — never
  `concatenatedapplicationname` or `CapitalisedApplicationName`.

## iOS export compliance

- Every iOS app deployed to App Store Connect must declare its export
  encryption configuration in its `Info.plist`: set
  `ITSAppUsesNonExemptEncryption` to `false` when the app uses only exempt
  encryption (e.g. HTTPS), so builds skip the manual export-compliance prompt.

## App Store Connect listing icon

- An app's App Store Connect listing shows a placeholder icon until a build is
  attached to its version (App Store → the iOS version → Build). It then uses
  that build's icon; there is no separate icon upload.

## Credentials

- Third-party service credentials are often stored in `~/willsawyerrrr.dev/.env`.
  If a credential isn't in a project's own `.env`, check there.

## 1Password Environments

- Local development loads secrets from 1Password Environments via
  `op run --environment <id> -- <command>`, not from a `.env` file. Environment
  IDs are not secrets.
- Each project has its own Environment. Reusable Environments hold secrets
  shared across projects (e.g. Apple Development, a general-purpose one); add a
  new one whenever several projects need the same secrets.
- Pass `--environment` once per Environment to combine them; variables merge
  and, on a name clash, the last one wins, so list the shared Environment
  before the project's.

### Shared Environments

| Environment       | ID                         | Holds                                                                                          |
| ----------------- | -------------------------- | ---------------------------------------------------------------------------------------------- |
| Apple Development | b5zkkwxuutlttwbrv5xhgojye4 | Apple team ID, App Store Connect key, Developer ID certificate, notarisation key               |
| Shared            | 3i642eynjpsx2uctyqlexobgge | Account-level tokens: Supabase, GitHub, Linear, Vapi, Twilio, Recraft, Homebrew tap deploy key |

### Project Environments

| Environment         | ID                         |
| ------------------- | -------------------------- |
| App Intents Factory | d2ddxa6xgvqrxvux52jwkxgamy |
| Chore Tracker       | wjm4duhdh5lbojqz2gn6pqck6q |
| Dashboard           | p4opp3txd6i72uch2gwirp2lbu |
| Homebrew Tap        | tftzukegxqsikrtd7o5cojt66q |
| Loopr               | wukpvhxkhkygbjbpg2jl4urine |
| Nest                | we4tm6dkfoffx42g243qr7ju6m |
| Personal Shopper    | pypsxvgj5p7ioxffch5lil4w5u |
| Phone Claude        | ufudw2eopg5tmebz6ptldpitki |
| Platform            | 3wm7pn2k5bnmyuzqznz33lufp4 |
| Tee Finder          | zphtn46o5nvwlcz3poouqxesfe |
| Tether              | pr4n6btanxalwrgrhgp2xu2h5i |
| Work Use Tracker    | gdfkh3sptrkqouuj37rofcuc3e |

## Deployment

- When deploying a project to Vercel, add the `<app-name>.willsawyerrrr.dev`
  domain to the Vercel project.
