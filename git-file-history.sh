#!/usr/bin/env bash
set -euo pipefail

git ls-files | while read -r f; do
  printf '%s\t%s\n' "$(git log -1 --format='%ai%x09%h' -- "$f")" "$f"
done | sort -r
