# Leaf-Scalar Differential Audit — Findings (round 1)

Date: 2026-07-11. Tooling: `classify_functions.py`, `gen_leaf_diff.py`,
`run_leaf_audit.sh`. Runtime: vamos + SAS/C 6.51.

## What was audited
The first fully-isolated batch: functions that (a) make no calls, (b) touch no
A4-globals / OS libraries / chipset, (c) reference no external symbols, and
(d) have an all-scalar signature with ≥1 param and a non-void return. The
classifier found **12**, of which **1** (`PARSE_ReadSignedLong_NegateValue`)
was dropped as a non-callable internal label fragment → **11 audited**.

Each function is run two ways over a shared 24-value fuzz table: the restored
SAS/C compiled to an executable, and the original ASM slice assembled and
linked into an executable. Outputs are diffed. Identical ⇒ behaviorally
equivalent (Silver PASS).

## Result: 10 PASS, 1 real bug (fixed), 1 benign divergence

**REAL BUG — FIXED:** `ESQDISP_TestWordIsZeroBooleanize`
- Original ASM: `TST.W; SEQ D0` (`$FF` if zero) `; NEG.B D0` (`$FF`→`$01`) `; EXT`
  → returns **+1** for zero, 0 otherwise.
- Restored C returned **−1** for zero — the author assumed the classic
  "booleanize to 0/−1" idiom, but the byte `NEG` of `$FF` is `+1`.
- Fixed `esqdisp_test_word_is_zero_booleanize.c` (`return -1` → `return 1`);
  re-ran the harness → PASS. This is a bug the static normalized-ASM "green"
  lane passed as equivalent.

**BENIGN DIVERGENCE — no fix:** `DISPLIB_NormalizeValueByStep`
- The original does `MOVE.W` arithmetic then `MOVE.L D7,D0`, returning the low
  word with an **undefined high word** (leftover caller register bits). The
  restored C returns `(long)(short)value`, deterministically sign-extending.
- Low words match (`0x8000`); only the don't-care high word differs
  (`0x0000` vs `0xffff`). **Resolved by caller analysis:** every caller reads
  the result via `MOVE.W D0` (e.g. `cleanup2.s:266` `MOVE.W D0,WDISP_BannerCharRangeStart`;
  also `esqdisp.s`, `cleanup3.s`) — low word only, high word ignored. The
  difference is therefore unobservable. Confirmed benign; no fix.

**PASS (10):** BRUSH_PlaneMaskForIndex, ESQIFF2_ValidateAsciiNumericByte,
ESQIFF2_ValidateFieldIndexAndLength, LADFUNC_ComposePackedPenByte,
LADFUNC_GetPackedPenHighNibble, LADFUNC_SetPackedPenHighNibble,
LADFUNC_SetPackedPenLowNibble, PARSEINI_AdjustHoursTo24HrFormat,
TLIBA1_ParseStyleCodeChar, ESQDISP_TestWordIsZeroBooleanize (after fix).

## Harness bugs found & fixed during the round (important)
Runtime findings MUST be verified in isolation — two of the first three
apparent "divergences" were harness artifacts, not restoration bugs:
1. **Symbol truncation:** SAS/C truncates identifiers to ~31 chars; the 36-char
   `_ESQIFF2_ValidateFieldIndexAndLength` mis-resolved and the call jumped to
   garbage → false divergence. Fixed by renaming the tested symbol to a short
   alias (`TESTFN`) on all three sides (driver/impl/slice).
2. **stdin consumption:** `vamos` in a `while read` loop ate the manifest →
   audit silently stopped at 5/12. Fixed with `</dev/null`.
3. **Infinite loops:** `step=0` fed to a normalize-by-step loops forever.
   Bounded program runs with `--max-cycles 20000000`.

## Data-leaf tier — mechanism PROVEN (2026-07-11)
`LADFUNC_ParseHexDigit` (reads `WDISP_CharClassTable`) was audited by extracting
the table into a linkable object and linking it into both sides. It **PASSes**
(behaviorally equivalent). Fixture: `src/decomp/sas_c/_dltest/`.

