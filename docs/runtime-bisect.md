# Runtime bisect: c5 hang and canary3 missing diagnostics

## What the binaries are

| file | contents |
|---|---|
| `ESQ_asmonly` | pure assembly. **Control — test this first.** |
| `ESQ_only_videochip` | + `ESQ_CheckCompatibleVideoChip` (startup path) |
| `ESQ_only_four` | + the other four exact restorations (no startup involvement) |
| `ESQ_only_strcat` | + `STRING_AppendAtNull` only |
| `ESQ_c5` | all five exact restorations |
| `ESQ_canary3` | those five + `strcat` + `NEWGRID_GetGridModeIndex` |

## What the static evidence says

`ESQ_c5` was diffed against `ESQ_asmonly` instruction by instruction, with
relocation fields masked on both sides. The complete set of differences:

- **8 inserted `4e71` NOPs** — object longword padding, between functions
- **515 PC-relative displacement fixups** — consequences of the shift
- **nothing else at all**

No instruction differs, no relocation site moved incorrectly, and the DATA hunk
differs only in three bytes belonging to relocated code pointers. The five
restored functions were each located in the linked CODE hunk and are
byte-identical to the originals. `VPOSR` resolves to `3e39 00dff004` with no
spurious relocation.

**So `ESQ_c5` and `ESQ_asmonly` are semantically the same program.** If `c5`
hangs at the diagnostic screen, `ESQ_asmonly` must hang there too — which is
why the control matters before anything else is investigated.

Two readings are consistent with the report, and the control separates them:

1. **The hang predates the C work.** Then it is a pre-existing problem (or the
   split build in general) and the restorations are exonerated.
2. **"Please Stand By..." is not a hang.** That screen is what the program shows
   while waiting for its satellite data feed. With no feed attached, sitting
   there indefinitely may be correct behaviour, and reaching it may be the
   furthest the program has ever got.

## `canary3` showing no diagnostics is a separate, real regression

`canary3` differs from `c5` only by `strcat` and `NEWGRID_GetGridModeIndex`,
both *behavioural* (not byte-exact). Diagnostics vanishing points at `strcat`,
since those strings are assembled with it. `ESQ_only_strcat` isolates it.

Static review of the compiled `strcat` found no defect: it handles an empty
`dst`, returns `dst`, and preserves every callee-saved register it touches
(A2/A3/A5) while clobbering only A0/D0 — strictly more conservative than the
original, which clobbers A0/A1/D0. If `ESQ_only_strcat` misbehaves, the bug is
somewhere that review did not reach and the C should be replaced by linking the
routine from `sc.lib`, which is the correct fix for library code anyway.
