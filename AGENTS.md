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

## How to write documentation and comments

Use the `ste-writing-skill` skill for every piece of prose you write here. That
covers `README.md`, `AGENTS.md`, the files under `docs/`, the `SASC-MISMATCH`
headers in `src/c/`, script header comments, and pull-request text. Invoke the
skill before you write, not after.

Install it from
<https://github.com/woosal1337/blog/blob/main/videos/ep01-the-cure-for-ai-slop/ste-writing-skill.md>.
Save it as `SKILL.md` under `~/.claude/skills/ste-writing-skill/` for every
project, or under `.claude/skills/ste-writing-skill/` for this one.

The skill writes ASD-STE100 Simplified Technical English. It has two modes. Use
**strict** for procedures, build steps, and anything an operator follows under
pressure. Use **STE-flavored** for explanation, such as the reasoning in this
file and the summary lines in a mismatch header.

The rule applies to prose only. Do not change code, identifiers, command
syntax, byte strings, or disassembly text to satisfy it. A `ref:` or `got:`
line is evidence, so copy it exactly.

Why this matters more here than in most repositories: this file and the C
headers are the record of what was tested and ruled out. A vague sentence in a
mismatch header sends the next reader to repeat work that was already done. The
skill removes the shapes that hide that vagueness, such as passive voice with
no actor, stacked hedges, and one thing under two names.

## Refresh the derived numbers at the end of a run

Some numbers in `README.md` and in this file are copies of build output. They go
stale without a sound. A stale number is worse than no number, because a reader
trusts it. Refresh them at the end of any run that changes the restoration count
or the module list.

1. Run `python3 tools/coverage.py`. Read the function count, the byte count, the
   percentage, and the exact count.
2. Run `./build-split.sh`. Read the `N source modules -> M link units` line and
   the two hunk sizes.
3. Run `grep -vc '^\s*#\|^\s*$' src/c/replacements*.txt` for the manifest entry
   counts.
4. Write those values into the `## Status` block of `README.md`.
5. Redraw the 40-cell bar in that block. Fill `round(percent / 100 * 40)` cells.
6. Correct the module and unit counts in **Two constraints that will bite you**.
7. Correct the exact-rate table in **Progress is measured in BYTES**.
8. Correct any manifest entry count quoted in prose in this file.

Do not refresh one file and skip the other. `README.md` and this file must
agree. A reader who finds two different counts cannot tell which one is current.

Never copy a number from an earlier session, from a commit message, or from
memory. Run the command. Every count above changes when the lane moves. Several
have already been wrong in this file for exactly that reason.

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
until each unit lands on a 4-byte boundary — which is why 788 source modules
become 401 link units. Source files stay fine-grained; only the assembly grouping
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

  Two tools do this so you do not have to find the sites by hand, and a
  restoration that reads a dozen globals needs a dozen renames:

  ```sh
  python3 tools/check_c_symbols.py          # which externs still lack the underscore
  python3 tools/check_c_symbols.py --fix    # rename them all
  python3 tools/rename_for_c.py <Symbol>... # rename named symbols only
  ```

  Run `./test-hash.sh` after `--fix`. One tranche renamed 144 symbols in one
  call and the hash did not move. Do this BEFORE the first full C build:
  otherwise every missing underscore costs a whole split build to find, one at
  a time, as `Reference to undefined symbol _FOO`.

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

### A MISSING header compiles clean and emits the wrong call

`esq-dos.h`/`esq-exec.h`/`esq-graphics.h` are not only about the volatile base.
They are also what makes an OS call BE an OS call. A function with no prototype
in scope gets an implicit declaration, and SAS/C then emits an ordinary external
call with the arguments on the STACK:

```
missing esq-dos.h:  4879<path> 61000000 584f      push path / BSR _DeleteFile / pop
with esq-dos.h:     41f9<path> 2208 2c79<base> 4eaeffb8
                                                  LEA / MOVE.L A0,D1 / base / JSR _LVODeleteFile
```

It compiles without an error. `gcommand_load_ppv3_template.c` was written with
only `esq-exec.h` and called `DeleteFile`; the restoration looked finished and
compared sanely. **Check that every OS function a file calls has its header, not
only the ones you reached for the volatile base.** A cheap check is to grep the
emitted bytes for the LVO offset you expect.

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

