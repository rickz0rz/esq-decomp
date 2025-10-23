# Esquire Disassembly

This repository contains a living disassembly and annotation of the Esquire 9.04 scheduler, built for the Amiga platform. The goal is to document system behavior, preserve historical software, and enable small targeted fixes through commented assembly.

## Repository Layout
- `src/` – Primary source tree with `ESQ.asm` (entry point), supporting macro/include files, and interrupt modules.
- `src/modules/` – Annotated module set (e.g., `gcommand.s`, `kybd.s`); look for descriptive aliases above legacy `LAB_xxxx` labels when navigating routines.
- `assets/` – External dependencies: Workbench ROM under `kickstart/` and the extracted HDD image under `prevue/`.
- `build/` – Generated binaries and intermediate objects; safe to regenerate via the build scripts.
- `build.sh`, `test-hash.sh` – Reference scripts for assembling and verifying the image with the vasm toolchain.

## Pre-Requisites
- Place the Amiga Workbench 2.04 ROM at `assets/kickstart/v2.04.rom`.
- Download and extract the [Esquire 9.04 HDD image](https://park-city.club/~frix/prevue/Prevue.zip) into `assets/prevue/`.
- Install [vasm](https://sun.hasenbraten.de/vasm/) (m68k, `mot` syntax) and update any hard-coded paths in the scripts to match your setup.
- Optional: Install the [Amiga Assembly](https://marketplace.visualstudio.com/items?itemName=prb28.amiga-assembly) VS Code extension for improved syntax support.

## Getting Started
1. Verify the prerequisites above and ensure the vasm binaries are accessible.
2. Make the helper scripts executable: `chmod +x build.sh test-hash.sh`.
3. Build the disassembly with `./build.sh`. By default this writes the `ESQ` executable to `~/Downloads/Prevue/ESQ`; adjust the script if you prefer a local output path.
4. Validate the output with `./test-hash.sh`; the script prints the expected SHA-256 hash for the canonical build.

## Contributor Guide
If you plan to extend or annotate the disassembly, read the contributor guidelines in [`AGENTS.md`](AGENTS.md) for module organization, coding style, testing expectations, and review workflow.
