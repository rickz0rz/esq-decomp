# The 44 bytes that are still assembly

Last measured 2026-08-06 from `build/ESQ.map` on the 877-entry maximum-C
manifest.

```
maximum-C build, CODE hunk    235,436 bytes
  from compiled C             235,392      99.981%
  from assembly                    44       0.019%
```

**Every function in ESQ is compiled C**, and every byte of alignment padding is
gone too. What remains is ONE module holding three strings.

Regenerate the table below at any time:

```sh
ESQ_FARCALLS=1 SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
  C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh
python3 tools/lastmile.py
```

A contributor in `build/ESQ.map` whose name ends `.asm` is assembly. Everything
else is C.

## The inventory

| bytes | address | module | kind |
|---:|---|---|---|
| 44 | 0x03949c | `submodules/unknown36_p0_strings.s` | string data |

That is the whole list. It was fourteen modules and 100 bytes until 2026-08-06,
when the thirteen alignment-padding modules were dropped -- see "Retired: 56
bytes of alignment padding" below for what changed and why.

## The floor: 44 bytes of strings that CANNOT move

`src/modules/submodules/unknown36_p0_strings.s` holds three constants:

```
_DEBUG_STR_UserAbortRequested:  "** User Abort Requested **",0,0
_DEBUG_STR_Continue:            "CONTINUE",0,0
_DEBUG_STR_Abort:               "ABORT",0
```

They are the Ctrl-C break requester's body and button text, and they are
**pointed at by a DATA TABLE**. `src/c/data_wdisp_p1.c` builds:

```c
struct DEBUG_AbortRequesterTagChain_t DEBUG_AbortRequesterTagChain = {
    ..., (char *)DEBUG_STR_UserAbortRequested, ...,
    ..., (char *)DEBUG_STR_Continue, ...,
    ..., (char *)DEBUG_STR_Abort, ... };
```

That is what closes the door, and it closes it twice over:

1. **They need real linkable addresses.** A stack local has no address the
   linker can write into a table, so the trick that retired the other four
   strings ("What DID move" below) cannot be used here.
2. **A C definition would grow the DATA hunk.** SAS/C 6.51 places every string
   literal and every initialised static in `data`, with no option to place it
   elsewhere. AGENTS.md records that a DATA hunk which grows by even four bytes
   shifts every symbol after it and FROZE THE DISPLAY -- measured twice on
   `data/flib.s`, and again on a 16-byte static in `lib_hex_parse_sprintf.c`.

The original keeps them in the CODE section and reaches them PC-relative, which
is a thing the C compiler cannot be asked to do.

**What would unblock it:** a compiler that can place a constant in the code
section, or a linker script that moves SAS/C's `data` output for these three
objects only without disturbing the rest. Neither is available in this
toolchain.

### ...and the PORTABLE build RUNS. The growth rule was a conflation

```sh
tools/portable_build.sh
```

The three become ordinary string literals in `src/c/data_debug_abort_strings.c`
and the assembly contribution goes to **ZERO**. The DATA hunk grows 55,820 ->
55,864, which this document and AGENTS.md both said would freeze the display.

**It does not. Measured 2026-08-06, three independent boots:**

| check | result |
|---|---|
| `soak_esq.sh` x2 | PASS -- 10/10 distinct frames, 10/10 Amiga content, 1 exception line |
| `listings_esq.sh` on a replayed feed | PASS -- `curday.dat` 42 -> 1017 bytes |
| `curday.dat` against the assembly control | **byte-identical** |
| `data_offset_audit` / `check_pcrel_range` | clean |

**Why it survives, and what the real invariant is.** Nothing in ESQ depends on
the ABSOLUTE offset of a data symbol, because the linker relocates every
absolute reference. ESQ depends on the DISTANCE BETWEEN two data symbols, and
it does so in three places no relocation can correct:

1. The 59 `Global_*` equates in `src/Prevue.asm`. Each is a fixed displacement
   from `_Global_REF_LONG_FILE_SCRATCH`, the A4 near-data base at DATA offset
   `0x8000`. Eleven point into unlabelled space inside a reserved block.
2. `src/c/esq-neardata.h`, which writes the same displacements as
   `<symbol> + <number>` -- 102 of them.
3. The eight adjacencies where code reads ACROSS a symbol boundary, listed in
   AGENTS.md.

The 44 bytes land at DATA offset **0**, in front of every pre-existing symbol,
so the whole image shifts as one piece. The A4 base moves `0x8000` -> `0x802c`,
exactly 44, and every distance above is preserved. Read the map to confirm:

```sh
grep -E '_Global_REF_LONG_FILE_SCRATCH|_DEBUG_STR_' build/ESQ.map
```

**`data/flib.s` was the other kind of change, and it was never about size.**
Its conversion hit the `char X[] = "..."` padding bug, which drops a pad byte
and moves symbols RELATIVE TO EACH OTHER inside the module. That is a broken
distance, not a shifted image. `tools/data_offset_audit.py` was written after
that finding and detects exactly it; the portable build passes it clean.

So the rule "a DATA hunk that grows by four bytes freezes the display" merges
two different things. State it as:

> **Growth at the FRONT of the DATA hunk is free. Growth in the MIDDLE is
> fatal.** What must be preserved is the distance between pre-existing symbols,
> not the size of the hunk.

The two builds still differ by one manifest row and one define, and the
byte-exact gates are untouched either way:

| build | assembly | runs on the box |
|---|---:|---|
| `C_REPLACEMENTS=src/c/replacements-all.txt` | 44 bytes | yes |
| `tools/portable_build.sh` | **0 bytes** | **yes** |

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
| maximum-C build | 99.981% C by CODE byte |
| executable assembly | none |
| `tools/worklist.py 99999` | 0 functions, 0 bytes remaining |
| coverage by byte | 99.4% (732 of 753 application functions) |
| byte-exact restorations | 34 files |
| both byte gates | green |

The 21 labels `coverage.py` still counts as unrestored are interior branch
targets and fall-through fragments inside functions that ARE restored; twenty
of them are in `diskio1.s`, the module AGENTS.md documents as "26 labels and
ONE function".
