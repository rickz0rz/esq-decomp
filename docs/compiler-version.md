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

## What would settle it

Obtain SAS/C 6.55/6.56/6.57/6.58 and re-run both cases. If either idiom flips,
the version is pinned. Until then, treat 6.51 as the working toolchain and
expect a minority of functions not to reach byte-exactness — leave those in
assembly rather than distorting the C to force a match.

## Reproducing

```sh
tools/cmatch.sh <file.c> <FunctionLabel> [sc options]   # compile and diff
python3 tools/refbytes.py <FunctionLabel>               # original bytes
```