**The 2026-07-31 tranche is DONE: coverage is 75.3% by byte, 591 restorations.**
It was reached by working the LARGE end rather than the small one -- the 600 to
1,600 byte band -- because byte-per-function is roughly four times better there
and the per-function overhead is the same. `docs/tranche-target.md` still
describes the old under-400 plan; the bands below are the live picture. Run
`python3 tools/worklist.py` for what is left, smallest first. It regenerates
from `coverage.survey()`, so it cannot go stale. `--bands` shows what the next
size band would add. **97.7% is the ceiling**; only 4,368 bytes are truly
blocked, and `docs/blocked-shapes.md` says what each class would take.


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
| intra-unit (`6100`) | **11** | 217 | 5% |
| no-calls | **13** | 122 | 10% |
| cross-unit (`4EBA`) | **0** | 219 | **0%** |

Zero of 219. Every function whose original calls are `4EBA` is capped at
`behavioural` under 6.51, and the cap is the call opcode alone — same size, same
displacement, same semantics, different byte. `src/c/script_read_next_rbf_byte.c`
is the whole class in six bytes.

So **prefer `intra-unit` targets, and treat `cross-unit` as blocked until the
compiler question is settled.** Two caveats keep this honest:

- Matching an intra-unit call is still luck, not skill. The original emitted
  `6100` because the callee was in the same `.c` file; we emit it because that
  is all 6.51 emits. The two coincide, which is why the rate is 12% and not
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

> **`soak_esq.sh` captures the fs-uae window BY ID, and this is not a detail.**
> It used to crop a hardcoded rectangle out of a full-screen grab. On 2026-07-30
> that scored the WRONG PIXELS three times in one day — twice an editor window,
> once the desktop — because fs-uae had moved to another macOS Space, where a
> full-screen grab cannot see it at all. The same binary then read FROZEN and
> PASS on consecutive runs. A window-id capture finds the window on any Space at
> any position. It needs `pyobjc-framework-Quartz` and `Pillow`:
> `/tmp/.capvenv/bin/pip install pyobjc-framework-Quartz Pillow`.
>
> It now also **exits nonzero** on a frozen display, and reports how many frames
> hold Amiga content, so a broken capture fails loudly instead of reading as a
> hang. The old version printed `DISPLAY FROZEN` and exited 0, which is why a
> real hang survived in a manifest documented as proven.
>
> **Compare a candidate against the reference by MEASUREMENT, not by eye.** Frames
> from two runs are never at the same point in ESQ's display cycle, and judging
> them by eye produced three wrong calls in one session — including a "clipped
> logo" defect that was only the crop cutting off the window. A per-frame colour
> statistic settles it: the green panel that exposed the register-argument class
> read 0.0 in every reference frame and 0.328 in every candidate frame.
>
> `tools/framecolor.py` now does that comparison. Soak both builds, then:
>
> ```sh
> ./tools/soak_esq.sh ~/Downloads/Prevue/ESQ.known-good-36cf56ed kg 150 15
> ./tools/soak_esq.sh build/ESQ <label> 150 15
> /tmp/.capvenv/bin/python tools/framecolor.py kg <label>
> ```
>
> It bins every pixel of every frame into six coarse colours and prints the
> min, median and max share per bin per label. **Read the RANGES, not the
> medians.** Two ranges that overlap are the display cycle and mean nothing. A
> bin whose ranges are DISJOINT is a real difference in what the program drew,
> and the tool exits nonzero on one.

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

### SOLVED: the ESC-menu guru was a silently truncated 16-bit call (2026-07-28)

**Cause.** vlink resolves a 16-bit PC-relative reference internally when both ends
land in the same output section, and when the required displacement exceeds
+/-32767 it **writes the wrapped low 16 bits and says nothing**. The call then
jumps exactly 65536 bytes away from its target, into arbitrary code. In the
313-entry maximum-C build five calls were wrapped:

| caller | callee | over the limit by |
|---|---|---:|
| `DISKIO2_HandleInteractiveFileTransfer` | `_GROUP_AM_JMPTBL_WDISP_SPrintf` | 687 |
| `ED1_HandleEscMenuInput` | `ESQIFF_JMPTBL_MATH_DivS32` | 379 |
| `_ED1_EnterEscMenu` | `ESQIFF_JMPTBL_MATH_Mulu32` | 189 |
| `_ED1_EnterEscMenu` | `ESQIFF_JMPTBL_MATH_Mulu32` | 121 |
| `ESQSHARED_UpdateMatchingEntriesByTitle` | `NEWGRID_JMPTBL_MATH_DivS32` | 23 |

