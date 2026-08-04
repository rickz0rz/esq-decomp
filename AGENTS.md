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
until each unit lands on a 4-byte boundary — which is why 1,015 source modules
become 531 link units. Source files stay fine-grained. Only the assembly grouping
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

`fixEscMenuExitDisplayMode`, also at the top of `src/Prevue.asm`, corrects a
defect in the original program. See the next section. It changes one byte and no
size, so **both settings keep `build-split.sh` content-identical**, and `= 1`
fails `test-hash.sh` by design.

## SOLVED: the ESC menu leaves the ad window grey (2026-07-31)

**Symptom.** Press ESC to open the menu, ESC again to close. The top of the
screen — the ad window, black on a healthy grid — turns solid light grey and
stays that way. The guide below keeps running correctly. It never recovers.
Measured flat at grey 0.335 for 140 seconds.

**It is a defect in the ORIGINAL, and four builds prove it.** The 614-entry C
manifest, the pure-assembly `ESQ_FARCALLS=1` build, the byte-exact known-good
build, and the shipped `ESQ.decompressed` with `DF0:` patched to `DH2:` all read
grey **0.3356**, the same number to four places. So no restoration causes it and
the far-call rewrite does not either. Test the original before blaming the
reconstruction.

**Cause.** `_ED1_ExitEscMenu` calls `_TEXTDISP_SetRastForMode(1)`. That routine
sets palette slot 0 to palette slot `n` and fills the overlay rastport with pen
`n`. Slot 1 of `_ESQFUNC_BasePaletteRgbTriples` is `12,12,12`, which is `$CCC`,
which is `(204,204,204)` — the grey that is on screen. Slot 2 is `0,0,0`, the
state before the menu opened.

`_ESQIFF_PlayNextExternalAssetFrame` gives the ad window back to the guide twice,
and both times it writes the same four calls with a **2**:

```
_ESQIFF_RestoreBasePaletteTriples / SetCopperEffect_OffDisableHighlight
PEA 2.W / _TEXTDISP_SetRastForMode / _ESQIFF_RunCopperRiseTransition
```

`_ED1_ExitEscMenu` is that sequence with a `1`. Every other caller in the program
passes 0 or 2. This site is the only `1`.

**Fix.** `fixEscMenuExitDisplayMode = 1` in `src/Prevue.asm` changes `PEA 1.W`
to `PEA 2.W`. Both encode in 4 bytes (`4878 0001` and `4878 0002`), so the
monolithic image differs by **exactly one byte at 0x00E4C5 and no code moves**.
Verified: `build-split.sh` reports CONTENT-IDENTICAL at both settings.

Set it without editing the file:

```sh
ESQ_FIX_ESCMENU=1 ./build-split.sh
```

The equate sits behind `ifnd`, and `build-split.sh` passes `-D` to **both** the
reference monolith and every unit, so the two sides still compare like with like.
`test-hash.sh` takes no environment and therefore always builds the default.

**The C arm must move with it.** `src/c/ed1_exit_esc_menu.c` replaces this module
in `replacements-all.txt`, so the assembly flag alone would leave a maximum-C
build broken. `build-split.sh` reads `fixEscMenuExitDisplayMode` out of
`src/Prevue.asm` and passes `DEFINE=ESQ_FIX_ESCMENU` to `sc`, so the two arms
cannot disagree. The default of 0 keeps the file byte-comparable, so
`cmatch.sh` and `mismatches.py --recheck` still measure the exact arm.

**Why every harness missed it.** Both byte gates ignore runtime behaviour.
`check_pcrel_range`, `a6_audit` and `data_shape_audit` all pass. `soak_esq.sh`
passes, because the guide keeps redrawing and the frames stay distinct.
`menusweep_esq.sh` passes, because it selects items with number keys and never
presses ESC to resume. `framecolor.py` compares whole-frame colour bins, and one
bin turning grey still overlapped. The user found it by looking at the screen.

```sh
./tools/escwatch_esq.sh <binary> <label> [open_wait] [shots] [gap]
```

That is the regression test. It opens the menu, closes it, then shoots on a timer
with **no further input**, and exits nonzero if the grey survives. A single shot
after the close cannot tell a permanent fault from a redraw still in progress, so
watch the series rather than one frame. `tools/menuresidue.py` scores frames from
any source and also exits nonzero.

## SOLVED: a byte-wide extern on a word-wide global (2026-07-31)

Found while proving the ESC-menu fix on the 614-entry manifest, and it is a
**separate defect** with a separate cause. After the menu closed, the maximum-C
build drew the header row and the running clock and left the rest of the guide
black. The pure-assembly build redrew it correctly, so this one belongs to a
restoration.

**Cause.** `script_prime_banner_transition_from_hex_code.c` declared
`CONFIG_BannerCopperHeadByte` as `unsigned char`. The data section spells it
`DC.B 0 / DC.B 142`, which looks like two bytes and is one word: every reader in
the program loads it with `MOVE.W` and every writer stores `MOVE.W`. On a 68000
offset 0 is the HIGH half, so the byte declaration read **0 instead of 142** and
primed every banner transition toward character 0. Eleven other restorations
already declared it `short`, several with a header comment saying why.

**The data section is not the authority on width. The code is.**

Fixing it also made the restoration more faithful: 90 bytes plus an alignment NOP
became 92 against 92, and the emitted stream now carries the original's word load.

```sh
python3 tools/extern_width_audit.py          # the manifest
python3 tools/extern_width_audit.py --all    # every restoration
```

`build-split.sh` runs it on any build that sets `C_REPLACEMENTS` and aborts on a
hit. It compares each C extern's declared width against the operand size the
module it replaces uses on that symbol, and reports only the direction that can
be wrong: **C narrower than the assembly**. Narrower assembly is ordinary, since
`MOVE.B` on a word global is a cast to char.

Two filters keep it honest, and both were needed to get from 25 hits to 0:

- A symbol used only as `&NAME` is skipped. The address of a symbol does not
  depend on its declared width, so four `char` declarations of pointer globals
  are harmless. `LEA` and `PEA` are excluded for the same reason.
- Widths are taken from the module the C file REPLACES, not program-wide.
  `HIGHLIGHT_CopperEffectSeed` is a `DC.W` that one unrelated routine reads with
  `MOVE.L`, deliberately, to pick up the two bytes after it.

**Nothing else could see this.** Both byte gates ignore a C build.
`data_shape_audit.py` asks whether the symbol IS the data or POINTS AT it, which
was right either way. `check_pcrel_range` and `a6_audit` passed. The file was
already recorded `behavioural`, so a smaller emitted size read as ordinary
codegen divergence rather than as a wrong load. It is the same family as the
clock-format table that was read one level too shallow: a C declaration can name
the right symbol and still read the wrong bytes.

**A second, smaller divergence is recorded but NOT changed.**
`_ED1_EnterEscMenu` copies 24 bytes from `_KYBD_CustomPaletteTriplesRBase` into
the working palette and the exit never calls `_ESQIFF_RestoreBasePaletteTriples`,
which is the call the asset player pairs with `SetRastForMode`. Both palettes
hold the same 8 triples by default, so this is invisible until an INI `COLOR`
entry changes the custom one. Restoring it would add a 4-byte call and move code,
which the one-byte fix does not. Leave it until something measures a difference.

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

### AN LVO NAME IN THE DISASSEMBLY CAN NAME THE WRONG LIBRARY

`_EXEC_CallVector_48` calls `_LVOexecPrivate3`, which is -48, and the name says
exec. It is not exec. The base it loads is `_INPUTDEVICE_LibraryBaseFromConsoleIo`,
ESQ's cached CONSOLE DEVICE base, and -48 on console.device is `RawKeyConvert`.
The offset table the disassembly labelled from was simply the wrong library.

**The register spec is what makes an identification certain, not the offset.**
The stock pragma is:

    #pragma libcall ConsoleDevice RawKeyConvert 30 A19804

`04` is the argument count and the nibbles before it are the registers read
right to left: 8 = A0, 9 = A1, 1 = D1, A = A2. The original loads exactly those
four, in exactly that order:

    MOVEM.L 12(A7),A0-A1        ; event, buffer
    MOVEM.L 20(A7),D1/A2        ; length, keymap

An offset alone matches many functions. An offset plus a four-register order
matches one. Check `sc/include/pragmas/*_pragmas.h` before naming a vector.

`src/c/esq-console.h` restates that pragma against ESQ's own base variable,
because the stock one names `ConsoleDevice` and ESQ does not use that name.

## Never include `<proto/*.h>`

Use `src/c/esq-dos.h`, `esq-exec.h`, `esq-graphics.h`, `esq-diskfont.h` and
`esq-intuition.h` instead. They are the stock headers with the library base
declared **`volatile`**.

