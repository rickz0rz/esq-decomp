# ESQ decompilation — working agreement

Reverse-engineering of ESQ, the Prevue Guide channel-listings program for the
Amiga. Abandoned software; the goal is a faithful, buildable reconstruction.

## The prime directive

**Every change must be proven byte-equivalent by a build. No exceptions.**

This project has been attempted several times before and failed each time. The
failure mode was always the same: chasing *behavioural* equivalence, which has
no objective pass/fail signal, so small unexplainable hacks accumulated until
the result no longer worked and nobody could say which change broke it.

There are two gates. Both must be green before any change is considered done:

```sh
./test-hash.sh      # monolithic vasm build == 6bd4760d…  (exact SHA-256)
./build-split.sh    # separately-assembled+linked build == reference content
```

If a change cannot be made to keep both green, **it does not go in.** Revert it
and pick a different approach. Do not "fix" a mismatch by hand-patching bytes,
inserting inline assembly, or special-casing the build. A red gate is
information, not an obstacle.

## What "binary equivalent" means here

`test-hash.sh` compares the whole file. `build-split.sh` compares *content*:
hunk count, sizes, memory flags, every byte, and the complete relocation set —
but not relocation table *encoding*. Encoding is a linker artifact with no
runtime meaning, and the genuine original ESQ used a different encoding than
vasm emits, so demanding an exact byte match on it would be matching an accident
of the rebuild rather than the program.

Be aware the reference hash is **not** the shipped ESQ. It is a vasm rebuild of
a lightly-forked disassembly (`DF0:`→`DH2:` paths, an added `InjectCTRL`
subfunction, changed version string). The true original is ~400 code bytes
larger. See `docs/reference-binary.md`.

## Toolchain

| Tool | Role |
|---|---|
| `vasmm68k_mot` | assembler; `-Fhunkexe` for the monolith, `-Fhunk` for objects |
| `vlink` | links the split build |
| SAS/C **6.51** under `vamos` | the *only* compiler for the C phase |

SAS/C 6.51 lives on the `sasc:` volume (`~/.vamosrc` already assigns
`sc:`/`include:`/`lib:`). Its own linker `slink` is at `sc:c/slink`.

**Do not use the GCC or vbcc cross-compilers for restoration work.** Neither can
reproduce SAS/C codegen byte-for-byte, and attempting it is what sank earlier
attempts. They are fine for scratch experiments, never for committed output.

## Layout

```
src/Prevue.asm     canonical module list and link order; also the monolithic build root
src/*.s            shared headers: lvo-offsets, hardware-addresses, structs, macros,
                   string-macros, text-formatting, exec-constants, data-offsets, data-lengths
src/modules/**.s   code, one source module per file
src/data/*.s       data section, one source module per file
tools/gen_units.py derives link units from Prevue.asm
tools/hunkcmp.py   content-equality comparator
build/units/       generated translation units (not checked in)
```

`src/Prevue.asm` stays authoritative: it declares what is in the program and in
what order. `gen_units.py` reads it to produce the units, so the two builds can
never silently disagree about content or ordering.

## Two constraints that will bite you

Both were discovered the hard way; both are enforced by `build-split.sh`.

**1. Objects are longword-sized.** Hunk objects store section sizes in
longwords, so an object whose content is 2 (mod 4) bytes gets padded, shifting
everything after it. `gen_units.py` therefore coalesces consecutive modules
until each unit lands on a 4-byte boundary — which is why 164 source modules
become 69 link units. Source files stay fine-grained; only the assembly grouping
is coarser. **You can still edit any module in isolation.**

**2. vasm rewrites branches based on what is visible.** A bare
`JSR sym` / `JMP sym` is silently encoded as `BSR.W`/`BRA.W` when `sym` is in the
same section and in range, but as a 6-byte absolute when it is external. Split
the file differently and the encoding changes underneath you. All 48 affected
sites are now written explicitly (`BSR.W foo`, not `JSR foo`).

*When adding or moving code, always write the branch width you mean.* If a unit
grows unexpectedly, this is almost certainly why — diff the vasm listings
(`-L file.lst`) of the two builds and compare per-source-line encoding sizes.

## Build variants

`includeCustomAriAssembly` at the top of `src/Prevue.asm` gates Ari's debug
instrumentation (a serial status dump). It guards one block in
`src/modules/groups/a/o/esqpars.s` and one in `src/data/wdisp.s`.

- `= 0` (default) — the shipping program. This is what `test-hash.sh` checks.
- `= 1` — adds 128 code bytes, 52 data bytes, 11 relocations. `test-hash.sh`
  will *not* match, and should not; `build-split.sh` still must pass, because it
  compares the split build against a monolith built with the same settings.

**Both settings must keep `build-split.sh` green.** Check the `= 1` path after
touching exports or module structure — it is easy to break without noticing,
since the default build says nothing about it.

> `XDEF` for a symbol defined inside an `if` block must live *inside* that same
> block. Exporting a symbol that the conditional excluded is an error, so a
> top-of-file export block is wrong for conditional code — see the `XDEF` next
> to `WDISP_FMT_CTRLH_STATUS_MAX` in `src/data/wdisp.s`.

## Constants that used to resolve by accident

Under one big assembly, any symbol could reference any other. With separate
assembly that is gone, so a few genuinely-constant values were hoisted into
headers:

- `src/exec-constants.s` — `MEMF_*`, previously stranded inside a code module.
- `src/data-offsets.s` — fixed offsets between DATA labels (e.g.
  `Offset_RastPort2_FromDisplayContextBase = 8`), previously written inline as
  label-difference expressions.
- `src/data-lengths.s` — string lengths consumed by code. Each is re-verified by
  an `assert` at its original site in `src/data`, so editing the data without
  updating the header **fails the build** instead of silently desyncing.

Never add a hardcoded constant without an `assert` tying it back to the thing it
describes.

## Driving SAS/C (read before your first compile)

```sh
tools/cmatch.sh <file.c> <FunctionLabel> [extra sc options]   # compile + diff vs reference
python3 tools/refbytes.py <FunctionLabel>                     # reference bytes from the original
python3 tools/objbytes.py <file.o>                            # bytes/xdefs/xrefs of a compiled object
```

Three invocation rules, each of which silently produces wrong conclusions if
broken:

1. **Options must come BEFORE the source filename.** `sc FOO=bar file.c`, never
   `sc file.c FOO=bar`. Options placed after the filename are accepted without
   complaint and have no effect — every compile looks identical and you will
   conclude, wrongly, that the flags do nothing.
2. **`NOSTKCHK` is mandatory.** By default `sc` emits a stack-check prologue
   (`CMPA.L (d16,A4),A7` / `BCS.W`, referencing `__XCOVF` and `___base`). The
   stock binary has none, so without this flag *every* function mismatches by 8
   leading bytes.
3. **Option names are not guessable.** They use embedded-capital abbreviations —
   `STacKCHecK` → `STKCHK`, `STacKEXTend` → `STKEXT`, `OPTimizerPEEPhole` →
   `OPTPEEP`, `SHORTINTegers` → `SHORTINT`. Extract the full list with
   `strings sc | grep -E '^[A-Z][A-Za-z]{3,24}$'`. Invalid options *are*
   rejected, so a silent no-op means rule 1, not a bad name.

