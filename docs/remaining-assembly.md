# The assembly that is left: NONE

Last measured 2026-08-06 from `build/ESQ.map` on the 878-entry maximum-C
manifest.

```
maximum-C build      291,256 bytes      CODE 235,392 + DATA 55,864
  from compiled C    291,256      100.000%
  from assembly            0        0.000%
```

**Every byte of the linked image comes from compiled C.** There is no separate
manifest and no switch. This document is now the record of how the last bytes
went, and of the rule that had to be corrected to let them go.

Regenerate the figure at any time:

```sh
ESQ_FARCALLS=1 SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
  C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh
```

A contributor in `build/ESQ.map` whose name ends `.asm` is assembly. There are
none. Note that `tools/lastmile.py` still counts 157 module includes as
assembly: 150 are empty files, six are parent modules whose content was split
out, and `src/modules/c-exports.s` holds only `assert` directives. None emits a
byte. **The link map is the authority, not the module count.**

**The byte-exact gates are untouched and both are green.** Neither reads a
manifest, so `src/Prevue.asm` still assembles the reference image.

## The last 44 bytes: three strings, and a rule that was wrong

`src/modules/submodules/unknown36_p0_strings.s` held three constants:

```
_DEBUG_STR_UserAbortRequested:  "** User Abort Requested **",0,0
_DEBUG_STR_Continue:            "CONTINUE",0,0
_DEBUG_STR_Abort:               "ABORT",0
```

They are the Ctrl-C break requester's body and button text, and a DATA TABLE
holds their addresses -- `src/c/data_wdisp_p1.c` builds
`DEBUG_AbortRequesterTagChain` from them. So the trick that retired the other
four CODE-section strings cannot work here: a stack local has no address a
linker can write into a table. They had to become real C definitions, and
SAS/C 6.51 places every string literal in `data`.

That was believed to be fatal. `src/c/data_debug_abort_strings.c` grows the DATA
hunk 55,820 -> 55,864, and both this document and AGENTS.md said a hunk which
grows by even FOUR bytes freezes the display, on the evidence of `data/flib.s`
measured twice.

**Re-measured 2026-08-06. It does not.**

| check | result |
|---|---|
| `soak_esq.sh` x2 | PASS -- 10/10 distinct frames, 10/10 Amiga content, 1 exception line |
| `menusweep_esq.sh` | all six ESC-menu items clean, no gurus |
| `keyprobe_esq.sh 53:6 53:6 53:6` | three distinct pixel hashes, menu alternating |
| `listings_esq.sh` on a replayed feed | PASS -- `curday.dat` 42 -> 1017 bytes |
| `curday.dat` against the assembly control | **byte-identical** |
| `framecolor.py` against a pure far build | every bin overlaps, exit 0 |
| `a6_audit` / `data_shape_audit` / `extern_width_audit` | clean |
| `check_pcrel_range` / `data_offset_audit` | clean |
| `test-hash.sh` / `build-split.sh` | PASS / CONTENT-IDENTICAL |

`escwatch_esq.sh` FAILS at grey 0.335 -- and the byte-exact known-good build
FAILS IDENTICALLY, 0.3351/0.3354 over the same 12 frames. That is the ESC-menu
defect in the ORIGINAL, gated behind `fixEscMenuExitDisplayMode`, and it is not
a regression. **Run the control before reading a FAIL as one.**

### Why the growth is safe, and what the real invariant is

ESQ never depends on the ABSOLUTE offset of a data symbol, because the linker
relocates every absolute reference. It depends on the DISTANCE BETWEEN two data
symbols, and it does so in three places no relocation can correct:

1. The 59 `Global_*` equates in `src/Prevue.asm`. Each is a fixed displacement
   from `_Global_REF_LONG_FILE_SCRATCH`, the A4 near-data base at DATA offset
   `0x8000`. Eleven point into unlabelled space inside a reserved block.
2. `src/c/esq-neardata.h`, which writes the same displacements as
   `<symbol> + <number>` -- 102 of them.
3. The eight adjacencies where code reads ACROSS a symbol boundary, listed in
   AGENTS.md.

This module links FIRST, so its 44 bytes land at DATA offset **0**, in front of
every pre-existing symbol. The whole image shifts as one piece: the A4 base
moves `0x8000` -> `0x802c`, exactly the growth, and every distance survives.
Confirm it in the map:

```sh
grep -E '_Global_REF_LONG_FILE_SCRATCH|_DEBUG_STR_' build/ESQ.map
```

**`data/flib.s` was a different fault wearing the same symptom.** Its conversion
hit the `char X[] = "..."` padding bug, which drops a pad byte and moves symbols
RELATIVE TO EACH OTHER inside the module. That is a broken distance, not a
shifted image. `tools/data_offset_audit.py` was written after that finding and
catches exactly it; this build passes it clean.

So state the rule as:

> **Growth at the FRONT of the DATA hunk is free. Growth in the MIDDLE is
> fatal.** What must be preserved is the distance between pre-existing symbols,
> not the size of the hunk.