`esq-intuition.h` arrived on 2026-07-31 with `esq_check_topaz_font_guard.c`,
which calls `SizeWindow` and `RemakeDisplay`. It needed a C-visible name for the
base, so `src/data/esq.s` gained an `_IntuitionBase` label beside
`_Global_REF_INTUITION_LIBRARY` -- the same arrangement `_GfxBase`, `_DOSBase`
and `_DiskfontBase` already use. A label emits no bytes, so both gates stayed
green across the change.

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

## An `(A4)` symbol is a NAMED ADDRESS IN OUR OWN DATA, not hidden runtime state

`modules/submodules/` is full of references like `Global_DosIoErr(A4)` and
`LEA Global_CharClassTable(A4),A0`. They look like SAS/C runtime state living in
a near-data area that a `DATA=FAR` build cannot reach, and that reading is
wrong. It cost one restoration a needless functional analogue before it was
checked.

**A4 is `_Global_REF_LONG_FILE_SCRATCH`.** `ESQ_StartupEntry` loads it in its
fourth instruction and never changes it. The label sits at DATA offset 32768 --
the classic SAS/C near-data base of data+0x8000 -- and the `Global_*` names are
plain equates in `src/Prevue.asm` giving a displacement from it.

So resolving one is arithmetic:

```
address = offset_of(_Global_REF_LONG_FILE_SCRATCH) + <the equate>
```

Look that address up in the DATA label map and the symbol usually has a name.
`Global_CharClassTable` is -1007 and lands exactly on `_WDISP_CharClassTable`,
which another restoration was already indexing directly.
`Global_GraphicsLibraryBase_A4` is -22440 and lands on `_GfxBase`, which is the
same variable `esq-graphics.h` uses.

**So an A4 reference is normally a FAITHFUL restoration reached by a different
addressing mode, not an analogue.** The divergence is only
`near-data-addressing`: a 16-bit displacement off A4 becomes an absolute
reference, 2 bytes more per site, which is what `DATA=FAR` means.

Two cautions before assuming every one resolves:

- **Some land on unlabelled space.** `Global_DosIoErr` (-640),
  `Global_HandleTableBase` (+22492) and nine others point into the middle of a
  `DS.B`/`DS.L` block that carries no label of its own. Those need a label added
  first -- byte-neutral, like every other labelling in this project -- before C
  can name them.
- **Many are expressions, not literals.** `Global_AppErrorCode` is defined as
  `Global_FormatCallbackByteCount+Type_Long_Size`. The arithmetic has to be
  evaluated before the lookup; a regex for `= <number>` sees only 14 of the 59.

## The "proven blockers" were NOT blockers. Here is the corrected analysis

An earlier version of this file claimed four things could never be written in C
and that 0% assembly was therefore unreachable. **Three of the four were wrong.**
The error was generalising from one true measurement without testing the ways
around it, and it is written up here because the wrong version was believed for
a while and acted on.

### What was actually measured, and what was wrongly concluded

TRUE: SAS/C reads the REMAINDER out of D1 after calling its divide helper.
Compile `return a % b;` and the call is followed by `move.l d1,d0`. A C function
returns one value, in D0, so a C definition of `__CXD22` cannot satisfy `%`.

FALSE, and this is the part that was assumed rather than tested: that this makes
the helpers unwritable. Three measurements say otherwise.

**Only `%` reads D1.** `a / b` calls the same helper and reads D0. So a C-written
`__CXD22` serves every division in the program correctly.

**`%` has an exact workaround that reads only D0.** `x - (x/y)*y` compiles to
`jsr __CXD22` / `jsr __CXM22` / `sub.l` -- two helper calls, both read through
D0, no D1 anywhere. There are 62 `%` sites in `src/c`.

**The helper bodies are expressible.** A shift-subtract division loop compiles
with NO external reference at all -- no `__CXD22`, so it cannot recurse. And
`(unsigned long)(unsigned short)a * b` emits `MULU.W` inline, so `__CXM33` can be
built from 16-bit partial products without calling itself. Both verified by
compiling and reading the object's xref list, which was empty.

So the divide and multiply helpers are a bounded refactor -- rewrite 62 `%`
sites, then write four helpers in C -- not an impossibility.

### The stack-restoring pair is setjmp/longjmp

`ESQ_ShutdownAndReturn` ends:

```
MOVE.L  (A7)+,D0
MOVEA.L Global_SavedStackPointer(A4),A7
MOVEM.L (A7)+,D1-D6/A0-A6
RTS
```

That is a stack switch and a return on the restored stack, which no C statement
expresses -- but it is precisely what `longjmp` does, and SAS/C has it.
`Global_SavedStackPointer` is written and read ONLY inside
`modules/groups/_main/a/a.s`, by this function and by `ESQ_StartupEntry` which
saved it. Nothing else in the program touches it, so replacing the saved-state
representation with a `jmp_buf` is a change local to that one pair.

It is a functional analogue rather than a transcription, and it has to be
labelled as one.

### The startup entry is an `__asm` function

`ESQ_StartupEntry` is entered by the OS with the command line in A0 and its
length in D0, which `register __a0` / `register __d0` express. It also does
`LEA _Global_REF_LONG_FILE_SCRATCH,A4` to establish the near-data base -- and a
`DATA=FAR` build needs no A4 at all. Ten modules still reference `(A4)`, every
one of them still assembly and every one on the conversion list. When they are C
they will use the absolute accessors in `src/c/esq-neardata.h`, and A4 becomes
dead.

### So what is the real floor?

**Zero, as far as anything measured so far shows.** Each of the three is work --
some of it delicate, the setjmp pair especially -- but none is a wall.

The honest statement is: no remaining assembly has been shown to be
inexpressible. That is different from a proof that all of it is expressible, and
the difference matters. Test the specific claim before recording another blocker,
and record what was measured separately from what was concluded.

## Library code is not application code

`src/modules/submodules/unknown*.s` is largely SAS/C runtime library code, not
application code. Confirmed: every relocation-free routine there appears
verbatim in SAS/C 6.51's `sc.lib` — `STRING_AppendAtNull` (`strcat`),
`MATH_DivS32`, `MATH_Mulu32`, `STRING_CompareNoCase`, `STRING_CopyPadNul`,
`FORMAT_U32ToOctalString`. (Routines with A4-relative fixups cannot be compared
this way, since those are resolved at link time and absent from the reloc
table — the 5% verbatim-match figure is a floor, not a ceiling.)

**Do not hand-decompile these.** No C fed to `sc` reproduces them, because they
were built from SAS's own library sources. Treat a stubborn mismatch in a
`submodules/` function as a signal that it is library code.

### ...but LINKING sc.lib is not the answer, and this was measured (2026-08-03)

An earlier version of this section said the faithful route is to link `sc.lib`.
Three measurements say otherwise, and all three point the same way.

**sc.lib CANNOT be added to the link. It collides on exactly 9 symbols**, which
are the 9 vlink reports. ESQ defines all of them itself: the six AmigaOS library
bases (`_DOSBase`, `_DiskfontBase`, `_GfxBase`, `_IntuitionBase`, `_SysBase`,
`_UtilityBase`) and the three SAS/C arithmetic helpers (`__CXD22`, `__CXD33`,
`__CXM33`). The bases became C definitions when the DATA section converted, so
this collision grew as the C lane advanced.

**It is not needed either.** Across the whole 770-entry link, exactly ONE symbol
is undefined -- `_LinkerDB`, the near-data base, which vlink supplies itself. So
the library has nothing to contribute.

**The helpers are already handled better than sc.lib could.**
`src/modules/submodules/unknown22_p0.s` exports the ORIGINAL's own routines
under SAS/C's names: `__CXM33` is `MATH_Mulu32`, `__CXD33` is `MATH_DivS32`,
`__CXD22` is `MATH_DivU32`. Every `/` and `%` a restoration compiles therefore
lands on the original's code. Linking 6.51 would replace it.

**And replacing it would LOSE fidelity, by a measured 20 bytes.** Our `__CXD33`
(50 bytes) and `__CXM33` (32) are byte-identical to 6.51's. Our `__CXD22` is the
same length as 6.51's, 146 bytes, agrees for 121 of them, and then differs in a
20-byte tail. Two routines identical and a third differing slightly is the
signature of a NEARBY library version, and it belongs with the version evidence
in `docs/compiler-version.md`.

So `SCLIB=` stays available for a future need and must not be set today. The
comment in `build-split.sh` used to call an unnecessary library "harmless but
noisy"; it is not harmless, it fails the link.

### Reading the library, and matching a routine to a member

```sh
python3 tools/sclib.py <lib>                 # every member and its symbols
python3 tools/sclib.py <lib> --symbol __CXD22
python3 tools/libmatch.py --all-remaining    # which submodules ARE library members
python3 tools/libmatch.py <Label> ...
```

`sc.lib` is not an `ar` archive. Each block is HUNK_LIB, a body of concatenated
hunks with NO HUNK_UNIT or HUNK_END between units, then a HUNK_INDEX naming
them. 6.51's sc.lib holds TWO such blocks. Symbol definitions live in the index,
so a parser that walks only the body finds 528 hunks and zero symbols.

