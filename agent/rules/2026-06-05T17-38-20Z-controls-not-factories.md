# Call them "controls", never "factories"

The helpers under `lib/constant/controls/` (e.g. `Controls::Constant`) that build example constants for tests are **controls** — the TestBench term. Always refer to them as "controls." Do not call them a "factory" or "factories," even loosely (e.g. avoid "the test factory", "the Controls factory").

**Why:** "Controls" is the established TestBench vocabulary the user works in; "factory" is foreign terminology that the user does not want mixed in. (The project `CLAUDE.md` once described them parenthetically as "factories for building example constants," which seeded earlier slips — that parenthetical has been corrected.)

**How to apply:** When naming or describing these helpers anywhere — plan task titles, prose, commit messages, decision-log entries, code comments — use "control(s)". Build example constants "through `Controls::Constant`," not "through the factory." Related: the `control_` test-variable prefix rule.
