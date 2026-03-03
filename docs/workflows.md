# Dev Workflows

Patterns and recipes for day-to-day development.

## Git Worktrees

Worktrees let you check out multiple branches simultaneously without stashing
or switching. Each worktree is a separate directory backed by the same `.git`.

```bash
# Create a worktree for a feature branch
git worktree add ../my-feature feature-branch

# Create a worktree with a new branch
git worktree add -b fix/bug ../fix-bug main

# List active worktrees
git worktree list

# Remove when done (delete the directory first or use --force)
git worktree remove ../my-feature
```

**When to use**: parallel reviews, testing a fix without losing context,
running two branches side-by-side.

**Cleanup**: stale worktrees (deleted directories) can be pruned with
`git worktree prune`.

### Never push to main from a worktree

Each worktree has its own branch ref. Pushing `worktree-branch:main` from
a worktree updates the remote, but your local `main` in the main checkout
doesn't move. Other worktrees can't see the change either. This leads to
invisible divergence and confused history.

**Instead — funnel everything through the main checkout.**

### Aliases (in `.gitconfig`)

| Alias | Expands to | What it does |
|-------|-----------|--------------|
| `git wt` | `worktree list` | Show all worktrees |
| `git wta <name>` | `worktree add -b <name> ../<name> main` | Create a worktree + branch off main |
| `git wtrm <path>` | `worktree remove <path>` | Remove a worktree |
| `git land <branch>` | `rebase main <branch> && checkout main && merge --ff-only <branch>` | Rebase branch onto main, then fast-forward main to match |

### The flow

```bash
# 1. Create a worktree (from the main checkout)
git wta fix-thing            # creates ../fix-thing on branch fix-thing

# 2. Work there, commit on its branch
cd ../fix-thing
git add -p && git commit

# 3. Back in the main checkout, update main
cd /path/to/project
git pull                     # pull.rebase=true, so this is fetch + rebase

# 4. Land the branch
git land fix-thing           # rebases fix-thing onto main, then ff-merges
git push

# 5. Clean up
git wtrm ../fix-thing
git branch -d fix-thing
```

### What `git land` does under the hood

```
git rebase main fix-thing
```
Syntax: `git rebase <onto> <branch>` — reads as "replay fix-thing's
commits onto main." The first arg is the destination, the second is what
moves. After this, fix-thing sits directly on top of main.

```
git checkout main
git merge --ff-only fix-thing
```
Since fix-thing is now directly ahead of main, main just slides its
pointer forward — no merge commit, no diamond in the graph. That slide
is called a "fast-forward." `--ff-only` is a safety net: it refuses if
main diverged (meaning the rebase didn't work or something else landed
in between).

> **Note**: `pull.rebase = true` is set globally in `.gitconfig`, so
> `git pull` on main already rebases onto `origin/main`.

**Rule**: `main` is only ever touched from one place — the main checkout.
Worktree branches stay on their own branches until you're ready to integrate.

## Claude Code Agents

Claude Code can spawn sub-agents for parallel or isolated work. Two ways
to use them:

### In-session worktree agent

Use `/worktree` (or the `EnterWorktree` tool) to isolate work in a
throwaway branch. Claude creates a worktree under `.claude/worktrees/`,
does the work there, and prompts you to keep or discard on exit.

### Background agents (via `Agent` tool)

Claude can launch sub-agents that run in the background with
`run_in_background: true`. Useful for:

- Running tests while continuing to code
- Parallel research across multiple files
- Isolated exploration that won't pollute the main context

### Agent types

| Type | Use for |
|------|---------|
| `Explore` | Codebase search and understanding |
| `Plan` | Designing implementation before writing code |
| `general-purpose` | Multi-step tasks, broad research |

## Branching Conventions

_Add your preferred branching patterns here._

## PR Workflow

_Add your PR creation and review workflow here._
