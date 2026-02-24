# `oinfo.dat` Format

This document describes `df0:oinfo.dat` as used by:
- `DISKIO2_WriteOinfoDataFile` (`src/modules/groups/a/h/diskio2.s:2045`)
- `DISKIO2_LoadOinfoDataFile` (`src/modules/groups/a/h/diskio2.s:2153`)

Path constant:
- `CTASKS_PATH_OINFO_DAT` (`src/data/ctasks.s:71`)

## Encoding

`oinfo.dat` is a NUL-token stream:
1. Primary group code (decimal token)
2. Primary line head string (NUL-terminated)
3. Primary line tail string (NUL-terminated)

`DISKIO_WriteDecimalField` writes token 1 as decimal text.
String tokens are written with `(strlen + 1)` so NUL delimiters are persisted.

## Load Behavior

On load:
- Reads group code token first.
- If loaded code matches `TEXTDISP_PrimaryGroupCode`, reads the next two strings.
- Replaces:
  - `ESQIFF_PrimaryLineHeadPtr`
  - `ESQIFF_PrimaryLineTailPtr`
  via `ESQPARS_ReplaceOwnedString`.

If group code does not match current primary group, the strings are ignored.

## Notes

- Missing file returns failure; caller decides fallback behavior.
- Empty strings are valid and serialized as a single NUL byte.

## Quick Parser Tips

- Read first token as decimal group code and compare against current primary code before consuming string payloads.
- Keep both strings NUL-terminated and allow empty-string tokens.
- Preserve token order exactly (`group`, `head`, `tail`) for writer compatibility.
