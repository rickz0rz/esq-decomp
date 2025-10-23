# Repository Guidelines

## Project Structure & Module Organization
The `src/` tree houses the main disassembly. `src/ESQ.asm` is the entry point and pulls in shared modules such as `macros.s`, `structs.s`, `string-macros.s`, and `text-formatting.s`. Interrupt-specific code sits under `src/interrupts/`. Hardware constants and linker fragments live in the sibling `.s` files; place new shared tables alongside the closest conceptual peer. Runtime dependencies are external: drop the Workbench ROM at `assets/kickstart/v2.04.rom` and unpack the HDD image under `assets/prevue/`. The `build/` directory is scratch output and can be regenerated at any time.

## Build, Test, and Development Commands
Use the vasm 68000 toolchain. Update the absolute path in `build.sh` to match your local install, then run:
```bash
chmod +x build.sh
./build.sh
```
This assembles `src/ESQ.asm` and writes `ESQ` into `~/Downloads/Prevue/` by default. For experiments you can assemble directly into the repo:
```bash
~/Downloads/vasm/vasmm68k_mot -Fhunkexe -linedebug -o build/ESQ src/ESQ.asm
```
Keep build artifacts out of version control unless they document a regression.

## Coding Style & Naming Conventions
Indent instructions with four spaces and align operands in columns as seen in the existing files. Keep opcodes uppercase, labels in mixed-case Pascal style (`SECSTRT_0`, `.copyByteFromD1To5929Buffer`), and reserve leading dots for local scope. Place shared constants or macros in the dedicated `.s` files and accompany non-obvious logic with concise `;` comments. Prefer macros over duplicated instruction sequences and gate optional code with flags such as `includeCustomAriAssembly`.

When adding descriptive aliases for existing jump destinations, keep the original `LAB_xxxx` label in place and introduce the new name directly above it, e.g.:
```
; Describe intent here.
KYBD_UpdateHighlightState:
LAB_0E05:
    ...
```
This preserves binary compatibility while giving future readers a stable symbol.

## Testing Guidelines
Run the deterministic hash check before submitting:
```bash
./test-hash.sh
```
It assembles without symbols and prints a SHA-256 digest; confirm it matches the expected line or update the annotation with justification. When altering ROM-dependent behavior, capture emulator traces to accompany the hash evidence.

## Commit & Pull Request Guidelines
Follow the short, imperative commit style already used (`Add more hardware addresses.`). Limit each commit to a single logical change and mention the touched module or hardware table when relevant. Pull requests should summarize behavioral impact, list setup notes (ROM paths, emulator configuration), and attach hash/test output or relevant screenshots. Link to any related issue or external research to give reviewers context.
