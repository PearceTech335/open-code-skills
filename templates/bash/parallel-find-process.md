---
name: parallel-find-process
language: bash
tags: [bash, find, parallel, xargs, process, file-walking]
use-case: Find files matching a pattern and process them in parallel
created: 2026-07-31
---

## Description

Walks a directory tree for files matching a pattern, then processes them
in parallel with xargs. Handles special characters in filenames safely.

## Usage

Call `./process-files.sh /path/to/search "*.log" "./analyze.sh"`.

## Code

```bash
#!/usr/bin/env bash
set -euo pipefail

search_root="${1:?usage: $0 <root> <pattern> <command>}"
pattern="${2:?}"
command="${3:?}"

if [[ ! -d "$search_root" ]]; then
    echo "error: directory '$search_root' not found" >&2
    exit 1
fi

find "$search_root" -type f -name "$pattern" -print0 \
    | xargs -0 -P "$(nproc)" -I {} "$command" "{}"
```

## Notes

- `-P "$(nproc)"` runs one process per CPU core. Adjust as needed.
- `-print0` / `-0` pair handles filenames with spaces, newlines.
- Add `trap 'kill 0' EXIT` if foreground tasks need cleanup on interrupt.