`libmatch.py` masks the fields a relocation patches, at each one's own width,
which is what makes the comparison honest. The commonest relocation in a
near-data library is the A4-relative DREL16, and masking 4 bytes there would
hide two bytes of real opcode and manufacture a match.

**It finds 3 of the 51 remaining routines under 6.51, and that low rate is the
point.** The original linked ITS OWN library version, so 6.51's members are not
expected to match.

**All three installed libraries have now been compared, and the library brackets
the version from both sides:**

| routine | size | Lattice 5.10 | SAS/C 6.00 | SAS/C 6.51 |
|---|---:|---|---|---|
| `MATH_DivS32` = `_CXD33` | 50 | identical | identical | identical |
| `MATH_Mulu32` = `_CXM33` | 32 | 8 differ | identical | identical |
| `MATH_DivU32` = `_CXD22` | 146 | **2 differ** | 20 differ | 20 differ |

ESQ has 6.x's multiply helper, which Lattice 5.10 does not, and a divide helper
two bytes from Lattice's against twenty from 6.x's. That is a library BETWEEN
the two, which is the same window the codegen tests give. 6.00 and 6.51 are
indistinguishable on this test. The whole Lattice difference is one instruction:
ESQ has `exg.l d0,d1` where Lattice has `exg.l d1,d0`. Full write-up and the
one-command recipe: `docs/compiler-version.md`.

**A short match is not an identification, and the tool says so.** Every AmigaOS
stub in `amiga.lib` is the same three instructions -- load the base into A6,
`JSR` a negative offset, `RTS` -- so a 20-byte routine "matching"
`_FreeVisualInfo` means nothing. Anything under 24 bytes is listed separately
rather than counted.

**But short matches that CORROBORATE each other are evidence, and one settled a
module.** `modules/submodules/unknown36.s` is SAS/C's `_cxbrk.c`, the Ctrl-C
break requester. Its strings appear in that member at 258, 286, 296 and 302,
which is exactly their order and spacing in our module: `** User Abort Requested
**`, `CONTINUE`, `ABORT`, `*** Break: `. The string block is identical and only
the code differs, 416 bytes against 332 -- the version gap seen from the other
side.

Note `amiga.lib` and `small.lib` are NOT HUNK_LIB. They are plain object units
concatenated, with their symbols in a HUNK_EXT per unit, so a HUNK_LIB-only
parser reports 0 members and that reads exactly like an empty library.

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

**Coverage is 98.0% by byte, 702 restorations, both gates green. The
push-to-the-ceiling run of 2026-07-31 is DONE.** It took coverage from 75.3% by
working the worklist straight down, largest first, and by LABELLING four blocks
the disassembly had documented but left unnamed -- `ESQIFF_NoOpFrame`,
`GCOMMAND_ShiftBannerCopperRowsDead`, `TLIBA1_DumpFormatStruct` and the stub
after `ESQIFF_QueueIffBrushLoad`. Each label is byte-neutral and each corrected a
worklist entry that was reporting two functions as one.

The last item was `_ESQPARS_ConsumeRbfByteAndDispatchCommand`, 5,956 bytes, the
RBF serial command interpreter and the largest function in the program. It alone
moved coverage 3.1 points. It has NO jump table -- the dispatch is a chain of
`SUBQ.W`/`SUBI.W` on the command byte, which a C `switch` reproduces -- and 30
command arms, most of them the same read-record-then-verify-checksum shape.
Read the arms by ADDRESS ARITHMETIC on the `BEQ.W` displacements rather than by
the label names: several labels in that module name the wrong command, and
`.processCommand_D_Diagnostics` is in fact the 'K' clock handler.

**Three unblocked functions remain, 398 bytes, and all three were read and
confirmed NOT restorable as C**: `ESQ_ShutdownAndReturn` (76 bytes, restores A7
from a global), `ESQSHARED4_LoadCopperColorWordsFromNibbleTable` (92, D3/A2/A3
live on entry) and `ESQSHARED4_ApplyBannerColorStep` (230, several entry points
branching back into its own head). `coverage.py` does not screen these because
each blocker is a shape its rules do not cover. **So 97.2% is the practical
ceiling, not a waypoint.** Everything else that is left carries a blocker:
1,148 bytes of interior labels and the rest register-argument or falls-through
shapes. Run `python3 tools/worklist.py 99999` to confirm before assuming there
is work; it regenerates from `coverage.survey()`, so it cannot go stale.


Function count flatters: the easy targets are small, so a high count can sit on a
tiny fraction of the program. 202 restorations once read as 28% of the program
and was 5.2% of it by byte. At 702 restorations the two readings have converged
-- 96% by count against 98.0% by byte -- because the large end has been worked.

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
| intra-unit (`6100`) | **13** | 274 | 5% |
| no-calls | **16** | 131 | 11% |
| cross-unit (`4EBA`) | **0** | 255 | **0%** |

Zero of 255. Every function whose original calls are `4EBA` is capped at
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
> **`soak_esq.sh` HAS A FALSE-FAIL MODE AND THE FROZEN-RUN LENGTH DOES NOT
> DISTINGUISH IT.** It reports `DISPLAY FROZEN` on a healthy binary often enough
> to send you bisecting something that is not broken. Re-run twice before
> believing a FAIL; two of three passing means the binary is fine.
>
> Run length is NOT the tell. One flake showed `longest identical run: 2` and
> another showed **10** -- every frame identical -- and both passed on re-run.
> These two numbers are the tell, and they have held on every case measured:
>
> | | healthy or flake | real fault |
> |---|---|---|
> | `illegal/exception lines` | 1 | 2 or 3 |
> | `log lines` | 1032-1033 | 1199-1202 |
>
> `frames with Amiga content` is the third: 10/10 healthy, 0/10 to 6/10 when the
> machine died. The `data/flib.s` layout break and the strncpy overrun both moved
> all three and reproduced every run; both flakes moved none of them.

> **A MEDIAN DIFFERENCE BETWEEN THE PURE AND MAXIMUM-C BUILDS IS EXPECTED, and it
> is not evidence of anything.** Measured 2026-08-01: the pure far build reads
> blue 0.045 and yellow 0.017 at the median, and EVERY maximum-C build reads
> 0.026 and 0.012 -- the 713-entry build and the 642-entry build from many
> commits earlier give the same two numbers. The MINIMA and MAXIMA agree, so the
> same screens are being drawn; the maximum-C image is about 8% larger and slower,
> so over a 150-second sample it sits in different proportions of ESQ's display
> cycle.
>
> So before treating a median gap as a defect, **compare an OLDER maximum-C build
> against the same pure build.** If the gap is already there, it belongs to the
> build class and not to the change under test. The pure build compared against
> ITSELF is the other control worth having: its medians reproduce to within 0.003.
>
> The gap that DID mean something looked different -- the clock-format defect had
> yellow at half on all three of min, median and max, and the register-argument
> defect had green at 0.328 against 0.000, which is disjoint rather than merely
> shifted.

> It bins every pixel of every frame into six coarse colours and prints the
> min, median and max share per bin per label. **Read the RANGES, not the
> medians.** Two ranges that overlap are the display cycle and mean nothing. A
> bin whose ranges are DISJOINT is a real difference in what the program drew,
> and the tool exits nonzero on one.

> **THE GREEN BIN IS AN EXTERNAL AD BRUSH AND IT IS INTERMITTENT. Do not read
> it as a regression.** ESQ loads IFF advertisements from disk on its own
> schedule, and the "sportsview" brush fills a third of the screen with green
> when it is up. On 2026-08-02 a pure far build showed it in 6 of 10 frames
> (green 0.285) while every maximum-C build showed 0.000 across 20 frames, and
> that reads exactly like a broken asset path. It is not. **The pristine
> `ESQ.known-good-36cf56ed` also shows 0.000**, and so did a 300-second run and
> a build with all 49 `esqiff`/`brush`/`ctasks` restorations removed. The brush
> appeared in ONE run out of six.
>
> The general rule this is a case of: a bin that is present in one build and
> absent in another is only evidence once the KNOWN-GOOD build has been soaked
> in the same session and agrees with the candidate. Soaking it costs two and a
> half minutes and settles the question. A bisect started on this signal costs
> hours and finds nothing.

`~/Downloads/Prevue/ESQ.known-good-36cf56ed` is the pristine byte-exact build.
**Probe it first whenever a FAIL looks surprising**, since every harness copies
the candidate over `~/Downloads/Prevue/ESQ`.

**A run stuck at the BOOT LOADER passes the statistics table.** One 300-second
soak captured 10 identical frames of Workbench showing `Loading PREVUE Software
/ PLEASE WAIT..... / ROM version 2.04` -- ESQ never started. It reported
`frames with Amiga content: 10/10`, `illegal/exception lines: 1` and
`log lines: 1032`, which is the HEALTHY signature in the table above, under a
`DISPLAY FROZEN` verdict that would otherwise read as a flake. The same binary
booted normally on the next run. **Look at one frame before believing either
the verdict or the statistics.**

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