`_ED1_EnterEscMenu` is the function that runs when you press ESC. Both of its
calls were wrapped, which is why the alert arrived on the ESC-menu path and
nowhere else.

**Why it hid for so long.** Nothing in the toolchain could see it. The CODE size
is unchanged. The relocation count is unchanged, because a same-section
PC-relative reference emits no reloc either way. `cmatch`/`cdiff` compare a
function's own bytes, not where its calls land. Both byte gates stay green, and
`a6_audit` and `verify_restorations` pass. vlink DOES range-check some references
-- that is `Error 28`, which this project hit while padding -- so the checking is
simply inconsistent, and the unchecked path is silent.

It also explains every confusing symptom: the fault depended on image LAYOUT
rather than on any restoration's content (a wrapped displacement is a function of
the distance between caller and callee); no single file was ever attributable;
removing enough restorations fixed it by bringing the pairs back into range; and
the landing address moved between builds because it is always 64KB below whatever
the intended target happened to be.

**The check, and it is wired in.** `tools/check_pcrel_range.py` scans every
`JSR (d16,PC)` and `BSR.W` in a linked binary against a `vlink -M` map and reports
any whose target is not a symbol but sits exactly 64KB from one. `build-split.sh`
now relinks with symbols, runs it, and **ABORTS the build** on any hit. Validated
three ways: the byte-exact pure-assembly build (which works) reports 0 of 3892;
the 271-entry build reports 0 of 3407; the 313-entry build reports 5 of 3200 and
fails the build.

**`--margins` says how much room is left, which is what you need BEFORE adding
restorations, not after:**

```sh
python3 tools/check_pcrel_range.py --margins build/ESQ build/ESQ.map
```

It prints the surviving calls closest to the limit with the caller each sits in.
Growth only costs a call if it lands BETWEEN that caller and its callee — code
added before the pair, or after it, moves both ends equally and is free. So read
the tight pairs first, look up their addresses, and pick targets outside those
spans. On the 285-entry manifest the tightest is 47 bytes
(`DISKIO2_HandleInteractiveFileTransfer -> _GROUP_AM_JMPTBL_WDISP_SPrintf`).

**BUT THE MARGINS DO NOT PREDICT THE COST OF A NEW ENTRY, and treating them as if
they did wastes builds.** Replacing a module makes it its own link unit, which
changes how `gen_units.py` coalesces its neighbours, so the image moves by more
than the restoration's own size delta. Measured on the 2026-07-29 tranche: three
new entries inside the 47-byte pair total +138 bytes by their own deltas, and the pair
went over by 513. Use the margins to CHOOSE candidates, then bisect empirically —
add, build, read `check_pcrel_range`, drop the biggest OVERSHOOTING entry inside
the named span, repeat. Dropping an undershooting one makes it worse.

> Two false-positive classes had to be excluded first, both found by testing the
> detector against the KNOWN-GOOD pure build rather than assuming it was right.
> DATA symbols must not be mixed in (the map lists them under `Symbols of S_1:`),
> and the encoded displacement must be large in magnitude -- a legitimate short
> branch to a local label that happens to sit 64KB from some symbol is not a wrap.

**How to grow a C manifest now.** Add restorations and build. If the check fails
it names the caller, the callee and the overshoot, so shrink the span between
them. Dropping an OVERSHOOTING restoration inside the span works, since those make
the image larger than the assembly they replace -- note that dropping an
*undershooting* one makes things WORSE, which is a real trap: the first three
entries tried this way grew the image by 12 bytes and pushed the overshoot from
23 to 35.

`src/c/replacements-tranche.txt` is the largest manifest verified WITHOUT the
far-call flag: **293 entries, check_pcrel_range clean, `a6_audit` clean, and it
BOOTS** (`tools/soak_esq.sh` PASS). `src/c/replacements-runnable.txt` is its
278-entry parent, also clean and additionally proven on all six ESC-menu items.

`src/c/replacements-all.txt` is the one to grow. At **440 entries** on
2026-07-31 it is clean on every check there is: `check_pcrel_range` 0 truncated
of 202 calls, `a6_audit` 0 of 440, `soak_esq.sh` 10 of 10 distinct frames,
`menusweep_esq.sh` clean on all six ESC-menu items with no guru, and
`framecolor.py` shows every colour bin overlapping the known-good build.

