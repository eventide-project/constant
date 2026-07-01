# Say "verified", not "green"

Do not describe a passing test suite (or a passing test) as **"green"** — it is
slang. Say **"verified"** instead: "the suite is verified," "75 tests verified,"
"keep the suite verified." The compound "green-on-arrival" likewise becomes
**"verified-on-arrival"**.

**Why:** "green" is an oblique, tooling-flavored metaphor — the color of a passing
CI indicator — that the reader has to map back to the actual meaning: the tests
pass, the behavior is confirmed. "Verified" states that meaning directly, with no
mapping to memorize. This is the same literal-naming discipline as the other
de-slang rules (arm → scenario, cut → increment) and the
name-literally-not-by-analogy rule.

**How to apply:** in prose, commit messages, logs, and loop records, write
"verified" wherever the impulse is "green." Applies going forward; existing
records are not retroactively swept. Related: the name-literally-not-by-analogy
rule and the lexicon rules.
