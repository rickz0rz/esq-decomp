# `config.dat` Format

This document describes the `df0:config.dat` serialization used by:
- `DISKIO_SaveConfigToFileHandle` (`src/modules/groups/a/g/diskio.s:2342`)
- `DISKIO_ParseConfigBuffer` (`src/modules/groups/a/g/diskio.s:1332`)

## Overview

`config.dat` is a fixed-order, fixed-width serialized record generated with:
- `Global_STR_DEFAULT_CONFIG_FORMATTED` in `src/data/diskio.s:70`

Writer target path:
- `df0:config.dat` (`src/data/diskio.s:68`)

Parser behavior:
- Reads fields in-order from the buffer.
- Guards each optional tail field with length checks; truncated older files are accepted.
- Applies validation/clamps/defaults per field.

## Format String

Exact formatter string (concatenated):

```text
%01ld%01lc%01ld%01ld%02ld%02ld%01lc%01lc%01lc%01lc%01ld%01ld%01lc%01lc%01lc%01lc%01lc%01lc%01lc%02ld%02ld%01lc%01lc%01lc%02ld%02ld%02ld%03ld%01ld%2.2s%01lc%01lc%01lc%01c%01c%01d%01c%01c%01c%01c%01c%01c
```

Important:
- Field 35 (`%01c`) is a raw byte (banner copper head byte payload), not decimal text.
- Field 36 (`%01d`) is the palette-count digit.

## Field Map (In Serialization Order)

1. `%01ld` -> `CONFIG_RefreshIntervalMinutes` (`'0'..'9'` digit -> numeric)
2. `%01lc` -> `CTASKS_STR_C`
3. `%01ld` -> `CONFIG_NicheModeCycleBudget_Y` (digit)
4. `%01ld` -> `CONFIG_NicheModeCycleBudget_Static` (digit)
5. `%02ld` -> `CONFIG_SerializedNumericSlot05`
6. `%02ld` -> `CONFIG_NewgridWindowSpanHalfHoursPrimary`
7. `%01lc` -> `CTASKS_STR_G`
8. `%01lc` -> `CONFIG_SerializedFlagSlot08_DefaultN` (default `'N'` if missing)
9. `%01lc` -> `CTASKS_STR_A` (default `'A'` if missing)
10. `%01lc` -> `CTASKS_STR_E`
11. `%01ld` -> `CONFIG_SerializedNumericSlot10` (clamped `0..9`)
12. `%01ld` -> `CONFIG_NicheModeCycleBudget_Custom` (clamped `0..9`)
13. `%01lc` -> `CONFIG_NewgridSelectionCode34PrimaryEnabledFlag` (`Y/N`, invalid -> `Y`)
14. `%01lc` -> `CONFIG_NewgridSelectionCode35EnabledFlag` (`Y/N`, invalid -> `Y`)
15. `%01lc` -> `CONFIG_SerializedFlagSlot15_DefaultN` (`Y/N`, invalid -> `N`)
16. `%01lc` -> `CONFIG_NewgridSelectionCode34AltEnabledFlag` (`Y/N`, invalid -> `N`)
17. `%01lc` -> `CONFIG_NewgridSelectionCode32EnabledFlag` (`Y/N`, invalid -> `Y`)
18. `%01lc` -> `CONFIG_RuntimeMode12BannerJumpEnabledFlag` (`Y/N`, invalid -> `N`)
19. `%01lc` -> `CTASKS_STR_L` (must be `L/S/V`, invalid -> `L`)
20. `%02ld` -> `CONFIG_SerializedNumericSlot19`
21. `%02ld` -> `CONFIG_SerializedNumericSlot20`
22. `%01lc` -> `CONFIG_ModeCycleEnabledFlag` (`Y/N`, invalid -> `Y`)
23. `%01lc` -> `CONFIG_NewgridPlaceholderBevelFlag` (`Y/N`, invalid -> `Y`)
24. `%01lc` -> `CONFIG_NewgridSelectionCode48_49EnabledFlag` (`Y/N`, invalid -> `N`)
25. `%02ld` -> `CONFIG_SerializedNumericSlot25`
26. `%02ld` -> `CONFIG_SerializedNumericSlot26`
27. `%02ld` -> `CONFIG_NewgridWindowSpanHalfHoursAlt`
28. `%03ld` -> `CONFIG_TimeWindowMinutes`
29. `%01ld` -> `CONFIG_ModeCycleGateDuration` (clamped `1..9`)
30. `%2.2s` -> brush label for `BRUSH_SelectBrushByLabel` (2 chars)
31. `%01lc` -> `CONFIG_NewgridSelectionCode16EnabledFlag` (`Y/N`, invalid -> `Y`)
32. `%01lc` -> `Global_REF_STR_USE_24_HR_CLOCK` (`Y/N`, invalid -> `N`; also selects 12h/24h lookup table)
33. `%01lc` -> `CONFIG_ParseiniLogoScanEnabledFlag` (`Y/N`, invalid -> `Y`)
34. `%01c` -> banner-copper mode token
35. `%01c` -> banner-copper payload byte (used when token indicates direct byte mode)
36. `%01d` -> `Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES` (effectively forced to `8`)
37. `%01c` -> `ED_DiagTextModeChar` (must be in `NRLS`, else `N`)
38. `%01c` -> `CONFIG_EnsurePc1GfxAssignedFlag` (`Y/N`, invalid -> `N`; `Y` triggers PC1 mount/assign helper)
39. `%01c` -> `CONFIG_MsnRuntimeModeSelectorChar_LRBN` (must be in `LRBN`, else `N`)
40. `%01c` -> `CONFIG_LRBN_FlagChar` (`Y/N`, invalid -> `Y`, with runtime side-effect path)
41. `%01c` -> `CONFIG_MSN_FlagChar` (must be in `MSN`, else `N`)
42. `%01c` -> `CTASKS_STR_1` (must be `'1'` or `'2'`, invalid -> `'1'`)

