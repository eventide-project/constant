---
name: Memory files live in the project, not in ~/.claude
description: For this project, memory files must be stored inside the repo at `memory/` so they can be committed to git. Never write memory to the default `~/.claude/projects/.../memory/` location.
type: feedback
---

Memory files for this project live at `<repo>/memory/`, not at the default `~/.claude/projects/-Users-sbellware-projects-eventide-constant/memory/`.

**Why:** Files in `~/.claude` cannot be committed to the project's git repo. The user wants memory committed alongside the code so it travels with the repo and is shared across machines/collaborators. (Note: `.claude/` inside the repo is gitignored, so don't fall back to that either — use a top-level `memory/` directory.)

**How to apply:** When saving any memory for this project, write to `/Users/sbellware/projects/eventide/constant/memory/<name>.md` and update `/Users/sbellware/projects/eventide/constant/memory/MEMORY.md`. Do not create or write anything under `~/.claude/projects/-Users-sbellware-projects-eventide-constant/memory/`. At session start, check the in-repo `memory/` directory for `MEMORY.md` and existing entries.
