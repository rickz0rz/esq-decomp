# ESQ / Prevue Decomp — Completion Plan

Status: **draft plan**, 2026-07-11. Owner: RJ.

This plan takes the project from "restored ASM that hash-matches + per-function
C restorations of unverified quality" to "an as-close-as-possible C
representation, with each function proven equivalent to the original and the
whole program rebuildable from C."

## Ground truth vs. hypothesis

Exactly one thing is currently *trustworthy*:

- **The hash-exact hybrid ASM build.** `decomp-build.sh` assembles the mapped
  module tree (133/133 modules) and byte-matches the canonical binary
  (`6bd4760d…`). This proves the *restored assembly* equals the original. It is
  our oracle for original behavior.

Everything else is a **hypothesis to be re-proven** (prior work was largely
produced by a weaker LLM and may be wrong):

- ~945 SAS/C `.c` restorations and ~1,690 `compare_sasc_*` lanes.
- ~2,000 per-function `semantic_filter_*.awk` files.
- "green lane", "coverage complete", "missing-exports empty" claims.
- The GCC lane (`*_gcc.c`) — **demoted** to optional cross-check only.

## Empirical finding that shapes the plan (2026-07-11)

`src/decomp/scripts/measure_match_tiers.py` bucketed every judgeable SAS/C lane
by reusing the cached `.dis` (no recompile):

| Tier | Meaning | Count |
|------|---------|-------|
| GOLD (raw or structural) | SAS/C output identical to original instructions | **0 / 777** |
| SILVER | equal only *after* the per-function semantic awk filter | ~598 |
| RED\* | differs even after filter (approx; static run omits `-v ENTRY` args) | ~179 |

Worked examples (`STRING_ToUpperChar`, `ALLOC_InsertFreeBlock`) show the
original and the SAS/C recompile differ in **stack-frame model** (`LINK A5` vs
raw `SUBQ A7`), **register allocation**, and **branch signedness**
(`BLT/BGT/BCC` vs `BGE/BCS/BHI`). That last one can hide real behavioral bugs.

**Conclusions:**
1. **True 1-to-1 (Gold) is 0% with the current SAS/C version+flags.** The
   original was built with a different compiler/version/flags, and some leaf
   routines are almost certainly hand-written assembly that no C will match.
2. Therefore **every "green" lane is Silver at best** — equivalence rests
   entirely on hand-written awk filters, which is precisely where false-greens
   (and the signed/unsigned bug class) hide.
3. Static diffing cannot adjudicate Silver vs. broken. **We need execution.**

## Acceptance model — two tiers per function

- **Gold** — SAS/C recompiles the C to byte-identical original ASM (true 1-to-1).
  Pursue opportunistically; expect it to stay rare unless compiler archaeology
  finds the original toolchain.
- **Silver** — not byte-identical, but **behaviorally identical** under vamos
  differential testing (this becomes the real bar for "done").
- **Hardware-only** — touches custom chips ($DFFxxx)/copper/interrupt vectors;
  not runnable under vamos. Falls back to the hash-exact ASM oracle; documented
  as "not behaviorally provable, byte-proven only."

## Phases

### Phase 0 — Ground truth + measurement (DONE except archaeology)
- [x] Reconfirm hash-match (lock the oracle). `test-hash.sh` reproduces
  `6bd4760d…` on this machine (2026-07-11). Oracle confirmed.
- [x] `measure_match_tiers.py` — Gold/Silver/Red census from cached `.dis`.
- [x] `classify_functions.py` — behavioral classifier over 1382 lanes:
  **PURE 1119 / OS_CALL 222 / GLOBAL 29 / HARDWARE 8**. A stricter
  leaf test (no calls, no external symbol refs, all-scalar signature) yields a
  **12-function fully-isolated first audit batch**. Note: "PURE" means no
  chipset/OS/A4 in the slice — many still delegate via `JSR <label>` or read
  data tables by absolute address, so they are testable only once those deps
  are linked (the next tiers).
- [ ] **Function classifier**: bucket every export as CPU-pure / OS-call /
  hardware, so we know what is behaviorally testable vs oracle-only.
