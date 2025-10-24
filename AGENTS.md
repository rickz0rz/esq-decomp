# Repository Guidelines

## Project Structure & Module Organization
`src/ESQ.asm` is the root include; it stitches together feature modules under `src/modules/` (UI control in `gcommand.s`, keyboard input in `kybd.s`, disk helpers in `diskio2.s`) plus shared routines from `src/subroutines/`. Display tables and highlight presets live in `src/data/`, while interrupt-specific logic sits in `src/interrupts/`. Keep module-level assets beside their code: banner strings go in the matching data file, and new shared macros belong in `macros.s` or `text-formatting.s`. External requirements (Workbench ROM, HDD image) are stored under `assets/`. Treat `build/` as disposable output.

## Build, Test, and Development Commands
Ensure the vasm 68k toolchain is installed and update the hard-coded path inside `build.sh` and `test-hash.sh` if needed. Typical workflow:
```bash
chmod +x build.sh test-hash.sh
./build.sh        # Produces ESQ in ~/Downloads/Prevue/ or your configured path
./test-hash.sh    # Rebuilds to a temp file and verifies SHA-256 = 6bd4760d...
```
For targeted experiments, invoke vasm directly (example path):
```bash
~/Downloads/vasm/vasmm68k_mot -Fhunkexe -linedebug -o build/ESQ src/ESQ.asm
```
Never commit generated binaries; stash them or place them in `build/`.

## Coding Style & Naming Conventions
Use four-space indentation, uppercase opcodes, and align operands as in the existing modules. Public entry points should follow the `MODULE_ActionVerb` pattern (`GCOMMAND_LoadDefaultTable`, `KYBD_HandleRepeat`), with the original `LAB_xxxx` label retained immediately below the alias. Local labels stay lowercase with a leading dot. Favor short descriptive comments over block prose; explain hardware magic numbers and state transitions, not obvious move instructions. Share repeated sequences through macros and keep configuration flags (`includeCustomAriAssembly`) centralized.

## Testing Guidelines
Every behavior change must preserve the canonical hash unless the goal is an intentional divergence. Run `./test-hash.sh` after each meaningful edit; if the output differs from `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`, investigate or document why. When touching input handling or drawing code, capture emulator traces or screenshots to supplement the hash result.

## Commit & Pull Request Guidelines
Commits should be small, scoped, and written in imperative mood (`Rename LAB_0D57 highlight helpers`). Reference affected modules in the body and call out any new tables or configuration knobs. Pull requests need a brief summary, testing evidence (hash output, emulator logs), and links to related research threads. Highlight any remaining anonymous labels (`LAB_****`) that still require naming so reviewers can coordinate follow-up work.

## Documentation & Review Workflow
Update inline comments, `README.md`, and tables in `src/data/` when you rename labels or introduce new presets so future contributors can follow the thread. Cross-link helpers between modules (e.g., note when `gcommand.s` exports are consumed by `wdisp.s`) and record open renaming targets in the AGENTS checklist to keep the disassembly uniformly annotated.