**Growing the manifest past a proven point is safe for the byte gates, which do
not read it. A manifest that has only been LINKED is not a manifest that has
been RUN.** Soak before treating a new size as good.

**A green manifest does not mean a green BUILD.** The 440-entry manifest passed
every check above while ESC failed to close the menu, because the defect was in
the far-call rewrite and no harness pressed that key. The user found it by
hand. `tools/keyprobe_esq.sh <binary> <label> 53:6 53:6 53:6` now covers it:
enter the menu, leave it, enter it again. Frame 2 must differ from frames 1
and 3.

**`ESQ_FARCALLS=1` removes this whole constraint, and `replacements-all.txt` now
links and runs under it.** Read the next section before you grow a manifest by
hand. The advice above still applies to a byte-exact manifest, which cannot use
the flag.

SEVEN of the 2026-07-29 restorations are deliberately absent from the tranche
manifest: `esq_main_init_and_run.c`, `ed_handle_editor_input.c`,
`ed2_handle_menu_actions.c`, `diskio_parse_config_buffer.c`,
`cleanup_parse_aligned_listing_block.c`, `coi_load_oi_data_file.c` and
`cleanup_draw_clock_format_list.c`. Each sits between a tight caller/callee pair
and wraps it. Nothing is known to be wrong with any of them; this is the layout
limit, not a defect, and the manifest header says so. They still count toward
coverage, which is read from the headers.

**Build it with `CODE=FAR` or it will not link, and the errors will blame the
wrong files.** The option is in the manifest header, and skipping it costs an
hour:

```sh
SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
  C_REPLACEMENTS=src/c/replacements-runnable.txt ./build-split.sh
```

Without it `sc` emits `BSR.W` for every call. Every C caller more than 32767
bytes from its callee then fails with `Error 28`. vlink names only the first few
per run, so dropping the entries it names uncovers the next batch. It reads
exactly like the manifest outgrowing the address space, and it is not. Byte-exact
manifests must NOT use `CODE=FAR`, because it changes the call encoding. That is
why it cannot be the default. `build-split.sh` now detects this case and prints
the fix.

### A prose warning in a header protects nothing (2026-07-30)

FIFTEEN restorations carry `SASC-MISMATCH: register-argument-convention`. Their
summaries say the original takes its arguments in REGISTERS, so the function is
"callable only from assembly" and is "documented, not linkable". **Not one of
them carried the `DO-NOT-LINK:` marker, which is the only form a tool reads.**
Seven were linked into `replacements-tranche.txt` and `replacements-runnable.txt`
-- the two manifests this file called verified-good, one of them "proven on all
six ESC-menu items".

They are not a subtle risk. `ESQ_SetCopperEffect_Custom` compiles to
`610000004e75`, a call and a return, against a 32-byte original that reads D0 and
D1. The function does none of its work. `ESQ_DecColorStep` linked alone over a
clean 356-entry build paints a green panel over the grid area, which is how the
class was found at all.

Every one of the fifteen now carries `DO-NOT-LINK:`, and the manifests were
rebuilt without them: maximum-C 373 -> **362**, tranche 300 -> **293**, runnable
285 -> **278**. The byte-exact manifest never contained one.

**Two rules follow.** Write the machine-readable marker whenever the prose says a
restoration must not be linked. And treat `register-args` as a link blocker
rather than only a restoration blocker -- `coverage.py` screens it when choosing
targets, which is not the same as keeping the result out of a build.

**A restoration that FAULTS AT RUNTIME says so in its own header.** Put
`DO-NOT-LINK: <what was measured>` in the header block and
`tools/gen_all_manifest.py` keeps it out of every manifest it writes. The
restoration still counts toward coverage, which is read from the headers, so the
analysis is kept rather than deleted. Two files carry it today, both weather
brush drawers, both confirmed solo against the verified baseline with an address
error -- see the notes in `src/c/wdisp_draw_weather_status_day_entry.c`.

### SOLVED: `ESQ_FARCALLS=1` lifts the 16-bit ceiling (2026-07-30)

`CODE=FAR` fixes the call encoding on the **C** side only. The assembly keeps
its own 16-bit PC-relative references, and those are what capped the manifest.
There are two forms, and the second one is easy to miss:

