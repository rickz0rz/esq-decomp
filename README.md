# esq-decomp

A reconstruction of ESQ, the Prevue Guide channel-listings program for the
Amiga. The name is short for "Esquire". The software is abandoned. The goal is
a source tree that builds back to the original binary, byte for byte. The
second goal is to move as much of that tree as possible from assembly to C.

Every change must survive a build that proves byte equivalence. Nothing else
counts as evidence. Earlier attempts at this program chased behavioral
equivalence instead, and each one failed the same way. Small unexplained fixes
accumulated until the result stopped working. Nobody could then name the change
that broke it.

## Status

Both byte gates pass on the current tree.

```
assembly converted to C   99.4%   [########################################]
                                  193,894 of 195,146 application bytes
```

`tools/worklist.py 99999` now reports **0 functions and 0 bytes remaining**.
Every unrestored label left in `coverage.py`'s survey is an interior branch
target or a fall-through fragment inside a function that IS restored -- twenty
of the twenty-one are in `diskio1.s`, the module this project already documents
as "26 labels and ONE function".

Count the bytes, not the functions. The easy targets are small, so a function
count reads higher than the real progress. By function count the same work is
97%, which flatters it.

Run `python3 tools/coverage.py` to regenerate every number in this section.

| measure | value |
|---|---|
| application functions | 753 (195,146 bytes) |
| restored to C | 732 (193,894 bytes, 99.4% by byte, 97% by count) |
| byte-exact restorations | 31 application functions, plus 3 library functions (34 files) |
| source modules | 1,033, coalesced into 539 link units |
| DATA section in C | 55,820 of 55,820 bytes (100%) |
| linked size | CODE 211,348 bytes, DATA 55,820 bytes |

### The maximum-C build

`coverage.py` measures the restoration lane and its universe is not the whole
program, so it cannot answer "how much of the built binary is C". Read the link
map for that. A contributor in `build/ESQ.map` whose name ends `.asm` is
assembly and everything else is C.

```
maximum-C build, CODE hunk   99.96%  [########################################]
                                     235,384 of 235,484 bytes come from C
```

| measure | value |
|---|---|
| maximum-C manifest | 861 entries (`src/c/replacements-all.txt`) |
| assembly remaining | 100 of 235,484 CODE bytes (0.04%) |
| module includes still assembly | 173, of which 150 are EMPTY and 10 are pads |
| modules holding real code | ZERO (`python3 tools/lastmile.py`) |

**No executable assembly is left.** Every function in the program is compiled
C. The 100 bytes that remain are 44 bytes of string constants and 56 bytes of
alignment padding, spread over 14 modules.

Four other CODE-section strings were retired by building them a character at a
time into stack locals, which keeps the text in CODE where the original has it.
The three that remain cannot move: `data_wdisp_p1.c` builds a requester tag
chain holding their ADDRESSES, so they need real linkable symbols, and a C
definition would be an initialised static in `data` -- and a DATA hunk that
grows shifts every symbol after it and freezes the display.

The 56 bytes of padding could be deleted to reach 44, and deliberately are not.
Alignment filler is not assembly waiting to become C; it is content the
original image contains, and removing it would make the rebuild less faithful,
not more.

**`docs/remaining-assembly.md` is the byte-by-byte record**: every one of the
100 bytes with its address and module, why each of the two blocks cannot be
converted, what would unblock them, and the pattern that retired four other
strings to get here.

Three things once recorded as impossible are now done. The SAS/C arithmetic
helpers are C (`src/c/lib_math_helpers.c`), so every divide and multiply in the
program runs through compiled code. The vertical-blank interrupt server is C as
well, and it needed no special keyword. And the startup and shutdown pair is C,
which AGENTS.md had identified as a setjmp/longjmp problem. All three are
written up under "The last mile to 100% C" in `AGENTS.md`.

ONE LIVE FUNCTION IS AN ANALOGUE RATHER THAN A TRANSCRIPTION, and it is the
only one. `ESQ_ShutdownAndReturn` restores the stack pointer the entry saved
and returns on the restored stack, so the program can leave from any depth. No
C statement expresses that. setjmp/longjmp is the right answer and is not
available: `sc.lib` cannot be linked at all, and its `setjmp.o` needs
`___base` and `___top`, which a NOSTKCHK build never defines. It uses
dos.library `Exit()` instead, and `src/c/lib_esq_shutdown_and_return.c` states
the two behavioural differences that costs.

