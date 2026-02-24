# `LocAvail.dat` Format

This document describes the on-disk format used by `LOCAVAIL_SaveAvailabilityDataFile` / `LOCAVAIL_LoadAvailabilityDataFile`:
- `src/modules/groups/a/y/locavail.s`
- `src/modules/groups/a/g/diskio.s`
- `src/data/locavail.s`

## Key Point

`LocAvail.dat` is **not newline-delimited text**.  
It is a **stream of NUL-terminated C strings** (`\0`-terminated tokens).

The loader repeatedly calls `DISKIO_ConsumeCStringFromWorkBuffer` and `DISKIO_ParseLongFromWorkBuffer`, both of which consume one NUL-terminated token at a time.

## Top-Level Record Structure

The saver emits two back-to-back records:
1. `"LA_VER_1:  curday"`
2. `"LA_VER_1:  nxtday"`

Each record is serialized as:

1. Record tag token (`"LA_VER_1:  curday"` or `"LA_VER_1:  nxtday"`)
2. Group code (decimal token)
3. Node count (decimal token)
4. Mode char token (single char as a C string)
5. `node_count` node payloads

No newline separators are required; token boundaries are NUL bytes.

## Node Payload Structure

For each node, saver writes:

1. Class id (decimal token, expected `1..99`)
2. Duration (decimal token, expected `1..3600` where `< 0x0E11`)
3. Bitmap length (decimal token, expected `1..99`)
4. Bitmap token (string length = `bitmap_length`)

The bitmap token is encoded with character tags from `LOCAVAIL_TAG_UVGTI` (`"UVGTI"`):
- `U` -> class value `0`
- `V` -> class value `1`
- `G` -> class value `2`
- `T` -> class value `3`
- `I` -> class value `4`

On load, unknown bitmap chars are treated as zero and mark parse failure for that record.

## Tokenization Details

- Numeric values are written via `DISKIO_WriteDecimalField` using `"%ld"`, then stored as NUL-terminated tokens.
- Strings are written via `DISKIO_WriteBufferedBytes` with `(strlen + 1)`, explicitly including terminators.
- Loader verifies the first 6 bytes of each record tag case-insensitively against `"LA_VER"` before parsing numeric fields.

## Practical Escaped Example

Conceptual escaped byte stream:

```text
LA_VER_1:  curday\0
1\0
2\0
F\0
1\0
1800\0
6\0
UVGTIU\0
2\0
900\0
4\0
GGTT\0
LA_VER_1:  nxtday\0
2\0
0\0
F\0
```

In the real file this is contiguous binary data with `0x00` token separators, not printable `\0` text.

## Validation Behavior Notes

- If file load fails, the caller keeps/reset states to active primary/secondary group codes.
- If a record parses but its group code does not match current primary/secondary group code, the temporary parsed state is freed.
- Bounds checks in loader enforce positive counts and maximums noted above; invalid ranges reject the record.

## Quick Parser Tips

- Tokenize by `0x00` only; this file is a C-string token stream, not line-based text.
- Decode bitmap strings through `UVGTI` mapping and treat unknown chars as parse errors (while preserving loader-compatible zeroing behavior if needed).
- Validate `class`, `duration`, and `bitmapLength` early before allocating bitmap buffers.
