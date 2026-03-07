"""Extract (commit, file) tuples with line counts and category classification."""

import json
import re
import subprocess
import sys


def load_schema(path):
    with open(path) as f:
        schema = json.load(f)
    # build ordered list of (category, patterns) for matching
    rules = []
    for cat, info in schema["categories"].items():
        rules.append((cat, info["path_patterns"]))
    # exclude patterns
    excludes = schema.get("exclude", {}).get("path_patterns", [])
    return rules, excludes


def is_excluded(filepath, excludes):
    for pat in excludes:
        if pat in filepath:
            return True
    return False


def classify(filepath, rules):
    for cat, patterns in rules:
        for pat in patterns:
            if filepath.startswith(pat) or filepath == pat:
                return cat
    return "other"


def extract_repo(repo_path, repo_label, rules, excludes):
    """Run git log --numstat and parse into (commit, file) rows."""
    result = subprocess.run(
        ["git", "-C", repo_path, "log", "--numstat",
         "--format=COMMIT\t%h\t%aI\t%s", "--all"],
        capture_output=True, text=True,
    )

    rows = []
    excluded_count = 0
    current = None

    for line in result.stdout.splitlines():
        if line.startswith("COMMIT\t"):
            parts = line.split("\t", 3)
            current = {"hash": parts[1], "date": parts[2]}
        elif line.strip() and current:
            parts = line.split("\t", 2)
            if len(parts) == 3:
                added_str, removed_str, filepath = parts
                # binary files show as "-"
                added = int(added_str) if added_str != "-" else 0
                removed = int(removed_str) if removed_str != "-" else 0
                # handle renames: "path/{old => new}/rest" or "old => new"
                clean_path = resolve_rename(filepath)
                if is_excluded(clean_path, excludes):
                    excluded_count += 1
                    continue
                category = classify(clean_path, rules)
                rows.append({
                    "hash": current["hash"],
                    "date": current["date"],
                    "repo": repo_label,
                    "file": clean_path,
                    "added": added,
                    "removed": removed,
                    "category": category,
                })

    if excluded_count:
        print(f"  {repo_label}: excluded {excluded_count} vendor file entries")

    return rows


def resolve_rename(filepath):
    """Resolve git's rename syntax to the destination path.

    Handles:
      - "old => new"
      - "path/{old => new}/rest"
    """
    # bracketed rename: "path/{old => new}/rest"
    m = re.search(r'\{(.+?) => (.+?)\}', filepath)
    if m:
        prefix = filepath[:m.start()]
        suffix = filepath[m.end():]
        return prefix + m.group(2) + suffix

    # simple rename: "old => new"
    if " => " in filepath:
        return filepath.split(" => ")[1].strip()

    return filepath


def main():
    schema_path = sys.argv[1]
    current_repo = sys.argv[2]
    archived_repo = sys.argv[3]
    out_path = sys.argv[4]

    rules, excludes = load_schema(schema_path)

    rows = []
    rows.extend(extract_repo(archived_repo, "archived", rules, excludes))
    rows.extend(extract_repo(current_repo, "current", rules, excludes))

    # sort by date
    rows.sort(key=lambda r: r["date"])

    with open(out_path, "w") as f:
        f.write("hash,date,repo,file,added,removed,category\n")
        for r in rows:
            # quote file path in case of commas (unlikely but safe)
            f.write(f'{r["hash"]},{r["date"]},{r["repo"]},"{r["file"]}",{r["added"]},{r["removed"]},{r["category"]}\n')

    print(f"wrote {len(rows)} rows to {out_path}")


if __name__ == "__main__":
    main()