Note `sc5` is the same 6.51 driver in v5-compatibility mode, not a second
compiler version.

## Swapping a function to C

```sh
./build-split.sh                                             # pure asm, byte-exact gate
C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh       # with C replacements
```

`src/c/replacements.txt` maps a module path to a C file. `gen_units.py` drops
that module from the assembly units and links the compiled object **at exactly
the position the module occupied**, so link order and layout are preserved. The
default build ignores the manifest entirely, which is what keeps the byte-exact
gates meaningful.

Two things must line up or the link fails:

- **Symbol names.** `sc` emits `_foo` for `foo`; `NOUSCORE`/`NOUNDERSCORE` are
  accepted but inert. So assembly must refer to a C-restored function by its
  real SAS/C name — rename the label *and* its references to `_foo`. This is
  byte-neutral (labels do not affect encoding), so `test-hash.sh` stays green.
  Use a word-boundary match: `\bfoo\b` will not touch `SOME_JMPTBL_foo`, since
  `_` is a word character.
- **Section names.** `sc` emits into `text`/`data` by default, which vlink keeps
  as separate output sections from `S_0`/`S_1`. The program's 3072 explicit
  `(sym,PC)` operands then become cross-section 16-bit PC-relative relocations,
  which amigahunk executables cannot represent ("Unsupported relocation type
  R_PC"). Always compile with `CODENAME=S_0 DATANAME=S_1`.

## Extracting one function into its own module

Replacement is per-module, so a function inside a multi-function `.s` must be
split out first. `NEWGRID_GetGridModeIndex` is the worked example: the module
becomes three files (before / the function / after), `src/Prevue.asm` gains two
extra includes at the same position, and the hash is unchanged because content
and order are identical.

When splitting, **distribute the top-of-file `XDEF` block** so each part exports
only what it defines — an `XDEF` for a symbol that ended up in another file is
an error. Verify with `test-hash.sh` before going near C.

`tools/split_module.py` does all of this, including for many labels at once, and
both gates must stay green across a split — content and order are unchanged, so
a split that moves the hash is a bug in the tool.

**A piece's filename can collide with a real module.** The natural name for a
trailing piece is `<base>_pN.s`, but `_pN` is also how the original disassembly
named its own continuation modules: splitting `cleanup2.s` wrote a piece called
`cleanup2_p1.s` directly over the existing `cleanup2_p1.s` and its 15 functions.
The gates caught it only because the clobbered module was in the same build. The
tool now refuses any name that already exists on disk; if you extract by hand,
check the name first.

## Never include `<proto/*.h>`

Use `src/c/esq-dos.h`, `esq-exec.h`, `esq-graphics.h` instead. They are the stock
headers with the library base declared **`volatile`**.

SAS/C assumes A6 survives a call, so having loaded a library base for one call it
reuses the register for the next. ESQ's assembly does not honour that —
`MEMORY_AllocateMemory` loads `AbsExecBase` into A6 and returns without restoring
it — so the following `JSR _LVOInfo(A6)` enters **exec** at the dos offset and
resets the machine. `volatile` forces the reload, which is what the original does
anyway (three separate `MOVEA.L Global_REF_DOS_LIBRARY_2,A6` in one function).

The `reload-vs-cache` divergence recorded in several files was never cosmetic; it
was this bug. Full write-up and the exec-specific wrinkle: `src/c/esq-libbase.md`.

### The one exception: `esq-graphics-leaf.h`, for functions that call nothing else

The hazard above is an intervening call to **ESQ assembly**. AmigaOS library
functions preserve A6 (only D0/D1/A0/A1 are volatile across one), so a base
cached across nothing but library calls is safe — and the original relies on
exactly that: `TLIBA3_DrawInnerFrameBorder` loads the base once and issues four
`Move`/`Draw` calls on it. Forcing a reload there is not fidelity, it is **our**
artifact, +6 bytes a site the original never had (18 on that one function).

So `src/c/esq-graphics-leaf.h` is the same header with a non-volatile base, for
use **only** in a function whose every call is a library call — i.e. the
`no-calls` bucket in `coverage.py`. Say so in the file's header comment when you
use it.

**What makes this safe rather than a footgun is that `tools/a6_audit.py` already
draws the line in the right place.** Read its `audit` loop: a `jsr d16(a6)` leaves
the base live, a `jsr`/`bsr` to a symbol clears it. So adding an ESQ call to a
leaf file makes the audit flag the next library call and exit nonzero. The
precondition is machine-checked. If a6_audit flags a leaf file, switch it back to
`esq-graphics.h` — do not silence the audit.

Two measured results worth knowing before you reach for it:

- **It reproduced the original's reload pattern exactly**, which is the real
  argument for it. `_BEVEL_DrawHorizontalBevel` loads the base **twice** in the
  original — once up front, once after the pattern-reset stores — and 6.51 under
  the leaf header emits the same two loads in the same places. Both compilers
  treat a store through the rastport pointer as possibly aliasing the base. The
  volatile header would have emitted eight.
- **The alias behaviour is not option-selectable.** `OPTIMIZE`,
  `OPTIMIZERALIAS` and `NOOPTIMIZERALIAS` were tried and none changed it.

There is deliberately **no** `esq-dos-leaf.h` or `esq-exec-leaf.h`: the DOS
functions restored so far reload the base before every call in the original
anyway (`BRUSH_StreamFontChunk` does it twice for two `Read`s), so the volatile
header is already exactly right there and a leaf variant would buy nothing.

```sh
/tmp/.capvenv/bin/python tools/a6_audit.py     # run after any C build
```

Flags every `JSR d16(A6)` reached with a call in between and no reload; exits
nonzero if any remain. It found 14 of 232 restorations broken. **No byte gate can
see this** — all 14 compiled clean and compared sanely, because a byte comparison
checks a function's body, not the convention its callees use.

## Library code is not application code

`src/modules/submodules/unknown*.s` is largely SAS/C runtime library code, not
application code. Confirmed: every relocation-free routine there appears
verbatim in SAS/C 6.51's `sc.lib` — `STRING_AppendAtNull` (`strcat`),
`MATH_DivS32`, `MATH_Mulu32`, `STRING_CompareNoCase`, `STRING_CopyPadNul`,
`FORMAT_U32ToOctalString`. (Routines with A4-relative fixups cannot be compared
this way, since those are resolved at link time and absent from the reloc
table — the 5% verbatim-match figure is a floor, not a ceiling.)

**Do not hand-decompile these.** No C fed to `sc` reproduces them, because they
were built from SAS's own library sources. The faithful route is to link
`sc.lib`. Treat a stubborn mismatch in a `submodules/` function as a signal that
it is library code.

## Alignment limits which functions can be byte-exact end to end

A hunk object is longword-sized, so a C replacement whose function is not a
multiple of 4 bytes gains padding the original never had. Of the five exact
restorations, `LADFUNC_GetPackedPenHighNibble` (20) and
`ESQ_CheckCompatibleVideoChip` (48) are 4-aligned and cost nothing; the other
three (26, 30, 34) each add 2 bytes. Splitting a function into its own module
also closes the surrounding assembly units at non-aligned boundaries, adding a
little more.

So `C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh` currently reports
DIFFERS with CODE 48 bytes larger, even though **every restored function is
byte-identical** — verified by locating each one in the linked CODE hunk. The
padding is inert: it sits between functions and is never executed.

The gate still means something. Growth must equal the sum of per-object
rounding; anything else is a real regression. A restoration whose function is
4-aligned costs nothing at all, so prefer those when the whole-binary match
matters.

Note `build-split.sh` exits nonzero whenever the result is not content-identical.
That is correct for `replacements.txt` (a regression) but expected for
`replacements-canary.txt`.

## Defining symbols C needs but assembly cannot export

Hardware registers must be reached as externs, not pointer casts. But vasm
silently drops `XDEF` of an absolute equate — verified against `EQU`, `=` and
`PUBLIC`, all three producing an object with no external-definition hunk — and
`vlink -D` only takes effect inside a linker script, which would replace the
default layout.

`tools/mkabsdefs.py` therefore synthesises a tiny object exporting them as
`EXT_ABS`, which the linker resolves by value with no relocation, matching the
stock binary. `src/modules/c-exports.s` asserts the addresses still agree with
`hardware-addresses.s` so the two cannot drift.

Also: `sc` truncates external symbols to 33 characters by default, which
silently produced `_SCRIPT_ClearSearchTextsAndChanne` and an undefined-symbol
link error. `IDLEN=128` is now passed always.

## Two implementations behind one switch: `ESQ_EXACT`

Some restorations can only match the original's bytes by writing C that no one
would write on purpose — keeping provably-dead code alive, choosing a type for
its width rather than its meaning, avoiding an early return. That is correct for
*this* project, whose product is evidence about the original, but it is not the
code you would want if the goal were a maintainable program.

So a restoration may carry **both**, selected by a compile-time define:

```c
#ifndef ESQ_EXACT
#define ESQ_EXACT 1
#endif
...
#if ESQ_EXACT
    /* the form that reproduces the original's bytes */
#else
    /* clean C, functionally identical, not byte-identical */
#endif
```

`ESQ_EXACT` defaults to **1** everywhere, so every measurement in this document
and every number in every restoration header refers to the exact arm. The
fallback is opt-in:

```sh
ESQ_EXACT=0 tools/cmatch.sh <file.c> <Label>        # compile the fallback
ESQ_EXACT=0 C_REPLACEMENTS=... ./build-split.sh     # a whole functional build
```

Three rules, or the switch does more harm than good:

1. **Only add an arm when the exact form is genuinely distorted.** Most
   restorations are natural C already and must stay single-armed. A `#if` that
   guards two spellings of the same thing is noise.
2. **The fallback must be functionally identical**, not merely similar. It is not
   a place to fix bugs found in the original — `parseini_load_weather_strings.c`
   drops a block that is unreachable in the original *too*, which is why dropping
   it changes nothing observable.
3. **Document it in the header** with an `ESQ_EXACT:` line saying what the exact
   arm does that the fallback does not, and what it costs.

`tools/mismatches.py --recheck` compiles the `ESQ_EXACT=0` arm of every dual-arm
file and **exits nonzero if it does not build**. Without that, a fallback nothing
ever compiles would rot silently, since every other tool builds the exact arm by
default.

Worked example: `parseini_load_weather_strings.c`, 168/168 exact against 92 bytes
functional — 76 bytes of dead code that exists in the original and is unreachable
there as well.

**On inline assembly specifically:** the long-term goal is an ESQ with none. If a
future compiler makes inline assembly available and a function genuinely needs it
to match, it belongs in the `ESQ_EXACT` arm with a pure-C fallback in the other —
and **ask first**. It is not a local decision.

## Recording codegen divergences

When SAS/C makes a different-but-equivalent choice than the original, **record
it in the C file rather than distorting the source to force a match.** Every
file in `src/c/` carries a header:

```c
/* RESTORES: <asm label this C replaces>
 * MODULE:   <module path it substitutes for, or a note>
 * STATUS:   exact | behavioural | library
 *
 * SASC-MISMATCH: <short-slug>
 *   ref:     <original bytes>            <disassembly>
 *   got:     <what sc emits>             <disassembly>
 *   summary: what differs and why it is equivalent
 *   tried:   option sets and source forms already ruled out
 *   scope:   how many sites program-wide, and how to find them
 *   retest:  what a different compiler would have to do to match
 */
```

`STATUS` is the contract: `exact` is byte-identical and safe for a faithful
build; `behavioural` is same-semantics but different bytes; `library` means the
original is SAS/C library code that should be linked from `sc.lib` rather than
decompiled.

```sh
python3 tools/mismatches.py             # inventory of restorations + divergences
python3 tools/mismatches.py --recheck   # recompile each and report the truth
```

**On obtaining a different SAS/C version, point the toolchain at it and run
`--recheck`.** Anything that flips `DIFFER` -> `MATCH` is a divergence that
version does not have: it both fixes the restoration and helps pin the compiler.
The tool also exits nonzero if something recorded as `exact` stops matching, so
it is safe to wire into a check.

`tools/cmatch.sh` and the recheck both default to
`NOSTKCHK DATA=FAR CODENAME=S_0 DATANAME=S_1`; override with `SCOPTS_BASE`.

Known divergences so far are written up in `docs/compiler-version.md`.

## Progress is measured in BYTES, not function count

Function count flatters: the easy targets are small, so a high count can sit on a
tiny fraction of the program. 202 restorations once read as 28% of the program
and was 5.2% of it by byte.

```sh
python3 tools/coverage.py             # progress by byte and by count
python3 tools/coverage.py --targets   # next targets, ranked
```

Targets are ranked by how likely they are to become byte-exact once the compiler
is identified, which depends on how the original encoded their calls:

- **cross-unit** — every call is `4EBA` (`JSR (d16,PC)`), the encoding the
  original used for a callee in another translation unit.
- **intra-unit** — contains a `BSR.W` (`6100`) to a nearby callee, so that callee
  shared a `.c` file with it.

**The bucket names describe the ORIGINAL. They do not rank our chances, and for
a long time this section claimed the opposite.** It used to say cross-unit
targets were "pre-positioned to match" because our one-function-per-file
restorations emit only cross-unit calls. That reasoning is sound and the
conclusion is still wrong, because it assumed `sc` encodes a cross-unit call the
way the original did. It does not: **SAS/C 6.51 emits `BSR.W` for every call,
whoever the callee is.** So it is the `6100` bucket our output lines up with.

The restoration record says so unambiguously:

| bucket | exact | behavioural | exact rate |
|---|---:|---:|---:|
| intra-unit (`6100`) | **11** | 57 | 16% |
| no-calls | 11 | 109 | 9% |
| cross-unit (`4EBA`) | **0** | 144 | **0%** |

Zero of 144. Every function whose original calls are `4EBA` is capped at
`behavioural` under 6.51, and the cap is the call opcode alone — same size, same
displacement, same semantics, different byte. `src/c/script_read_next_rbf_byte.c`
is the whole class in six bytes.

So **prefer `intra-unit` targets, and treat `cross-unit` as blocked until the
compiler question is settled.** Two caveats keep this honest:

- Matching an intra-unit call is still luck, not skill. The original emitted
  `6100` because the callee was in the same `.c` file; we emit it because that
  is all 6.51 emits. The two coincide, which is why the rate is 16% and not
  higher — see `docs/compiler-version.md`, "Call encoding depends on the
  callee's translation unit".
- 6.00 has the mirror-image problem: it emits `4EBA` for everything. Neither
  version picks per callee, which is part of why neither is the one.

`--targets` still ranks by the old assumption and prints cross-unit only; use the
`coverage.survey()` enumeration below instead.

## Reading a large restoration

```sh
tools/cdiff.sh <file.c> <Label> [sc options]   # size delta + differing regions
/tmp/.capvenv/bin/python tools/casm.py <file.c> <Label> [sc options]   # itemised delta
```

`cmatch.sh` prints both byte strings in full, which is unreadable past a hundred
bytes. `cdiff.sh` prints one line per differing region with relocated fields
excluded. **Region count is the number to watch**: a handful means a few idiom
substitutions; dozens means the code generator laid the function out differently.

`casm.py` answers the question `cdiff.sh` structurally cannot: *what does each
difference cost?* It disassembles both streams, aligns them on instruction shape
(so a register-allocation difference is one hunk instead of desynchronising
everything after it), and prints ref/got byte counts per hunk with a running
total. The last line says whether the itemisation adds up to the observed byte
delta — which is rule 3 below, checked mechanically instead of by hand. Use it
for anything that does not land byte-exact; hand-tallying is slow and gets the
wrong answer often enough to be worth not doing.

It needs capstone, which is not in the system Python:

```sh
python3 -m venv /tmp/.capvenv && /tmp/.capvenv/bin/pip install capstone
```

Four rules that keep the record trustworthy:

1. **Equal size is not evidence of fidelity.** Two restorations so far emitted
   exactly the original's byte count while differing in 19 and 29 regions. Both
   say so in their headers. Always report the region count alongside the size.

   The sharper version: a size-exact restoration can be *less* faithful than a
   size-divergent one. `ctasks_start_iff_task_process.c` sat at 202/202 with four
   regions and a header asserting the agreement was genuine. Switching its seglist
   stores to the struct form -- which makes SAS/C emit the original's
   `2348000a`/`337c4ef90008` *verbatim*, where the old form emitted no such
   instructions at all -- moved it to 192/202. The ten spurious bytes had been
   paying for a missing `LINK` and a shorter constant. Strictly closer to the
   original, strictly worse on both headline numbers.

   So **region counts are only comparable between candidates of the same size.**
   Once the lengths differ, every region after the first divergence is misaligned
   and the count inflates by itself. To compare two candidates of different sizes,
   test whether the reference's actual instruction sequences appear in each:

   ```sh
   # does the emitted stream contain the original's instructions, verbatim?
   tools/cmatch.sh <file.c> <Label> | grep '^  got ' | grep -c '<ref hex subsequence>'
   ```

   Beware that a verbatim search fails on a register-allocation difference alone
   (`2f2a0004` vs `2f2b0004` is the same instruction on a different register), so
   match the opcode and addressing mode rather than the whole word when the A5
   class is in play.

2. **Count spurious address computations when the sizes differ.** The cheapest
   size-independent fidelity proxy: how many `LEA <d16>(An),Am` sites the
   reference emits versus the candidate. Equal counts mean the candidate is
   addressing memory the way the original does; an excess means it is recomputing
   addresses the original folded into displacements.

   ```sh
   # 41e8..41ef = LEA (d16,An),Am -- compare reference against emitted
   python3 tools/refbytes.py <Label> | grep '^bytes:' | grep -o '41e[89a-f]00' | wc -l
   ```

   `NEWGRID_DrawGridHeaderRows` is the worked example: reference 5, cast-and-add
   form 8, struct form 5 -- decided the question while the byte total was moving
   the wrong way. This doubles as the **struct-offset check**, which is otherwise
   missing: `cdiff` masks relocated fields and cannot see a wrong offset at all.

3. **Account for the delta, or say you did not.** The strongest results explain
   every byte (`ED_HandleSpecialFunctionsMenu`: 640 vs 656, being 8 x 2 from one
   constant idiom). Where the bytes are not itemised, record it as a
   known-unknown -- `CLEANUP_ReleaseDisplayResources` carries an
   `unattributed-tail-delta` entry saying so. A guessed attribution is worse than
   none, because the whole value of a `SASC-MISMATCH` block is that it can be
   trusted on recheck.

## Running it: the only oracle for a maximum-C build

Neither gate can judge `replacements-all.txt` — behavioural restorations differ
from the original by construction — so the binary has to be RUN. Three harnesses
do that unattended:

```sh
tools/probe_esq.sh <binary> <label> [secs]        # boots? PASS/FAIL from the log
tools/soak_esq.sh  <binary> <label> [total] [gap] # minutes, screenshots, freeze check
tools/bisect_added.sh <baseline-list> <added-list> [tag]   # which new entry broke it
```

`probe_esq.sh` looks for ESQ's own serial setup (`baud=2400`) in the FS-UAE log.
`soak_esq.sh` runs for minutes and captures the emulator window; ESQ is a
broadcast program and cycles its own displays, so it exercises the grid, the
banners and the IFF brush loads with no input. Its freeze check is the point:
ESQ redraws a clock every second, so **identical consecutive frames mean the
display stopped updating** — a hang the boot probe cannot see, because the
machine is still nominally up.

`~/Downloads/Prevue/ESQ.known-good-36cf56ed` is the pristine byte-exact build.
**Probe it first whenever a FAIL looks surprising**, since every harness copies
the candidate over `~/Downloads/Prevue/ESQ`.

Three properties of this setup are not guessable and cost real time to learn:

- **FS-UAE buffers its log and only flushes on exit.** Measured: the file sits at
  exactly 45056 bytes for the whole run. You cannot poll for the marker; the run
  has to be given time and then killed.
- **A PASS is trustworthy, a FAIL is not.** With a 45s budget the probe reported
  FAIL for a binary that then passed five times running, because the run had not
  reached serial init yet on a host busy compiling. That one false FAIL sent an
  entire bisect after an innocent restoration. `probe_esq.sh` now retries before
  believing a failure.
- **Check the binary is FRESH.** `vlink` leaves the previous `build/ESQ` in place
  on an undefined-symbol error, so a manifest that failed to link once "passed"
  the probe — what got probed was the previous build. `build-split.sh` now
  deletes it first and exits nonzero, but the habit is worth keeping.

`tools/keydrive_esq.sh` reaches what the soak cannot: it focuses the emulator
and sends ESC / arrow / Return, the vocabulary `ED_GetEscMenuActionCode` actually
switches on (3, 13, 27, 155). It needs an **Accessibility** grant for the
terminal, separately from the Screen Recording grant the capture needs, and it
checks for that grant rather than assuming it — without it every keystroke fails
silently with error 1002 and the run is a no-op that looks like a pass.

> **Its arrow keypress is a NO-OP and always was** — FS-UAE eats the cursor keys
> as joystick input, so it only ever activates menu item 1. Prefer
> `tools/menusweep_esq.sh`, which reaches all six items using ordinary keys. See
> the OPEN section below; this one fact invalidated several published conclusions.

```sh
tools/menusweep_esq.sh <binary> <label> [items] [reps]   # all six ESC-menu items
tools/keyprobe_esq.sh  <binary> <label> <key:wait>...    # one boot, arbitrary keys
tools/gururate_esq.sh  <binary> <label> [runs]           # measure the FIRE RATE
tools/btrap_test.sh    <label> [exclude.c ...]           # build+run one manifest
python3 tools/btrap_bisect.py --list <file>               # removal-bisect
```

`keyprobe_esq.sh` is the one to reach for when you do not yet know what a key
sequence does — it boots once, sends whatever you list, and scores every frame.
That is how the dead arrow key was found, after months of trusting it.

### OPEN: the maximum-C build gurus on the ESC menu — 2026-07-28 update

Still open, but the picture changed substantially on 2026-07-28 and **several
earlier conclusions in this section were false negatives from a broken harness.**
Read this part before re-running any old experiment.

#### The harness was only ever pressing one menu item

`keydrive_esq.sh` sends ESC / Down / Return. Reading its captures showed **the
Down arrow never did anything**: FS-UAE consumes the cursor keys as emulated
joystick input before the Amiga keyboard sees them, so the `2_down` screen is
identical to the freshly-opened menu with "Edit Ads" still highlighted. Every
guru trial ever run therefore activated **menu item 1 and only item 1**, and the
old note that "ESC and the arrow are fine, the alert lands on RETURN" was
vacuous — the arrow was a no-op, not a passing case.

The menu's own text says "Push any key to select" and that is literal: an
**ordinary** key advances the selection by one. `tools/menusweep_esq.sh` uses
that to reach all six items, one boot per item. Five of them —
Edit Attributes, Change Scroll Speed, Diagnostic Mode, Special Functions,
Versions Screen — had never been exercised by anything, and that is where most
of the restored `ED_*` code lives.

#### It is NOT intermittent. That was an artifact of the weak sequence.

With the real sequence the fault fires **every time**:

```
  reference (byte-exact)      clean 6/6      (all six menu items)
  byte-exact C, 23 entries    clean 3/3      (splits and renames ARE inert)
  maximum-C 289               guru 2/2
  maximum-C 305               guru 6/6
```

So "a single trial is never evidence of absence" was the right rule for the old
harness and is now over-cautious: this reproducer is deterministic. **Every
earlier conclusion that rested on a CLEAN verdict has to be re-checked**, because
those verdicts were produced by a sequence that barely touched the program.

`tools/gururate_esq.sh` measures a fire rate rather than assuming one, and its
header does the arithmetic on how many clean trials an acquittal actually needs.

#### "Not one file" was WRONG

The claim rested on: the first 144 entries guru, but neither 72-entry half does.
Re-run with the working harness, **the second 72 (entries 73–144) gurus on its
own.** The old result was a false acquittal. A single culprit is back on the
table and the search space is 72 entries, not 289.

#### Two alert codes, one fault, and the landing site moves

| build | alert | log |
|---|---|---|
| 289 | `8100000F` | no log line |
| 305 | `8000000B` | `B-Trap FFF8 at 002248F6` |

`8000000B` is `ACPU_LineF` — the CPU executed a word as an instruction. Across
three builds the trap moved: `FFF8@002248F6`, `FFEC@00224932`, `FFF8@00224524`.
**Both the address and the opcode track image layout**, which is the signature of
a wild jump landing on whatever data happens to be there. Treat the two codes as
one fault with a layout-dependent symptom, not two bugs.

#### A log oracle now exists, and it is trustworthy

`grep -c B-Trap` on the FS-UAE log: **1 in each of six 305 trials, 0 in each of
six reference trials and both 289 trials** — 14 trials, no disagreement. That is
a different thing from the `Illegal instruction: 4e7b` mistake, which counted
Kickstart's own boot instruction.

It only sees the F-line variant, so `tools/btrap_test.sh` reports the log signal
**and** the screen verdict, and treats a build that merely swapped `8000000B` for
`8100000F` as still broken. Never oracle on the log alone.

#### Ruled out on 2026-07-28

- **My 16 restorations added that day.** Removing all sixteen still gurus.
- **The module splits and symbol renames.** The byte-exact 23-entry build carries
  all of them and is clean, so they are inert at runtime as well as byte-neutral.
- **A wrong pointer baked into DATA.** All six differing DATA bytes sit inside
  relocated longwords and each is shifted by exactly `0xAB2`, matching CODE
  growth. Nothing stray. The wild jump is computed at runtime, not linked in.
- **CHIP-memory exhaustion.** Worth stating precisely because the earlier
  "8MB of RAM does not fix it" experiment does NOT rule this out: the bigmem
  config raises `fast_memory` only, and `chip_memory` stays at 1024. Bitmaps and
  copper lists must live in chip RAM, so a failed chip allocation would be
  invisible to that test — and an unchecked one explains BOTH symptoms at once (a
  null jumped through, or a null freed). It is still wrong: `chip_memory = 2048`
  gurus 3/3 on the 305 build. `Prevue-HDD-bigchip.fs-uae` is left in place for
  re-testing.

#### The strongest remaining signal is SIZE, and it is very tight

| build | bytes | verdict |
|---|---:|---|
| reference / byte-exact C | 279804 | clean |
| keep 36b of the window | 280324 | clean |
| keep 36a of the window | 281172 | clean |
| keep entries 0–72 | 281360 | clean |
| keep entries 72–144 | 281740 | **fails** |
| 289 / 305 entries | 284716 / 285292 | **fails** |

Every failing build is larger than every clean build, with the boundary inside a
380-byte window. That is consistent with a latent fault that only manifests past
some layout threshold, and it explains why entry-level attribution keeps failing
in both directions: the subsets are changing size as much as content.

Trying to test size directly by padding a clean build hit `Error 28` at
**`-0x80e0`, only 224 bytes past the 16-bit limit** — so the hand-written
assembly's `BSR.W` pairs really are at the ceiling, and the padding experiment
that would settle this cannot be built at that size. Note the corollary: because
a C replacement moves code in and out of units, *which* pairs are stressed
depends on the manifest, not just on total size.

**The obvious next question is whether something 16-bit is truncating silently.**
vlink range-checks what it emits — it produced the Error 28 above — so a linked
build should be free of overflowed displacements. If that is true the size
correlation needs another explanation; if some reloc class is NOT checked, a
wrapped 16-bit displacement lands ~64KB away, on data, at a layout-dependent
address, which fits every observation. Auditing vlink's range checks per reloc
type is the cheapest way to close this.

#### Entry-level removal-bisect is confounded by layout — do not trust it alone

Keeping entries 73–144 reproduces the fault, yet removing **either** 36-entry
half of that window from the full manifest fails to fix it. Both cannot be true
of a simple single culprit, and the reason is that every subset changes the image
layout, which this fault is sensitive to. `tools/btrap_bisect.py` therefore stops
and says so rather than picking a half.

#### NARROWED to the ED_* family, but still NOT attributable to one file

Removing all **39 `ED_*` restorations** from the 313-entry manifest makes the
fault go away -- clean on both the log signal and the screen, across all six menu
items. That is the sharpest cut found so far, and it makes sense: `ED_*` is the
menu code and the fault fires on menu interaction.

**It is not any single one of them, and the attribution that looked solid did not
survive.** Bisecting inside the family needs the two-culprit technique (remove
half B permanently, then bisect half A against that baseline -- `btrap_bisect.py
--fixed`), because removing either half alone leaves the other half's failure in
place. Doing that named `ed1_draw_diagnostics_screen.c`. The confirmation step
then **refuted it**: an ED-free baseline plus only that file is CLEAN.

So the fault needs several `ED_*` entries present together and remains sensitive
to image layout. Two hypotheses were checked and are wrong:

- **A too-small `printfResult` buffer** in `ed1_draw_diagnostics_screen.c`. The
  original really does use 41 bytes (`.printfResult = -41`, frame 48) and the
  format expands to about 34, so there is no overflow and the C matches.
- **An out-of-bounds scratch write** in `ed_capture_key_sequence.c`. Its
  `scratch[sentinel*3 + phase]` reaches index 24, which looks like one past a
  24-byte array -- but `_KYBD_CustomPaletteCaptureScratchBase` is `DS.B 1`
  immediately before the 24-byte palette, so phase 1..3 lands exactly on R/G/B of
  pen `sentinel`. The off-by-one is deliberate and the restoration is faithful.

**ALWAYS RUN THE CONFIRMATION.** This project has now retracted three culprit
attributions, and this is the first one caught before it was believed, purely
because `btrap_bisect.py` prints the confirmation instruction and it was
followed. A bisect verdict inside a layout-sensitive fault is a hypothesis, not
a result.

#### The trap lands MID-INSTRUCTION: it is a wild jump, not a bad free

The logged opcodes are `FFF8`, `FFF4` and `FFEC` -- i.e. -8, -12 and -20 as
signed words. Those are not plausible instructions; they are **extension words**,
the second word of a `LINK.W A5,#-n` prologue (or equivalent data). So the PC is
landing at an ODD PLACE INSIDE an instruction stream, which makes this a wild
jump, and `ACPU_LineF` is just what the CPU says when it gets there. The
`8100000F` variant is the same wild jump landing somewhere that frees instead.

**The CODE base is not pinned yet, and this is what to finish.** Solving
`trapPC - base` against a `4e55fff8`-style site across four saved builds
(`ESQ_maxc305/313/314/disc1`, traps `0x2248f6 / 0x224932 / 0x224932 / 0x22491e`)
leaves **11 candidate bases**. Two land on a map symbol, and neither survives:

- `0x2207cc` -> `ESQ_CopperStatusDigitsB_TailColorWord`, which is in
  `src/data/esq.s` -- a DATA symbol matched against a CODE offset. Invalid; the
  map's symbol list must be split at `Symbols of S_1:` before use.
- `0x220076` -> `CLEANUP_TestEntryFlagYAndBit1 + 2`, but that base is 6 mod 8 and
  a loaded hunk comes from `AllocMem`, so it is 8-aligned. Implausible.

Each additional failing build with a distinct layout is one more constraint;
four gave 11 candidates, so a handful more should give one. `tools/btrap_test.sh`
already prints the trap line, and the binaries must be SAVED (it overwrites
`~/Downloads/Prevue/ESQ` every run). Once the base is known, the landing symbol
follows from the map and names what the wild pointer actually held.

#### THE LANDING SITE IS IDENTIFIED: `CLEANUP_RenderAlignedStatusScreen + 0x10c`

Method, which is reusable for any future wild-jump fault here:

1. Collect (trapPC, binary) from several FAILING builds with different layouts,
   saving each binary -- `btrap_test.sh` overwrites the staged `ESQ` every run.
2. Brute-force the CODE base: for every candidate `base`, require the word at
   `trapPC - base` to equal the logged opcode in EVERY build.
3. Discriminate what survives by requiring the ~24 bytes around the landing site
   to be BYTE-IDENTICAL across builds -- the real site is the same code in all of
   them, so candidates landing in shifting C output are eliminated.
4. Break any remaining tie on alignment: a loaded hunk comes from `AllocMem`, so
   the base is 8-ALIGNED. That is what settles it.

Result: base `0x00220888`, and the trap word is the `FFF8` displacement of a
`-8(A5)` access at `CLEANUP_RenderAlignedStatusScreen + 0x10c`. (Three candidate
bases survived step 3 because all three land on an `FFF8` displacement inside the
SAME function; only one is 8-aligned.) The function is **still assembly, not
restored**, so the landing site is untouched code -- it is where control arrives,
not the bug.

#### And the mechanism: an UNBOUNDED STACK COPY four instructions later

```
+0x1c6  MOVEA.L -8(A5),A0          ; title-table entry
+0x1ca  MOVEA.L 56(A0,D0.L),A0     ; -> title text pointer
+0x1ce  LEA     -554(A5),A1        ; stack buffer inside a LINK.W A5,#-840 frame
+0x1d2  MOVE.B  (A0)+,(A1)+ / BNE  ; copy until NUL -- NO length limit
```

`-8(A5)` is `_TEXTDISP_PrimaryTitlePtrTable[_TEXTDISP_CurrentMatchIndex]`, loaded
at `+0x0f8..+0x10a` with **no bound check on the index**. So a
`CurrentMatchIndex` that is out of range (notably -1, which several code paths
assign) reads a pointer from OUTSIDE the table, and the copy then runs from
whatever that points at until it happens to find a zero -- straight over the
840-byte frame and its return address. A smashed return address landing on
whatever the garbage text happened to contain is *exactly* a wild jump whose
target moves with image layout, and it explains both alert codes, the ED_*
sensitivity (ED drives the menu that sets the index) and why no single file is
attributable.

**This is a latent bug in the ORIGINAL, not something a restoration introduced** --
the unguarded index and the unbounded copy are in unmodified assembly. The C build
presumably just changes which value the index holds, or what lies past the table,
often enough to matter.

**Next step:** find what `_TEXTDISP_CurrentMatchIndex` actually holds when
`CLEANUP_RenderAlignedStatusScreen` runs, and which writer leaves it out of range.
Three restorations write it -- `script_dispatch_playback_cursor_command.c` (six
times), `textdisp_reset_selection_and_refresh.c`, and
`script_reset_banner_char_defaults.c` -- and the first was re-verified against the
original's jump table: its cases 5/6/7 call the renderer and do NOT set -1, which
matches. Do not assume the writer is a C file; the assembly writes it too.

#### Refuted: the 16-bit branch ceiling as the cause

`CLEANUP_RenderAlignedStatusScreen + 0x13c` calls `_DISPLIB_NormalizeValueByStep`,
which is the very symbol that produced `Error 28` during the padding experiment --
an appealing connection, since it would tie the guru to the branch ceiling and
explain the layout sensitivity. It is wrong: in the failing 313-entry build that
`JSR (d16,PC)` encodes `+28312`, well inside range and resolving exactly to the
symbol. vlink range-checks and ERRORS rather than truncating, which is why the pad
experiment failed to link instead of miscompiling.

#### Ruled out: wrong argument counts (`tools/check_c_signatures.py`)

A callee reading a stack slot the caller never pushed is the textbook way to
produce a wild pointer, and no existing check could see it -- cmatch compares the
body not the convention, both byte gates stay green, `a6_audit` only looks at
library bases, and the linker cannot know how many arguments a function wants.

So it is now checked: the tool derives the argument count from the reference's own
`d(A5)` reads and compares it with the C signature. **100 restorations checked, 0
errors.** That eliminates the class.

Two idioms it had to learn first, both after it cried wolf:

- **varargs.** `LEA 16(A5),A0` takes the address of the slot past the last named
  argument and passes it on. `disptext_build_layout_for_source.c` is `(src, fmt,
  ...)` and correctly spells that `&fmt + 1`, so 2 parameters is right even though
  slot 2 is touched.
- **A7-addressed arguments in a framed function.** `_DISPLIB_DisplayTextAtPosition`
  has `LINK.W A5` and still reads 28/32/36/40(A7). Those are invisible to the A5
  scan, so such functions report 0 slots -- which is why the "declares more"
  direction is advisory and only "declares fewer" is an error.

#### There is a verified-working C build: `src/c/replacements-runnable.txt`

274 entries -- `replacements-all.txt` minus the 39 `ED_*`. Verified 2026-07-28:
boots, `a6_audit` 0/274, and **clean on all six ESC-menu items** with no B-Trap.
Use it whenever you need a C build that actually runs; keep
`replacements-all.txt` as the maximal-coverage target that does not.

**Next step:** run `tools/ddmin_guru.py` against the 72-entry reproducer with the
new deterministic oracle. ddmin was previously crippled by the intermittent
verdict — a clean answer cost `trials` runs and was still unreliable. Now a
verdict costs one run and can be believed, which is what makes the complement
testing it does affordable. Prefer the 72-entry reproducer over the 289: same
fault, a quarter of the search space, and builds fast enough to iterate on.


## Verifying a C build

`build-split.sh` reports DIFFERS for any C build and that is expected -- objects
are longword-sized, so a restored function of odd word length gains padding and
shifts everything after it. The real acceptance test is:

```sh
C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh
python3 tools/verify_restorations.py
/tmp/.capvenv/bin/python tools/a6_audit.py     # stale-A6 library calls
```

which locates each compiled replacement inside the linked CODE hunk and checks
every byte, compares relocated fields positionally, confirms the size growth
equals the sum of per-object rounding, and confirms every differing DATA byte
sits inside a relocated longword.

## Source shapes that change the emitted bytes

Each of these was measured against a real function; the cited file has the
before/after. They are not style preferences -- picking the wrong one costs bytes
and mismatched regions.

| write this | not this | why |
|---|---|---|
| `a = b = 0;` | `a = 0; b = 0;` | the original holds zero in a register and stores it twice; separate statements emit `CLR` twice. Works for pointers too (`SUBA.L A0,A0`). See `esqdisp_promote_secondary_group_to_primary.c`, `newgrid_init_selection_window.c` |
| `dst = *src;` (struct) | `memcpy(&dst, src, sizeof)` | struct assignment emits a `MOVE.L`/`DBF` long copy; memcpy of the same bytes emits a `MOVE.B` loop. `tliba3_init_runtime_entry.c`, 296 -> 276 bytes |
| `memcpy(buf, src, 24)` (char array) | a hand-written loop | for a plain byte array memcpy inlines to exactly the original's `MOVEQ`/`MOVE.B (A0)+,(A1)+`/`DBF`. `ed_capture_key_sequence.c` |
| `table[i].field` repeatedly | hoisting `p = &table[i]` | the original often recomputes the index multiply per access; hoisting collapses them. `tliba3_init_runtime_entry.c` |
| `strlen(s)` / `strcmp(a,b)` | anything else | both inline to the original's scan loops; no library call is involved |
| `void __saveds f(void)` | a plain definition | when the original opens `MOVE.L A4,-(A7)` / `LEA <data>,A4` and restores A4, it is a Task entry point. `__saveds` reproduces the `LEA` exactly. `ctasks_ifftaskcleanup.c` |
| `(long)AvailMem(...) > n` | `AvailMem(...) > n` | `AvailMem` returns ULONG, so the natural form emits `BLS`; the original has `BLE`. `disptext_append_to_buffer.c` |
| `unsigned short` counters | `short` | when the original's loop bounds use `BCC`/`BCS`/`BHI` rather than `BGE`/`BLT`, the counters are unsigned. `esqiff2_read_serial_record_into_buffer.c` |
| `((struct T *)p)->field = x;` | `*(long *)((char *)p + 10) = x;` | struct member access folds the offset into a `(d16,An)` displacement (`MOVE.L A0,10(A1)`, 4 bytes); the cast-and-add form makes SAS/C materialise the address into a register per store (`MOVEA.L`/`ADDA.W`/`MOVE.L (A1)`, 10 bytes). `ctasks_start_close_task_process.c`, 148 -> 136 |
| `(x << 3)` | `(x * 8)` | where the original has `ASL.L #3`, write the shift. `* 8` makes SAS/C widen the whole computation: it zero-extends via `SWAP`/`CLR.W`/`SWAP` (8 bytes where the original's `MOVEQ #0` / `MOVE.W` is 4) **and** spills an argument to a stack slot it has to allocate, giving the function a frame the original has none of. Worth **28 bytes** on one 94-byte function. `tliba3_draw_inner_frame_border.c`, 144 -> 116 |

**Split an accumulate from the call that feeds it.** Where the original updates
a variable *before* calling (`ASL.L #4,D7` then `JSR`), write two statements --
`v <<= 4; v += f(x);` -- not one. As a single expression SAS/C evaluates the call
first and spills the partial result to a stack slot it has to allocate:
`parseini_parse_hex_value_from_string.c` goes 84 bytes -> 64 exact-size on that
change alone. Match the original's ORDER, not just its arithmetic.

**Dead code needs a zero LOCAL, not a literal.** Where the original tests a
constant zero and branches past a block (`MOVEQ #0` / `TST.L` / `BEQ`), that block
is unreachable but still occupies bytes. `if (0) {...}` gets folded away; assigning
0 to a local and testing that keeps it. `parseini_load_weather_strings.c` -- 74 of
its 168 bytes are dead.

**A green diff does NOT validate struct offsets.** `DATA=FAR` makes every global
field access an absolute long carrying a relocation, and `cdiff.sh` masks
relocated fields by definition -- so a wrong struct layout produces byte-identical
output. Offsets are only tested if the file is promoted to `exact` and linked.
Re-derive them from the listing before promoting anything that uses a struct.
`diskio_write_buffered_bytes.c`

**A provably-dead test means the source used a pointer.** If the original
null-checks something that can never be null -- the address of a static array, say
-- write the source through a pointer local (`p = arr; if (p && *p)`) rather than
testing the array directly. Testing directly lets the compiler drop the dead
branch and costs the match. `script_split_and_normalize_search_buffer.c`

**The chain must stop where the original's does.** In
`newgrid_init_selection_window.c` the original zeroes two pointers from one
register and then uses a *fresh* zero for the adjacent long -- chaining all three
would be wrong. Match the grouping, not just the idiom.

**A range test just before a jump table belongs to the table.** If the original
shows `CMPI.L #n` immediately before a PC-relative jump table, that is the
switch's own bound check -- do NOT also write an explicit `if (x >= n)` guard, or
SAS/C emits the test twice. Let the switch's `default` handle out-of-range.
`ed_get_esc_menu_action_code.c` -- 172 bytes -> 156 by deleting the guard.

**Keyboard dispatchers want `switch` + `SHORTINT`, together.** The original tests
key codes with a chained subtract (`SUBI.W #13` / `SUBI.W #14` / `SUBI.W #$80`),
each consuming the running difference. An `if/else` chain gives independent
compares instead; a `switch` gives the chain but at the wrong width (`MOVEQ` +
`SUB.L`). Only both together reproduce it. `ed_handle_edit_attributes_input.c`
went 172 bytes -> 166 exact this way, and it explains why the other two ED key
handlers needed `SHORTINT`. It is a tool to try, not a universal rule --
`ed_get_esc_menu_action_code.c` has the same dispatch shape and `SHORTINT` does
not help there.

**`SHORTINT` is per-file and often load-bearing.** Three restorations need it
(`ed_is_confirm_key.c`, `ed_handle_special_functions_menu.c`,
`ed_handle_edit_attributes_menu.c`); one breaks under it
(`ladfunc_get_packed_pen_high_nibble.c`). Symptoms of needing it: the original
compares with `SUBI.W`/`CMPI.W` where you emit `CMPI.L`, or a switch selector
gains an extra `EXT.L`. `src/c/replacements.txt` carries a per-file options
column.

**SAS/C never emits `-(An)` for a store.** A function that fills a buffer
back-to-front (`*--p = c`) costs two extra bytes per write -- SAS/C decrements
with a separate `SUBQ` then stores through plain indirect. This is unreachable
from C, not merely different. Screened by `tools/coverage.py`; it finds exactly
**one** such function program-wide, so this is a real but narrow blocker, not a
broad one. The wider lesson is the diagnostic: a restoration overshooting badly
with no structural disagreement is a hint the original was hand-written assembly,
not compiled C -- see `esq_format_time_stamp.c`, 142 bytes against 212.

**A `_Return` label means the reference bytes stop early.** Where the original's
epilogue is branched to from inside the function, the disassembly gives it its
own exported label (`Foo_Return`), and `refbytes.py` extracts label-to-label — so
the reference for `Foo` ends before its `MOVEM`/`UNLK`/`RTS`. A C restoration
always includes its own epilogue, so the raw delta overstates by the epilogue
size. Add it back before judging, and say you did in the header.
`esqdisp_allocate_highlight_bitmaps.c` is +18 raw and +8 real.

## Six shapes a C replacement cannot express, and how the tool knows

`coverage.py` screens these out so they stop appearing as reachable targets. Each
was established by working the function, not by looking at it — the first four
cost real time before they were encoded.

| blocker | signature | why C cannot |
|---|---|---|
| `register-args` | entry `MOVEM` preserves D0/D1/A0/A1 | no compiler saves the registers its arguments arrive in |
| `live-register-on-entry` | first instruction dereferences an address register never loaded | entered with a register already set by the caller |
| `rotate-instruction` | `ROL`/`ROR`/`ROXL`/`ROXR` | C has no rotate operator; SAS/C emits none |
| `tail-jump` | last instruction is `JMP` | SAS/C emits `JSR` then `RTS` — different instruction, different stack |
| `predecrement-store` | `MOVE.x src,-(An)` | SAS/C never emits `-(An)` for a store |
| `falls-through` | no `RTS`/`RTE`/`RTR` **anywhere** in the body | it is not a function; it falls into the next one, and C would add a prologue and a return the original has not |

Two of these are narrow enough to quote: exactly **two** functions program-wide
contain a rotate (the other is `MATH_DivU32`, SAS/C library code), and exactly
**one** ends in a tail `JMP`. They are not blunt filters.

`falls-through` is the widest of them: **26 blocks** were sitting in the target
list looking small and easy, `DISKIO1_AppendTimeSlotMaskValueTerminator` among
them — it ends `ADDQ.W #4,A7`. Test the WHOLE body rather than the last line, or
five real functions get screened out by mistake: an extract can run past the RTS
into inter-function padding, and one whose epilogue is branched to from inside
stops early at its `_Return` label.

**Do not trust `--targets` as the work list.** It prints the **25 largest
cross-unit** functions and nothing else, which hides both the small end and the
whole `no-calls` bucket. Every restoration in the 2026-07-27 batch came from the
small end of the full list. Enumerate `coverage.survey()` directly:

```py
import sys; sys.path.insert(0, 'tools'); import coverage
BLOCK = {'register-args', 'live-register-on-entry', 'interior-label',
         'rotate-instruction', 'tail-jump', 'predecrement-store', 'falls-through'}
c = [f for f in coverage.survey()
     if f['kind'] == 'no-calls' and f['status'] is None      # status None = not yet restored
     and not (set(f['blockers']) & BLOCK)]
```

Without the `status` filter that returns 132, not 31 — it counts everything
already done.

As of 2026-07-27 that leaves **31 unblocked `no-calls` candidates, 6302 bytes** —
an earlier version of this file claimed the bucket was empty, which was wrong.
They matter out of proportion to their size: with no cross-unit call in them,
nothing structural stops one being **exact**, and every other bucket is capped at
`behavioural` until the compiler question is settled.

## Not every label is a function

A label whose body references `(A5)` but has no `LINK.W A5` is an **interior
label** -- reached by branch or fall-through from inside a larger routine, using
that routine's frame. It cannot be restored as C at all: a C function would build
its own frame and the `A5` references would address nothing. `tools/coverage.py`
detects and excludes these. `DISKIO1_DumpDefaultCoiInfoBlock` is the worked
example.

## The C phase

Replace assembly with C **one leaf subroutine at a time**, compiled by SAS/C
6.51, and accept the result only when the emitted bytes are identical to the
assembly it replaces. If a function cannot be made to match, **leave it in
assembly and move on** — a partial decompilation that builds correctly is worth
far more than a complete one that does not.

Never reach for inline assembly to close a gap. That is the exact move that
produced the "odd regressions that don't make sense" in every prior attempt.

**And in any case SAS/C 6.51 has no inline assembly**, which was tested rather
than assumed. `__asm(" ...")` and `#asm`/`#endasm` are syntax errors; `asm(...)`
and `__emit(...)` compile silently into ordinary external calls to `_asm` and
`___emit`, which is worse than an error because it looks like it worked:

```
asm(" moveq #1,d0");   ->  48790000000061000000584f70004e75   (a call to _asm)
__emit(0x7001);        ->  4878700161000000584f70004e754e71   (a call to ___emit)
```

So the rule is not just policy here, it is the toolchain. A function that needs
assembly stays in assembly.

**What SAS/C does have is `__asm` register parameters**, and they work:

```c
void __asm t(register __a0 char *p, register __d0 long n)   /* 2e00 2a48 ... */
```

Arguments arrive in the named registers with no stack traffic. This is untried
for restoration so far and is the obvious tool for any register-argument leaf
helper. It does **not** rescue the `register-args` family below, because SAS/C
still copies the arguments into its own callee-saved registers, whereas those
routines preserve and work in the argument registers themselves.
