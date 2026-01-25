# Current Work Context

## Build State
- Canonical hash remains `6bd4760d1cf0706297ef169461ed0d7b7f0b079110a78e34d89223499e7c2fa2`. Run `./test-hash.sh` after each batch of label renames; the script assembles with `-nosym` and removes the temporary output automatically.
- Tooling assumes vasm 68k is installed under `~/Downloads/vasm/`; adjust `build.sh` and `test-hash.sh` if your local path differs.

## Active Refactor Threads
- `src/modules/gcommand.s` is mid-pass: many routines already export `GCOMMAND_*` aliases layered above their legacy `LAB_xxxx` labels. Remaining extern-visible labels referenced outside the module include `LAB_0CCF`, `LAB_0CE8`, `LAB_0D57`, `LAB_0D58`, `LAB_0D61`, `LAB_0D75`, `LAB_0D7A`, `LAB_0D84`, `LAB_0D89`, `LAB_0D8E`, `LAB_0DCF`, `LAB_0DD5`, `LAB_0DE9`, `LAB_0DF1`, `LAB_0DFA`. Check cross-references with `rg 'LAB_0[CD]' -g'*.s' --glob '!src/modules/gcommand.s'`.
- Associated data tables in `src/data/wdisp.s` still carry anonymous `LAB_22F*` symbols. Many are now annotated as likely switch/jump tables; name them as their purpose becomes clear during gcommand work (e.g., highlight flag tables, banner presets).
- `src/modules/newgrid.s` remains largely unaliased with raw `LAB_` labels; plan a naming/comment pass once the gcommand/wdisp path settles.

## Documentation Touchpoints
- `AGENTS.md` now captures module layout, naming conventions (`MODULE_ActionVerb` aliases), and the expected hash workflow. Keep it updated as you clarify additional modules.
- `README.md` summarizes the current build steps and structure (including asset paths and `src/decomp/`); update it if the layout or policies change.

## Suggested Next Steps
1. Continue renaming and commenting the remaining `LAB_0Dxx` exports in `gcommand.s`, mirroring the established alias/comment format.
2. Propagate those names to all call sites across `src/modules/`, `src/subroutines/`, and `src/data/`.
3. Once the UI highlight path is fully named, revisit `src/data/wdisp.s` to formalize table names and document their relationship to the gcommand routines.
4. Schedule an alias/comment sweep for `src/modules/newgrid.s` and its related tables once the UI naming stabilizes.
5. Re-run `./test-hash.sh` and capture the output hash in commit or PR notes for traceability.
