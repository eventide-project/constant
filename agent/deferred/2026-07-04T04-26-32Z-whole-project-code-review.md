# Code review of the whole project

Conduct a code review across the entire project — production library code (`lib/`), the test suite (`test/`), controls, and supporting files — not just a single diff. Assess correctness, consistency with the project's own rules and conventions in `agent/rules/`, reuse/simplification/efficiency opportunities, and any drift that accumulated across the many test-first passes that built the `Constant` mixin, `Constant::Module`, and `Constant::Literal`.

**Gated on:** no active feature or task in flight — both implementation plans (`constant-class`, `constant-literal-restructure`) are complete and the deferred queue is otherwise clear, so this can run whenever the developer chooses to spend a session on it.

**Why:** the library reached feature-complete through a long sequence of incremental TDD passes and a coverage audit; a holistic pass over the whole codebase can catch cross-cutting inconsistencies and cleanup that per-diff review could not see.

**How to apply:** review the whole tree (not `git diff`). Surface findings as options for the developer rather than applying changes unilaterally, consistent with the human-in-the-loop methodology rules. Delete this file once the review is done and any resulting work is either completed or itself registered as follow-up items.