- [ ] **Compiler archaeology (time-boxed)**: try SAS/C versions + flag combos
  (frame pointer, opt level, `-cpu`, signedness of `char`) against a handful of
  functions to see if the Gold rate can be moved off zero. If it stays ~0,
  formally accept Silver as the primary bar and stop chasing Gold.

### Phase 1 — Per-function differential harness (core deliverable)

> **POC COMPLETE (2026-07-11) — harness proven end-to-end AND caught a
> false-green.** `src/decomp/scripts/poc_diff_string_to_upper_char.sh` runs the
> original ASM slice and the restored C for `STRING_ToUpperChar` under vamos
> with 12 shared input vectors and diffs the outputs. Result: **5/12 vectors
> diverge.** The original preserves the argument's high 24 bits (`MOVE.L` +
> low-byte-only `SUBI.B`); the restored C zero-extends (`return (ULONG)ch`), so
> e.g. `0x11223361 → ASM 0x11223341` vs `C 0x00000041`. The static
> normalized-ASM "green" lane passed this as equivalent — the runtime test does
> not. This is the plan's core thesis demonstrated on real code. (Whether the
> divergence *matters* depends on callers — that's what the Phase-2 audit
> determines — but the restoration's contract is objectively wrong.)
>
> **Integration gotchas discovered (bake into the Phase-1 generator):**
> 1. SAS/C C symbols are underscore-prefixed (`_Name`); the hand-asm reference
>    object must `XDEF _Name` or the call binds to garbage and crashes
>    (`InvalidCPUStateError`).
> 2. Original hand-asm helpers are stack-ABI (arg at `4(A7)`); driver extern and
>    C impl declared `__stdargs` to match.
> 3. Assemble the original slice with SAS/C `asm` (slink-native hunk), not vasm.
> 4. vamos needs `-m 8192` (8 MiB; 16 MiB overflows the 24-bit bus).
> 5. `sc LINK` names output after the first source basename — rename between
>    the two builds (no `PROGRAM=` option).

**Generalization status (2026-07-11):** `gen_leaf_diff.py` + `run_leaf_audit.sh`
auto-generate and run the differential harness for the leaf-scalar batch:
per function it wraps the original slice (`XDEF _entry`, dot-locals renamed),
injects `__stdargs` into the restored C, bakes a shared 24-value fuzz table into
a driver, builds both sides under vamos (`--cwd esq:_audit/<fn>`), runs, diffs.
Confirmed the WORD/BYTE ABI matches (SAS/C promotes `short`→4-byte slot; the
original reads the low word at `+2`, e.g. `MOVE.W 10(A7)`). Next tiers:
**data-leaf** (pure compute + reads a `src/data` table → link the table) and
**GLOBAL/A4** (stand up an A4 world), then **OS_CALL** (call-trace signature).

Build a generator that, per function, produces two tiny Amiga hunk executables
sharing one **driver**:
- Driver seeds input registers + a scratch/global (A4) memory world from a fuzz
  vector, calls the function, dumps output registers + touched memory + the
  OS-call trace.
- **Side A** links the original ASM slice; **Side B** links the SAS/C-compiled
  C. Run both under vamos over N fuzz vectors; diff the dumps + call traces.
  Identical across all vectors ⇒ Silver PASS.
- Prove the loop end-to-end on **one** trivial leaf first (e.g. a string
  helper), then scale.
- Hard part: standing up the **A4/global world** per function (leaf functions
  are trivial; global-touching ones need the global map from `Prevue.asm` /
  `src/data`).

### Phase 2 — Audit + fix (IN PROGRESS)
First batch complete (2026-07-11) — see `docs/leaf-audit-findings.md`:
- **14 isolated functions audited** across three tiers (pure-leaf 11, data-leaf
  2, pointer-leaf 1). Result: **13 pass, 1 real bug fixed, 1 benign** (proven by
  caller analysis).
- **Real bug found & fixed:** `ESQDISP_TestWordIsZeroBooleanize` returned −1 for
  zero; original returns +1. The static "green" lane missed it; the runtime
  harness caught it. Fix verified by re-running the harness.
- The differential harness — not the awk filter — is now the gate for these.

