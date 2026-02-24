# `SourceCfg.ini` Format

This document describes the format consumed by:
- `TEXTDISP_LoadSourceConfig` (`src/modules/groups/b/a/textdisp.s:2212`)
- `PARSEINI_ParseIniBufferAndDispatch` section-8 path (`src/modules/groups/b/a/parseini.s:760`)

Path:
- `df0:SourceCfg.ini` (`src/data/textdisp.s:17`)

## Line Format

SourceCfg entries are parsed as `key=value` lines.

Parser behavior for each relevant line:
1. Find first `=`
2. Split key/value at `=`
3. Trim leading/trailing whitespace on value
4. Truncate key at first delimiter from section-8 delimiter set (space/tab class)
5. Dispatch `key` + `value` to `TEXTDISP_AddSourceConfigEntry`

## In-Memory Representation

`TEXTDISP_AddSourceConfigEntry` allocates a 6-byte record:
- `+0..+3`: pointer to owned key string
- `+4`: flag byte derived from value/type string
- `+5`: padding/unused

The entry pointer is stored in `TEXTDISP_SourceConfigEntryTable`.

## Semantics

During application (`TEXTDISP_ApplySourceConfigToEntry`):
- Entry source names are compared case-insensitively to config keys.
- On match, the entry’s display flags (`entry+40`) are OR’d with the stored flag byte.

Known special case:
- Type string matching `PrevueSports` sets flag `0x08`.

## Notes

- The loader clears previous SourceCfg entries before parsing the file.
- The parser uses the global INI dispatcher; comments/section syntax are governed by `PARSEINI_ParseIniBufferAndDispatch`.

## Quick Parser Tips

- Split at the first `=` only; keep remaining `=` characters in the value string.
- Trim value whitespace before type/flag matching so config lines are robust to spacing.
- Rebuild a fresh table each load (`TEXTDISP_ClearSourceConfig` semantics) to avoid stale entries.