### NOTHING JUDGED WHAT A BUILD WRITES TO DISK, and the reason is worse

Every harness above judges a build by what is ON SCREEN. `tools/fileio_esq.sh`
adds the drive side: it hashes the emulated drive, boots a build, captures every
created or modified file, and RESTORES the drive from a backup taken outside it.
`tools/fileiodiff.py` compares two captures with clock stamps masked, and
reports line-ending changes separately because CRLF versus LF is the most likely
stdio defect.

```sh
tools/fileio_esq.sh <pure-build> pure 90 53:5 19:3 36:6 36:4 53:6 53:10
tools/fileio_esq.sh <candidate>  cand 90 53:5 19:3 36:6 36:4 53:6 53:10
python3 tools/fileiodiff.py pure cand
```

**`df0:` IS NOT THE FLOPPY. It is the same host directory the harness watches.**
ESQ's data paths all start `df0:` -- `"df0:config.dat"`, `"df0:err.log"`,
`"DF0:LocAvail.dat"` -- and reading that as the floppy drive is wrong. The drive's
own `S/Startup-Sequence` reassigns it before ESQ ever starts:

```
assign df0: dismount
assign df0: dh1:
```

`dh1:` is `hard_drive_1` in the fs-uae config, which is `~/Downloads/Prevue`. So
every `df0:` path lands in the directory `fileio_esq.sh` snapshots, and
`BLANK.ADF` only exists to let the boot finish. The drive holds `config.dat` and
`LocAvail.dat` under exactly the names ESQ opens, which is the corroboration.

**The assign lives OUTSIDE this repository**, in the emulated drive's startup
script. Nothing in `src/` records it, so a grep of the sources for `dh2:` finds
zero data paths and the floppy reading looks correct. An earlier version of this
section drew that conclusion and it was wrong. **Read the drive's
`S/Startup-Sequence` before concluding anything about where a path resolves.**

**An empty capture can be a HARNESS result**, and the first thing to suspect is
the boot delay. Keys sent before ESQ is up go nowhere and the run then reads as a
program that wrote nothing. Pass `BOOT=95`, the value `keyprobe_esq.sh` needs.
`fileiodiff.py` exits 2 rather than 0 when neither build wrote anything, because
a clean result there proves nothing.

**BUT THE EMPTY CAPTURE HERE IS REAL, AND THE CAUSE IS THE MISSING SERIAL FEED.**
Measured 2026-08-04 on `ESQ.known-good-36cf56ed`, 150 seconds, six menu keys at
`BOOT=95`: **no file on the drive changed at all.** Confirmed independently of
the harness by mtime, including the `.uaem` metadata the snapshot excludes and
the restore never touches. Only `ESQ` itself changed, which is the harness
staging the binary.

Every data write is gated behind a pending flag, and the listing data path sets
those flags:

```
DISKIO2_FlushDataFilesIfNeeded
    -> if (CTASKS_PrimaryOiWritePendingFlag)   COI_WriteOiDataFile(...)
    -> if (CTASKS_SecondaryOiWritePendingFlag) ...
```

`CTASKS_PrimaryOiWritePendingFlag` is set by `CLEANUP_ParseAlignedListingBlock`
and `DISKIO2_LoadCurDayDataFile`, and `DISKIO_SaveConfigToFileHandle` is called
from `ESQPARS_ConsumeRbfByteAndDispatchCommand` -- the RBF **serial** command
interpreter. **ESQ is a broadcast receiver.** With no head-end feeding it
listings, nothing marks data dirty, so nothing is written, and a keyboard-only
harness cannot reach the write path however it is driven.

So `fileio_esq.sh` is correct and currently has nothing to measure. **The SAS/C
stdio write layer -- `STREAM_BufferedPutcOrFlush` and `STREAM_BufferedGetc` --
therefore has NO runtime coverage of any kind, and restoring it would be both
unverifiable and unexercised.** Getting coverage means driving the SERIAL port
(`serial_port` in the fs-uae config, ESQ opens it at baud 2400) with RBF
commands. That is a new harness, not a longer key sequence.

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

`src/c/replacements-all.txt` is the one to grow. It stands at **822 entries**,
every DATA module among them, with 28 restorations held out as unsafe to link.
It went 440 -> 464 from new restorations and 464 -> 614 from SPLITTING modules,
which is the cheaper lever of the two and was sitting unused. It went 770 -> 790
on 2026-08-03 from CONVERTING JUMP TABLES and from the alias forwarders that
unblocked them. Both are described under "The last mile to 100% C" below.

**At 822 it is PROVEN END TO END** (2026-08-03), on the same sequence that
proved 440: `check_pcrel_range` 0 truncated of 50 calls, `a6_audit` 0 of 821,
`data_shape_audit` and `extern_width_audit` clean, `data_offset_audit` 50 data
modules in agreement, `soak_esq.sh` PASS at 150 seconds twice and at 300 once
(10 of 10 distinct frames, 10 of 10 holding Amiga content, 1 exception line,
1032 log lines), `keyprobe_esq.sh <bin> <label> 53:6 53:6 53:6` alternating
menu-open / closed / open with three distinct pixel hashes,
`menusweep_esq.sh` clean on all six ESC-menu items, `guru_detect.py` exit 0 on
every shot set, and `framecolor.py` every bin overlapping the pure far build.

> **The two weather brush drawers are LINKED again.** Both carried
> `DO-NOT-LINK: address error (Guru 8000 0003) within 50 seconds of boot`, and
> at 770 entries the guru NO LONGER REPRODUCES -- 300 seconds of soak plus the
> menu sweep, against a fault that used to be certain inside 50. Neither file
> changed, so the cause was elsewhere. The register-argument, extern-width,
> extern-shape and far-call branch-target fixes all landed in between. **A fault
> that stopped reproducing is not a fault that was understood.** Both headers
> keep their original analysis for whoever meets it next.

**Four defects had to be fixed before it would link at all**, and every one was
invisible to the byte gates. Read these before growing the manifest again:

1. A manifest row named a C file that is not on disk. Four jump tables stayed in
   assembly and nothing reported it.
2. A missing `<string.h>` turned an inlined `strlen` into a call to an undefined
   symbol.
3. The DATA hunk lost its CHIP flag.
4. The DATA hunk grew 20 bytes.

The last two have their own sections below.

**Growing the manifest past a proven point is safe for the byte gates, which do
not read it. A manifest that has only been LINKED is not a manifest that has
been RUN.** Soak before treating a new size as good.

## The last mile to 100% C

**MEASURE THIS IN BYTES, NOT IN MODULES.** A module count says 240 includes are
still assembly and that is misleading: 150 of them are EMPTY files and 10 hold
only an alignment pad. The honest number comes from the link map.

**The maximum-C build is 96.6% C by CODE byte.** 226,404 bytes of 234,256 come
from compiled C. 7,852 bytes are assembly.

```sh
python3 tools/lastmile.py                  # module buckets, plus the code worklist
python3 tools/lastmile.py --list jumptable # the modules in one bucket
```

It reads `src/Prevue.asm` and the manifest, so it cannot go stale. For the byte
split, read `build/ESQ.map`: a contributor whose name ends `.asm` is assembly and
everything else is C.

### The floor, re-measured after the divide-helper and interrupt work

Two things this table used to call impossible are now DONE and linked. What is
left is smaller and better understood.

| bytes | share | why it is still assembly |
|---:|---:|---|
| ~5,500 | 2.4% | SAS/C runtime and protocol code in `submodules/` |
| ~1,560 | 0.7% | headless continuation modules and small pads |
| ~1,000 | 0.4% | jump tables blocked on VARIADIC or unrestored targets |
| 660 | 0.3% | register-argument helpers, marked `DO-NOT-LINK` |
| 564 | 0.2% | the `_ED1_EnterEscMenu` fall-through pair |
| 464 | 0.2% | one body with several entry points |
| 460 | 0.2% | the startup and shutdown entry |

Regenerate it from `build/ESQ.map`; a contributor whose name ends `.asm` is
assembly.

### SOLVED: the divide helpers are C, and the remainder in D1 is gone

`__CXD33`/`_MATH_DivS32`, `__CXD22`/`_MATH_DivU32` and `__CXM33`/`_MATH_Mulu32`
are now `src/c/lib_math_helpers.c`. Every `/` and `*` in the program runs
through compiled C.

**The obstacle was real and it was not the register convention.** These helpers
return TWO values -- the quotient in D0 and the SIGN-CORRECTED REMAINDER in D1 --
and that is how SAS/C implements `%`:

```
long r(long a, long b) { return a % b; }
   -> 2007 2206 61000000 2001      ... BSR.W __CXD33 / MOVE.L D1,D0
long q(long a, long b) { return a / b; }
   -> 2007 2206 61000000           ... BSR.W __CXD33   (D0 used as-is)
```

