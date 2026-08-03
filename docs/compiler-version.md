# Which compiler built ESQ

**Working answer: SAS/C 6.51 or something very close to it — but not exactly it.**

Only 6.51 is installed (`sasc:sc/c/sc`, `$VER: SAS/C_Driver 6.51 (14.1.94)`).
`sc5` is the same driver in v5-compatibility mode, not a second version.

## Settings established so far

| setting | evidence |
|---|---|
| `NOSTKCHK` | the stock binary has no `__XCOVF`/`___base` stack-check prologue; `sc` emits one by default |
| `DATA=FAR` | globals are reached by absolute long (`CMP.L (xxx).L,D0` + relocation), not `d16(A4)`. Without it `sc` emits A4-relative and needs `_SDA_BASE_`/`___base` |
| `CODENAME=S_0`, `DATANAME=S_1` | so `sc` emits into the same sections as the assembly; otherwise `text`/`data` stay separate output sections and the program's explicit `(sym,PC)` operands become unrepresentable cross-section 16-bit PC-relative relocations |

The ~215 `d16(A4)` references that *do* exist are SAS/C runtime internals (handle
table, DOS library base, argc/argv), which are always near. Application data is
far. Both models coexisting is expected, not contradictory.

## Evidence the library is 6.51

Every relocation-free routine in `src/modules/submodules/` appears **verbatim**
in 6.51's `sc.lib`/`scnb.lib`/`scs.lib`/`scsnb.lib`: `STRING_AppendAtNull`
(`strcat`, 22 bytes), `MATH_DivS32`, `MATH_Mulu32`, `STRING_CompareNoCase`,
`STRING_CopyPadNul`, `FORMAT_U32ToOctalString`. Routines with A4-relative fixups
cannot be compared this way (those are resolved at link time and absent from the
executable's relocation table), so the verbatim-match count is a floor.

This is the strongest single piece of evidence for 6.51.

## Further settings established (10-function batch)

| setting | evidence |
|---|---|
| `SHORTINT` is **per-file** | `ED_IsConfirmKey` compares with `SUBI.W`, which only happens with 16-bit `int`; but `LADFUNC_GetPackedPenHighNibble` matches only *without* it. SAS/C reads a per-directory `SCOPTIONS`, so the original translation units need not have shared settings. `src/c/replacements.txt` carries a per-file options column. |
| hardware registers as externs | writing `*(volatile UWORD *)0xDFF004` yields `MOVEA.L #imm,An` + `MOVE.W (An),Dn`; the stock binary uses absolute `MOVE.W (xxx).L,Dn`. Exporting the equates from `src/hardware-exports.s` and declaring them `extern` reproduces it exactly. |

Source-shape rules that turned out to be load-bearing, all verified by byte match:

- **Chained assignment.** The original loads zero into a register once and
  stores it twice; four separate `= 0` statements make `sc` emit `CLR`.
  `SCRIPT_ClearSearchTextsAndChannels` needs `a = b = 0`.
- **Assignment order within a chain.** `LOCAVAIL_FreeNodeRecord` stores `first`
  before `second`, so it must be written `second = first = 0`.
- **No redundant local.** `LADFUNC_GetPackedPenHighNibble` computes straight
  into D0; introducing a named local for the widened value costs a register.

## Second batch: more load-bearing source shapes

Verified by byte match:

- **Work in place on a parameter.** `SCRIPT_WriteCtrlShadowToSerdat` keeps the
  value in D7 and uses `BSET #8`; introducing a temporary routes it through D0
  and emits `ORI.W #$100`, costing 4 bytes. Two separate statements
  (`value &= 0xFF; value |= 0x100;`) are needed, not one combined expression.
- **`short` loop counters.** `ESQIFF_RestoreBasePaletteTriples` compares with
  `CMP.W` and indexes with `ADDA.W`; a `long` counter widens both.

Two divergences that may not be expressible in C at all: both
`SCRIPT_GetCtrlLineFlag` and `ESQIFF2_ValidateAsciiNumericByte` load a value
with `MOVE.B`/`MOVE.W` into a register and then return the **full 32-bit
register**, so the upper bits carry whatever the caller left there. Callers
evidently use only the low part. No C construct produces an unextended return,
and forcing one would be a distortion -- these two are candidates for staying in
assembly permanently.

## OS library calls: mechanism solved, one divergence left

SAS/C ships the pragma headers (`include:pragmas/*_pragmas.h`), and
`#include <proto/graphics.h>` reproduces the original's call sequence exactly:

```
2c79 <base>   MOVEA.L GfxBase,A6
4eae feaa     JSR     _LVOSetAPen(A6)
```

Same base load, same LVO offsets, same encoding. Use the proto headers for any
OS-calling restoration -- a plain `extern` declaration produces an ordinary
external call and cannot match.

What remains is A6 handling. SAS/C treats A6 as callee-saved and adds it to the
`MOVEM` masks (`48e73002` / `4cdf400c`); the original treats it as scratch and
does not save it (`48e73000` / `4cdf000c`). It also loads the base before
setting up arguments where the original does it after. Neither `CONSTLIBBASE`,
`NOCONSTLIBBASE`, `SAVEDS` nor `NOSAVEDS` changes this.

That single difference now blocks every OS-calling function, which is a large
share of the display and disk paths -- making it, alongside the A3/A5
allocation order, the highest-value thing for a different compiler version to
fix.

## What a large function costs (318-byte trial)

`NEWGRID_SelectEntryPen` was attempted as a deliberate scale test: 318 bytes,
zero calls, two PC-relative jump-table switches, three BTST flag tests, struct
fields and two clamp ranges.

Result after three source shapes, in about twenty minutes:

| attempt | bytes | note |
|---|---:|---|
| two-variable sentinel | 292 | switches based at case 2 |
| explicit `~0 & 0xFF` | 340 | expressions cost code |
| single variable, switch based at case 1, `OPTIMIZE` | **318** | exact size |

At 318/318, **79% of instruction words are identical in sequence** -- both jump
tables, all three flag tests, the pen constants, both clamps, the epilogue. Of
the 30 differing words, 8 differ only in a register field (`BTST #1,27(A3)` vs
`27(A0)`), the familiar allocation divergence.

So a function of this size is reachable *semantically* on the first sitting, and
lands within a few percent structurally -- but exact is out of reach while the
register-allocation divergence stands, and the residual also includes source
shapes that no obvious C reproduces (the original opens with a duplicated
`MOVEQ #0,D7` before `NOT.B`).

Practical read: large functions are worth restoring for the analysis, and they
are *not* disproportionately harder to get semantically right. They are
disproportionately unlikely to be byte-exact, because every divergence class in
the program gets more chances to appear in 318 bytes than in 30.

## Lattice C 5.10 tested and ruled out -- but it narrows the target

Lattice C 5.10 (`~/Downloads/LATTICE-C-hdd`, driver 5.10, phases lc1/lc2 V4.01)
was run against the acceptance test. It does **not** match, but the way it fails
is informative. Three distinct behaviours for the same function:

| compiler | prologue | pointer local | size |
|---|---|---|---:|
| Lattice C 5.10 | `LINK A5` frame, saves nothing | **A0** | 40 |
| **ORIGINAL ESQ** | no frame, `MOVE.L A3,-(A7)` | **A3** | 36 |
| SAS/C 6.51 | no frame, `MOVE.L A5,-(A7)` | **A5** | 36 |

Lattice keeps a frame pointer in A5 and does not use address register variables
at all -- it addresses the parameter through the frame and borrows A0. The
original has no frame and *does* use a register variable, like 6.51, but picks
A3 because A5 is unavailable to it.

**So the original sits between the two**: it has 6.51's register-variable
allocation while still reserving A5 the way the frame-pointer-era compiler does.
That points at **SAS/C 5.x, or an early 6.x (6.0-6.3)** -- the versions where
the allocator had been added but A5 was still reserved by convention. Those are
the versions worth hunting for; Lattice 4.x/5.x and 6.51 are both excluded.

### Driving Lattice C under vamos

Worth recording since it took some doing:

- Use the separate config: `vamos -c ~/Downloads/lattice-c-vamos -- lc ...`.
  The `--` is required, since Lattice's `-` options otherwise get eaten by vamos.
- The `lc` driver **crashes vamos** (`FreeMem: Unknown memory to free`) when it
  spawns its phases. Run the phases directly instead:
  `lc1 -oquad:x.q work:x.c` then `lc2 -v -owork:x.o quad:x.q`.
- The V4.01 front end is **K&R only** -- ANSI prototypes are rejected with
  "invalid argument type specifier".
- `-v` (no stack check) is a **phase-2** option; lc1 rejects it.

## A one-line acceptance test for a candidate compiler

When another SAS/C turns up, this settles the biggest question in seconds:

```sh
tools/cmatch.sh src/c/textdisp_reset_selection_state.c TEXTDISP_ResetSelectionState
```

`TEXTDISP_ResetSelectionState` is 36 bytes in both builds and differs in
**nothing but the address register**. The first two bytes of the output tell you
everything:

- `2f0b` = `MOVE.L A3,-(A7)` -> matches the original; the register-allocation
  divergence is gone and dozens of recorded restorations should flip to exact.
- `2f0d` = `MOVE.L A5,-(A7)` -> same divergence as 6.51.

Then run `python3 tools/mismatches.py --recheck` for the full picture.

## A third divergence: register allocation order

Across every function with a pointer local, SAS/C 6.51 allocates **A5** where
the original uses **A3**, and **D6 before D7** where the original uses D7 first.
`TEXTDISP_ResetSelectionState` is the cleanest case: 36 bytes both ways, every
single other byte identical, only A3 vs A5.

Not the data model and not an option. Exhaustively probed on
`TEXTDISP_ResetSelectionState`, all of which still emit `2f0d` (A5):
`NOAUTOREG`, `OPTIMIZE`, `SHORTINT`, `DATA=FAR`, `DATA=NEAR`, `CODE=FAR`,
`PARAMETERS=REGISTERS`, `NOOPTIMIZERSCHEDULER`, `OPTIMIZERALIAS`, and every
`DEBUG=` level (`LINE`, `SYMBOL`, `FULL`, `FULLFLUSH`, `SYMBOLFLUSH`) -- the
DEBUG idea being that a debug frame pointer would reserve A5, which it does not.

The allocation *order* is the tell: the original picks A3 first and A2 second
(descending from A3, never touching A4/A5/A6), so its free set excluded A5.
SAS/C 6.51's free set includes A5 and it picks that first. Nothing in the option
set changes the free set. This blocks 4 of the 10 functions in the batch and is the
highest-value thing for a different compiler version to fix.

## Evidence the code generator is *not* quite 6.51

Two independent application functions where 6.51 makes a different — equally
valid, same-semantics — choice than the original, under every option
combination tried (`OPTIMIZE`, `NOOPTPEEP`, `OPTSIZE`, `OPTTIME`, `NOOPTGLO`,
and the non-optimizing default):

**1. `BRUSH_PlaneMaskForIndex`** — 24 of 28 bytes match, including the `D7`
save, parameter at `8(A7)`, explicit `TST.L`, `MOVEQ #9`/`CMP.L` bound check,
`BRA.S` to a shared exit, and the epilogue. The divergence is materialising
`1L << n`:

```
original :  7001 efa0                 MOVEQ #1,D0 ; ASL.L D7,D0        (4 bytes)
SAS/C 6.51: 2007 7200 01c1 2001       MOVE.L D7,D0 ; MOVEQ #0,D1 ;
                                      BSET D0,D1 ; MOVE.L D1,D0        (8 bytes)
```

Not a blanket version tell: the original contains **3** register-to-register
`BSET`s (all genuine `x |= 1<<n`) *and* **4** `MOVEQ #1`+`ASL.L`. Its compiler
chose contextually; 6.51 always prefers `BSET`. Scope is 4 sites program-wide.

**2. `NEWGRID_GetGridModeIndex`** — the original computes the value in `D0`,
then stores once to the `D7`-allocated local:

```
original :  7001 b0b9 <abs> 6702 7006 2e00 2007   (22 bytes)
SAS/C 6.51: 7001 b0b9 <abs> 6604 2e00 6002 7e06 2007   (24 bytes)
```

6.51 sinks the assignment into both branches. Source forms tried: ternary,
if/else, initialiser, `register` qualifier, inverted condition, two-return.
The two-return form under `OPTIMIZE` produces the original's exact core
(`7001 b0b9 <abs> 6702 7006 4e75`) but drops the `D7` round-trip entirely.

## SAS/C 6.00 tested — the target is bracketed between 6.00 and 6.51

SAS/C 6.00 (`~/Downloads/SAS-C-6-hdd`, config `~/Downloads/sas-c-6-vamos`) was
run against all 195 restorations. It is **not** the compiler either, but unlike
Lattice it fails in the opposite direction from 6.51, which brackets the target.

|  | 6.00 | 6.51 | both | union |
|---|---:|---:|---:|---:|
| restorations matched | 10 | 18 | 5 | 23 |

Neither version reaches 23, so the original is neither. Three independent
codegen classes separate them, and on **all three** the original sits strictly
between:

| class | SAS/C 6.00 | ORIGINAL | SAS/C 6.51 |
|---|---|---|---|
| `1 << n` | `MOVEQ #1` + `ASL.L` | **same as 6.00** | `BSET` |
| call to an extern | `4eba` `JSR (d16,PC)` | **same as 6.51** | `6100` `BSR.W` |
| redundant `MOVE.L Dn,Dn` | emitted | **removed** | removed |

The first says the original predates the `BSET` shift idiom; the second and
third say it postdates 6.00's calling encoding and gained the self-move peephole.
Consistent reading: **6.00 < original < 6.51**, i.e. one of 6.1/6.2/6.3.

The five that only 6.00 matches are `BRUSH_PlaneMaskForIndex`,
`DISKIO2_ParseIniFileFromDisk`, `ED_CommitCurrentAdEdits`,
`ESQPARS_PersistStateDataAfterCommand`, `TEXTDISP_ResetSelectionAndRefresh` —
all instances of the shift idiom recorded as `shift-of-one-via-bset`. Confirming
that slug's `retest:` prediction exactly.

**Do not mix compilers to harvest the union.** The original was built by one
compiler; picking whichever of two produces the nicer bytes per file would be
matching an artifact of our tooling, not reconstructing the program. 6.51 stays
the single toolchain (`AGENTS.md`), and 6.00 is a probe only.

### The register-allocation divergence is not an option

`A3` (original) vs `A5` (both 6.00 and 6.51) survives every plausible switch —
swept against the acceptance test on both compilers:

```
option        6.51    6.00    first 2 bytes
<none>        DIFFER  DIFFER  2f0d   MOVE.L A5,-(A7)
OPTIMIZE      DIFFER  DIFFER  2f0d
OPTSIZE       DIFFER    -     2f0d
OPTTIME       DIFFER    -     2f0d
AUTOREG       DIFFER    -     2f0d
OPTGLOBAL     DIFFER    -     2f0d
NOOPTPEEP     DIFFER    -     2f0d
NOAUTOREG     DIFFER  DIFFER  4aaf   no register variable at all
```

`NOAUTOREG` only removes the register variable; nothing selects *which* register.
So the allocator's preference order is compiled into the code generator, and a
candidate version either has it or does not — which makes the acceptance test a
sound one-line filter.

## The A3/A5 divergence has a single root cause: A5 is a reserved frame pointer

Counting prologue idioms across the whole original program settles what the
acceptance test was only sampling:

| idiom | count in the original |
|---|---:|
| `LINK.W A5` (frame pointer) | 364 |
| `MOVE.L A5,-(A7)` (A5 as a register variable) | **1** |
| `MOVE.L A3,-(A7)` | 381 |
| `MOVE.L A2,-(A7)` | 119 |
| `MOVEM` mask including A5 | **0** |
| `MOVEM` mask including A3 | 674 |

The original's code generator **never** allocates A5 as a register variable. It
reserves A5 as the frame pointer, so the first available address register for a
register variable is A3 (A4 is the small-data base, A2 comes next in 119 cases).

SAS/C 6.00 and 6.51 both free A5 when a function needs no frame and hand it out
as the first address register variable — hence `2f0d` where the original has
`2f0b`. The same property explains `ED1_DrawStatusLine1`: given a local array the
original emits `LINK.W A5,#-44` and addresses the buffer at `-41(A5)`, while 6.51
adjusts A7 directly (`SUBA.W #44,A7`) and addresses it at `11(A7)`.

So two divergence classes that looked independent — register allocation and
frame construction — are one property, and it is not option-selectable:
`DEBUG=FULL`, `DEBUG=LINE`, `DEBUG=SYMBOL`, `STKEXT`, `PROFILE` and `OPTIMIZE`
all leave 6.51 emitting `2f0d`. A candidate compiler that passes the `2f0b`
acceptance test will fix both at once.

### The same property, seen from the local-variable side

The `stack-local-pointer` divergence recorded in four `src/c` headers is this
same property, and not a separate class. Because the original reserves A5 for a
frame, it also has a frame to spill into, so it keeps a walking pointer in a slot
and reloads it at every use. 6.51 has no frame to spill into, so it allocates the
pointer to an address register and the reloads disappear.

| function | ref | got | delta | what the delta is |
|---|---:|---:|---:|---|
| `GCOMMAND_FindPathSeparator` | 96 | 80 | -16 | all of it |
| `GCOMMAND_TickPresetWorkEntries` | 132 | 116 | -16 | all of it |
| `DISKIO_ConsumeLineFromWorkBuffer` | 130 | 140 | +10 | most of it |
| `GCOMMAND_ApplyHighlightFlag` | 220 | 216 | -4 | -24 of it |

Two properties make this useful as a probe. The sign of the delta is not fixed,
so it cannot be mistaken for a size-optimization difference. And
`tools/casm.py` attributes 100% of the delta on the first two functions, which
means they contain no other disagreement at all. A candidate compiler that
reproduces `GCOMMAND_TickPresetWorkEntries` at 132 bytes has the frame-pointer
property, and it needs nothing else to get there.

### What finding the compiler is actually worth

`SCRIPT_SaveCtrlContextSnapshot` is the cleanest evidence in the project, because
it is a restoration where the register allocation is the **only** divergence.
234 bytes in the original, 234 emitted, and all 22 differing regions are the same
two-bit difference:

```
ref:  1779 xxxxxxxx 01b4     MOVE.B (abs).L,436(A3)
got:  1b79 xxxxxxxx 01b4     MOVE.B (abs).L,436(A5)
```

Same instruction, same offset, same operand, same length. The original holds the
struct pointer in A3; SAS/C holds it in A5. Nothing else about the function is
wrong -- the control bytes, both inlined `strcpy` loops, all thirteen scalar
copies and the index loop reproduce exactly.

So on a compiler that reserves A5, this function goes byte-exact with **no source
change at all**. Every other restoration has the A3/A5 issue tangled up with
frame layout, call encoding or constant forms, which makes it hard to say what a
compiler find would buy. Here it is isolated, and the answer is: this whole
function, for free.

## Call encoding depends on the callee's translation unit

`ED_SaveEverythingToDisk` is byte-for-byte identical to 6.51's output except that
every call is `4EBA` (`JSR (d16,PC)`) in the original and `6100` (`BSR.W`) from
6.51. Both are 4 bytes with a 16-bit PC-relative displacement.

The original uses **both** forms, and the split is not random:

| form | displacements observed |
|---|---|
| `6100` BSR.W | 0x0092, 0x00ae, 0x0330, 0x0886, 0x123c, 0xff12, 0xfebe, 0xf776 |
| `4EBA` JSR (d16,PC) | 0x2034, 0x3e36, 0x5f52, 0xb4ec, 0xcfc0 |

BSR.W is used for near targets and JSR (d16,PC) for far ones, which is what
"callee in the same translation unit" looks like after linking — both forms have
the same ±32767 range, so this is not a range decision.

That has a consequence for this project specifically: **a one-function-per-file
restoration emits only cross-unit calls**, so it can never reproduce a BSR.W the
original got from an intra-unit call, nor vice versa. Some functions therefore
match only by accident of which form we happen to emit. Reproducing the rest
would mean reconstructing the original's grouping of functions into `.c` files,
which is a separate and much larger problem than picking the right compiler.

6.00 emits `4EBA` for every call and 6.51 emits `6100` for every call; neither
picks per-callee, which is further evidence both are the wrong version.

### It is locality, not distance — three counter-examples

The evidence above is drawn from a single function, where "same translation
unit" and "nearby after linking" are confounded: same-unit callees are nearby
*because* they are same-unit. The displacement table therefore cannot tell the
two explanations apart, and as written it reads as though near/far were the
rule.

Three thunks separate them. Each is a six-byte forwarder whose callee is a jump
stub in an adjacent but *different* module, and each is encoded `4EBA` at a
displacement far inside the range where `ED_SaveEverythingToDisk` used `BSR.W`:

| function | displacement | encoding |
|---|---|---|
| `SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte` | 0x0158 | `4EBA` |
| `SCRIPT_ReadNextRbfByte` | 0x0164 | `4EBA` |
| `DST_WriteRtcFromGlobals` | 0x066c | `4EBA` |

All three are smaller than the largest `BSR.W` displacement observed (0x123c)
and two are smaller than the *smallest* `4EBA` one by an order of magnitude. So
the split is not a distance heuristic. **Translation-unit locality is the rule**,
and the near/far correlation in the original table is a side effect of it.

This matters because it is the difference between a property that might be
tuned by an option and one that cannot be: a distance threshold would be a
code-generator parameter worth hunting for in the option list, whereas per-callee
locality is a linker-visible fact the compiler can only know from the source
grouping. Nothing in `sc`'s option list reaches it.

`src/c/script_read_next_rbf_byte.c` and its sibling are the minimal probes for
this class — six bytes, one instruction in question, no other open class in the
function. They supersede `esqiff_handle_brush_ini_reload_hotkey.c` (128 bytes,
nine regions) as the first thing to run on a newly obtained compiler.

## CORRECTION: the target is OLDER than 6.00, not between 6.00 and 6.51

The "6.00 < original < 6.51" bracket recorded above rested on the call-encoding
class, and that class turned out to be translation-unit locality rather than a
version property (see the section above). The original uses **both** `BSR.W` and
`JSR (d16,PC)`; 6.51 always emits the former and 6.00 always the latter, so
whichever functions matched under either compiler did so by accident of where
their callee happened to live. That evidence has to be withdrawn.

With it removed, the classes line up consistently in the other direction:

| class | 6.00 | 6.51 | original |
|---|---|---|---|
| A5 reserved as frame pointer | no | no | **yes** |
| `LINK` frame for locals | no | no | **yes** |
| 680 as `MOVEQ #85`+`ASL.L #3` | yes | yes | **no** (`MOVE.L #680`) |
| parameter load order | ascending | ascending | **descending** |
| `1 << n` | `MOVEQ`+`ASL` | `BSET` | `MOVEQ`+`ASL` |
| redundant `MOVE.L Dn,Dn` | emitted | removed | removed |

Four classes put the original *before* 6.00; one (the shift idiom) puts it
before 6.51 and agrees with 6.00; only the self-move peephole points the other
way, and that one is weak — it depends on our reconstructed source shape rather
than on structure.

Combined with the Lattice C 5.10 result, the target is bracketed from both
sides. Lattice 5.10 builds a frame unconditionally and has no address register
variables at all; the original omits the frame when it has no locals and does
use register variables, so it is *newer* than 5.10. 6.00 has already stopped
reserving A5, so the original is *older* than 6.00.

    Lattice C 5.10  <  ORIGINAL  <  SAS/C 6.00

That means the version to hunt is a **late Lattice C 5.x / SAS/C 5.x** — 5.02,
5.04, 5.10a/b, or the first SAS-branded 5.x — not 6.1–6.3 and not 6.55–6.58.

The single most diagnostic property is whether the compiler reserves A5. That is
one test, and it also settles the frame-for-locals class, since they are the same
property.

## Constant materialisation: the original's rule, measured

Established across ed_draw_diagnostic_mode_text.c, cleanup_draw_grid_time_banner.c
and ed_draw_bottom_help_bar_background.c. The original reaches a large constant in
four bytes two ways, and otherwise falls back to a six-byte `MOVE.L`:

| form | sightings | bytes |
|---|---|---:|
| `MOVEQ #n` + `ADD.L Dn,Dn` (2n) | 190=95x2, 150=75x2, 240=120x2, 216=108x2, 130=65x2, 154=77x2 | 4 |
| `MOVEQ #n` + `NOT.B Dn` (~n) | 215=~40 (twice), 255=~0, 145=~110 | 4 |
| `MOVE.L #n` | 280, 300, 345, 385, 450, 475, 555, 595, 639, 265, 396, 640, 8192 | 6 |

Both short forms are confirmed across multiple independent functions and, for the
`NOT.B` form, across three different constant values -- so neither is an artifact
of one call site. The original reaches for a four-byte form whenever the target is
`2n` or `~n` for some `n` in MOVEQ range, and spends six bytes otherwise.

SAS/C 6.00 and 6.51 both generalise to `MOVEQ #n` + `ASL.L #k` for any power of
two, so they reduce 300 as 75<<2, 328 as 82<<2 and 696 as 87<<3 where the
original would not. **The original never shifts by more than one.**

That gives a two-sided test for a candidate compiler, which is stronger than
checking one form -- a compiler implementing only the doubling rule would pass a
single-form check and still be wrong:

- compile something containing **300** and look for `223c0000012c` (`MOVE.L`),
  not `724be589` (`MOVEQ`+`ASL`);
- compile something containing **145** and look for `7e6e 4607`
  (`MOVEQ #110`+`NOT.B`), not a `MOVE.L` or a shift.

**Better single probe:** `src/c/ladfunc2_emit_escaped_char_to_scratch.c` tests both
forms in one compile. It contains the adjacent constants 168 and 169, which the
original reaches by two *different* four-byte tricks:

```
168 -> 7254 d281      MOVEQ #84,D1 / ADD.L D1,D1     (2n)
169 -> 7256 4601      MOVEQ #86,D1 / NOT.B D1        (~n)
```

A compiler emitting both has the whole repertoire; one emitting `MOVE.L` or a
shift for either does not.

## A clean probe for the call-encoding class

`src/c/esqiff_handle_brush_ini_reload_hotkey.c` isolates the cross-unit call
class completely, which none of the other probes do. It restores
`ESQIFF_HandleBrushIniReloadHotkey` at **128 bytes against 128**, in nine
differing regions, of which **eight are the call encoding and nothing else**:

```
ref  4eba00ae 4eba00ba 4eba9bd6 4eba73b2 4eba00fc 4eba0074 4eba006e 4eba00d0
got  61000000  x8
```

The ninth is the original popping its argument frame before storing the result
where 6.51 pops after -- same instructions, same bytes, different order.

There is no `LINK` here, no address-register variable, no constant to
materialise, no library call and so no A6 question. That makes it the sharpest
single test available for the one property that blocks the largest number of
otherwise-perfect restorations: **does the candidate emit `JSR (d16,PC)` for a
call to an extern, or `BSR.W`?** A compiler that emits the former should take
this function byte-exact on the first compile, with no source changes.

Worth running first on any newly-obtained version, before the two constant
probes above -- it is a single yes/no with no interpretation required.

## Two more isolated probes, and what makes a probe good

A probe is only worth having if the candidate's answer is unambiguous, which
means the function must contain **exactly one** open class. Three now qualify,
and they cover different properties:

| probe file | restores | size | the one thing it tests |
|---|---|---:|---|
| `esqiff_service_pending_copper_palette_moves.c` | `ESQIFF_ServicePendingCopperPaletteMoves` | 372/372 | `4EBA` vs `6100`, and **nothing else** |
| `esqiff_handle_brush_ini_reload_hotkey.c` | `ESQIFF_HandleBrushIniReloadHotkey` | 128/128 | the same, plus one ordering region |
| `ladfunc_parse_hex_digit.c` | `LADFUNC_ParseHexDigit` | 100/100 | `MOVE.L Dn,Dm` vs `MOVE.B Dn,Dm` widening a char |
| `ed_draw_help_panels.c` | `ED_DrawHelpPanels` | 118/116 | `MOVE.L #640` vs `MOVEQ #80`+`LSL.L #3` |

`ESQIFF_ServicePendingCopperPaletteMoves` supersedes the 128-byte probe in the
section above for the call-encoding class. It is 372 bytes with eight calls, and
`casm.py` reports exactly eight differing hunks -- every one of them `4eba`
against `6100`, with no ninth region of any kind. 340 of its 372 bytes are
identical. Run it first.

`LADFUNC_ParseHexDigit` is the tightest of the remaining two: 88 of its 100 bytes are
identical, and the remaining 12 are the same two-byte instruction six times.

```
ref  2007 4880 48c0     MOVE.L D7,D0 / EXT.W D0 / EXT.L D0
got  1007 4880 48c0     MOVE.B D7,D0 / EXT.W D0 / EXT.L D0
```

Only the low byte of that copy can matter -- `EXT.W` overwrites bits 8-15 on the
next instruction -- so this is a free choice the two code generators make
differently, every time a `char` parameter is widened. Neither `SHORTINT` nor
`NOOPTIMIZE` moves it.

`ED_DrawHelpPanels` is the first probe for the constant rule that is a whole
function rather than a byte pattern to grep for: six library calls, the shared
`GfxBase` load, the RastPort reloaded per call and the second `RectFill` reusing
`D2` all reproduce, so a `MATCH` means the constant behaviour agrees and a
`DIFFER` of exactly 2 bytes means it does not. It also records a convention
difference that costs nothing but is real: the original does **not** preserve A6
across library calls, 6.51 adds it to the save mask.

The general lesson from assembling these: when a restoration lands size-exact
with a handful of same-size hunks, check whether those hunks are all *one* class
before filing it as ordinary. If they are, it is a probe, and it is worth more
than the restoration.

## Arithmetic: three more classes, and a caution

| operation | original | SAS/C 6.51 |
|---|---|---|
| `x * 10` (32-bit) | `JSR MATH_Mulu32` (helper) | `ASL`/`ADD` chain inline |
| `x * 30` (16-bit) | `MULU #30` inline | `MULU #30` inline (agrees) |
| `x * 3` | `LSL.L #2` + `SUB.L` | `MOVE`/`ADD`/`ADD` |
| `x / n` and `x % n` | one `MATH_DivS32` call, quotient in D0 **and** remainder in D1, both used | two separate helper calls |

**Width matters for the multiply.** The original calls the helper only for
32-bit multiplies; a 16-bit multiply goes inline through `MULU`, and there SAS/C
agrees. `COI_ComputeEntryTimeDeltaMinutes` is the counterexample that establishes
this -- earlier files stated the rule as "every multiply by a small constant",
which was too broad.

The caution: these do not all point the same way. On `x * 10` the original calls
out where SAS/C inlines, but on `x * 3` the original uses the shift and SAS/C
uses adds. So "SAS/C optimises more" is too glib a summary — the two code
generators simply pick different reductions, and only the constant-materialisation
rule above is a clean one-directional difference.

## Parameter and case layout

- **Parameter load order.** The original emits prologue loads in descending
  register order (D7, D6, D5); 6.00 and 6.51 both emit ascending (D5, D6, D7).
  `DISPTEXT_SetLayoutParams` is 98 bytes against 98 and differs by nothing else.
- **Case body layout.** For a switch with more than two cases the compare chain
  matches but SAS/C places the bodies in a different order, so every dispatch
  displacement differs. This is why `ED_HandleEditAttributesMenu` shows 29
  differing regions despite emitting exactly 680 bytes.

## What would settle it

Run the acceptance test on any Lattice/SAS C in the 5.x range:

```sh
tools/cmatch.sh src/c/textdisp_reset_selection_state.c TEXTDISP_ResetSelectionState
```

`2f0b` (`MOVE.L A3,-(A7)`) in the first two bytes means the compiler reserves A5
and you have found it; `2f0d` means A5 is being handed out as a register variable
and it is not the one. Until then, treat 6.51 as the working toolchain and expect
a minority of functions not to reach byte-exactness — leave those in assembly
rather than distorting the C to force a match.

### Note on alignment padding

A function of odd word length gets two bytes of padding to round the object to a
longword, and the filler is compiler-specific: 6.51 emits `4e71` (NOP), 6.00
emits zeros. `tools/cmatch.sh` strips either, but only when doing so makes the
lengths agree. Before that fix, 6.00's zero pad made genuine matches read as
mismatches — the first pass over 6.00 undercounted its matches by six.

## The LIBRARY narrows the version too, and it is cheaper to test than codegen

A compile tests the code generator. The linked runtime tests the LIBRARY, and
the original linked its own version of `sc.lib`. Comparing the two is a second,
independent line of evidence, and it needs no compile at all.

```sh
python3 tools/libmatch.py --all-remaining     # submodules vs the installed libraries
python3 tools/sclib.py <lib> --symbol __CXD22
```

All three installed libraries were compared on 2026-08-03. The three arithmetic
helpers sit in one member in every one of them -- 196 bytes, the signed divide
at offset 0 and the unsigned at offset 50 -- so the comparison is like for like.

| routine | size | Lattice C 5.10 | SAS/C 6.00 | SAS/C 6.51 |
|---|---:|---|---|---|
| `MATH_DivS32` = `_CXD33` | 50 | **identical** | **identical** | **identical** |
| `MATH_Mulu32` = `_CXM33` | 32 | 8 bytes differ | **identical** | **identical** |
| `MATH_DivU32` = `_CXD22` | 146 | **2 bytes differ** | 20 bytes differ | 20 bytes differ |

**This brackets the library from BOTH sides, and it agrees with the codegen
bracket.** ESQ has 6.x's `_CXM33`, which Lattice 5.10 does not -- Lattice opens
that routine `2042 2243` where ESQ and 6.x open `48e7 3000`. But ESQ's `_CXD22`
is two bytes from Lattice's and twenty from 6.x's. A library holding the new
multiply and the old divide is one BETWEEN the two, which is exactly the
`Lattice 5.10 < ORIGINAL < SAS/C 6.00` window the codegen tests give.

**6.00 and 6.51 are indistinguishable here.** All three helpers are identical
between them, so this test cannot separate 6.x versions. It separates eras.

The whole `_CXD22` difference against Lattice is ONE INSTRUCTION at offset 138:

```
ESQ      c141   exg.l d0, d1
Lattice  c340   exg.l d1, d0
```

Same operation, operands encoded the other way round, and the other 144 bytes
agree. Against 6.x the divergence is larger and starts at byte 121.

**This is a one-command test for any version candidate, and it needs no
compile:**

```sh
python3 tools/libmatch.py --libdir <candidate>/lib --all-remaining
python3 tools/sclib.py <candidate>/lib/sc.lib --symbol __CXD22
```

A version whose `_CXD22` matches all 146 bytes is a much stronger signal than
one function reaching byte-exactness, because a library member is compiled code
whose source form nobody chose. Read the `_CXM33` row at the same time: a
candidate must match ESQ there as well, which is what rules Lattice 5.10 out.

Match counts over the 51 routines still in `modules/submodules/` are 3 for both
6.x versions and 1 for Lattice. Read a low count as a version gap rather than as
evidence the routines are not library code -- `libmatch.py` masks every
relocated field, so a mismatch is a real difference in the instruction stream.

> **Two false-positive classes had to be excluded before these counts meant
> anything, and both were found by testing the tool rather than trusting it.**
> A short routine matches by accident, because every AmigaOS stub in `amiga.lib`
> is the same three instructions, so anything under 24 bytes is reported apart
> from the count. And a region that is mostly relocation is not evidence at all:
> Lattice's `_sys_errlist` is a pointer table, and masking covered every byte of
> it, so it "matched" 20 unrelated routines at one offset and turned 1 real hit
> into 20. `libmatch.py` now requires that at least half the window, and at
> least 16 bytes, are actually compared.

## Reproducing

```sh
tools/cmatch.sh <file.c> <FunctionLabel> [sc options]   # compile and diff
python3 tools/refbytes.py <FunctionLabel>               # original bytes
```
