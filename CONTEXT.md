# Current Work Context

## Build State
- Canonical hash remains `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`. Run `./test-hash.sh` after each batch of label renames; the script assembles with `-nosym` and removes the temporary output automatically.
- Tooling assumes vasm 68k is installed under `~/Downloads/vasm/`; adjust `build.sh` and `test-hash.sh` if your local path differs.

## Active Refactor Threads
- `src/modules/gcommand.s` is mid-pass: many routines already export `GCOMMAND_*` aliases layered above their legacy `LAB_xxxx` labels. Remaining extern-visible labels to rename include `LAB_0D57`, `LAB_0D58`, `LAB_0D61`, `LAB_0D75`, `LAB_0D7A`, `LAB_0D84`, `LAB_0D89`, `LAB_0D8E`, `LAB_0D91`, `LAB_0D94`, `LAB_0D9B`, `LAB_0DB3`, `LAB_0DB6`, `LAB_0DC1`, `LAB_0DC6`, `LAB_0DC7`, `LAB_0DDA`, `LAB_0DE8`, `LAB_0DEB`, `LAB_0DEC`, `LAB_0DF1`, `LAB_0DFA`. Check cross-references with `rg 'LAB_0D' -g'*.s'`.
- Associated data tables in `src/data/wdisp.s` still carry anonymous `LAB_22F*` symbols. Name them as their purpose becomes clear during gcommand work (e.g., highlight flag tables, banner presets).

## Documentation Touchpoints
- `AGENTS.md` now captures module layout, naming conventions (`MODULE_ActionVerb` aliases), and the expected hash workflow. Keep it updated as you clarify additional modules.
- `README.md` summarizes the current build steps and references the aliasing workflow; update the “Development Workflow” section if new policies arise.

## Suggested Next Steps
1. Continue renaming and commenting the remaining `LAB_0Dxx` exports in `gcommand.s`, mirroring the established alias/comment format.
2. Propagate those names to all call sites across `src/modules/`, `src/subroutines/`, and `src/data/`.
3. Once the UI highlight path is fully named, revisit `src/data/wdisp.s` to formalize table names and document their relationship to the gcommand routines.
4. Re-run `./test-hash.sh` and capture the output hash in commit or PR notes for traceability.