A C function returns ONE value, so no C definition can preserve D1. **Do not
trust the `; RET: D0: result/status` header comments in `modules/submodules/` --
they are auto-generated and they hide second return values.** The four `NEG.L D1`
instructions in `_MATH_DivS32` are the proof: they sign-correct the remainder and
would be dead code otherwise.

**The fix was to remove the dependency, not to work around it.** Every `%` in
`src/c` became `a - (a / b) * b`, which compiles to a divide and a multiply that
both read only D0. 56 sites in 31 files.

```sh
/tmp/.capvenv/bin/python tools/d1_remainder_audit.py            # the linked image
/tmp/.capvenv/bin/python tools/d1_remainder_audit.py --src f.c  # one source file
```

**It must report ZERO before `unknown22_p0.s` may be replaced.** It went 57 -> 0.
Nothing else can see this fault: the caller's bytes are right, the helper's bytes
are right, and only the pairing is wrong.

Three traps the audit had to survive, each of which made it report a false clean:

- Scanning `src/**.s` finds sites that are NOT IN THE BUILD, because a module
  replaced by C never links. It scans the linked image instead.
- A linear disassembly of the CODE hunk DESYNCS on the embedded jump tables and
  found 0 of 106 calls. It scans for the call opcodes and disassembles only the
  short window after each one.
- On a `CODE=FAR` build the call is `JSR abs.L` with a FOUR-byte relocation, not
  `BSR.W` with a two-byte one. Filtering on size 2 found nothing at all.

Writing the helpers needs two more things. The arguments arrive in registers, so
each is an `__asm` function with `register __d0` and `register __d1` parameters.
And neither body may use `/`, `%` or `*` on a long, or it compiles into a call to
itself -- the divide is a shift-and-subtract loop and the multiply is built from
16-bit partial products, which emit `MULU.W` inline. The compiled object has an
EMPTY xref table, which is how that was checked rather than assumed.

The C divide is slower than the original, which uses `DIVU` on 16-bit halves.
If it ever shows up in a profile, that is the optimisation to add.

### SOLVED: the vertical-blank interrupt server is C

`_ESQ_TickGlobalCounters` is the `is_Code` target that `_SETUP_INTERRUPT_INTB_VERTB`
installs, and it is now compiled C. It needed NO keyword at all -- not
`__interrupt`, not `__saveds` -- and that is the part worth remembering.

- The original reads NO incoming register. Its first instruction is a global
  load, so A1, A5 and A6 are ignored.
- The original saves nothing and touches only D0/D1/A0/A1, which is exactly what
  AmigaOS lets an interrupt server clobber. Compiled C opens
  `MOVEM.L D5-D7,-(A7)`: it saves every callee-saved register it uses, so it
  honours the same rule automatically.
- The compiled object references A4 **zero** times. `__saveds` would therefore be
  actively WRONG here -- it would load LinkerDB into A4 in interrupt context,
  where the interrupted task's A4 must be left alone.

SAS/C 6.51 does have both keywords, and they work:

```
void __interrupt f(void)   3039<G> 5440 33c0<G> 4a80 4e75    ... TST.L D0 / RTS
void __saveds    f(void)   2f0c 49f9<LinkerDB> ... 285f 4e75  A4 save / set / restore
```

Reach for `__saveds` when the ORIGINAL opens `MOVE.L A4,-(A7)` / `LEA <data>,A4`
-- that is a Task callback establishing ESQ's near-data base, and
`_LOCAVAIL2_AutoRequestNoOp` is the worked example. An interrupt server that
never touches A4 does not want it.

### EVERY JUMP TABLE IS NOW C. The lever is exhausted

All 26 are converted, 2026-08-04. `tools/lastmile.py` reports no `jumptable`
bucket at all. Three things made the last eleven possible, and each is written up
below: a v-form for a variadic target, `split_module.py` to cut a convertible
routine away from one that is not, and reading the register spec in
`sc/include/pragmas/*_pragmas.h` to identify a library vector.

### C code does NOT need the jump tables, and no longer uses them

A jump table entry is one `JMP target`. The tables exist because the ORIGINAL's
translation units could not reach each other with a 16-bit PC-relative call. A C
restoration has no such constraint, so `GROUP_AG_JMPTBL_MEMORY_AllocateMemory(...)`
is just a slower, uglier way to write `MEMORY_AllocateMemory(...)`.

**The emitted bytes are IDENTICAL either way**, because the call target is a
RELOCATION and `cmatch` masks it. Measured on `brush_load_brush_asset.c`: 1336
bytes and the same divergence point both ways, and the two byte strings compare
equal. `mismatches.py --recheck` reports NO status changes across all 875
restorations, and both byte gates stay green.

```sh
python3 tools/detunk_c.py            # report
python3 tools/detunk_c.py --write    # apply, then run check_c_symbols.py --fix
```

2,882 call sites in 346 files became direct calls on 2026-08-03. The program
loses one `JMP` per call at run time.

**Four things the tool must not do, each of which it got wrong first:**

1. **Do not rewrite inside COMMENTS.** A restoration header names the thunk and
   the module it lives in as documentation. Renaming that text makes the header
   describe a symbol the assembly does not have. Several headers were corrupted
   before this was fixed.
2. **Do not rewrite a thunk the file DEFINES.** Some restorations implement a
   jump-table entry as a C forwarder, named on the `RESTORES:` line.
   `lib_handle_close_all_and_return_with_code.c` defines
   `UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode`; renaming the definition produced
   a duplicate symbol and a function that called itself.
3. **`extern` is what separates a declaration from a definition.** A multi-line
   extern prototype has no semicolon on its first line either, and treating
   those as definitions silently suppressed 890 legitimate rewrites.
4. **`Global_JMPTBL_*` is NOT a thunk.** `Global_JMPTBL_DAYS_OF_WEEK`,
   `..._MONTHS` and their siblings are DATA TABLES of pointers.

**Range is not a concern for the maximum-C build.** `CODE=FAR` makes every call
`JSR abs.L`, which has unlimited range. The byte-exact manifest does not use
`CODE=FAR`, but no file in `src/c/replacements.txt` calls a thunk at all, so that
lane never changed. `check_pcrel_range` still guards both.

The thunks themselves STAY in assembly. Assembly modules still call them, and
`jmptbl_to_c.py` still converts whole tables where every target is restored.

### A VARIADIC TARGET NEEDS A V-FORM, and that is all it needs

A jump-table thunk in front of a VARIADIC function cannot be written in plain C:
there is no way to say "pass on the arguments I was given". `jmptbl_to_c.py`
used to refuse such a target outright, and `WDISP_SPrintf` alone blocked FOUR
tables.

**The answer is the standard C one.** Split the work into a form that takes an
argument POINTER, and make every variadic entry a thin wrapper over it --
`vsprintf` to `sprintf`. `src/c/lib_hex_parse_sprintf.c` now exposes
`WDISP_VSPrintf(buf, fmt, args)` and `WDISP_SPrintf` is four lines on top of it.
The generator emits the same wrapper for each thunk:

```c
long GROUP_AE_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, ...)
{
    va_list ap;
    long n;
    va_start(ap, fmt);
    n = WDISP_VSPrintf(buf, fmt, (void *)ap);
    va_end(ap);
    return n;
}
```

**This is sound on this toolchain because SAS/C's `va_list` on the 68000 IS the
pointer the original passes.** Measured rather than assumed:

```
va_start(ap, fmt)   ->   lea.l $14(a7), a5
```

a plain address just past the last named parameter, which is exactly what the
original's `PEA 16(A5)` computes. No argument is copied and the callee sees the
same block.

The convention the tool looks for is a `V` after the module prefix:
`WDISP_SPrintf` -> `WDISP_VSPrintf`. A variadic target with no such sibling is
still refused, with a message naming the v-form it wanted.

**IT GENERALISES. `FORMAT_RawDoFmtWithScratchBuffer` has the identical shape** --
`LEA 12(A5),A0` for the argument pointer, then a worker that takes one
(`FORMAT_FormatToBuffer2`, which is to it what `WDISP_FormatWithCallback` is to
sprintf). It took the same treatment and freed three more tables. When a
variadic function computes an argument pointer and hands it to a worker, the
worker IS the v-form and the split is already there in the original.

**But the v-form must be LINKED, and that is the catch.** `lib_hex_parse_sprintf.c`
was already in the manifest, so adding `WDISP_VSPrintf` to it produced a real
symbol immediately. `unknown2a.s` was NOT, so the whole module had to be
converted first -- which was only possible because its two unlabelled blocks are
dead. Check that the module can be linked before counting on a v-form.

`WDISP_VSPrintf` IS A NEW SYMBOL that the original does not have. That is the
price, along with one extra call for callers that reach sprintf through a thunk.

### Aliases: five modules name one function twice

A module can carry two labels on ONE address, with only a comment between them:

```
COI_SelectAnimFieldPointer:
_COI_GetAnimFieldPointerByMode:
    LINK.W  A5,#-20
```

