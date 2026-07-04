# Record substantive TDD design dialogue automatically, as the session proceeds

When the session contains substantive dialogue about the project's TDD approach — definitions, decisions, forks taken or rejected, methods, reasoning, the results of running a method — record it without being asked, as the conversation proceeds. Do not wait for a "record this" instruction; the recording is automatic.

Two destinations, used together:
- **The running digest** — append each substantive TDD exchange to the TDD dialogue digest observation (`agent/observations/…-tdd-dialogue-digest.md`), preserving the *flow and reasoning* (why a fork was taken), not just conclusions.
- **Discrete artifacts** — when an exchange yields a binding convention, a working hypothesis, or a decision, also create the appropriate discrete file: a rule (`agent/rules/`), an observation (`agent/observations/`), and/or a one-line decision-log entry (`agent/log/`), per the existing conventions.

**Why:** The TDD dialogue is too valuable to lose, and conclusions alone omit the reasoning that produced them — the reasoning is often the more valuable part. Recording it automatically removes the dependence on remembering to ask, and keeps the record complete rather than sampled. The harness cannot do this semantically via a settings.json hook (hooks run shell commands and cannot distill dialogue), so the agent does it as a standing practice.

**How to apply:** After each substantive TDD design exchange, append a dated entry to the digest observation and create/update discrete artifacts as warranted — proactively, in the same turn, before moving on. Keep the digest scannable: short entries that capture the reasoning and point to the discrete files for detail. Trivial mechanics (typo-level edits, restating settled points) do not need recording. Related: the observations convention (`agent/observations/`), the decision-log convention (`agent/log/`), and the TDD rule set.