Moving the divide helpers meant removing a hidden dependency first: they return
the quotient in D0 **and the remainder in D1**, which is how SAS/C implements
`%`. Every `%` in `src/c` was rewritten as `a - (a / b) * b`.
`tools/d1_remainder_audit.py` proves no caller reads D1, and it must report zero
before those helpers may be linked.

A restoration is **exact** when the compiler emits the original bytes. It is
**behavioural** when the code does the same work with different bytes. Most
restorations are behavioural, because SAS/C 6.51 encodes calls differently from
the compiler that built the original. `docs/compiler-version.md` records the
hunt for the real one.

## The two gates

```sh
./test-hash.sh      # monolithic vasm build, exact SHA-256 match
./build-split.sh    # separately assembled and linked build, content match
```

`test-hash.sh` hashes the whole file against
`6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`.

`build-split.sh` compares content: hunk count, sizes, memory flags, every byte,
and the full relocation set. It does not compare the relocation table encoding,
because that is a linker artifact with no runtime meaning. It also scans every
16-bit PC-relative call for silent truncation and stops the build on a hit.

If a change cannot keep both gates green, it does not go in. Revert it and pick
another approach. A red gate is information, not an obstacle. Never patch bytes
by hand or special-case the build to close a gap.

There is one deliberate exception, and it is a build flag rather than a change.
`fixEscMenuExitDisplayMode` in `src/Prevue.asm` corrects a defect in the original
program: closing the ESC menu paints the ad window light grey and never clears
it. The flag defaults to 0, so `test-hash.sh` stays green. At 1 the monolithic
image differs by exactly one byte and no code moves, so `build-split.sh` stays
green at both settings. Set it for any build you intend to run:

```sh
ESQ_FIX_ESCMENU=1 ./build-split.sh
```

AGENTS.md records the evidence, including the four builds that show the defect
is original, and the regression test that now guards it.

The reference hash is not the shipped ESQ. It is a vasm rebuild of a lightly
forked disassembly. The fork changes `DF0:` paths to `DH2:`, adds an
`InjectCTRL` subfunction, and changes the version string. The true original is
about 400 code bytes larger. See `docs/reference-binary.md`.

## Toolchain

| tool | role |
|---|---|
| `vasmm68k_mot` | assembler, `-Fhunkexe` for the monolith and `-Fhunk` for objects |
| `vlink` | links the split build |
| SAS/C 6.51 under `vamos` | the only compiler for the C phase |

Do not use the GCC or vbcc cross-compilers for restoration work. Neither one
reproduces SAS/C codegen byte for byte. They are fine for scratch experiments
and wrong for committed output.

`build.sh` writes a binary straight to the emulator directory.
`stage-builds.sh` builds every variant and records a hash manifest.

## Layout

```
src/Prevue.asm     module list and link order, and the monolithic build root
src/*.s            shared headers: LVO offsets, hardware addresses, structs,
                   macros, string macros, text formatting, exec constants,
                   data offsets, data lengths
src/modules/**.s   code, one source module per file
src/data/*.s       data, one source module per file
src/c/*.c          C restorations, one function per file
src/c/*.txt        replacement manifests
tools/             build, comparison, and emulator harness scripts
docs/              file formats, the compiler hunt, and the reference binary
build/units/       generated link units, not checked in
```

`src/Prevue.asm` stays authoritative. It declares what is in the program and in
what order. `tools/gen_units.py` reads it to produce the link units, so the two
builds cannot disagree about content or ordering.

Hunk objects store section sizes in longwords. An object whose content is 2
modulo 4 bytes gets padded, which shifts everything after it. `gen_units.py`
therefore joins consecutive modules until each unit lands on a 4-byte boundary.
That is why 1,015 source modules become 531 link units. You can still edit any
module on its own.

## The C phase

Replace assembly with C one leaf subroutine at a time. Compile it with SAS/C
6.51. Accept the result when the emitted bytes match the assembly it replaces.
If a function does not match, leave it in assembly and move on. A partial
decompilation that builds correctly is worth more than a complete one that does
not.

```sh
tools/cmatch.sh <file.c> <Label>            # compile and diff against the reference
tools/cdiff.sh  <file.c> <Label>            # size delta and differing regions
python3 tools/refbytes.py <Label>           # reference bytes from the original
python3 tools/coverage.py                   # progress by byte and by count
python3 tools/mismatches.py --recheck       # recompile every restoration and report
```

Build with C replacements through a manifest:

```sh
C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh
python3 tools/verify_restorations.py
/tmp/.capvenv/bin/python tools/a6_audit.py
python3 tools/data_shape_audit.py           # does a C extern deref as often as the original
python3 tools/extern_width_audit.py         # is a C extern narrower than the original reads it
python3 tools/data_adjacency_audit.py       # where the code reads across a data symbol boundary
python3 tools/merge_module_c.py --verify    # one C unit per module, from the per-function files
```

`build-split.sh` runs the first two audits itself on any build that sets
`C_REPLACEMENTS`, and stops the build on a hit. They catch two errors that no
byte check can see: reading a global one level too shallow, and declaring a word
global one byte wide so the read takes the high half.

`data_adjacency_audit.py` answers a question the DATA section raises rather than
the code: which symbols the program reads across. There are eight, and each has
to become one struct before `src/data` can stop being assembly.

`merge_module_c.py` builds one C unit per module out of the per-function
restorations, for modules `split_module.py` cannot cut. Always pass `--verify`:
it compiles each candidate, which is the only way to catch a forward declaration
that disagrees with the definition it names.

Five manifests exist, each for a different question:

| manifest | entries | what it is for |
|---|---:|---|
| `replacements.txt` | 23 | byte-exact only, so the build must stay content-identical |
| `replacements-runnable.txt` | 278 | proven on all six ESC-menu items |
| `replacements-tranche.txt` | 293 | the largest set proven without `ESQ_FARCALLS` |
| `replacements-all.txt` | 790 | every restoration, judged by running it |
| `replacements-canary.txt` | 20 | a deliberate mismatch, to prove the gate can fail |

`replacements-all.txt` needs `ESQ_FARCALLS=1`. That flag widens the assembly's
own 16-bit PC-relative references, which used to cap how much C the program
could hold. It must stay off for `replacements.txt`, and both byte-exact gates
run without it.

`build-split.sh` reports DIFFERS for any build that contains a behavioural
restoration. That is expected. The size growth must equal the sum of the
per-object rounding, and `verify_restorations.py` checks that.

## Running it

Byte gates cannot judge a build full of behavioural restorations. Such a build
has to run. Three harnesses drive FS-UAE without an operator:

```sh
tools/probe_esq.sh     <binary> <label> [secs]              # does it boot
tools/soak_esq.sh      <binary> <label> [total] [gap]       # minutes, plus a freeze check
tools/menusweep_esq.sh <binary> <label> [items] [reps]      # all six ESC-menu items
tools/keyprobe_esq.sh  <binary> <label> <key:wait>...       # one boot, arbitrary keys
tools/escwatch_esq.sh  <binary> <label> [open] [shots] [gap] # ESC on, ESC off, then watch
python3 tools/framecolor.py <label-a> <label-b>             # compare two runs by colour
python3 tools/menuresidue.py <png>...                       # ESC-menu grey left on screen
```

ESQ redraws a clock every second. Identical consecutive frames therefore mean
the display stopped, which is a hang the boot probe cannot see.

`escwatch_esq.sh` covers the one path the other harnesses never reached: closing
the ESC menu. It presses ESC twice and then shoots on a timer with no further
input, so a permanent fault reads differently from a redraw still in progress.
It exits nonzero if the menu background survives the close.

A build can animate correctly and still draw the wrong picture, because a wrong
constant changes a colour without stopping the display. Soak the known-good
binary under its own label, then run `framecolor.py` against the candidate. Read
the ranges it prints, not the medians: overlapping ranges are the display cycle,
and a disjoint range is a real difference.

Read the harness notes in `AGENTS.md` before you trust a result. A PASS is
reliable and a FAIL is not, because a busy host can miss the marker.

## Documentation

- `AGENTS.md` — the working agreement, and the first thing to read
- `docs/tranche-target.md` — the current restoration target and the loop to follow
- `docs/blocked-shapes.md` — what cannot be restored, and what each class would take
- `docs/reference-binary.md` — what the reference hash is and is not
- `docs/compiler-version.md` — known codegen divergences and the compiler hunt
- `docs/*-format.md` — the on-disk data formats ESQ reads
- `docs/runtime-bisect.md` — how to attribute a runtime fault to one change
- `README` — legacy notes from the original disassembly effort

## Writing

Write documentation and comments in ASD-STE100 Simplified Technical English.
Use the `ste-writing-skill` skill. `AGENTS.md` gives the rule and the install
link.
