# `qtable.ini` Format

This document describes the file written by:
- `DISKIO2_WriteQTableIniFile` (`src/modules/groups/a/h/diskio2.s:1867`)

Path:
- `df0:qtable.ini` (`CTASKS_PATH_QTABLE_INI` in `src/data/ctasks.s:69`)

## Layout

Header:
1. Literal `[Qtable]`
2. `CRLF`

Body:
- One line per alias entry from `TEXTDISP_AliasPtrTable`:
  - `key="value"` + `CRLF`

Where:
- `key` = first C-string pointer at alias node offset `+0`
- `value` = second C-string pointer at alias node offset `+4`

The writer emits raw string bytes (without NUL terminators) and inserts:
- `=` between key/value
- opening and closing `"` around value
- `CRLF` line endings

## Notes

- File is generated only when `TEXTDISP_AliasCount >= 1`.
- The routine is write-only in this path; parsing is handled elsewhere through broader INI workflows.

## Quick Parser Tips

- Expect `CRLF` line endings and quoted values (`key="value"`).
- Do not include NUL terminators when reconstructing file text from in-memory alias strings.
- Preserve header literal `[Qtable]` exactly for compatibility with downstream INI consumers.