| form | sites | becomes |
|---|---:|---|
| `BSR.W sym` / `BRA.W sym` to a global | 882 | `JSR sym` / `JMP sym` |
| `sym(PC)` -- 3047 `JSR`, 18 `LEA`, 4 `PEA` | 3069 | the same operand without `(PC)` |

`sym(PC)` is the original's cross-unit call encoding, so it is spread over the
whole program. A first attempt at this work searched for `(sym,PC)`, found zero,
and reported the problem as ten times smaller than it is. **The syntax in these
sources is `sym(PC)`.**

An absolute operand reaches the same target with the same meaning and costs 2
bytes. vasm keeps the short form when the target is in the same unit, where the
distance is bounded anyway. Set the flag on any manifest you intend to RUN:

```sh
ESQ_FARCALLS=1 SCOPTS="NOSTKCHK DATA=FAR CODE=FAR CODENAME=S_0 DATANAME=S_1 IDLEN=128" \
  C_REPLACEMENTS=src/c/replacements-all.txt ./build-split.sh
```

Measured on the 362-entry maximum-C build: 4114 branches widened over 475
modules, `check_pcrel_range` down from 3892 calls to **219, none truncated**,
`a6_audit` 0 of 362, and the soak gives 10 of 10 distinct frames. The pure
assembly build under the flag also runs, which is the cleaner test, because a
failure there belongs to the rewrite and not to any restoration.

**The flag also retired an exclusion, and that uncovered a real defect.** 17
restorations were excluded only because an 8-bit `BSR.S` in another module
reached them, which `ESQ_FARCALLS=1` removes. Admitting them turned the grid
area GREEN in every frame. The cause was not the far-call rewrite. Four of the
17 are **register-argument** functions whose own headers said they could not be
linked, in prose that no tool reads. The 8-bit rule had been keeping them out by
accident. See the section below.

`gen_units.py` writes rewritten COPIES under `build/units/far/`, and
`build-split.sh` puts that directory first on the include path. A rewritten
module shadows the original and every other file still resolves from `src/`. The
directory is emptied on every run, so a stale tree can never shadow a pure
build. **Both byte-exact gates are untouched, because the default build does not
set the flag.**

Do NOT set it for `src/c/replacements.txt`. `verify_restorations.py` proves the
image grew by exactly the sum of per-object rounding, and widened branches add
bytes that this accounting does not know about.

Three traps, each of which cost a build to find:

1. **Widening a module can break its own short branches.** A module gains 2
   bytes per site, so an 8-bit branch inside it can go out of reach. The tool
   promotes every `.S` branch in a module it rewrites.
2. **A short branch can cross a module boundary.** `BSR.S _P_TYPE_CloneEntry`
   reaches the next module only while the two stay adjacent. An earlier version
   promoted local labels alone, and vlink answered `does not fit into 8 bits`.
   Short branches to a global are now widened everywhere, not only in rewritten
   modules.
3. **A HAND-COMPUTED branch target silently moves.** Fixed 2026-07-31, and it
   broke the ESC menu in every far build ever run. One site in the program wrote
   its target as arithmetic on two labels rather than as a symbol:

   ```
   .case_show_version:
       BSR.W   *+(_ED1_EnterEscMenu_AfterVersionText-.dispatch_table+2)
   ```

   That resolves to `_ED1_EnterEscMenu_AfterVersionText + 20`, which is
   `ED1_ExitEscMenu` only while the 20 bytes between them keep their size. The
   span holds one `JSR sym(PC)`, which the rewrite widens to 6 bytes, so the
   branch landed on the `RTS` two bytes above the target. Pressing ESC in the
   menu called a bare return, and the menu never closed.

   **Nothing could see it.** Both byte gates ignore the flag. `check_pcrel_range`
   reads the encoded displacement, and this displacement was correct -- the
   MEANING of the arithmetic changed, not the encoding. `a6_audit` and the soak
   passed. `menusweep_esq.sh` passed all six items, because it selects items with
   number keys and Return and never tests ESC-to-resume.

   The site now reads `BSR.W ED1_ExitEscMenu`, which assembles to the same bytes
   and cannot drift. Both gates stayed green across the change. A grep for
   `*+(`, `*-(`, `*+$` and `*-$` over `src/modules` and `src/data` finds no other
   site, so the class is closed. **Write a branch target as a symbol.** If a
   future disassembly pass reintroduces the arithmetic form, this returns.

