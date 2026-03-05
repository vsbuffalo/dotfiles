---
description: "Stage and commit changes with a clear message"
---

Follow these steps:

1. Run `git diff --staged --name-only` to check for already-staged files.
2. If nothing is staged, run `git status --porcelain` and `git diff` to understand all changes.
   - **Propose** which files to stage based on what looks like a coherent, related changeset — exclude files that seem unrelated, are runtime artifacts, or look like they don't belong in the repo.
   - If you're **unsure** whether a file belongs in this commit (e.g. unrelated change, generated file, lock file update), **ask** before including it.
   - Present your recommendation like:

     > I'd stage these files:
     > - file1 (reason)
     > - file2 (reason)
     >
     > Skipping: file3 (reason), file4 (reason)

   - **Watch out for files that should never be committed:** .env files, credentials, API keys, tokens, private keys, secrets in config files. If you spot any, call them out with a warning and exclude them from the proposal.
   - Wait for confirmation before staging. **Never use `git add -A` or `git add .`** — always add specific files by name.
3. Once files are staged, run `git diff --staged` and `git log -5 --pretty=%B` to understand the changes and recent commit style.
4. Write a commit message using **Conventional Commits** format:
   - Type: feat, fix, refactor, docs, test, chore, perf, build, ci
   - Scope: from the primary directory or module changed (omit if too diverse)
   - Subject: lowercase, imperative mood, ≤72 chars, no period
   - Body: 1-3 lines on *why*
   - Add `!` and a `BREAKING CHANGE:` footer if public APIs/schemas/CLI changed incompatibly

   **Style A (default):** flat bullet list after the body.
   ```
   feat(scope): subject line here

   Why this change was made in 1-3 lines.

   Highlights:
   - Verb-led bullet for significant change
   - Another bullet
   ```

   **Style B:** use when the project's CLAUDE.md specifies Style B, or when a commit has a clear mix of user-visible and internal changes. Categorize bullets so it's easy to see what needs verification.
   ```
   feat(scope): subject line here

   Why this change was made in 1-3 lines.

   User-facing:
   - Change the user should test/verify
   - Another visible change

   Internal:
   - Plumbing, refactor, or infra change
   - Another internal change

   Fixes:
   - Bug fix that was resolved (include if applicable)
   ```
   Omit any empty section. "Fixes:" is optional — only include when there are actual bug fixes.

5. Never include Co-authored-by, Signed-off-by, or any AI attribution in the message.
6. Show me the proposed commit message and wait for approval before committing.
7. Commit using a HEREDOC: `git commit -m "$(cat <<'EOF' ... EOF)"`
