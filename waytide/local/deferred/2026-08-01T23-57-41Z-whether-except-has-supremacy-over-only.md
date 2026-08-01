# Whether `except:` has supremacy over `only:`

`Constant::Import` applies `only:` and then `except:`, so `except:` is last and would appear
to win. Whether it actually has supremacy — and whether the ordering is observable at all —
is unassessed.

## What happens now

Verified 2026-08-01, with a source owning `A`, `B`, and `C`:

```
only: [A,B]                  ->  imported [:A, :B]
except: [C]                  ->  imported [:A, :B]
only: [A,B], except: [C]     ->  imported [:A, :B]
only: [A,B], except: [B]     ->  raises: B is named in both only: and except:
only: [A],   except: [B]     ->  imported [:A]
only: [A],   except: [A]     ->  raises: A is named in both only: and except:
```

## The finding: `except:` cannot remove anything once `only:` is given

For `except:` to subtract a name, that name has to be in the set `only:` narrowed to — which
means it is in **both** lists, which the conflict refusal rejects. So every combination that
survives is one where `except:` names something `only:` had already excluded, and the
subtraction is a **no-op**.

**Supremacy does not arise.** The two keywords cannot both act on the same name, so their
order is unobservable. Applying `except:` first would produce identical results in every
case.

This was not foreseen when the conflict refusal was designed. The refusal was added because
`only: [X], except: [X]` silently imported nothing; what it also did, unremarked, was remove
the only circumstance in which the two keywords interact.

## The question this actually raises

**Should the combination be refused outright?** If `except:` is inert whenever `only:` is
given, then a call passing both is either a no-op on the `except:` argument or an error, and
neither is a use. Accepting it silently lets a caller write something with no effect and
receive no signal — the same shape as the failure the conflict refusal was added to fix, one
level up.

**That option was on the table and was passed over.** On 2026-07-31 the choice was between
refusing `only:` and `except:` together outright, refusing a name in both lists, and keeping
the ordering as it was. Refusing a name in both was chosen. The reasoning available then did
not include this finding — that the narrower refusal empties the combination of any behavior
— so the decision is worth revisiting with it in hand rather than treated as settled.

## A second ordering fact, unrelated to supremacy

The conflict check runs **before** `only:`'s undefined-name check. With a source owning only
`A`:

```
only: [Nope], except: [Nope]   ->  Nope is named in both only: and except:
```

rather than reporting that `Nope` is not defined on the source. Both are true; which is
reported is decided by the order of the checks, and nothing records that this was chosen.
Whether the caller is better served by hearing that the name does not exist is a separate
question from supremacy, and is also unassessed.

**Gated on:** nothing.

**Why:** the ordering of the two keywords looks like a precedence decision and is not one —
the conflict refusal removed the only case where precedence could show. That leaves a
combination the library accepts and cannot act on, which is worth either refusing or
deliberately allowing, and a check order that decides which of two true statements a caller
hears, chosen by accident of where the code was written.

**How to apply:** decide whether passing both `only:` and `except:` is refused outright. If
it is, that is a change to design through the hinges, and the conflict refusal and its test
are reconsidered alongside it, since an outright refusal subsumes them. If it is not, record
that the combination is deliberately permitted and inert, and cover the no-op so the
behavior is stated somewhere. Separately, decide whether the conflict check should run before
or after `only:`'s undefined-name check, and record it either way. Then delete this file and
record an entry in `waytide/local/log/`. Related: `lib/constant/import.rb`,
`test/automated/import_constant/only_and_except_conflict.rb`, and the log entry
`2026-07-31T01-08-49Z-import-collision-refusal-is-carried-out.md`.

---

Authored by Scott Bellware on Sat Aug 1 2026 at 4:57:41 PM PT