The remaining 220 PC-relative calls are same-unit branches that vasm chose to
keep short. `check_pcrel_range` still runs on every build and still aborts on a
wrap, so this is a smaller haystack rather than a removed check.

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

**`register` on a loop counter is a real lever, not a no-op.** SAS/C 6.51 honours
the keyword, and it matters exactly where the frame is crowded: in a loop whose
body makes a wide call, 6.51 spills the counter and increments it in MEMORY
(`42af001c` / `52af001c`) where the original keeps it in a data register
(`7800` / `5284`). Measured twice -- `wdisp_draw_weather_status_summary.c`
240 -> 236, and `newgrid_find_next_entry_with_alt_markers.c` 252 -> 244, the
latter even though two frame slots were already pinned by out-parameter
addresses. Try it on any counter whose loop body calls something with four or
more arguments.

**The zero-local trick generalises to ANY constant, and to array strides.**
AGENTS.md already records that `if (0)` is folded away while a local holding 0
is not. The same mechanism covers three more cases, all measured on 2026-07-31:

- **A nonzero bound.** `gcommand_parse_ppv_command.c` has a dead `> 96` test the
  original still emits. Written against the literal, 6.51 folds it and emits no
  `MOVEQ #96`; written against a local holding 96, it emits the original's
  instruction. Costs 4 bytes and is the right trade under rule 1.
- **An array stride.** `tliba1_draw_formatted_text_block.c` indexes a 10-byte
  record. As `table[i].field`, 6.51 strength-reduces every one of TWELVE sites
  into shift-and-add and emits no `MULS`; holding the stride in a local and
  writing `(char *)table + i * ten` gives EIGHT `MULS`, matching the original,
  and saves 36 bytes.
- **...but only when the index is a running variable.**
  `esqiff2_parse_group_record_and_refresh.c` indexes the same way with a field
  number 6.51 can enumerate as one of {0, 1, 3}. There the stride local produces
  ZERO `MULS` either way and COSTS 12 bytes. Measure both; do not carry the
  result between functions.

**A restoration far UNDER its reference is a signal to check the REFERENCE.**
`diskio1_dump_program_source_record_verbose.c` first measured 416 against 754 --
45% short, which no codegen divergence explains. The cause was the
already-documented "not every function has a label" case: a second, unlabelled
function followed it and `refbytes.py`, which extracts label-to-label, had
concatenated the two. Labelling it is byte-neutral, corrects the worklist entry
from 754 to its true 416, and promotes the 338-byte function beneath it to its
own entry. **A large negative delta with no structural disagreement means the
reference is wrong, not the C.** A large POSITIVE delta is the ordinary case and
means the opposite.

**SHORTINT has to be measured per file, every time.** Seven files in the
2026-07-31 tranche were compiled both ways. Two adopted it
(`script_setup_highlight_effect.c`, exactly matching the reference at 748;
`locavail_parse_filter_state_from_buffer.c`, 12 under instead of 20), one was a
tie, and FOUR were made worse -- `textdisp_filter_and_select_entry.c`,
`script_handle_serial_ctrl_cmd.c`, `ladfunc_repack_entry_text_and_attr_buffers.c`
and `parseini_handle_font_command.c`. Every one of those four has the
chained-subtract dispatch the rule points at, so **the dispatch shape does not
predict the answer.** Compile it both ways and compare against the reference
size; that is the only signal.

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

Without the `status` filter that returns 137, not 9 — it counts everything
already done.

As of 2026-07-31 that leaves **4 unblocked `no-calls` candidates, 1,378 bytes** —
an earlier version of this file claimed the bucket was empty, which was wrong.
The count goes UP as well as down: four of these appeared on 2026-07-30 when
blocks that carried no label were given one, which stopped their neighbours
absorbing them. So the bucket is nearly worked out, but "nearly" has been wrong
here twice; run the enumeration rather than trusting a number.
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

## ...and not every function has a label

`refbytes.py` extracts label to label, so a function that is followed by
UNLABELLED code absorbs it. The size in the worklist is then the sum of two
functions, and a split at that label would move the second one into the C
replacement and delete it.

`ESQ_NoOp_006A` is the worked example. It reads as **58 bytes** and it is two
bytes, one `RTS`. The other 56 belong to a dead copper-list routine that the
disassembly documented in a `; FUNC:` comment and never gave a label. The same
thing hid `ESQ_NoOp_0074`.

