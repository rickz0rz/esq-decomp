# `curday.dat` / `nxtday.dat` Format

This document summarizes the disk record layouts used by:
- `DISKIO2_WriteCurDayDataFile` / `DISKIO2_LoadCurDayDataFile`
- `DISKIO2_WriteNxtDayDataFile` / `DISKIO2_LoadNxtDayDataFile`
- `src/modules/groups/a/h/diskio2.s`

## Encoding Model

Both files are mixed binary/token streams:
- Fixed-size binary blocks for per-entry headers.
- NUL-terminated strings for variable text fields.
- Decimal numeric fields written with `DISKIO_WriteDecimalField` and read with `DISKIO_ParseLongFromWorkBuffer`.

`DISKIO_ParseLongFromWorkBuffer` consumes one NUL-terminated token then parses signed decimal.

## `curday.dat` Layout

Write path: `DISKIO2_WriteCurDayDataFile` (`src/modules/groups/a/h/diskio2.s:20`)

Top-level sequence:
1. 21-byte status packet (`ESQ_STR_B`)
2. `DST_PrimaryCountdown` (decimal token)
3. Revision tag string (`"DREV 5"` in current writer)
4. Weather status label string (`WDISP_WeatherStatusLabelBuffer`)
5. Optional weather status text string (`WDISP_WeatherStatusTextPtr` or empty)
6. Primary group code (decimal token)
7. Primary entry count (decimal token)
8. Primary group checksum (decimal token)
9. Primary group record length (decimal token)
10. Repeated entry records (see below)

Per-entry sequence:
1. Fixed entry block (size depends on loader `DREV`; writer emits 48 bytes)
2. Entry title string (NUL-terminated)
3. Slot records for active slots only (0..48), then sentinel index token (`49`)

Per-slot sequence (for each emitted slot):
1. Slot index (decimal)
2. Slot flag byte `7(slot)` (decimal)
3. Slot byte at `+252+slot` (decimal)
4. Slot byte at `+301+slot` (decimal)
5. Slot byte at `+350+slot` (decimal)
6. Slot text string (NUL-terminated)

## `nxtday.dat` Layout

Write path: `DISKIO2_WriteNxtDayDataFile` (`src/modules/groups/a/h/diskio2.s:1226`)

Top-level sequence:
1. Secondary group code (decimal token)
2. Secondary entry count (decimal token)
3. Secondary group checksum (decimal token)
4. Secondary group record length (decimal token)
5. Repeated entry records

Per-entry and per-slot structure matches the `curday.dat` writer:
- 48-byte entry block
- Title string
- Active-slot tuples (`index`, four numeric slot bytes, slot text)
- Slot sentinel (`49`)

## Revision/Compatibility Notes

`curday` loader inspects a `DREV` string and adapts parsing:
- `DREV 1/2/3/4/5` are recognized.
- Old revisions imply shorter fixed entry-header copy lengths and reduced slot-field parsing.

`curday` entry-header copy lengths by `DREV`:

| `DREV` | Bytes copied into entry struct before title parse |
| --- | --- |
| `DREV 1` | 40 |
| `DREV 2` | 41 |
| `DREV 3` | 46 |
| `DREV 4` | 48 |
| `DREV 5` | 48 |

`curday` per-slot parse differences:

| `DREV` | Parsed per active slot |
| --- | --- |
| `1` | `slotFlag`, `slotText` |
| `2..4` | `slotFlag`, `+252`, `+301`, `+350`, `slotText` |
| `5` | Same as `2..4`, plus sparse-slot index optimization |

`nxtday` loader slot behavior:
- Always parses `slotFlag`, `+252`, `+301`, `+350`, `slotText`.
- Uses sparse-slot index optimization when `DISKIO_CurrentDriveRevisionIndex > 4`.

Both loaders include a sparse-slot optimization path (rev > 4 behavior):
- A parsed slot index token can indicate the next active slot.
- Slots before that index are skipped without consuming full slot payloads.
- A trailing sentinel index token is consumed at entry end.

Current writers emit rev-5 style data and slot sentinel token `49`.

## Quick Parser Tips

- For `curday.dat`, parse the `DREV` tag first, then select the correct entry-header size and slot-field schema.
- Respect sparse-slot mode for rev > 4: when the next active slot index is ahead of the current slot, skip payload reads until that index.
- Treat slot sentinel token `49` as end-of-entry slot stream; then move to next entry.