The original spends no bytes on the alias. C cannot give one function two
external names, so the second name becomes a forwarder. **The tell is that
`refbytes.py` reports the alias as ZERO bytes**, because it extracts label to
label.

These were blocking real work. `COI_SelectAnimFieldPointer` and
`_COI_ProcessEntrySelectionState` each held up a 36-thunk jump table, and
`_ESQDISP_DrawStatusBanner` held up another.

`merge_module_c.py` used to refuse an alias pair as a fall-through. It now
separates them: an alias has NO INSTRUCTION between the two labels, so `last_op`
is still `None`, while a genuine fall-through always has at least one. The
`_ED1_EnterEscMenu` pair is still correctly refused.

### Jump tables are the cheapest lever, and it was sitting unused

A jump table is a run of `JMP target` thunks. `jmptbl_to_c.py` turns each thunk
into a C function that forwards the arguments and returns the result. The tool
reads the target's own restoration to copy the parameter list, so it cannot drop
an argument.

Eight tables converted on 2026-08-03 and the manifest went 770 -> 790, counting
the restorations that unblocked them. That is 127 thunks. Both byte gates stayed
green, because the default build does not read the manifest.

**A thunk can be spelled `BRA.W target` instead of `JMP target`, and a comment
can sit between the label and the instruction.** Both forms are the same tail
transfer. The tool used to accept only `JMP` on the very next line, so it refused
seven tables that were pure jump tables. It now accepts both spellings and skips
comment lines. All 17 tables converted before the change regenerate
byte-identically, so the change is safe.

### The remaining tables are blocked by their TARGETS, not by themselves

Eighteen tables still refuse, and every one refuses for the same reason: a thunk
points at a function that has no C restoration. Two groups cause it, and only one
of them is work.

- **SAS/C runtime routines** in `modules/submodules/`. The arithmetic helpers
  and `WDISP_SPrintf` USED to be listed here as a hard floor. Both were solved:
  see "SOLVED: the divide helpers are C" and "A VARIADIC TARGET NEEDS A V-FORM"
  below. What is left in this group is `FORMAT_RawDoFmtWithScratchBuffer`,
  `FORMAT_FormatToBuffer2`, `UNKNOWN36_FinalizeRequest`, `UNKNOWN2A_Stub0`,
  `EXEC_CallVector_48` and `STREAM_BufferedWriteString`.
- **Real ESQ functions nobody has written yet** -- `GRAPHICS_AllocRaster`,
  `CLOCK_CheckDateOrSecondsFromEpoch`, `LOCAVAIL_SaveAvailabilityDataFile`,
  `LADFUNC_SaveTextAdsToFile` and `TLIBA_FindFirstWildcardMatchIndex` among them.
  These ARE reachable.

So the order of work is fixed by a dependency. Write the code modules first. Each
one that lands releases every jump table that points at it. Do not attack the
tables directly -- that only re-reads the same refusals.

**Check the target's ARITY against a real caller before writing a thunk for it.**
`GRAPHICS_AllocRaster` reads its width and height from `16(A5)` and `20(A5)`, not
from `8(A5)` and `12(A5)`, so it is not the two-argument function its name
suggests. A thunk written from the name would pass the wrong slots and no byte
check would see it.

**Byte-exactness is not a goal on this lane.** A converted thunk costs two bytes
and one extra frame, which the `tail-jump` divergence records. Chase the byte
match only on `src/c/replacements.txt`, which is a separate manifest.

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

## SOLVED: an all-C DATA section loses the CHIP flag (2026-08-02)

`src/Prevue.asm` line 1148 is `SECTION S_1,DATA,CHIP`. The DATA hunk holds the
copper lists and the bitplanes, so the custom chips DMA from it and it must be
chip RAM.

**A C object cannot say that.** SAS/C emits a plain `data` hunk with no memory
attribute. While even one data module was still assembly the flag arrived from
that module and the hunk was correct. When the last one was converted, nothing
contributed it and the DATA hunk linked MEMF_ANY -- so on any machine with fast
RAM the program loads its data where the chips cannot read it.

**`hunkcmp.py` is the ONLY thing that sees this**, as one line:

```
hunk1 MISMATCH mem: 1 vs 0
```

The link succeeds. Both byte gates ignore a C build. `check_pcrel_range`,
`a6_audit`, `data_shape_audit` and `extern_width_audit` all pass.

**Fix.** `tools/mkchipflag.py` synthesises a HUNK_DATA of length ZERO with the
CHIP bit set, named `S_1`. vlink merges input sections by name and ORs their
memory attributes, so the flag arrives and the image does not move -- measured
byte-identical, with the size-table entry going `0x00000001` -> `0x40000001`.
`build-split.sh` passes it unconditionally, because CHIP OR CHIP is CHIP, so a
build whose data is still assembly is unaffected.

Two other ways were measured and both are wrong. An assembly stub
`SECTION S_1,DATA,CHIP` with no content makes vasm emit a size-0 **CODE** hunk
instead, which does nothing at all. The same stub with a `DC.W 0` in it brings
the flag and 2 bytes, and on the DATA side bytes are not inert.

## SOLVED: a data module can measure right and still lay out wrong (2026-08-02)

`data_to_c.py` cross-checks its arithmetic against vasm, so it knows
`data/textdisp_p2.s` is 144 bytes. That is the sum of the spans it PARSED, not
what the compiler EMITS.

`_TEXTDISP_FormatEntryFallbackTable` is two pointers, eight longs and a trailing
`DC.B 0` -- 41 bytes. SAS/C 6.51 gives a struct holding a `long` an alignment of
2, so it emitted 42, and every symbol after it in the module moved by one byte
while the total still agreed. The DATA hunk grew 4.

**The rule this project already had was right and was not being checked.**
AGENTS.md says "Compare the OFFSETS, not the total" for exactly this reason.
Nothing enforced it.

```sh
python3 tools/data_offset_audit.py [manifest]
```

It assembles each converted data module alone, reads its label offsets, reads
the symbol offsets out of the compiled object, and reports every disagreement.
`build-split.sh` runs it on any build that sets `C_REPLACEMENTS` and aborts on a
hit. Offsets are compared RELATIVE to the module's first symbol, because a
replaced module can sit at a nonzero offset inside a coalesced object, and the
candidate objects come from `build/objlist` -- `build/obj` is never cleaned, and
matching against stale objects from earlier builds reported four modules as
shifted by thousands of bytes when nothing was wrong with them.

`data_to_c.py` now peels the trailing byte off an odd-sized struct span into its
own symbol, which is byte-neutral and leaves a 40-byte struct needing no
padding.

**SPLIT THE STRINGS OUT RATHER THAN CONVERTING THEM.** A CODE module that holds
string constants cannot be converted whole: the strings live in the CODE section
in the original, and C would move them to DATA. `unknown36.s` held two functions
and five strings, so `split_module.py` cut the function out on its `;!======`
separators -- byte-neutral, both gates green -- and the strings stayed in
assembly. Do this before reaching for a DO-NOT-LINK.

**A STRING LITERAL IS AN INITIALISED STATIC, INCLUDING A ONE-CHARACTER ONE.**
`Open("*", MODE_OLDFILE)` in `lib_parse_command_line_and_run.c` emitted a 4-byte
DATA hunk, in a file whose own header warned about exactly this. Write the text
a character at a time into a local instead. The original has the same problem in
reverse and solves it by keeping its template PC-relative in the CODE section
(`LEA .loc(PC),A1` then four MOVE.L and a MOVE.W).

**`objbytes.py` PRINTS NO `xdef:` LINE WHEN THE OBJECT HAS A SECOND UNIT**, which
is what a stray string literal produces. A missing xdef line on a file whose
functions are not static is therefore a reliable tell that a DATA hunk crept in.
Dump the hunk structure to confirm.

**A second source of DATA growth is an initialised static in ORDINARY C code.**
`lib_hex_parse_sprintf.c` held `static char kHexDigitTable[16]`. The original
keeps those digits in the CODE section, reached PC-relative. 6.51 puts every
initialised static in `data`, and that object links BEFORE the converted data
modules, so all 55,820 bytes of real data shifted by 16. `static const` does not
help -- measured, still DATA. The digit is now computed rather than looked up,
which costs 12 inert CODE bytes and returns the DATA hunk to its reference size.
**Watch the hunk1 size on any restoration that holds an initialised static.**

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

**...and it does not validate the DEREFERENCE COUNT either.** The same masking
hides a worse error than a wrong offset: an `extern` that reads a global one
level too shallow. `_Global_REF_STR_CLOCK_FORMAT` is a single `DC.L` that HOLDS
a table base, so the original reads the pointer, indexes it, then reads the
string:

```
MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0 / ADDA.L D0,A0 / MOVEA.L (A0),A1
```