Key requirement discovered: SAS/C references globals as **near** (A4-relative
small-data). A plain `SECTION data,DATA` table triggers *Error 510: Near
Reference to data item not in near data section*. The table object must use
`SECTION __MERGED,DATA` and export **both** names (`WDISP_CharClassTable` for
the ASM slice's absolute `LEA`, and `_WDISP_CharClassTable` for the SAS/C C
reference) at the same address. This near-data model is the same core challenge
as the GLOBAL/A4 tier and the Phase-3 whole-program link.

To generalize the data-leaf tier: detect a function's external data symbols,
extract each symbol's `DC.*` block from `src/data/*.s`, emit a `__MERGED` table
object with dual XDEFs, and link it into both sides. ~56 candidates exist
(`report_data_leaf_candidates.py`), though many are void/global-mutating rather
than scalar-returning.

## Pointer-leaf tier — `ESQ_WildcardMatch` PASS
The one isolated function taking `const char *` args (`ESQ_WildcardMatch`,
`unsigned char(const char*, const char*)`) was audited with 13 string/pattern
pairs covering `*`, `?`, exact, mismatch, and empty-string edges. **PASS** —
pointers pass through `__stdargs` fine (the pointer value is passed and
dereferenced absolutely, independent of the near/far model).

## Session scoreboard — isolated tier EXHAUSTED
| tier | audited | pass | real bug | benign diff |
|------|---------|------|----------|-------------|
| pure-leaf | 11 | 10 | 1 (ESQDISP, fixed) | — |
| data-leaf (reads a table) | 2 | 2 | — | — |
| pointer-leaf (const char*) | 1 | 1 | — | — |
| **total** | **14** | **13** | **1** | 1 |

The isolated-function universe is now essentially exhausted (~14). Every
remaining restoration either delegates via `JSR <label>`, touches A4-globals,
or needs the chipset — none are testable in isolation. **Scaling the audit
beyond this requires Phase 3 (whole-program link: link all restored C into one
program, all original ASM into another, run both, compare traces).**

## Round 2 — buffer/pointer-arg tier (2026-07-13)
`gen_leaf_diff.py` was extended to test PURE-leaf functions that take a **buffer
pointer** (+ scalar) arg: the driver allocates a 64-byte buffer, seeds it
deterministically (nonzero bytes 0..38, NUL at 39, zero padding — string
scanners stay in-bounds), passes it identically to both sides, and after the
call prints the return value **and a digest of the buffer** (catches in-place
writes). Scalars use a bounded pool (indices ≤63) so neither side reads OOB.
11 candidates (one pointer + scalars, `build/decomp/ptr_tier.tsv`). Report:
`docs/leaf-audit-report-ptr-tier-2026-07-13.txt`.

**Result: 8 PASS, 2 explained non-bugs, 1 inconclusive (crash).**
- **PASS (8):** COI_CountEscape14BeforeNull, DATETIME_ClassifyValueInRange,
  ESQ_TestBit1Based, ESQDISP_TestEntryBits0And2, ESQDISP_TestEntryBits0And2_Core,
  FORMAT_U32ToOctalString, NEWGRID_SetRowColor, P_TYPE_GetSubtypeIfType20.
  (ESQ_TestBit1Based passing directly validates a dependency of the two newly
  restored ESQSHARED functions.)
- **NON-BUG — dead return value:** `DATETIME_NormalizeMonthRange`. The original's
  `DIVS`/`SWAP` idiom leaves the year quotient in the return's **high word**
  (e.g. `0x03710002`); the C returns a clean `0x00000002`. The buffer digest
  (in-place ctx mutations at off 8/18) is IDENTICAL on both sides, and **every
  caller discards the return** (`disptext2.s:166/198` do `MOVE.L A3,D0` right
  after; `:386` uses D4; `:920` ignores it). Return is dead → benign.
- **NON-BUG — harness ABI (regargs):** `ESQSHARED4_DecodeRgbNibbleTriplet`. Its
  slice reads the arg from **A1** (`__regargs`), but the stdargs driver passes
  the pointer on the stack → the ASM side reads a garbage A1. The restored C
  (`(src[0]&15)<<8 | (src[1]&15)<<4 | (src[2]&15)`) is a byte-exact match of the
  ASM logic. HARNESS LIMITATION, not a restoration bug: regargs functions need a
  register-arg driver (TODO if that tier is pursued).
