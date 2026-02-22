# Repository Guidelines

## Project Structure & Module Organization
`src/Prevue.asm` is the root include; it stitches together feature modules under `src/modules/groups/` (UI control in `gcommand.s`, keyboard input in `kybd.s`, disk helpers in `diskio2.s`) plus shared routines from `src/subroutines/`. Display tables and highlight presets live in `src/data/`, while interrupt-specific logic sits in `src/interrupts/`. `src/decomp/` holds experimental C decomp/cleanup helpers and does not participate in the build. Keep module-level assets beside their code: banner strings go in the matching data file, and new shared macros belong in `macros.s` or `text-formatting.s`. External requirements (Workbench ROM, HDD image) are stored under `assets/kickstart/` and `assets/disks/prevue/`. Treat `build/` as disposable output.

Recent re-org notes:
- Code has been split into smaller files along more logical boundaries; module names may change again as functionality becomes clearer.
- `src/modules/groups/` contains lettered folders (`a`, `b`, `c`, `d`, etc.) that group files sharing jump-table/export patterns. These groupings are heuristic, not definitive source boundaries.
- `src/modules/submodules/` currently groups utility-like routines that have not been confidently named yet. Expect placeholders such as `unknown*.s` until behavior is understood.
- Some larger modules now have numbered companion files (e.g., `disptext2.s`, `newgrid1.s`, `script2.s`–`script4.s`) to keep related chunks together.
- Alignment/padding bytes after jump tables are likely compiler artifacts that mark original object/source boundaries; treat them as file-end markers unless proven otherwise.
  - Heuristic only: padding can also appear mid-file for table/code alignment, and jump tables are suggestive but not definitive boundaries.
  - Some jump tables appear shared across multiple files; this is likely due to linker layout/segment reuse rather than a strict file-level boundary.

## Build, Test, and Development Commands
Ensure the vasm 68k toolchain is installed and update the hard-coded path inside `build.sh` and `test-hash.sh` if needed. Typical workflow:
```bash
chmod +x build.sh test-hash.sh
./build.sh        # Produces ESQ in ~/Downloads/Prevue/ or your configured path
./test-hash.sh    # Rebuilds to a temp file and verifies SHA-256 = 6bd4760d...
```
For targeted experiments, invoke vasm directly (example path):
```bash
~/Downloads/vasm/vasmm68k_mot -Fhunkexe -linedebug -o build/ESQ src/Prevue.asm
```
Never commit generated binaries; stash them or place them in `build/`.

## Coding Style & Naming Conventions
Use four-space indentation, uppercase opcodes, and align operands as in the existing modules. Public entry points should follow the `MODULE_ActionVerb` pattern (`GCOMMAND_LoadDefaultTable`, `KYBD_HandleRepeat`), with the original `LAB_xxxx` label retained immediately below the alias. Local labels stay lowercase with a leading dot. Favor short descriptive comments over block prose; explain hardware magic numbers and state transitions, not obvious move instructions. Share repeated sequences through macros and keep configuration flags (`includeCustomAriAssembly`) centralized.
When opaque data blocks appear (formerly “garbage”), annotate them as likely switch/jump tables and name them accordingly as you confirm usage.
For jump stubs, use a clear prefix such as `MODULE_JMPTBL_*` or `ESQ_JMPTBL_*` and add a header block (they are still callable entry points).
Prefer named symbols for A4-based globals (e.g., `Global_SavedDirLock`) instead of raw offsets like `-612(A4)`. Define these in `src/Prevue.asm` and reuse them across modules.

## Inline Documentation Standards (vasm-friendly)
Prefer inline comments in the `.s`/`.asm` files over external docs. Do not change instruction semantics; do not optimize or reorder code unless explicitly requested. Avoid renaming labels unless asked; add an alias label or comment-based name instead.

### Function header blocks
Add a standardized header block immediately above each identified subroutine entry label (or expand an existing block). Use this template:
```
;------------------------------------------------------------------------------
; FUNC: <primary_label>   (<human_name_or_guess>)
; ARGS:
;   stack +4: <type/name>  (if known)
;   stack +8: <type/name>  (if known)
;   A0/A1/A2/A3: <meaning> (if known)
;   D0-D7: <meaning>       (if known)
; RET:
;   D0: <meaning>          (or "none")
; CLOBBERS:
;   <regs modified>
; CALLS:
;   <library or local calls>
; READS:
;   <globals/struct offsets read>
; WRITES:
;   <globals/struct offsets written>
; DESC:
;   <1–4 lines describing behavior>
; NOTES:
;   <edge cases, DBF count semantics, signedness, etc.>
;------------------------------------------------------------------------------
```
Rules:
- If uncertain, mark with `??` rather than inventing facts.
- Keep DESC short and factual.
- For `DBF`, state loop count as “runs (Dn+1) iterations”.
- If the code looks like a compiler idiom (switch/jumptable, memcpy loop, checksum), say so in DESC.

### Symbol/data blocks
Add a symbol block above data/table definitions you touch:
```
;------------------------------------------------------------------------------
; SYM: <label>   (<human_name_or_guess>)
; TYPE: <u8/u16/u32/struct/array>  (best estimate)
; PURPOSE: <what it represents>
; USED BY: <key functions>
; NOTES: <indexing scheme, units, bounds, sentinel values>
;------------------------------------------------------------------------------
```
Prefer naming by role (e.g., `gChoiceIndex`, `kHalfHourLookup`) even if the original label remains. Document sentinel values and indexing formulas.

### Struct offset annotations
When code accesses offsets like `112(A3)` or `18(A0)`, add inline end-of-line comments:
```
    MOVE.W  10(A0),D1        ; A0+10 = minute (0..59) ??
```
Use the format `; A<reg>+<offset> = <field>` or `; <base>+<offset> = <field>`. If uncertain, keep `??` and reuse consistent field names across files.

