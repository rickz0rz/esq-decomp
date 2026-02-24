# `Gradient.ini` Format

This document describes the `df0:Gradient.ini` format consumed by:
- `PARSEINI_ParseIniBufferAndDispatch` (`src/modules/groups/b/a/parseini.s:61`)
- `PARSEINI_ParseRangeKeyValue` (`src/modules/groups/b/a/parseini.s:930`)
- `GCOMMAND_ValidatePresetTable` (`src/modules/groups/a/u/gcommand3.s:520`)

Path:
- `df0:Gradient.ini` (`src/data/parseini.s:98`)

## Overview

`Gradient.ini` is parsed through the generic INI dispatcher.  
The `[GRADIENT]` section (case-insensitive) is the one that drives preset-table parsing.

When `[GRADIENT]` is entered, the staging table is reset from seed defaults via:
- `GCOMMAND_InitPresetTableFromPalette` into `GCOMMAND_GradientPresetTable`

At `TABLE = DONE`, the staging table is validated and, if valid, copied to:
- `GCOMMAND_DefaultPresetTable` (0x820 bytes)

## Section And Line Handling

- Section headers use `[name]` syntax and are compared case-insensitively.
- In `[GRADIENT]`, lines are parsed by `PARSEINI_ParseRangeKeyValue`.
- Keys and values are split at the first `=`.
- Leading whitespace is skipped for both key and value.
- Value scanning for this path uses delimiters `" ;\t"` (space, semicolon, tab), so `;` starts a value-side comment.

## Supported Keys

### 1. `TABLE = DONE`

Finalizes parsing:
- Runs `GCOMMAND_ValidatePresetTable` on `GCOMMAND_GradientPresetTable`.
- On success, copies the full table into `GCOMMAND_DefaultPresetTable`.
- Resets current range index sentinel to `-1`.

### 2. `COLORn = m`

Pattern:
- Key must begin with `COLOR`.
- Optional numeric suffix `n` is parsed as signed long.

Constraints:
- `n` must be `0..15`; otherwise active index becomes invalid (`-1`).
- `m` is parsed as signed long, accepted range `1..63`.
- Stored row-length value is `m+1` (so stored range is `2..64`).

Effect:
- Sets active table row index to `n`.
- Stores row-length/count word at row header slot.

### 3. `<index> = <hexValue>`

For non-`TABLE` / non-`COLOR` keys in `[GRADIENT]`:
- Key is parsed as signed long index.
- Value is parsed as hexadecimal (consecutive hex digits).

Constraints:
- Active `COLORn` row must already be valid.
- `<index>` must be `0 <= index < rowLength`.
- `<hexValue>` must be `0x000..0xFFF` (12-bit, `< 0x1000`).

Effect:
- Writes word value into the active row at that column index.

## In-Memory Table Layout

Target table: `GCOMMAND_GradientPresetTable` in `src/data/wdisp.s:2592`

- Total size: 520 longs = 2080 bytes (`0x820`)
- Rows: 16
- Per-row stride: 128 bytes (`row * 0x80`)
- Row count header: `table + (row * 2)` (word)
- Row values: `table + 32 + (row * 0x80) + (col * 2)` (word)

Validator constraints (`GCOMMAND_ValidatePresetTable`):
- Each row count must be in `1..64`.
- Each populated value must be in `0x000..0xFFF`.

## Notes

- A dedicated command path exists to load this file (`.cmd_parse_gradient_ini` in `src/modules/groups/b/a/parseini.s:2187`).
- Current named-symbol traces confirm parse/validate/copy behavior; a direct runtime banner consumer of `GCOMMAND_GradientPresetTable` itself remains unconfirmed.
- `PARSEINI_ParseColorTable` handles `COLOR%d` parsing for other INI sections (`[TEXTADS]`/`[BRUSH]`) and is not the primary `[GRADIENT]` range parser.

## Quick Parser Tips

- Treat `TABLE = DONE` as a commit step; without it, new values may never be promoted to the default preset table.
- Keep row/column/value bounds strict (`row 0..15`, `value <= 0xFFF`, `index < rowLength`) to mirror in-code acceptance.
- Preserve the two-level layout (row header counts + row payload words) so generated data matches validator expectations.
