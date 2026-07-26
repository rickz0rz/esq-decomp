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

## What would settle it

Obtain SAS/C **6.1, 6.2 or 6.3** and run the acceptance test; `2f0b` in the first
two bytes pins the version on the spot. 6.55–6.58 remain worth testing but are
now the less likely direction, since the shift idiom has to get *less* optimised
than 6.51, not more. Until then, treat 6.51 as the working toolchain and expect a
minority of functions not to reach byte-exactness — leave those in assembly
rather than distorting the C to force a match.

### Note on alignment padding

A function of odd word length gets two bytes of padding to round the object to a
longword, and the filler is compiler-specific: 6.51 emits `4e71` (NOP), 6.00
emits zeros. `tools/cmatch.sh` strips either, but only when doing so makes the
lengths agree. Before that fix, 6.00's zero pad made genuine matches read as
mismatches — the first pass over 6.00 undercounted its matches by six.

## Reproducing

```sh
tools/cmatch.sh <file.c> <FunctionLabel> [sc options]   # compile and diff
python3 tools/refbytes.py <FunctionLabel>               # original bytes
```
