# `dst.dat` Format

This document describes the on-disk DST window format used by Esquire, based on the parser/writer routines in:
- `src/modules/groups/a/j/dst.s`
- `src/modules/groups/a/j/disptext2.s`
- `src/data/dst.s`

## Overview

`dst.dat` is a text-like file containing two sections:
- `g2` window pair
- `g3` window pair

Each section stores two encoded timestamps:
- "in time" entry (marker byte `0x04`)
- "out time" entry (marker byte `0x13`)

The code uses section tags `"g2"` and `"g3"` to find sections, then searches each section for marker bytes `4` and `19` (decimal).

## Encoded Timestamp Payload

Each marker is followed by a fixed-width payload:

`YYYYDDDHH:MM`

Field meaning:
- `YYYY`: 4-digit year
- `DDD`: day-of-year (`001..366`)
- `HH`: hour (`00..23`)
- `MM`: minute (`00..59`)

Parser offsets (from marker location):
- `+1` .. `+7`: `YYYYDDD` (7 chars)
- `+8`: hour parse start
- `+11`: minute parse start

## Section Shape

Conceptually, each section is written like:

```text
 g2:<0x04>YYYYDDDHH:MM<0x13>YYYYDDDHH:MM
 g3:<0x04>YYYYDDDHH:MM<0x13>YYYYDDDHH:MM
```

Notes:
- The writer emits lowercase tags with leading spaces: `" g2:"` and `" g3:"`.
- The marker bytes are control characters, not printable ASCII digits.
- If an entry is missing/null at runtime, formatter fallbacks print `" NO IN TIME "`, `" NO OUT TIME "`, or `" NO DST DATA "` in diagnostics/output paths.

## Practical Example (escaped form)

This escaped representation is useful for tooling/docs:

```text
 g2:\x04199609102:30\x13199630102:30
 g3:\x04199609102:30\x13199630102:30
```

The actual file stores raw bytes `0x04` and `0x13`, not the four-character sequences `\x04`/`\x13`.

## Quick Parser Tips

- Scan for `"g2"`/`"g3"` section anchors first, then search forward for marker bytes `0x04` and `0x13`.
- Parse payload as fixed `YYYYDDDHH:MM`; do not rely on separators between `YYYY` and `DDD`.
- If either marker payload is missing, preserve a null/missing state so runtime fallback strings can render correctly.
