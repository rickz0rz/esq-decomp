# The 100 bytes that are still assembly

Last measured 2026-08-04 from `build/ESQ.map` on the 864-entry maximum-C
manifest.

```
maximum-C build, CODE hunk    235,484 bytes
  from compiled C             235,384      99.958%
  from assembly                   100       0.042%
```

**Every function in ESQ is compiled C.** Not one of these 100 bytes is
executable. Regenerate the table below at any time:

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
| 8 | 0x037b9c | `submodules/unknown10_p1.s` | padding |
| 4 | 0x039644 | `submodules/unknown40_p1.s` | padding |
| 4 | 0x038578 | `submodules/unknown22_p1.s` | padding |
| 4 | 0x03745c | `submodules/unknown2b_p1_p1.s` | padding |
| 4 | 0x0356cc | `groups/b/a/tliba3_p5_p0_p1.s` | padding |
| 4 | 0x023e88 | `groups/a/z/locavail2_p0.s` | padding |
| 4 | 0x022d24 | `groups/a/x/ladfunc2_p1.s` | padding |
| 4 | 0x01f2a0 | `groups/a/t/gcommand2_p1.s` | padding |
| 4 | 0x00e2e8 | `groups/a/j/dst2_p2.s` | padding |
| 4 | 0x007e90 | `groups/a/f/ctasks_p1.s` | padding |
| 4 | 0x0045ac | `groups/a/c/cleanup2_p1_p0_p1.s` | padding |
| 4 | 0x000b04 | `groups/a/a/app_p2.s` | padding |
| 4 | 0x000558 | `groups/_main/b/bb_p1.s` | padding |

**44 bytes of string data. 56 bytes of alignment padding. 0 bytes of code.**

## Block 1: 44 bytes of strings that CANNOT move

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
   strings (below) cannot be used here.
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

## Block 2: 56 bytes of alignment padding

Thirteen modules whose entire content is `ALIGN_WORD` -- which `src/macros.s`
defines as `DC.W $0000`, two bytes -- plus `submodules/unknown10_p1.s`, eight
bytes the disassembler rendered as instructions and which are really the tail
of a string plus filler. Each 2-byte pad becomes 4 in the map because a hunk
object is longword-sized.

**These could be deleted and deliberately are not.** Replacing each pad module
with an empty translation unit would take the figure to 44 bytes and 99.98%,
and it was tested. It is rejected on principle:

> Alignment filler is not assembly waiting to become C. It is content the
> original image contains. Deleting it would make the rebuild LESS faithful in
> exchange for a decimal place, and this project's product is a faithful
> reconstruction.

There is also no C construct that emits inter-module padding into the code
section, so "converting" them was never on the table -- only removing them.

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
| maximum-C build | 99.958% C by CODE byte |
| executable assembly | none |
| `tools/worklist.py 99999` | 0 functions, 0 bytes remaining |
| coverage by byte | 99.4% (732 of 753 application functions) |
| byte-exact restorations | 34 files |
| both byte gates | green |

The 21 labels `coverage.py` still counts as unrestored are interior branch
targets and fall-through fragments inside functions that ARE restored; twenty
of them are in `diskio1.s`, the module AGENTS.md documents as "26 labels and
ONE function".