AGENTS.md's "only convert a layout-neutral module" stays the safe DEFAULT for
converting a data module in place, because `coalesce()` inserts its padding
mid-section. It is not a ban on the hunk changing size.

### The sizes must be explicit

The arrays are declared `[28]`, `[10]` and `[6]`, not `[27]`, `[9]` and `[6]`.
The assembly is `DC.B "...",0,0`, and `char X[] = "..."` would drop the padding
NUL and move these three relative to each other -- which is the fatal kind of
change described above.

## Retired: 56 bytes of alignment padding (2026-08-06)

Thirteen modules whose entire content was filler -- an `ALIGN_WORD`, which
`src/macros.s` defines as `DC.W $0000`, or a couple of bytes the disassembler
rendered as instructions because that is what a disassembler does with padding.
`ORI.B #0,D0` is `0000 0000`; `MOVEQ #97,D0` is `7061`, the ASCII "pa" left over
from a preceding string.

They aligned the ORIGINAL's layout, and the maximum-C image does not have that
layout: 235,436 CODE bytes against the reference's 211,348, every function a
different size, and `gen_units.py` coalescing to 4-byte boundaries by itself.

**They could not be converted, only removed, and that was measured.**
`char p[2] = {0,0}`, `char p[2] = "\0"` and the `const` form all emit
`HUNK_DATA` with `HUNK_CODE` of zero. Bytes reach the code section only as
instruction operands inside a function, and no C emits exactly `DC.W 0` -- an
empty function is `RTS`, `0x4E75`.

Each is replaced by a deliberately empty translation unit, `src/c/pad_*.c`. One
file per module, because `gen_all_manifest.py` de-duplicates extra rows by C
FILE and that guard is worth keeping: two modules sharing a real restoration
would link duplicate symbols.

The assembly modules stay on disk; `src/Prevue.asm` is what the byte-exact build
assembles.

Verified byte-identical output on a replayed listings feed, plus both byte
gates, all audits and a soak.

## What DID move, and the pattern that moved it

Four CODE-section strings were retired on 2026-08-04:

| string | was in | now |
|---|---|---|
| `"dos.library"` | `groups/_main/a/a_strings.s` | local in `ESQ_StartupEntry` |
| `"*** Break: "` | `submodules/unknown36_p0_strings_local.s` | local in `UNKNOWN36_ShowAbortRequester` |
| `"intuition.library"` | `submodules/unknown36_p0_strings_local.s` | local in `UNKNOWN36_ShowAbortRequester` |
| `DOS_STR_CRLF` | `submodules/unknown2b_p1_p0.s` | local in `STREAM_BufferedPutcOrFlush` |

Each is built A CHARACTER AT A TIME into a stack local, the way
`console_name()` in `lib_parse_command_line_and_run.c` already did. That keeps
the text in CODE where the original has it and needs no symbol at all, so the
module that held it contributes nothing and is replaced by a deliberately empty
translation unit (`src/c/strings_now_local_*.c`).

**The assembly modules STAY on disk.** `src/Prevue.asm` is what the byte-exact
build assembles; only the maximum-C build replaces them. Removing a module
would move every byte after it and fail `test-hash.sh`.

**The pattern applies when, and only when, nothing holds the string's ADDRESS.**
`unknown36_p0_strings.s` had to be split in two for exactly this reason: two of
its five strings had only C readers and moved, three are in a tag chain and
could not.

This took the residual from 160 bytes to 100.

## One trap this work exposed

`ESQ_StartupEntry` is the first byte of the CODE section -- the OS enters the
program at offset 0. SAS/C lays functions out in SOURCE ORDER, so a `static`
defined earlier in `lib_esq_startup_entry.c` lands at offset 0 and **the OS
enters that instead**.

Writing the `"dos.library"` helper above the entry point did exactly that. The
map showed `_ESQ_StartupEntry` at 0x36 and ESQ exited instantly with
`esq failed returncode 114`, having run the string builder with the command
line in A0 and returned through its RTS.

No byte gate can see it, and the soak's statistics read HEALTHY while it
happened. The check is one line:

```sh
grep "_ESQ_StartupEntry" build/ESQ.map      # must be 0x00000000
```

Helpers in that file are now defined BELOW the entry point and only prototyped
above it, because a prototype emits nothing.

## Status of the whole conversion

| measure | value |
|---|---|
| maximum-C build | **100% C** -- 0 assembly bytes in the linked image |
| maximum-C manifest | 878 entries |
| executable assembly | none |
| `tools/worklist.py 99999` | 0 functions, 0 bytes remaining |
| coverage by byte | 99.4% (732 of 753 application functions) |
| byte-exact restorations | 34 files |
| both byte gates | green |

The 21 labels `coverage.py` still counts as unrestored are interior branch
targets and fall-through fragments inside functions that ARE restored; twenty
of them are in `diskio1.s`, the module AGENTS.md documents as "26 labels and
ONE function".