**The isolated-function tier is EXHAUSTED (~14 functions).** Every remaining
restoration delegates via `JSR <label>`, touches A4-globals, or needs the
chipset — none testable in isolation. So Phase-2-at-scale is gated on Phase 3:
link the whole restored-C corpus vs the whole original, run both, compare. The
per-function harness stays useful for spot-checking individual fixes.

Remaining suspects to chase once whole-program linking exists: the
signed/unsigned and truncation/extension classes (the two bug archetypes seen
so far — ESQDISP polarity, DISPLIB high-word — are both of this family).

### Phase 3 — Whole-program SAS/C rebuild
**Readiness inventoried (2026-07-11, `report_phase3_readiness.py`):** the 947
restored `.c` files define **1514 functions**; unresolved externs break down as:
- **1985 DATA** — all resolvable from `src/data/*.s` + `hardware-addresses.s` +
  `Prevue.asm` equates. **This is the main scaffolding: assemble `src/data` into
  the `__MERGED` near-data (A4) segment** so the C links against it (the model
  proven in the data-leaf tier — `SECTION __MERGED,DATA`, dual `_Name`/`Name`
  XDEFs).
- **~14 OS calls** (`CopyMem`, `AvailMem`, `Disable`, `SetDrMd`, `Date2Amiga`…)
  — provided by `amiga.lib`.
- **~5 genuine trivia** (a couple of data tables like `kHexDigitTable`, struct
  equates) — trivial to supply.

So a whole-program link is **feasible**; the corpus is nearly self-contained.

**Simplification found (2026-07-11):** `sc DATA=FAR` makes the C reference
globals by absolute 32-bit address, so the data segment can be a **plain
`SECTION data,DATA`** assembled by vasm — no `__MERGED`/near-data (A4) juggling.
Verified end-to-end: ParseHexDigit built with `DATA=FAR` against a plain data
object still runs correctly (PASS). This is the simpler path; use it.

Concrete build steps:
1. **DONE.** `src/decomp/scripts/build_data_segment.sh` assembles all of
   `src/data` (+ equates/macros) into `datasegment.o` (350 KB), exporting all
   **1841** C-referenced data symbols with `_Name` aliases. Validated
   end-to-end: ParseHexDigit (`sc DATA=FAR`) links against it and runs correctly.
   (Wrapper needs `includeCustomAriAssembly = 0`.)
2. Compile all restored `.c` to objects with `sc DATA=FAR` (mind the ~31-char
   symbol limit — long names may need aliasing or `IDLEN`).
3. `slink` all objects + `datasegment.o` + `amiga.lib` + `c.o` startup → exe.
4. Run headless under vamos; diff its OS-call / file-I/O trace (config/ini/dat
   parsing — formats in `docs/`) against the original binary run the same way.
   No chipset ⇒ no render, but proves startup + I/O + logic paths.

**WHOLE-PROGRAM BUILD ACHIEVED — LOADS & RUNS (2026-07-11).** The whole
restored-C corpus **compiles (930/938) and links CLEANLY** — **0 undefined,
0 multiply-defined** — into `ESQ_fullc` (639 KB, valid HUNK_HEADER `0x000003F3`).
It **LOADS and EXECUTES under vamos**: runs the program startup
(`main`→`ESQ_ParseCommandLineAndRun`→…) and reaches `OpenLibrary("graphics.library")`,
where the headless vamos (no chipset) stops it. A real, loadable, running C
representation of the program.

The last unresolved mile was closed with documented workarounds (see the memory
`whole-program-c-link-achieved` and `build/decomp/phase3/exclude_objs.txt`):
- 8 vamos-uncompilable files: 4 JMPTBL wrappers → vasm `JMP`-stub objects; 3 real
  NEWGRID fns + 2 un-restored ESQSHARED + `AddIntVector` → **placeholder asm
  stubs** (`_missing_stubs.s`, return 0 — the only not-fully-faithful part; the
  3 NEWGRID `.c` exist and build on native SAS/C).
- 6 rare LVO offsets → `_lvostubs.s` (SAS/C `asm` emits hunk absolute externals).
- missing constants → `esq_fullc_consts.c`; long format strings → IDLEN=80
  recompile; missing globals → data-segment BSS.
