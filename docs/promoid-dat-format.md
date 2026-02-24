# `PromoId.Dat` Format

This document summarizes the format handled by:
- `P_TYPE_WritePromoIdDataFile` (`src/modules/groups/b/a/p_type.s:562`)
- `P_TYPE_LoadPromoIdDataFile` (`src/modules/groups/b/a/p_type.s:742`)

Path:
- `df0:PromoId.Dat` (`src/data/p_type.s:13`, `src/data/p_type.s:24`)

## High-Level Layout

The file is text sections with two top-level blocks:
1. `CURDAY:`
2. `NXTDAY:`

Each section stores either:
- a data header + `TYPES:` payload, or
- `No Data`

Writer emits section headers and payload in this order:
- `CURDAY:` block first
- `NXTDAY:` block second

## Data Block Shape

When a section has data, writer emits:

1. Header line: `" %03d %02d\n"`
2. Literal `"TYPES: "`
3. Raw type bytes (`count` bytes)
4. Line feed (`0x0A`)

Where header values are:
- first number: group code byte
- second number: type-count/length

If no data is present, writer emits:
- `No Data` plus blank-line spacing (`P_TYPE_STR_NO_DATA`)

## Loader Behavior

Loader:
- Finds each section by substring search (`CURDAY:`/`NXTDAY:`).
- Parses group code and length from the numeric header.
- Finds `TYPES:` and reads `length` bytes following it.
- Rebuilds per-group in-memory list entries for:
  - current primary group code
  - current secondary group code

Sections with non-matching group codes are ignored for active lists.

## Quick Parser Tips

- Locate sections by literal anchors (`CURDAY:`, `NXTDAY:`) before parsing numeric headers.
- Parse only as many `TYPES:` bytes as the advertised length; do not depend on line endings inside payload.
- Accept `No Data` as a valid section body and map it to an empty in-memory list.