Declared `char *X[]`, the symbol becomes the table and one load disappears.
Slot 0 then copies from the table base, whose first byte is the high byte of a
pointer, so the string is EMPTY and `Text()` draws nothing. Every time-slot
label vanished from the grid banner while the bevels, the separators and the
running clock stayed. **The emitted size is 124 bytes either way**, both byte
gates ignore a C build, `a6_audit` and `check_pcrel_range` passed,
`soak_esq.sh` passed, `menusweep_esq.sh` passed all six items, and
`framecolor.py` reported every bin overlapping -- the yellow bin sat at half
the reference median and still "overlapped", because both runs dip to zero
between screens. **A user watching the program found it.**

```sh
python3 tools/data_shape_audit.py          # the manifest
python3 tools/data_shape_audit.py --all    # every restoration
```

It compares each C extern against the addressing mode the original uses at that
symbol -- `LEA`/`PEA`/`#sym`/`sym(An,Dn)` means the symbol IS the data, a bare
operand means the symbol is READ -- and reports every disagreement.
`build-split.sh` runs it on any build that sets `C_REPLACEMENTS` and aborts on
a hit. Across all 593 restorations it finds exactly six other disagreements,
all confirmed benign and listed in the tool's `BENIGN` set: four are `char X[]`
with `X[0]` on a one-byte datum, which loads the same address, and two are
whole-struct assignments, which read the bytes at the symbol as `LEA` plus a
copy loop does.

**Read framecolor's MEDIANS, not only its overlap verdict.** The tool exits
nonzero only on disjoint ranges, and that test was too weak here. Compare a
candidate against the PURE assembly build under the same flags rather than
against the known-good alone: yellow ran 0.0163/0.0162/0.0162 on the pure far
build and 0.0082/0.0082/0.0054 on the broken one, which is unambiguous where
the min/median/max table was not.

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

**`SHORTINT` CHANGES THE CALLING CONVENTION, and measuring it by SIZE hides that.**
It makes `int` 16 bits, so a `short` PARAMETER occupies a 2-byte stack slot. ESQ's
callers are assembly and push 4-byte slots, so **every parameter after a `short` one
is read from the wrong offset**. `newgrid_set_row_color.c` measured well on size and
read its colour `value` two bytes early: every red pen came out blue and the logo
vanished into its background. It took a colour-oracle bisect to find, because no byte
check can see it -- `cmatch` compares a function's own bytes, not the offsets its
arguments arrive at.

Safe only when no parameter FOLLOWS the `short`/`int` one. Verify against the
reference's SLOT LAYOUT, not its size:

```sh
python3 tools/refbytes.py <Label> | grep -E 'MOVE.*\(A7\)'   # 4-byte slots?
```

`NEWGRID_SetRowColor` reads `MOVEA.L 20(A7)` / `MOVE.W 26(A7)` / `MOVE.L 28(A7)` --
arg2 is a 4-byte slot read as its low word. Three of ten `SHORTINT` entries had the
broken shape and were corrected; the option lives in `src/c/scopts.txt`, not in the
`OPTIONS:` header line, which is documentation only.

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

**The grep above is not the only tell, and it missed two.** A block with no
`; FUNC:` comment at all still absorbs its predecessor. Two turned up on
2026-07-31, both found because a worklist size did not match its disassembly: an
eight-byte `LINK/UNLK/RTS` stub after `ESQIFF_QueueIffBrushLoad`, which read as
298 bytes and is 290, and a 354-byte dead copper-shift block after
`_GCOMMAND_ClearBannerQueue`, which read as 390 bytes and is 36. The second one
is the sharper lesson: `_GCOMMAND_ClearBannerQueue` became byte-EXACT the moment
it stopped carrying somebody else's body. **A worklist entry whose size does not
match what the disassembly shows is a labelling bug, not a hard function.**

Fixing the six moved four new candidates into the `no-calls` bucket and shrank
two worklist entries from 58 bytes to 2. Both directions are the point: the
worklist was reporting sizes that were not true.

## Before the DATA section can move to C: eight adjacencies

In assembly the data section is one flat image and a symbol is only a name for
an offset, so a routine can read a word symbol with `MOVE.L` and pick up
whatever follows. C guarantees nothing about where two globals land. Every place
the code crosses a symbol boundary therefore has to become ONE struct or array
first.

```sh
python3 tools/data_adjacency_audit.py            # the overruns
python3 tools/data_adjacency_audit.py --sizes    # every symbol and its size
```

Over 2,218 data symbols, of which 1,921 are referenced by code, there are
exactly **eight**:

| symbol | storage | read as | shape |
|---|---:|---:|---|
| `ED_DiagAvailMemMask` | 3 | 4 | word plus byte |
| `ESQFUNC_MissingAssetRetryMask` | 3 | 4 | word plus byte |
| `ESQIFF_SecondaryLineHeadPtr` | 2 | 4 | split pointer |
| `ESQPARS2_BannerSnapshotPlane1DstPtr` | 2 | 4 | split pointer |
| `ESQPARS2_BannerSnapshotPlane2DstPtr` | 2 | 4 | split pointer |
| `ESQ_BannerColorClampValueA` | 1 | 2 | byte pair |
| `ESQ_BannerColorClampValueB` | 1 | 2 | byte pair |
| `HIGHLIGHT_CopperEffectSeed` | 2 | 4 | word plus two bytes |

`src/c/esq_update_copper_lists_from_params.c` is the worked example and reads
its group through a cast today, with the dependency written into its header.

A symbol the code only ever takes the ADDRESS of is skipped: its size is
whatever the code decides, so a displacement into it is ordinary indexing.

> The first version of the audit reported **zero** overruns, which reads exactly
> like a clean result. It keyed data labels by their written name and code
> references by the name with the underscore stripped, so the two never met --
> 166 symbols of 2,218 matched. Both sides now strip one leading underscore.
> **An audit that finds nothing is a claim, and it has to be tested against a
> case you already know about.**

## The DATA section CAN move to C, and the first module has

`src/data/displib.s` is now `src/c/data_displib.c`. It is 24 bytes and three
symbols, and it is **byte-exact**: the compiled object places
`_Global_STR_DISPLIB_C_1` at 0, `_Global_STR_DISPLIB_C_2` at 10 and
`_DISPTEXT_ControlMarkerXOffsetPx` at 20, with the same 24 bytes the assembly
emits. `build-split.sh` reports the same 6 differing DATA bytes with the module
in C as without it, so the conversion moved nothing.

**No build change was needed, and that is the surprise.** `gen_units.py` runs its
replacement map over BOTH groups -- `coalesce(...)` is called once for the code
group and once for the data group with the same `repl` -- so a manifest line
naming a path under `data/` already links a C object at that module's position.
The capability was there the whole time and had never been used.

Four rules, and the last two are the ones that will bite:

1. **Declare it in `src/c/replacements-extra.txt`.** `gen_all_manifest.py` only
   walks `src/modules`, so no data module can ever appear in its generated rows.

2. **Give every array an EXPLICIT SIZE: the string, plus the NUL, rounded up to
   even.** `NStr` ends in `CNOP 0,2`, and **SAS/C 6.51 does NOT word-align
   consecutive char arrays**, so `char X[] = "..."` on an odd-length string
   silently drops the pad byte and shifts every symbol after it. `data/flib.s`
   compiled to 148 bytes against 154 that way.

   **Compare the OFFSETS, not the total.** `data/esqpars.s` came out at exactly
   the right 92 bytes with two symbols in the wrong place, because the padding it
   lost and the object's longword rounding cancelled.

3. **Write `= 0` on an uninitialised symbol.** `DS.L 1` inside a loaded DATA hunk
   contributes four ZERO BYTES to the image. A C global with no initialiser is a
   tentative definition that SAS/C may place in BSS, which the linker puts in a
   different hunk -- moving everything after it. Check with
   `python3 tools/objbytes.py <file.o>` that the emitted size covers every symbol
   before adding a module.

4. **Order inside the file is the order in the original.** C guarantees nothing
   about where two globals land relative to each other, so any module whose code
   reads ACROSS a symbol boundary has to become one struct or array first.
   `tools/data_adjacency_audit.py` finds exactly eight such groups over 2,218
   symbols; they are listed in the section above and none of them is in
   `displib.s`. Convert the modules that hold them last.