- **INCONCLUSIVE — crash:** `LOCAVAIL_GetNodeDurationByIndex(void *statePtr,...)`
  walks a linked list from the buffer; random seed bytes are chased as node
  pointers → segfault on BOTH sides. Needs a valid hand-built state struct.

Scoreboard (cumulative): **25 functions audited, 21 PASS, 1 real bug (ESQDISP,
fixed), 3 explained non-bugs (2 benign, 1 harness-ABI), 1 inconclusive.** The
1 real bug in 25 audited (~4%) keeps validating the "don't trust prior work"
premise; the rest of the isolated + buffer-arg tiers are behaviorally clean.

## Round 3 — A4-global (writable near-data) tier (2026-07-13)
Proved a NEW tier: functions that read/write A4-relative globals, tested by
placing the touched globals in a writable `SECTION __MERGED,DATA` object,
XDEF'd as BOTH `Name` (for the ASM slice's `Global_X(A4)` ref) and `_Name` (for
the SAS/C C ref) at the same near-data storage. SAS/C's startup sets A4, so both
sides resolve to identical storage — the data-leaf `__MERGED` trick generalized
to *writable* globals. Runner: `src/decomp/scripts/run_global_diff.sh`; fixtures
in `src/decomp/sas_c/_gtest/<ENTRY>/` (globals.s / slice.s / impl.c / driver.c).
Driver seeds the globals + a test buffer, calls TESTFN over fixed inputs, and
prints return + global state + a buffer digest — so in-place global side effects
are compared, not just the return.

**Result: 4 PASS.** `FORMAT_Buffer2WriteChar`, `UNKNOWN10_PrintfPutcToBuffer`
(near-mode putc: append a byte to a global buffer, bump count, advance pointer).
`ESQSHARED4_CopyLivePlanesToSnapshot` (FAR-mode: 3×44-longword plane copy through
pointer globals — the runner auto-detects near vs far by the globals.s SECTION;
using the wrong mode links but crashes at runtime). `ESQSHARED4_DecodeRgbNibbleTriplet`
(via a regargs→stdargs wrapper prologue that preserves callee-saved D2) — this was
the Round-2 pointer-tier "divergence", now CONFIRMED PASS: it was purely the
stdargs-vs-regargs ABI artifact, the computed return always matched.

`ESQSHARED4_CopyPlanesFromContextToSnapshot` was ALSO verified (5th PASS) — it
exercises all harness capabilities at once: a regargs context arg (via the wrapper
prologue), far-mode contiguous pointer globals, and an updated-in-place context
struct (the advanced plane pointers matched too). So the differential harness now
covers near + far addressing, regargs, buffer args, and struct globals.