The comment block IS the tell, because the disassembly writes one per function.
Find every site with:

```sh
python3 - <<'EOF'
import os, re
for root, _, files in os.walk('src/modules'):
    for f in files:
        if not f.endswith('.s'): continue
        p = os.path.join(root, f); lines = open(p).read().split('\n')
        for i, ln in enumerate(lines):
            if not ln.startswith('; FUNC:'): continue
            j = i
            while j < len(lines) and (lines[j].startswith(';') or not lines[j].strip()):
                j += 1
            if j < len(lines) and not re.match(r'^[A-Za-z_.][\w.]*:', lines[j]):
                print(p, ln.split(':')[1].split()[0])
EOF
```

That found 15 sites. Six were real and are now labelled, one was a false
positive (a labelled function whose comment block repeats), and the rest are in
`submodules/`, which `coverage.py` does not survey. **Adding the label is
byte-neutral** — both gates stay green — and it costs nothing else, because the
new labels need no `XDEF`: nothing outside the module refers to them.

Fixing the six moved four new candidates into the `no-calls` bucket and shrank
two worklist entries from 58 bytes to 2. Both directions are the point: the
worklist was reporting sizes that were not true.

## A `_Return` label is not a second function

`gen_all_manifest.py` refuses to link a restoration whose module holds more than
one label, because a C file replaces the WHOLE module. That rule was counting
`<name>_Return` labels, which are not functions — they are the epilogue of
`<name>`, given a label because the body branches to them, and a C restoration
carries its own epilogue anyway.

The result was silent. The file compiled, compared correctly, and simply never
appeared in any manifest. **16 restorations were being dropped** when this was
found on 2026-07-30. Nothing reported it, because a missing manifest entry looks
exactly like a manifest entry that was never written.

If a restoration seems finished and the manifest count does not move, run
`python3 tools/gen_all_manifest.py` and read the `skipped` lines it prints. Every
exclusion has a reason attached.

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

Arguments arrive in the named registers with no stack traffic. It does **not**
rescue the `register-args` family below, because SAS/C still copies the
arguments into its own callee-saved registers, whereas those routines preserve
and work in the argument registers themselves.

**It DOES rescue the callers of that family, and five restorations now depend on
it.** A function that takes nothing itself but sets D0/D1 for a hand-written
helper is ordinary C plus an `__asm` prototype on the helper.
`esq_set_copper_effect_all_on.c` is the worked example. It is linked, it is in
`replacements-all.txt`, and the colour comparison against the known-good build
shows no difference — which is the test that found the register-argument class
in the first place.

### But read the helper's CLOBBERS before you link the caller

`__asm` says where the arguments go. It says nothing about what the helper
destroys, and SAS/C assumes the standard rule: D0/D1/A0/A1 are scratch, and
D2-D7/A2-A6 survive a call. A hand-written helper is under no such obligation.

- `_ESQ_DecColorStep` works in D1 and **D2** and restores neither.
- `_ESQ_BumpColorTowardTargets` works in D1, **D2** and **D3**, and also reads a
  target stream through **A1**, which it leaves advanced by 3.

So a C caller compiled by SAS/C does not save D2, because it believes nothing
can destroy it, and D2 then leaks out to whoever called the C function. The four
copper-list restorations therefore carry `DO-NOT-LINK:` and say why. The
original callers all open `MOVEM.L D2-D5/A2-A3` and never touch D2 or D3 in
their own bodies — **that MOVEM is not redundant, it is the clobber list**. A
saved register a function appears not to use is a message about its callees.

The A1 case is worse, because the caller relies on the helper to advance the
cursor. C cannot say "the callee moved my pointer": SAS/C models A1 as clobbered
by the call, so the value cannot survive it. `register __a1` gets the pointer
in. Nothing gets the advanced value back out. See
`esq_inc_copper_lists_towards_targets.c`, which threads the cursor by hand at
+4 bytes per call site.

Three of the fifteen `register-argument-convention` files are **callers**, not
register-argument functions, and are safe to link once the clobbers check out.
`ESQ_SetCopperEffect_OnEnableHighlight` and its sibling are already linked and
already proven, because their chain ends in `_ESQ_UpdateCopperListsFromParams`,
which opens `MOVEM.L D2-D4/A6,-(A7)` and honors the convention.