### Struct definitions (vasm mot)
vasm (mot syntax) has no native struct/record syntax, so define explicit offset symbols:
- `Struct_Foo__Field = <offset>`
- `Struct_Foo__Field_Size = <bytes>` (optional)
- `Struct_Foo_Size = <total bytes>`

Use these in operands for clarity, e.g. `MOVE.W Struct_Foo__Field(A0),D0`.

### Compiler idiom annotations
Add a short descriptive comment near common patterns:
- PC-relative jump table → “switch/jumptable”
- `SNE/NEG/EXT` → “booleanize to 0/-1”
- `DIVS #10; SWAP` → “extract decimal digits”
- `DBF` loops → “count = Dn+1”

### Naming guidance (comment aliases)
- Globals/state: `gX` (e.g., `gChoiceIndex`, `gCooldownCounter`)
- Constant tables: `kX` (e.g., `kChoiceTable`, `kHalfHourLookup`)
- Booleans: `isX`, `hasX` (e.g., `isPmFlag`, `hasBodyChunk`)
- Functions: `Draw*`, `Load*`, `Format*`, `Test*`
If unsure, use a conservative name with `??`, e.g., `(PickChoiceFromTable??)`.

## Testing Guidelines
Every change should be followed by `./test-hash.sh` as the default verification step. If the output matches the canonical hash (`6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`), the build is in a good spot; otherwise investigate or document why. When touching input handling or drawing code, capture emulator traces or screenshots to supplement the hash result.

## Commit & Pull Request Guidelines
Commits should be small, scoped, and written in imperative mood (`Rename GROUP_AS_JMPTBL_STR_FindCharPtr highlight helpers`). Reference affected modules in the body and call out any new tables or configuration knobs. Pull requests need a brief summary, testing evidence (hash output, emulator logs), and links to related research threads. Highlight any remaining anonymous labels (`LAB_****`) that still require naming so reviewers can coordinate follow-up work.

## Documentation & Review Workflow
Update inline comments, `README.md`, and tables in `src/data/` when you rename labels or introduce new presets so future contributors can follow the thread. Cross-link helpers between modules (e.g., note when `gcommand.s` exports are consumed by `wdisp.s`) and record open renaming targets in the AGENTS checklist to keep the disassembly uniformly annotated.

## AGENTS Checklist
- [x] Add semantic aliases for Digital Niche/Mplex option-state globals in `src/data/wdisp.s` (`22D*`/`22E*` range) and propagate to callsites.
- [x] Rename/clean local dispatch labels in `src/modules/groups/b/a/newgrid.s` and `src/modules/groups/b/a/newgrid1.s` (including duplicate local-label removals).
- [x] Rename local control-flow labels in `src/modules/groups/a/a/bitmap.s` (`BITMAP_ProcessIlbmImage`) to descriptive names.
- [x] Add conservative aliases for diagnostics clock/filter globals in `src/data/wdisp.s` (`223B`-`2243`, `2322`-`2325`) and propagate `ESQFUNC_DrawDiagnosticsScreen` callsites.
- [x] Add row-level budget/provenance annotations for `ED2`/`TEXTDISP` high-risk `%s` formatter rows and track guard-priority order in `CHECKPOINT_layout_coupling_population.md` (`5.12`).
- [x] Add conservative `wdisp.s` `220F+` pointer-state aliases (serial/raster/highlight/task-hook cluster) and propagate callsites in ESQ/CLEANUP/ESQDISP/GCOMMAND3/NEWGRID/TLIBA3.
- [x] Add conservative `wdisp.s` `2242`-`226F` status/banner/refresh aliases and propagate callsites (`APP2`/`CLEANUP2`/`DST2`/`ESQ*`/`ED*`/`NEWGRID1`/`PARSEINI3`/`UNKNOWN`), while documenting unresolved holds.
- [x] Trace producer paths for unresolved `226D/226E`; document direct-writer absence and indirect `ESQ_SelectCodeBuffer` overflow clobber path in checkpoint docs.
- [x] Resume A4-negative startup/stream alias pass in `src/Prevue.asm` (`-1120..-1024`, `-1144`, `-748`) and propagate to `unknown16/24/29/2b/31/35`, documenting node-stride/field inference in `CHECKPOINT_layout_coupling_population.md` (`5.16`).
- [x] Replace raw prealloc-handle node offsets in `unknown14/16/2b/31/35` with `Struct_PreallocHandleNode__*` symbols and document field/bit confidence notes (`CHECKPOINT_layout_coupling_population.md` `5.17`).
- [x] Document confirmed `SECTION S_1` in-place string-length crash root cause (`Global_GraphicsLibraryBase_A4` stale displacement into `GRAPHICS_BltBitMapRastPort`) and mitigation options in `CHECKPOINT_layout_coupling_population.md` (`5.18`).
- [x] Add persistent pass-coverage tracker in `CHECKPOINT_doc_coverage_matrix.md` so doc/rename sweeps do not re-process completed scopes.
- [ ] Continue tightening unresolved `src/data/wdisp.s` state semantics outside completed option-state ranges (`220F` cluster complete; `2256`/`226D`/`226E` confidence still trace-dependent).
- [ ] Continue NEWGRID documentation passes using `CHECKPOINT_doc_coverage_matrix.md` scope gates (`newgrid2.s` naming pass complete; `newgrid1.s` mostly complete; remaining `newgrid.s` non-message-loop functions still open).
- [ ] Continue resolving unknown `Struct_PreallocHandleNode` flag-bit semantics (`ModeFlags`/`StateFlags`) and `OpenFlags` mask naming from `STREAM_BufferedPutcOrFlush`/`STREAM_BufferedGetc` traces.