## Byte Position Table (1..52)

This table maps fixed output columns in `config.dat` to fields.

| Field | Byte(s) | Width | Symbol |
| --- | --- | --- | --- |
| 1 | 1 | 1 | `CONFIG_RefreshIntervalMinutes` |
| 2 | 2 | 1 | `CTASKS_STR_C` |
| 3 | 3 | 1 | `CONFIG_NicheModeCycleBudget_Y` |
| 4 | 4 | 1 | `CONFIG_NicheModeCycleBudget_Static` |
| 5 | 5-6 | 2 | `CONFIG_SerializedNumericSlot05` |
| 6 | 7-8 | 2 | `CONFIG_NewgridWindowSpanHalfHoursPrimary` |
| 7 | 9 | 1 | `CTASKS_STR_G` |
| 8 | 10 | 1 | `CONFIG_SerializedFlagSlot08_DefaultN` |
| 9 | 11 | 1 | `CTASKS_STR_A` |
| 10 | 12 | 1 | `CTASKS_STR_E` |
| 11 | 13 | 1 | `CONFIG_SerializedNumericSlot10` |
| 12 | 14 | 1 | `CONFIG_NicheModeCycleBudget_Custom` |
| 13 | 15 | 1 | `CONFIG_NewgridSelectionCode34PrimaryEnabledFlag` |
| 14 | 16 | 1 | `CONFIG_NewgridSelectionCode35EnabledFlag` |
| 15 | 17 | 1 | `CONFIG_SerializedFlagSlot15_DefaultN` |
| 16 | 18 | 1 | `CONFIG_NewgridSelectionCode34AltEnabledFlag` |
| 17 | 19 | 1 | `CONFIG_NewgridSelectionCode32EnabledFlag` |
| 18 | 20 | 1 | `CONFIG_RuntimeMode12BannerJumpEnabledFlag` |
| 19 | 21 | 1 | `CTASKS_STR_L` |
| 20 | 22-23 | 2 | `CONFIG_SerializedNumericSlot19` |
| 21 | 24-25 | 2 | `CONFIG_SerializedNumericSlot20` |
| 22 | 26 | 1 | `CONFIG_ModeCycleEnabledFlag` |
| 23 | 27 | 1 | `CONFIG_NewgridPlaceholderBevelFlag` |
| 24 | 28 | 1 | `CONFIG_NewgridSelectionCode48_49EnabledFlag` |
| 25 | 29-30 | 2 | `CONFIG_SerializedNumericSlot25` |
| 26 | 31-32 | 2 | `CONFIG_SerializedNumericSlot26` |
| 27 | 33-34 | 2 | `CONFIG_NewgridWindowSpanHalfHoursAlt` |
| 28 | 35-37 | 3 | `CONFIG_TimeWindowMinutes` |
| 29 | 38 | 1 | `CONFIG_ModeCycleGateDuration` |
| 30 | 39-40 | 2 | brush label |
| 31 | 41 | 1 | `CONFIG_NewgridSelectionCode16EnabledFlag` |
| 32 | 42 | 1 | `Global_REF_STR_USE_24_HR_CLOCK` |
| 33 | 43 | 1 | `CONFIG_ParseiniLogoScanEnabledFlag` |
| 34 | 44 | 1 | banner copper mode token |
| 35 | 45 | 1 | banner copper payload byte |
| 36 | 46 | 1 | `Global_REF_BYTE_NUMBER_OF_COLOR_PALETTES` |
| 37 | 47 | 1 | `ED_DiagTextModeChar` |
| 38 | 48 | 1 | `CONFIG_EnsurePc1GfxAssignedFlag` |
| 39 | 49 | 1 | `CONFIG_MsnRuntimeModeSelectorChar_LRBN` |
| 40 | 50 | 1 | `CONFIG_LRBN_FlagChar` |
| 41 | 51 | 1 | `CONFIG_MSN_FlagChar` |
| 42 | 52 | 1 | `CTASKS_STR_1` |

## Banner Copper Token (Fields 34-35)

`DISKIO_ParseConfigBuffer` interprets field 34 as a mode token:
- `'C'`: read field 35 as raw byte value and use as `CONFIG_BannerCopperHeadByte`
- `'F'`: force `CONFIG_BannerCopperHeadByte = 128` and consume one payload byte
- `'H'`/`'P'`/other: fallback path -> default `$8E` and consume one payload byte

After decode, value is clamped to `128..220`; invalid range falls back to `$8E` (142).

## Practical Notes

- `DISKIO_LoadConfigFromDisk` passes `(file_size + 1)` to parser and parser checks bounds before each late field, so older shorter records remain loadable.
- Save path writes a fixed 52-byte slice from the formatted buffer (`DISKIO_WriteBufferedBytes` call in `src/modules/groups/a/g/diskio.s:2581`), which is why format width/order must stay stable.

## Quick Parser Tips

- Parse strictly by byte position, not delimiters: the record is fixed-width text except for the raw copper payload byte at field 35.
- Validate/clamp exactly like loader logic (`Y/N` normalization, numeric clamps) before applying values to avoid behavior drift.
- If a record is shorter than 52 bytes, treat missing tail fields as “use parser default/fallback,” matching the in-code bounds checks.
