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
assembly converted to C   97.2%   [#######################################.]
                                  188,352 of 193,848 application bytes
```

Count the bytes, not the functions. The easy targets are small, so a function
count reads higher than the real progress. By function count the same work is
94%, which flatters it.

Run `python3 tools/coverage.py` to regenerate every number in this section.

| measure | value |
|---|---|
| application functions | 730 (193,848 bytes) |
| restored to C | 689 (188,352 bytes, 97.2% by byte, 94% by count) |
| byte-exact restorations | 29 |
| source modules | 981, coalesced into 494 link units |
| linked size | CODE 211,348 bytes, DATA 55,820 bytes |

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
That is why 788 source modules become 401 link units. You can still edit any
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
```

Five manifests exist, each for a different question:

| manifest | entries | what it is for |
|---|---:|---|
| `replacements.txt` | 22 | byte-exact only, so the build must stay content-identical |
| `replacements-runnable.txt` | 278 | proven on all six ESC-menu items |
| `replacements-tranche.txt` | 293 | the largest set proven without `ESQ_FARCALLS` |
| `replacements-all.txt` | 391 | every restoration, judged by running it |
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
python3 tools/framecolor.py <label-a> <label-b>             # compare two runs by colour
```

ESQ redraws a clock every second. Identical consecutive frames therefore mean
the display stopped, which is a hang the boot probe cannot see.

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