- multiply-defined → externed .c globals that duplicate `src/data`; excluded one
  object per duplicate-function pair (20 objects).

Pipeline (all reproducible):
- `compile_all_sasc_far.sh` — 938 restorations → **930 objects** (`sc DATA=FAR
  IDLEN=64`, `-m 10240`). 8 files fail to compile *in vamos only* (emulator hits
  a ~12 MB 24-bit-bus memory ceiling with far-data + full-symbol tables; the
  compiler CPU-crashes, not a code error — they'd build on native SAS/C). Mostly
  JMPTBL wrapper artifacts.
- `build_data_segment.sh` — 474 KB `datasegment.o`: all `src/data` + absolute
  equates (hardware/LVO/struct) + per-global BSS storage for 57 A4-globals.
- `link_full_program.sh` — slinks all objects + data + `amiga.lib` + `c.o`.

Unresolved shrank **184 → 22**. Two real fixes this pass: (a) the whole corpus
was made **convention-consistent** — stripped `__regargs` from the 7 files that
used it, since SAS/C exports `__regargs` functions as `@Name` while callers
declared them `_Name` (a self-consistent all-C program just needs one convention;
this resolved `ESQ_SetCopperEffectParams`); (b) an over-eager object-dedup that
mis-dropped real definers was removed (resolved `WDISP_UpdateSelectionPreviewPanel`).
The remaining 22: **7** from the 8 vamos-uncompilable files, **6** LVO offsets
(vasm won't XDEF chained absolute equates in hunk), **2** genuinely un-restored
large functions (`ESQSHARED_CreateGroupEntryAndTitle` 283 lines,
`ESQSHARED_UpdateMatchingEntriesByTitle` 613 lines), and ~7 missing constants
(`kHexDigitTable`, format strings, `DesiredMemoryAvailability`, `AddIntVector`).
Reaching 0 (a loadable exe) needs the 8 files compiled on **native SAS/C** plus
the 2 big functions restored — genuine work beyond this vamos environment.
Remaining cleanup:
- **95 multiply-defined** — globals defined in *both* the data segment and some
  `.c` (the `.c` should `extern` them); slink currently takes the first.
- the 23 unresolved (minor).
- correctness caveats: A4-globals get flat per-symbol storage (not the exact A4
  layout — fine for by-symbol C access); the program won't fully *run* under
  vamos (no chipset) beyond startup/IO.

Earlier validation: 3 restorations linked by real long names ran correctly (incl.
fixed `ESQDISP` → 1). IDLEN=64 gives full symbol significance (no truncation
collisions; verified 37-char names stay distinct).

### Phase 4 — Converge + document
- Iterate Phase 3 until traces match. Update `README.md`,
  `src/decomp/README.md`, `docs/decomp-continuation-prompt.md`.
- *Stretch:* stand up a real emulator (FS-UAE / vAmiga with a real Kickstart +
  Prevue disk — the `assets/` dirs are placeholders today) for a true
  display/boot equivalence check.

## Key risks
1. **vamos has no chipset** — hardware/interrupt functions get no runtime proof;
   they lean on the hash oracle. "100% behaviorally verified" is unattainable
   for that slice.
2. **Isolated-function global (A4) setup** is the main engineering cost in
   Phase 1.
3. **Whole-program SAS/C link** may reveal that some "restorations" are
   fragments that never formed linkable translation units — Phase 3 is where
   hidden gaps surface.
4. **Gold may stay 0%** — if compiler archaeology fails, accept that "as close
   as possible" means behavioral (Silver), not byte-identical, C.

## Tooling inventory (present on this machine)
- vasm: `~/Downloads/vasm/vasmm68k_mot` · vlink: `~/Downloads/vbcc_installer/vlink/vlink`
- vamos: `~/Downloads/vamos/bin/activate` (activate to PATH) · SAS/C via `sc-build-with-dis.sh`
- vbcc `vc` present (unused for canonical lane) · SAS/C includes at `/Users/RJ/Downloads/SAS-C-hdd/sc/include`