5. **ONLY convert a module that is LAYOUT-NEUTRAL: 4-aligned START OFFSET *and*
   a size that is a multiple of 4.** This is the alignment rule from the code
   side, and on the data side it is not a cost, it is a HARD LIMIT.

   **The size rule alone is not enough, and believing it cost a second frozen
   display.** `coalesce()` groups consecutive data modules until the running
   total is a whole number of longwords, and it FORCE-CLOSES the current group in
   front of a replaced module. If that group was mid-longword, the assembly unit
   it closes gets padded and everything after it moves. Nine modules were
   converted, every one of them a multiple of 4 and every one byte-exact against
   the assembler, and four of them started at a 2-mod-4 offset: the DATA hunk
   went 55,820 -> 55,832 and the display froze.

   `tools/data_to_c.py --write` now refuses on either count and prints both
   numbers. Ten of the 31 modules pass, and the list is not guessable from the
   sizes -- `data/kybd.s` is 48 bytes and fails on its start offset. A hunk object is longword-sized, so a data module of any
   other length gains padding, the DATA hunk GROWS, and every symbol after it
   moves.

   `data/flib.s` is 154 bytes. Converting it grew hunk1 from 55,820 to 55,824 and
   the display froze within seconds -- measured twice, 3 of 10 distinct frames
   and 2 illegal/exception lines against 1 for a healthy build. Its C is
   byte-correct and is kept, marked `DO-NOT-LINK`, in `src/c/data_flib.c`.
   `displib` (24) and `esqpars` (92) change the DATA hunk size by nothing and
   run.

   On the CODE side the same padding is inert: it sits between functions and is
   never executed. On the data side there is nothing inert about it -- it is
   inserted INTO the address space the program reads.

   The evidence does not say which symbol minds the shift.
   `data_adjacency_audit.py` cannot answer it either, because it skips any symbol
   the code only ever takes the ADDRESS of. To convert an odd-sized module,
   bisect first: insert 4 bytes of padding at successive points in the assembly
   DATA section and find what stops working.

```sh
python3 tools/data_to_c.py data/<mod>.s            # print the C
python3 tools/data_to_c.py data/<mod>.s --write    # write it, if it is allowed
```

The generator is byte-exact by construction and refuses anything it does not
understand. It cross-checks its own arithmetic against vasm before writing --
that caught three modules it measured wrong by 2 and 4 bytes -- and it reads the
`TextLineFeed`-style equates out of the headers rather than hardcoding them,
because two of five hardcoded values were wrong.

**Rename the data labels afterwards.** `check_c_symbols.py` inspects `extern`
DECLARATIONS, so it cannot see a symbol a data module DEFINES. Four labels in
`data/tliba1.s` and `data/clock.s` lacked the leading underscore and the link
failed on them. Run `tools/rename_for_c.py` over every label in a converted
module that does not already start with `_`.

31 data modules, 55,472 bytes, and it is 69% of everything left in assembly.
NINE are converted. Ten are layout-neutral in total, `data/esq.s` at 11,088 bytes
among them.

## Merging beats splitting when a module will not cut

A C replacement substitutes for a WHOLE module, so a module holding several
functions cannot be replaced until every one is written. `split_module.py`
answers that by cutting the module up, and it cannot cut a module whose label is
not at a `;!======` separator -- about 66 are like that.

`tools/merge_module_c.py` answers it the other way and needs no assembly change:

```sh
python3 tools/merge_module_c.py                        # what can be merged
python3 tools/merge_module_c.py --write --verify --add # write, compile, list
```

It writes one unit per module that `#include`s each restoration in the order the
LABELS appear in the module, so the compiled functions land in the same sequence
as the assembly they replace. The per-function files stay the single source of
truth, so `cmatch.sh` and `mismatches.py --recheck` still measure the real file.

**`--verify` is not optional.** Static checks catch a `static` helper defined
twice, a `#define` with two bodies, and a struct tag defined twice. They miss the
commonest clash: file A forward-declares a function that file B DEFINES, with a
different parameter list. Separately compiled that is invisible, because the
linker does not check types. In one unit SAS/C says `conflict with previous
declaration`. Two of the first thirteen candidates failed exactly that way, so
the compiler is the only gate worth trusting.

Two of those conflicts were worth fixing rather than skipping, and both were
latent documentation errors: `LADFUNC_DisplayTextPackedPens` takes a packed pen
BYTE and one caller declared it `long`, and `NEWGRID_GetEntryStateCode` takes
typed pointers where its caller declared `void *`. Where two files define the
same struct, wrap it in its own `#ifndef` guard -- the tool ignores guarded
definitions, and each file still compiles alone.

> **A fall-through between two labels blocks the merge, and this check is the
> reason the tool is safe.** When one block runs into the next, the two labels
> are ONE routine with a second entry point, and the earlier restoration stops
> where the assembly does not. `_ED1_EnterEscMenu` is the worked example: it ends
> at the copper rise and the assembly then runs straight into
> `_ED1_EnterEscMenu_AfterVersionText`, which resets the filter cursor. Merged as
> two independent C functions that reset would never happen -- on the ESC-menu
> path, silently. The tool refuses `ed1_p0.s` for that reason.

## A module of 26 labels can still be ONE function

`gen_all_manifest.py` used to refuse any module holding more than one label,
because a C file replaces the WHOLE module. That count is the wrong question.
What decides it is how many of those labels are FUNCTIONS.

`modules/groups/a/g/diskio1.s` is the case that forced this. It carries 26
labels and it is **one routine**: the head had no label at all, and the other 25
are branch targets inside it. Twenty of them sat in the worklist as
`falls-through` or `live-register-on-entry` -- twenty phantom entries for a
function that does not exist.

The test now asks, for every label except the one the C file restores:

- Does anything OUTSIDE the module name it? Then it is a function.
- Does ANY `BSR`/`JSR` name it, from anywhere? Then it is a function.
- Is it named only by a `Bcc`/`BRA` inside its own module? Then it is an
  interior branch target, and the C restoration of the routine covers it.

**A label that NOTHING names is a FUNCTION, not an interior target.** This is
the trap, and it is worth stating on its own, because the opposite reading looks
equally reasonable and is what the first version of the rule did.
`modules/groups/a/g/diskio1_p1.s` holds two dead dumpers, and the second is
named by nothing at all -- treating "unreferenced" as "interior" claimed that
one module for TWO C files at once. Only a `<name>_Return` epilogue is exempt.

A second guard covers what references cannot see: a module entered by
FALL-THROUGH from its predecessor in `src/Prevue.asm` is named by nothing
either, and must not be replaced. `fallen_into()` reads the include order and
checks the previous module's last instruction.

Read together the two rules say: **replace a module only when every way into it
is a reference to the one symbol the C file defines.**

## `replacements-all.txt` is GENERATED. Overrides go in `replacements-extra.txt`

The manifest header has always said "do not hand-edit" and past sessions edited
it anyway, to force in restorations the generator refuses. `gen_all_manifest.py`
rewrites the whole file, so those entries vanished on the next run without a
word. Four were found missing this way.

```
python3 tools/gen_all_manifest.py                          # truncates and rewrites
python3 tools/merge_module_c.py --write --verify --add     # appends merged units
```

**Run them in that order, and never `--add` without `--write --verify`.** `--add`
on its own does not gate on compilation: it will list a `_merged.c` that does not
build and leave the manifest pointing at a file that is not on disk.

`src/c/replacements-extra.txt` is appended verbatim, after the generated rows and
with no skip rule applied. Put a deliberate override there with a comment saying
who read the case and why it is safe. An override whose C file the generator
already emits is ignored, so a stale one is harmless.

**One of the four was a generator defect, not a judgement call.** The
`DO-NOT-LINK` detector searched the whole file, so it matched PROSE that merely
names the marker: `esq_capture_ctrl_bit3_stream.c` explains why a *different*
file carries one and was dropped for saying so. The pattern now requires the
marker to OPEN a header line.

## A `_merged.c` is not a source of truth

`merge_module_c.py` reads every `RESTORES:` line under `src/c` to decide which
file restores which label. That included the `_merged.c` files it had written
itself, whose headers claim every label they cover -- so on the second run a
label resolved to the merged unit and the tool emitted
`#include "newgrid_p4_merged.c"` INSIDE `newgrid_p4_merged.c`.

Every declaration in the file then appeared twice and `--verify` reported the
collision as though the restorations clashed with each other. Three modules read
as blocked by a name clash that did not exist. The tool now skips `_merged.c`
when building that map.

**The per-function files stay the single source of truth.** If `--verify` blames
a clash, check that the two files really do disagree before rewriting either.

### SAS/C 6.51 accepts a forward tag declaration only BEFORE the definition

Merging exposes disagreements the linker never checks, and the fix is a forward
declaration plus the struct's own `#ifndef` guard:

```c
#ifndef NEWGRIDCLOCKDATA_DEFINED
struct NewGridClockData;
#endif
extern long NEWGRID_ComputeDaySlotFromClock(struct NewGridClockData *rec);
```

The guard is not decoration. 6.51 accepts `struct Foo;` followed by
`struct Foo {...}` and REJECTS the reverse with `Error 63: item "Foo" already
declared`, so an unguarded tag declaration compiles or not depending on which
file the merge happens to put first. Reusing the definition's own guard macro
makes it correct in both orders. Measured both ways on 2026-08-01.

Three prototypes were corrected this way and all three were latent documentation
errors, invisible while the files were compiled separately: two clock helpers
declared `char *` for a struct parameter, and `NEWGRID_GetEntryStateCode` was
declared `(void *, void *, long)` against a definition taking two typed pointers
and a `short`. All four files still emit byte-for-byte what they emitted before.

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
