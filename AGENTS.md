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
DIFFERS with CODE 16 bytes larger, even though **every restored function is
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
  original used for a callee in another translation unit. Our restorations are
  one function per file, so every call we emit is cross-unit too. **These are the
  high-value targets**: they are pre-positioned to match.
- **intra-unit** — contains a `BSR.W` to a nearby callee, so that callee shared a
  `.c` file with it. Matching those means reconstructing the original's source
  grouping, which is a separate and much larger problem.

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

## Verifying a C build

`build-split.sh` reports DIFFERS for any C build and that is expected -- objects
are longword-sized, so a restored function of odd word length gains padding and
shifts everything after it. The real acceptance test is:

```sh
C_REPLACEMENTS=src/c/replacements.txt ./build-split.sh
python3 tools/verify_restorations.py
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

## Five shapes that are hand-written assembly, and how the tool knows

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

Two of these are narrow enough to quote: exactly **two** functions program-wide
contain a rotate (the other is `MATH_DivU32`, SAS/C library code), and exactly
**one** ends in a tail `JMP`. They are not blunt filters.

Between them they emptied the `no-calls` unblocked bucket: it went from 9
candidates to 0, with 4 restored and 5 proven unreachable.

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
