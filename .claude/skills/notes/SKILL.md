---
name: notes
description: "Lab notebook — capture analysis results, benchmarks, and findings into notes/"
argument-hint: "[topic, or 'list', or 'update <title>']"
disable-model-invocation: true
---

# Lab Notebook

Capture analysis results, benchmarks, and findings from the current conversation into a structured markdown note in `notes/`.

## Routing

Parse `$ARGUMENTS` to determine the action:

- **`list`** → go to [List Notes](#list-notes)
- **`update <rough title>`** → go to [Update Existing Note](#update-existing-note)
- **Anything else** (including empty) → go to [Create Note](#create-note)

---

## Create Note

1. Review the full conversation context for: analysis results, benchmarks, numbers, commands run, methodology, findings, conclusions, code snippets, and error messages.
2. Derive a **short kebab-case title** (2-5 words, no filler words like "the", "a", "some") from `$ARGUMENTS` or, if empty, from the conversation context.
3. Generate the filename: `notes/<short-title>-YYYY-MM-DD.md` using today's date.
4. If a file with that exact name already exists, append a numeric suffix: `-2`, `-3`, etc.
5. Create the `notes/` directory (and any subdirectory) if it doesn't exist using `mkdir -p`.
6. If `$ARGUMENTS` mentions a subdirectory (e.g., "put this in perf", "under benchmarks"), **propose** a directory name like `notes/perf/` and confirm with the user before writing.
7. Write the note following the [Note Format](#note-format) below.
8. After writing, show the user:
   - The file path created
   - A 1-2 sentence summary of what was captured

### What to capture

- **Actual numbers and data** — not summaries. If the conversation has benchmark results like "p50: 12ms, p99: 45ms", include those exact numbers.
- **Commands that were run** — in fenced code blocks.
- **Code snippets** that are relevant to the findings.
- **Tables** for structured data (benchmark comparisons, before/after, etc.).
- **Error messages or stack traces** if they were part of the investigation.

If `$ARGUMENTS` is empty, use recent conversation context to determine both the topic and content. Prefer capturing the most recent substantial analysis or investigation.

---

## List Notes

1. Use Glob to find all `notes/**/*.md` files.
2. For each file, read the first line to extract the `# Title` heading.
3. Extract the date from the filename (the `YYYY-MM-DD` portion).
4. Display as a markdown table:

```
| File | Title | Date |
|------|-------|------|
| notes/benchmark-results-2026-02-21.md | Benchmark Results | 2026-02-21 |
```

5. If notes exist in subdirectories, group by subdirectory with a heading for each group.
6. If no notes exist, say so and suggest creating one.

---

## Update Existing Note

1. Glob for all `notes/**/*.md` files.
2. Fuzzy-match `<rough title>` from `$ARGUMENTS` against:
   - Filenames (ignoring date suffix and `.md` extension)
   - The `# Title` heading inside each file
3. **If exactly one match**: proceed to append.
4. **If multiple matches**: show the candidates as a numbered list and ask the user to pick one.
5. **If no match**: warn the user that no matching note was found, and offer to create a new one instead.
6. Read the matched file, then **append** new content at the end with today's date as a section marker:

```markdown

## Results *YYYY-MM-DD*

<new findings, benchmarks, data from the current conversation>
```

7. Only include section headings (Method, Results, Observations) that have new content to add. Don't add empty sections.
8. The `*date*` italic tag marks when the update was added. The original filename date stays unchanged.
9. After appending, show the user what was added and to which file.

---

## Note Format

Write notes in this format — no YAML frontmatter:

```markdown
# Descriptive Title

**Date**: YYYY-MM-DD
**Context**: <one-line description of what was being investigated and why>

## Method

<commands run, tools used, approach taken — with fenced code blocks for commands>

## Results

<concrete numbers, benchmarks, data — use tables where appropriate>

## Observations

<patterns noticed, surprises, interpretations, next steps if any>
```

### Format rules

- The title should be descriptive and specific (e.g., "Redis Cache Hit Rates Under Load" not "Cache Test").
- The **Date** and **Context** lines serve as lightweight metadata — easy to grep.
- Use fenced code blocks for commands and outputs.
- Use markdown tables for structured/comparative data.
- Include all relevant numbers from the conversation — this is a lab notebook, not an executive summary.
- Omit sections that have no content (e.g., skip Observations if there's nothing notable to observe).