Of the original 8 GLOBAL-leaf candidates, 5 are now verified. The rest
are NOT independently callable in isolation and were correctly skipped:
`ESQSHARED4_SetBannerCopperColorAndThreshold` **clobbers A4** (uses `LEA sym,A4`
as a scratch pointer, destroying the near-data base — assumes a specific caller
context); `ESQSHARED4_CopyLongwordBlockDbfLoop` / `...CopyPlanes*` are **regargs
mid-function fragments** (args in A3/A4/D1, tail `MOVEM.L (A7)+,D0-D1/A0-A4`
belongs to a caller's frame); `ALLOC_InsertFreeBlock` (121 ln) and
`NEWGRID_SelectEntryPen` (172 ln) are large and touch structured state.

Cumulative audit: **27 functions, 23 PASS, 1 real bug (ESQDISP, fixed),
3 explained non-bugs, 1 inconclusive.**

## Round 4 — systemic `NEG.B` booleanize-sign scan (2026-07-13)
Generalized the single ESQDISP bug into a corpus-wide grep. The original
booleanizes to **0/+1** via `Scc Dn; NEG.B Dn; EXT` (`NEG.B $FF = $01`); several
restorations wrongly returned **-1** for the true case (the 0/-1 idiom that
`Scc; EXT` *without* NEG.B produces). Detector: ASM `Scc D0` + `NEG.B D0` within
2 lines + `RTS` within 8 (a *returned* booleanizer) → check the matching C return.

**6 more functions fixed** (all verified against the ASM; ESQ_fullc recompiled +
relinked, stays 0/0):
- `DISPTEXT_AppendToBuffer` (disptext_append_helpers.c) — return -1 → +1
- `DISPTEXT_LayoutSourceToLines` (disptext_layout_lines_helpers.c, 3 sites)
- `DISPTEXT_LayoutAndAppendToBuffer` (disptext_layout_append_helpers.c, 3 sites)
- `WDISP_UpdateSelectionPreviewPanel` (wdisp_update_selection_preview_panel.c)
- `NEWGRID2_DispatchGridOperation` (newgrid2_dispatch_grid_op.c — its ASM even
  carries a WRONG "booleanize to 0/-1" comment)
- `DATETIME_SecondsToStruct` (datetime_seconds_to_struct.c) — VARIANT: stored
  `(isLeap!=0)?-1:0` to the struct leap field, but the ASM stores
  `DATETIME_IsLeapYear`'s raw 0/+1 return directly (`MOVE.W D0,20(A3)`); fixed to
  store the raw value.

RESOLVED-CORRECT (traced, NOT a bug): `stream_buffered_getc.c`'s
`node->ReadRemaining = (isTextMode)?-1:0` is faithful — it maps to the ASM's LATE
`.post_fill_flags` `ReadReject` branch which conditionally sets -1/0 on the text-mode
flag D7, not the EARLY `FlushReject` branch (a different flag) I first compared to.
Tracing before editing avoided introducing a bug. The `ESQDISP_GetEntryAuxPointerByMode`
booleanizers are ALSO resolved: they sit in a `; Unreferenced Code` block after the
live function's RTS (dead code, no restored C) — not a bug. Scan COMPLETE: 6 real
bugs fixed, all suspects resolved, both directions checked.

Why the differential harness missed these: all 5 CALL other functions (not
isolatable leaves), so the audit never reached them — the ASM-pattern grep is the
tool that scales this bug class. NOT bugs (left alone): internal flags booleanized
to -1 but only tested for truthiness (`newgrid_select_next_mode.c` modeAccepted);
`Scc; EXT` without NEG.B genuinely returns 0/-1. Still open: the
`ESQDISP_GetEntryAuxPointerByMode` jump-table-conflated region (SGT/SMI/SLT+NEG.B
returns) maps to unidentified C files. See memory `booleanize-neg-b-sign-bug-class`.

## Round 5 — division-signedness spot-check (2026-07-13)
Checked the class "ASM uses signed `MATH_DivS32` but C emits unsigned
`MATH_DivU32`" (would diverge for negative operands). Method: grep existing
`.c.dis` files for `MATH_DivU32` and cross-check the ASM helper. 44 `.dis` files
use division; only 5 emit `DivU32`, and 4 are legitimate (the `DivU32` primitive
itself, a JMPTBL stub, and `FORMAT_U32ToDecimalString` which divides an unsigned
U32). Exact-match spot-check: `DISPLIB_ApplyInlineAlignmentPadding` C emits
`DivS32`, ASM uses `DivS32` — clean. The one non-trivial case,
`datetime_seconds_to_struct`, has a codegen-count difference (ASM 9×S32+1×U32
across 10 sites; C 7×S32+2×U32 across 9 sites) — but its operands are
time-of-day components (always ≥ 0), where signed and unsigned division are
identical, so benign. **Verdict: no clear signedness bugs found** — unlike the
booleanize class, this axis of the corpus looks clean. (Not exhaustive: a
per-division operand-range proof for datetime was not done; low priority.)

## Takeaways
- The differential harness works and finds real bugs the static lanes miss —
  validating the "don't trust prior work" premise with a concrete fix.
- Equally important: the harness itself produces false positives if not built
  carefully; every divergence is verified in isolation before being called a
  bug (2 of the first 3 "divergences" were harness artifacts).
- Two tiers proven: **pure-leaf** (11 audited) and **data-leaf** (mechanism
  proven on 1). Next: generalize data-leaf table extraction, then the
  **GLOBAL/A4** tier (stand up an A4 world + compare globals after the call).
