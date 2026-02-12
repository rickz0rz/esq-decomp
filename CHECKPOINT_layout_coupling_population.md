# Layout-Coupling Population Trace

Date: 2026-02-12

## Purpose
Track where layout-coupled string/template data is populated so Section 1 hardcoded-string edits are safer and easier to verify.

## Anchor/Population Map

### 1) Channel label legacy anchor (`SCRIPT`)
- Anchor label: `DATA_SCRIPT_STR_ESDAYS_FRIDAYS_20ED` (`SCRIPT_ChannelLabelLegacyIndexAnchor`)
- True table base: `SCRIPT_ChannelLabelPtrTable`
- Consumers:
  - `src/modules/groups/b/a/textdisp.s` (`LEA DATA_SCRIPT_STR_ESDAYS_FRIDAYS_20ED,A0` index path)
  - `src/modules/groups/a/d/cleanup3.s` (`LEA DATA_SCRIPT_STR_ESDAYS_FRIDAYS_20ED,A0` index path)
- Population source:
  - Table is static in `src/data/script.s`.
  - Entries 19..22 point to zeroed placeholders (`SCRIPT_ChannelLabelEmptySlot0..3`).
  - No direct symbol-based writers to those placeholders identified yet.

### 2) Weather brush-name legacy anchor (`ESQFUNC`)
- Anchor label: `DATA_ESQFUNC_STR_I5_1EDD`
- True table base: `ESQFUNC_PwBrushNamePtrTable`
- Consumers:
  - `src/modules/groups/b/a/wdisp.s`
  - `src/modules/groups/a/n/esqiff.s`
- Population source:
  - Static pointer table in `src/data/esqfunc.s` (no dynamic rewrite path identified in this pass).

### 3) Termination-reason legacy anchor (`CTASKS`)
- Anchor label: `CTASKS_STR_TERM_DL_TOO_LARGE_TAIL`
- True table base: `CTASKS_TerminationReasonPtrTable`
- Consumers:
  - `src/modules/groups/a/g/diskio.s`
- Population source:
  - Static pointer table in `src/data/ctasks.s`.

### 4) Section 1-style template strings (`Niche/Mplex/PPV`)
- Top-level reset+load entry: `FLIB2_ResetAndLoadListingTemplates` (`src/modules/groups/a/s/flib2.s`)
- Default population:
  - `FLIB2_LoadDigitalNicheDefaults`
  - `FLIB2_LoadDigitalMplexDefaults`
  - `FLIB2_LoadDigitalPpvDefaults`
- Disk/template ingestion + tail append:
  - `GCOMMAND_LoadDefaultTable`
  - `GCOMMAND_LoadMplexTemplate`
  - `GCOMMAND_LoadPPV3Template`
  - `GCOMMAND_ParseCommandOptions`
  - `GCOMMAND_ParseCommandString`
  - `GCOMMAND_ParsePPVCommand`
- Shared ownership helper:
  - `ESQPARS_ReplaceOwnedString` (`src/modules/groups/a/o/esqpars.s`)
  - Behavior: free old pointer, then allocate/copy new string, may return NULL on empty input or low-memory gate.

### 5) Startup population hub (`ESQ_MainInitAndRun`)
- Entry: `ESQ_MainInitAndRun` (`src/modules/groups/a/m/esq.s`)
- Role:
  - Central startup writer for display buffers, raster aliases, serial state, and multiple startup strings rendered before normal UI loop.
  - Important for Section 1 hardcoded-string edits because startup formatting/drawing paths run before many later guards are active.

#### 5.1 argv-driven string population
- `argv[1]` is copied bytewise into `Global_PTR_STR_SELECT_CODE` until NUL.
- No explicit destination-length guard is visible in the copy loop.
- Same copied string is later rendered via `ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines`.
- Risk implication:
  - Very long select-code input can stress destination capacity and downstream line-wrapper assumptions.

#### 5.2 Startup version banner composition
- `GROUP_AM_JMPTBL_WDISP_SPrintf` writes formatted text into `ESQ_StartupVersionBannerBuffer`.
- Inputs include mutable strings/numbers:
  - `Global_STR_GUIDE_START_VERSION_AND_BUILD` (format template)
  - `Global_STR_MAJOR_MINOR_VERSION`
  - `Global_PTR_STR_BUILD_ID`
  - `Global_LONG_BUILD_NUMBER`
  - `Global_LONG_PATCH_VERSION_NUMBER`
- The resulting buffer is rendered as a centered startup line.
- Risk implication:
  - If format/template components are expanded significantly, formatted output may exceed historical size expectations (buffer is fixed-size BSS).

#### 5.3 Raster-plane alias population (layout-coupled pointer state)
- 696x509 raster set allocated into `DATA_WDISP_BSS_LONG_221C..221E`.
- Secondary aliases seeded by fixed offset:
  - `DATA_WDISP_BSS_LONG_2224..` entries are seeded from `221C..` plus `+$5C20`.
- Later assignments copy into named runtime aliases:
  - `ESQSHARED_DisplayContextPlaneBase0..4`
  - `ESQSHARED_LivePlaneBase0..2`
- Risk implication:
  - These are pointer-topology assumptions tied to raster geometry/stride constants; edits to constants/tables can invalidate downstream blit/copy paths.

#### 5.4 Startup reset values influencing parser/checksum behavior
- Global reset block in `ESQ_MainInitAndRun` initializes:
  - `ESQIFF_UseCachedChecksumFlag` to `0`
  - `ESQ_TickModulo60Counter` to `0`
  - `ESQ_StartupStateWord2203` to `0` (semantics still unresolved)
- Risk implication:
  - String-driven parse flows depending on checksum mode or timing cadence assume these reset defaults.
  - A bad init ordering change can manifest as parser instability that looks like "string corruption".

#### 5.5 Immediate startup string renders
- Before full startup completion, `DrawCenteredWrappedTextLines` displays:
  - `DISKIO_ErrorMessageScratch`
  - `DATA_ESQ_STR_NO_DF1_PRESENT_1E0F` (conditional)
  - `Global_PTR_STR_SELECT_CODE`
  - `ESQ_StartupVersionBannerBuffer`
  - `DATA_ESQ_STR_SystemInitializing`
  - `DATA_ESQ_STR_PleaseStandByEllipsis`
  - `DATA_ESQ_STR_AttentionSystemEngineer` / `ER011` / `ER012` variants
- Risk implication:
  - These are early, high-visibility crash surfaces for malformed or overlong startup strings.

#### 5.6 Startup destination size budget (current code/data)
- `ESQ_SelectCodeBuffer` (`Global_PTR_STR_SELECT_CODE`)
  - Capacity: 10 bytes total (`DS.L 2` + `DS.W 1`) in `src/data/wdisp.s`.
  - Primary writer: argv copy loop in `ESQ_MainInitAndRun`.
  - Effective safe payload: 9 visible bytes + NUL.
  - Risk: copy loop is unbounded at callsite; long argv[1] can overrun this buffer.

- `ESQ_StartupVersionBannerBuffer`
  - Capacity: 80 bytes total (`DS.L 20`) in `src/data/wdisp.s`.
  - Writer: `WDISP_SPrintf("Ver %s.%ld Build %ld %s", ...)` in startup path.
  - Formatter behavior: `WDISP_SPrintf` does not accept output capacity.
  - Current static component lengths (from `src/data/esq.s`):
    - format literal length: 23 chars (`"Ver %s.%ld Build %ld %s"`)
    - major/minor string length: 3 (`"9.0"`)
    - build-id length: 3 (`"JGT"`)
    - patch/build values currently `4` and `21`
  - Current rendered line length estimate: 22 chars (+NUL = 23 bytes).
  - Worst-case 32-bit signed decimal budget:
    - Fixed literals = 13 chars
    - `%s` major/minor currently 3
    - `%ld` patch up to 11 chars
    - `%ld` build up to 11 chars
    - Remaining budget for final `%s` build-id = `79 - (13+3+11+11) = 41` chars
  - Practical guidance: keep build-id <= 41 chars if numeric fields may reach full 32-bit width.

- `DISKIO_ErrorMessageScratch`
  - Capacity: 41 bytes total (`DS.L 10` + `DS.B 1`) in `src/data/wdisp.s`.
  - Startup writes:
    - `ESQ_FormatDiskErrorMessage` uses `WDISP_SPrintf` with disk-error formats.
    - Fixed 40-byte longword copy from `DATA_ESQ_38_Spaces` in `ESQ_MainInitAndRun`.
  - Current format lengths (`src/data/common.s`):
    - `"Disk Errors: %ld"` = 16 chars
    - `"Disk is %ld%% full"` = 18 chars
  - Current startup space template length (`src/data/esq.s`):
    - `DATA_ESQ_38_Spaces` literal length = 39 chars (+NUL = 40 bytes)
  - Risk:
    - The fixed 40-byte copy assumes this source remains at least 40 bytes including NUL.
    - Shrinking `DATA_ESQ_38_Spaces` can pull adjacent bytes into scratch.

#### 5.7 Startup `WDISP_SPrintf` headroom audit
- Scope:
  - Immediate startup chain callsites reached from `ESQ_MainInitAndRun`
  - `ESQ_MainInitAndRun` banner formatter
  - `ESQ_FormatDiskErrorMessage` dual formatter paths

| Callsite | Destination | Capacity | Current/Practical max bytes (incl NUL) | Conservative signed-32 max bytes (incl NUL) | Conservative headroom | `<16` flag |
|---|---|---:|---:|---:|---:|---|
| `ESQ_MainInitAndRun`: `"Ver %s.%ld Build %ld %s"` | `ESQ_StartupVersionBannerBuffer` | 80 | 23 (current configured data) | 42 (with current `%s` inputs) | 38 | No |
| `ESQ_FormatDiskErrorMessage`: `"Disk Errors: %ld\\n"` | `DISKIO_ErrorMessageScratch` | 41 | 20 (if 16-bit source <=65535) | 26 | 15 | Yes |
| `ESQ_FormatDiskErrorMessage`: `"Disk is %ld%% full"` | `DISKIO_ErrorMessageScratch` | 41 | 18 (if percent source <=100) | 26 | 15 | Yes |

- Interpretation:
  - The two disk-message formatters are only low-margin under the conservative
    “full signed-32 `%ld`” assumption. Under practical source-domain bounds
    (16-bit error count / 0..100 percent), headroom is comfortable.
  - Version banner remains high-headroom with current configured `%s` inputs.

#### 5.8 Non-startup `WDISP_SPrintf` destination audit (`ED*`, `ESQFUNC`, `TEXTDISP`)
- Scope:
  - High-frequency formatter paths used by ESC editor/diagnostics and text-display
    command rendering.
  - Focused on fixed stack destinations where Section 1 string edits can amplify
    overflow risk.

| Area / Function | Destination | Capacity | Primary format(s) | Risk readout |
|---|---|---:|---|---|
| `ED1_EnterEscMenu` | `-41(A5)` | 41 | `"Ver %s.%ld"` | Low with current literals (`"9.0"` + patch number). |
| `ED1_DrawDiagnosticsScreen` | `.printfResult` (`-41(A5)`) | 41 | `"%ld baud"`, `"Disk 0 is %2ld%% full with %2ld Errors"` | Medium: second format can exceed 41 under full signed-32 `%ld` assumptions; practical inputs are usually bounded. |
| `ED1_DrawStatusLine1` | `-41(A5)` | 41 | `"SCRSPD=%d"` | Low (wide margin). |
| `ED1_DrawStatusLine2` | `-51(A5)` | 51 | `"MR=%d SBS=%d Sport=%d"`, `"Cycle=%c CycleFreq=%d AftrOrdr=%d"`, `"ClockCmd=%c"` | Medium-low: second format is near-capacity only under worst-case signed-32 `%d` assumptions. |
| `ED2_DrawEntryDetailsPanel` | `-120(A5)` | 120 | `"PI[%d] Clu_pos1=%d"`, `"Chan=%s Source=%s CallLtrs=%s"`, `"TS=%d Title='%s' Time=%s"` | Medium-high: `%s` fields are data-driven; no destination-length guard at formatter. |
| `ED2_DrawEntrySummaryPanel` | `-120(A5)` | 120 | `"CLU[%d] Clu_pos1=%d"`, `"Chan=%s Source=%s CallLtrs=%s"` | Medium-high: `%s` fields are pointer-driven and rely on upstream sanitization. |
| `ED2_HandleMenuActions` | `-50(A5)` | 50 | `"BitPlane1 =%8lx  "` | Low (fixed-width `%8lx` output). |
| `ED_DrawScrollSpeedMenuText` | `-80(A5)` | 80 | `"Satellite Delivered scroll speed (%c)"` | Low. |
| `ED_DrawCurrentColorIndicator` | `-41(A5)` | 41 | `" Current Color %02X "` | Low (byte-source `%02X`). |
| `ED_UpdateAdNumberDisplay` | `-40(A5)` | 40 | `"Ad Number %2ld"` | Low (wide margin; `%2ld` is minimum width, not max). |
| `ED_DrawAdEditingScreen` | `.printfResult` (`-41(A5)`) | 41 | `"Editing Ad Number %2ld"` | Low. |
| `ED_LoadCurrentAdIntoBuffers` | `-44(A5)` | 44 | `"Editing Ad Number %2ld"` | Low. |
| `ESQFUNC_DrawEscMenuVersion` | `-81(A5)` | 81 | `"Build Number: '%ld%s'"`, `" ROM Version: '%s'"` | Medium: build-id `%s` is pointer-driven; currently short/static. |
| `ESQFUNC_DrawMemoryStatusScreen` | `-72(A5)` | 72 | data/ctrl/memory counter lines with `%08ld`/`%03ld`/`%7ld` | Low-medium: mostly fixed-width numeric formats. |
| `ESQFUNC_DrawDiagnosticsScreen` | `-132(A5)` | 132 | long diagnostics lines with mixed `%ld/%d/%s` | Medium-high: several long templates plus `%s`; practical values usually bounded but conservative worst-case can exceed 132. |
| `TEXTDISP_BuildNowShowingStatusLine` | `-188(A5)` temp | 51 non-overlap bytes before `-137(A5)` | `%c` (+ align token) | Low at current callsite usage. |
| `TEXTDISP_BuildEntryDetailLine` | `-524(A5)` | ~512 usable bytes before `-12(A5)` temps | `%s` | Medium: large buffer, but `%s` depends on upstream trimming. |
| `TEXTDISP_HandleScriptCommand` | `-200(A5)` | 200 | `"xx%s"` | Medium: script-argument `%s` can grow without formatter-side bounds. |

- Interpretation:
  - Highest practical risk surfaces are the data-driven `%s` formatters in
    `ED2_*`, `ESQFUNC_DrawDiagnosticsScreen`, and `TEXTDISP_*`.
  - Most pure numeric ESC-status formatters remain low risk due to short/fixed-width
    templates and moderate destination capacities.
  - Conservative overflow conditions appear primarily when treating `%ld/%d` as
    unbounded full signed-32 width in templates that were authored for narrower
    runtime domains.

#### 5.9 Argument provenance + guard insertion candidates (analysis-only)
- `ED2_DrawEntryDetailsPanel` / `ED2_DrawEntrySummaryPanel`
  - `%s` provenance:
    - Entry struct field pointers at `+1`, `+12`, `+19` from `ED2_SelectedEntryDataPtr`.
    - Title pointer from `TEXTDISP_PrimaryTitlePtrTable` (`ED2_SelectedEntryTitlePtr`).
    - Sanitized slot text from `DISKIO2_CopyAndSanitizeSlotString` into 1000-byte temp.
  - Evidence:
    - `DISKIO2_CopyAndSanitizeSlotString` copies source until NUL and does not take
      an explicit destination capacity argument.
    - Entry flags at `+27` imply early fields are likely narrow/fixed-width, but not
      formatter-enforced.
  - Guard candidate points:
    - Before `Global_STR_CHAN_SOURCE_CALLLTRS_1` and `_2` format calls in `ed2.s`.
    - Before `Global_STR_TS_TITLE_TIME` format call in `ed2.s`.

- `TEXTDISP_HandleScriptCommand` (`case 'C'`)
  - `%s` provenance:
    - `A3` commonly points to `DATA_SCRIPT_BSS_LONG_2129`.
    - `DATA_SCRIPT_BSS_LONG_2129` is populated via `ESQPARS_ReplaceOwnedString`
      from `SCRIPT_CTRL_CMD_BUFFER` packet tail (`LEA 3(A2),A0` path).
  - Evidence:
    - `SCRIPT_CTRL_CMD_BUFFER` is 200 bytes (`DS.L 50`).
    - Parser passes `SCRIPT_CTRL_READ_INDEX` as command packet length into
      `SCRIPT_HandleBrushCommand`.
  - Guard candidate points:
    - Before `"xx%s"` in `TEXTDISP_HandleScriptCommand` (`textdisp.s`), clamp/copy
      to a bounded temp (`<=196` bytes payload + `"xx"` + NUL) before formatting.
    - Optional upstream guard in CTRL parser on `SCRIPT_CTRL_READ_INDEX` growth.

- `ESQFUNC_DrawDiagnosticsScreen`
  - `%s` provenance:
    - `%s` arguments are selected from fixed static literals/tables
      (`ON_AIR/OFF_AIR/NO_DETECT`, `OPEN/CLOSED`, `TRUE/FALSE`, `AM/PM`,
      insertion-mode labels).
  - Interpretation:
    - This routine’s practical overflow risk is dominated by long numeric rows,
      not by attacker-controlled `%s` input.
  - Guard candidate points:
    - Preflight formatted length (analysis hook) for the longest numeric templates
      before writing to `-132(A5)` if behavior changes become acceptable.

#### 5.10 `ESQFUNC_DrawDiagnosticsScreen` row-by-row byte budget (`-132(A5)`)
- Destination capacity:
  - `-132(A5)` = 132 bytes total (including trailing NUL).
- Budget model:
  - Conservative numeric width: `%ld`/`%d` => up to 11 chars.
  - `%04X` treated conservatively as up to 8 hex digits.
  - `%s` widths use actual static literal sets used at each callsite.

| Callsite format | Conservative max bytes incl NUL | Margin vs 132 | Priority |
|---|---:|---:|---|
| `DATA_ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L_1EC2` | 156 | -24 | `P0` |
| `DATA_ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC_1EC3` | 146 | -14 | `P1` |
| `DATA_ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS_1EC9` | 142 | -10 | `P2` |
| `DATA_ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC8` | 110 | +22 | monitor |
| `DATA_ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR_1EC7` | 109 | +23 | monitor |
| `DATA_ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT_1EC6` | 56 | +76 | low |
| `DATA_ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X_1EC1` | 62 | +70 | low |
| `DATA_ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT_1EB7` | 85 | +47 | low |

- Practical interpretation:
  - The top three rows (`P0`..`P2`) are the only ones that cross the 132-byte
    destination under conservative expansion assumptions.
  - `%s` in this function is mostly static-literal sourced; ranking is dominated
    by numeric-field expansion, not mutable string pointers.
- Guard-first order (if behavior changes later become acceptable):
  1. `DATA_ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L_1EC2`
  2. `DATA_ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC_1EC3`
  3. `DATA_ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS_1EC9`

#### 5.11 `ESQFUNC_DrawDiagnosticsScreen` (`P0`..`P2`) source-population map
- Scope:
  - Trace each high-priority formatter row argument back to its primary writer path(s)
    so a future guard can be placed where fan-in is highest.
  - All findings are behavior-preserving annotations only (no runtime guard inserted yet).

- `P0` row: `DATA_ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L_1EC2`
  - Destination: `-132(A5)` (132 bytes total).
  - Arguments at callsite:
    - `TEXTDISP_DeferredActionCountdown`
    - `TEXTDISP_DeferredActionArmed`
    - `LOCAVAIL_FilterModeFlag`
    - `LOCAVAIL_FilterStep`
    - `LOCAVAIL_FilterClassId`
    - `LOCAVAIL_PrimaryFilterState_Field08` (legacy `DATA_WDISP_BSS_LONG_2322`)
    - `LOCAVAIL_PrimaryFilterState_Field0C` (legacy `DATA_WDISP_BSS_LONG_2323`)
  - Primary population paths:
    - Deferred-action pair is armed to `(3,1)` in:
      - `src/modules/groups/b/a/script3.s` (`playback_cmd_case_enter_mode2_defer`)
      - `src/modules/groups/a/k/ed2.s` (transition cases that schedule refresh)
    - Deferred countdown is decremented in:
      - `src/modules/groups/b/a/textdisp2.s` (`TEXTDISP_TickDisplayState`)
    - Filter mode/step/class are state-machine outputs from:
      - `src/modules/groups/a/y/locavail.s` (`LOCAVAIL_SetFilterModeAndResetState`, `LOCAVAIL_UpdateFilterStateMachine`)
    - `Field08/Field0C` are layout-coupled longs inside `LOCAVAIL_PrimaryFilterState`;
      direct symbolic writers are sparse/indirect and remain partially unresolved.
  - Guard probe candidate:
    - Capture `WDISP_SPrintf` return length at this callsite first (`P0`) and compare
      against `131` before draw call (analysis-only hook first).

- `P1` row: `DATA_ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC_1EC3`
  - Destination: `-132(A5)` (132 bytes total).
  - Arguments at callsite:
    - `CLOCK_CacheMonthIndex0` / `CLOCK_CacheDayIndex0` / `CLOCK_CacheYear`
    - `CLOCK_CacheHour` / `CLOCK_CacheMinuteOrSecond`
    - `Global_REF_CLOCKDATA_STRUCT`
    - `CLOCK_CacheAmPmFlag` (`am`/`pm` suffix selector)
    - `LOCAVAIL_FilterCooldownTicks` (legacy `DATA_WDISP_BSS_LONG_2325`)
  - Primary population paths:
    - Clock cache fields are normalized by:
      - `src/modules/groups/b/a/parseini2.s` (`PARSEINI_NormalizeClockData` via RTC read/update path)
    - AM/PM flag is consumed as `0 => AM`, non-zero (typically `-1`) => PM in:
      - `PARSEINI_AdjustHoursTo24HrFormat`
      - `ESQFUNC_DrawDiagnosticsScreen`
      - `FLIB_AppendClockStampedLogEntry`
    - `LOCAVAIL_FilterCooldownTicks` is:
      - seeded from filter state progression in `locavail.s`
      - boosted/advanced in `cleanup2.s`
      - decremented in `app2.s` tick logic
  - Guard probe candidate:
    - Same return-length probe pattern at this callsite (`P1`) after `P0`.

- `P2` row: `DATA_ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS_1EC9`
  - Destination: `-132(A5)` (132 bytes total).
  - Arguments at callsite:
    - `DATA_ESQFUNC_BSS_LONG_1EB1` (local diagnostics counter)
    - `Global_RefreshTickCounter`
    - `Global_STR_TRUE_2`/`Global_STR_FALSE_2` (`%s`)
    - `DATA_SCRIPT_BSS_WORD_211C`
    - `ED_MenuStateId`
  - Primary population paths:
    - `DATA_ESQFUNC_BSS_LONG_1EB1` increments once per diagnostics draw.
    - `DATA_SCRIPT_BSS_WORD_211C` increments in script playback dispatch path
      (`src/modules/groups/b/a/script3.s` default increment branch).
    - `ED_MenuStateId` is a byte state id assigned across `ED*` handlers.
  - Guard probe candidate:
    - Third return-length probe location (`P2`) after `P0/P1` coverage.

- Practical ordering note:
  - `P0` has the widest argument fan-in and the highest conservative overrun margin.
  - `P1` is clock-domain heavy but mostly bounded by normalized date/time fields.
  - `P2` is mostly counter-driven; `%s` remains static `TRUE/FALSE`.

#### 5.12 `ED2` / `TEXTDISP` high-risk `%s` rows (budget + source map)
- Scope:
  - Expand row-level budget/provenance mapping for non-`ESQFUNC` `%s` formatters
    that were flagged as medium/high risk in section `5.8`.
  - Keep this pass behavior-preserving (annotation-only).

- Destination capacities:
  - `ED2_DrawEntryDetailsPanel` / `ED2_DrawEntrySummaryPanel`: `.panelTextBuffer = -120(A5)` (120 bytes incl NUL).
  - `TEXTDISP_HandleScriptCommand`: `.commandScratchBuffer = -200(A5)` (200 bytes incl NUL).
  - `TEXTDISP_BuildEntryDetailLine`: large scratch at `-524(A5)` (~512 bytes before temp slots).

| Area / format row | Conservative byte model (incl NUL) | Capacity | Margin expression | Priority |
|---|---:|---:|---|---|
| `ED2` details/summary: `"Chan=%s Source=%s CallLtrs=%s"` (`Global_STR_CHAN_SOURCE_CALLLTRS_1/_2`) | `24 + len(chan)+len(source)+len(callltrs)` | 120 | payload safe iff combined `%s` <= 96 | `E1` |
| `ED2` details: `"TS=%d Title='%s' Time=%s"` (`Global_STR_TS_TITLE_TIME`) | `30 + len(title)+len(time)` (conservative `%d` = 11 chars) | 120 | payload safe iff `len(title)+len(time) <= 90` | `E0` |
| `TEXTDISP` cmd C: `"xx%s"` (`DATA_SCRIPT_FMT_XX_PCT_S_214C`) | `3 + len(arg)` | 200 | payload safe iff `len(arg) <= 197` | `T0` |
| `TEXTDISP` detail build: align-prefix + `%s` (`DATA_SCRIPT_FMT_PCT_S_213F`) | small prefix + `len(entry_substring)` | ~512 | monitor; source must stay well below ~510 | monitor |

- Primary source-population paths:
  - `ED2` `Chan/Source/CallLtrs` rows:
    - `%s` pointers come from `ED2_SelectedEntryDataPtr` struct-like offsets
      (`+1`, `+12`, `+19`) and fallback `"NULL"` tags.
    - Selection pointer is loaded from `TEXTDISP_PrimaryEntryPtrTable`.
  - `ED2` `TS/Title/Time` row:
    - `title` `%s` comes from `DISKIO2_CopyAndSanitizeSlotString` output
      (1000-byte temp allocation path) or `"NULL"` fallback.
    - `time` `%s` comes from `TEXTDISP_FormatEntryTimeForIndex` local output.
  - `TEXTDISP` cmd C (`"xx%s"`):
    - Arg pointer is usually `SCRIPT_CommandTextPtr`
      (legacy `DATA_SCRIPT_BSS_LONG_2129`), replaced via `ESQPARS_ReplaceOwnedString`.
    - Common producer path is `SCRIPT_HandleBrushCommand` tail (`LEA 3(A2),A0`)
      after parser NUL-termination.
    - CTRL parser enforces `SCRIPT_CTRL_READ_INDEX <= 198` before dispatch in
      normal packet flow, keeping typical arg lengths below destination limits.
  - `TEXTDISP_BuildEntryDetailLine` `%s` copy row:
    - Source pointer is selected from entry aux table (`56(A0,index*4)`),
      then passed through control-skip logic before formatting.

- Guard-first order (if behavior changes later become acceptable):
  1. `E0`: `Global_STR_TS_TITLE_TIME` (`ED2_DrawEntryDetailsPanel`)
  2. `E1`: `Global_STR_CHAN_SOURCE_CALLLTRS_1/_2` (`ED2` details + summary)
  3. `T0`: `DATA_SCRIPT_FMT_XX_PCT_S_214C` (`TEXTDISP_HandleScriptCommand`)
  4. monitor: `DATA_SCRIPT_FMT_PCT_S_213F` (`TEXTDISP_BuildEntryDetailLine`)

#### 5.13 `WDISP` `220F+` alias pass (layout-coupled pointer state)
- Scope:
  - Continue conservative naming in `src/data/wdisp.s` beyond the earlier
    editor/system cluster, focusing on serial/raster pointer topology used by
    startup and cleanup paths.
  - Propagate aliases at callsites only (no opcode/flow changes).

- Aliases added (high-confidence):
  - Serial startup/teardown:
    - `WDISP_SerialIoRequestPtr` (legacy `LAB_2211_SERIAL_PORT_MAYBE`)
    - `WDISP_SerialMessagePortPtr` (legacy `DATA_WDISP_BSS_LONG_2212`)
  - Raster pointer tables / bitmap-linked plane pointers:
    - `WDISP_352x240RasterPtrTable` (`221A` cluster)
    - `WDISP_BannerRowScratchRasterTable0..2` (`221C..221E`)
    - `WDISP_BannerGridBitmapStruct` (`221F` start)
    - `WDISP_LivePlaneRasterTable0..2` (`2220..2222`)
    - `WDISP_DisplayContextPlanePointer0..4` (`2224..2228`)
  - Highlight/task patch state:
    - `WDISP_HighlightBufferMode` (`222A`)
    - `WDISP_HighlightRasterHeightPx` (`222B`)
    - `WDISP_ExecBaseHookPtr` (`222C`)
  - Pointer-table boundary marker:
    - `TEXTDISP_SecondaryEntryPtrTablePreSlot` (`2234`)

- Callsite propagation completed in:
  - `src/modules/groups/a/m/esq.s`
  - `src/modules/groups/a/b/cleanup.s`
  - `src/modules/groups/a/n/esqdisp.s`
  - `src/modules/groups/a/u/gcommand3.s`
  - `src/modules/groups/b/a/newgrid.s`
  - `src/modules/groups/b/a/tliba3.s`

- Deferred/unresolved:
  - `WDISP_ReservedLong220F` remains explicitly unresolved/reserved (`??`).

#### 5.14 `WDISP` `2242`-`226F` alias pass (status/banner/refresh state)
- Scope:
  - Continue conservative naming across the next unresolved `wdisp` span after
    the serial/raster cluster, focusing on status/banner string buffers, ad-edit
    pointer anchors, banner index math, and NEWGRID/cleanup gate flags.
  - Keep opcode flow unchanged; only alias/annotation + callsite propagation.

- Aliases added (high-confidence / medium-confidence):
  - Status/banner buffers:
    - `WDISP_WeatherStatusLabelBuffer` (`2245`)
    - `WDISP_StatusListMatchPattern` (`2246`)
  - Diagnostics/calendar display fields:
    - `WDISP_BannerSlotCursor` (`2242`)
    - `ESQFUNC_CListLinePointer` (`2244`)
  - ED/banner state:
    - `ED_AdRecordPtrTable` (`2250`)
    - `WDISP_BannerCharIndex` (`2257`)
    - `WDISP_BannerCharPhaseShift` (`225C`)
    - `WDISP_BannerCharRangeStart` (`226F`)
  - Refresh/tick gates:
    - `NEWGRID_MessagePumpSuspendFlag` (`2260`)
    - `NEWGRID_ModeSelectorState` (`2261`)
    - `NEWGRID_LastRefreshRequest` (`2262`)
    - `CLEANUP_PendingAlertFlag` (`2264`)
    - `PARSEINI_CtrlHChangeGateFlag` (`2266`)
  - Scratch raster bases:
    - `ESQSHARED_BannerRowScratchRasterBase0..2` (`2267`-`2269`)

- Explicitly kept unresolved (documented in-place with `??` notes):
  - `DATA_WDISP_BSS_WORD_2255`
  - `DATA_WDISP_BSS_WORD_2256`
  - `DATA_WDISP_BSS_WORD_225D`
  - `DATA_WDISP_BSS_LONG_225E`
  - `DATA_WDISP_BSS_WORD_226D`
  - `DATA_WDISP_BSS_LONG_226E`

- Callsite propagation completed in:
  - `src/modules/groups/a/a/app2.s`
  - `src/modules/groups/a/c/cleanup2.s`
  - `src/modules/groups/a/h/diskio2.s`
  - `src/modules/groups/a/j/dst2.s`
  - `src/modules/groups/a/k/ed1.s`
  - `src/modules/groups/a/k/ed2.s`
  - `src/modules/groups/a/l/ed3.s`
  - `src/modules/groups/a/m/esq.s`
  - `src/modules/groups/a/n/esqdisp.s`
  - `src/modules/groups/a/n/esqfunc.s`
  - `src/modules/groups/a/q/esqshared4.s`
  - `src/modules/groups/b/a/newgrid1.s`
  - `src/modules/groups/b/a/parseini3.s`
  - `src/modules/submodules/unknown.s`

#### 5.15 Producer trace: `226D` / `226E` unresolved fields
- Scope:
  - Trace concrete writer paths for `DATA_WDISP_BSS_WORD_226D` and
    `DATA_WDISP_BSS_LONG_226E` before attempting further naming.

- Direct writers (confirmed):
  - `DATA_WDISP_BSS_WORD_226D`
    - Only direct writer found: `CLR.W DATA_WDISP_BSS_WORD_226D` in
      `src/modules/groups/a/k/ed1.s` (`ED1_ExitEscMenu` path).
  - `DATA_WDISP_BSS_LONG_226E`
    - No direct writers found in current tree.
    - Only observed use is read/compare in `ED_InitRastport2Pens`
      (`src/modules/groups/a/l/ed3.s`), where it is compared to literal `14`.

- Indirect producer path (layout-coupled overflow):
  - `ESQ_MainInitAndRun` copies `argv[1]` into `ESQ_SelectCodeBuffer`
    using a byte loop with no destination bound check:
    - `src/modules/groups/a/m/esq.s` (`.copy_select_code_loop`)
  - `src/data/wdisp.s` layout adjacency:
    - `ESQ_SelectCodeBuffer` (10 bytes)
    - immediately followed by `Global_REF_BAUD_RATE` (4 bytes)
    - then `DATA_WDISP_BSS_WORD_226D` (2 bytes)
    - then `DATA_WDISP_BSS_LONG_226E` (4 bytes)
  - Spill thresholds from start of copied payload:
    - byte `10+` clobbers `Global_REF_BAUD_RATE`
    - byte `14+` clobbers `DATA_WDISP_BSS_WORD_226D`
    - byte `16+` clobbers `DATA_WDISP_BSS_LONG_226E`

- Decision:
  - Keep both `226D` and `226E` unresolved for now (`??`) because intended
    semantic producers are still unknown.
  - Record the `argv[1]` overflow as the only high-confidence non-semantic
    producer currently identified.

## Crash-Relevant Notes
- Legacy anchor indexing (`LEA anchor + index*4`) is sensitive to nearby string-layout edits.
- Mplex/PPV parse tails split on byte `$12`; malformed edits around that delimiter change template merge behavior.
- `ESQPARS_ReplaceOwnedString` can return NULL; callers that assume non-NULL are potential crash sites under memory pressure or empty-tail inputs.
- `ESQ_MainInitAndRun` performs several startup string copy/format operations with fixed destinations and no obvious explicit bounds checks at the callsite level.

## Behavior-Preserving Hardening Added In This Batch
- Added explicit alias/docs for `SCRIPT_ChannelLabelLegacyIndexAnchor`.
- Added explicit alias/docs for `SCRIPT_ChannelLabelEmptySlot0..3`.
- Added conservative `wdisp.s` `220F+` pointer-state aliases and propagated key callsites (`ESQ`/`CLEANUP`/`ESQDISP`/`GCOMMAND3`/`NEWGRID`/`TLIBA3`).
- Added conservative `wdisp.s` `2242`-`226F` aliases for status/banner/refresh state and propagated callsites (`APP2`/`CLEANUP2`/`DST2`/`ESQ*`/`ED*`/`NEWGRID1`/`PARSEINI3`/`UNKNOWN`).
- Tightened function docs for:
  - `ESQPARS_ReplaceOwnedString`
  - `FLIB2_*` template default/reset loaders
  - `GCOMMAND_*` template parse append paths

## Next Investigation Targets
1. Identify all callsites that dereference `GCOMMAND_*TemplatePtr` without a NULL guard.
2. Catalog additional layout-coupled anchor expressions beyond current `SCRIPT/ESQFUNC/CTASKS` set.
3. If behavior changes become acceptable, add guarded fallback strings at key dereference sites.
4. Add a lightweight validation hook (analysis-only first) that logs formatted length
   returns from critical `WDISP_SPrintf` startup calls versus destination capacities.
5. Extend row-level budget/provenance mapping beyond `ESQFUNC` into remaining
   high-risk `%s` destinations (`ED2_*` and `TEXTDISP_*`) so guard-priority
   ordering is explicit in those paths too.

## Follow-up
- The dereference audit requested in target (1) is now captured in `CHECKPOINT_templateptr_guard_audit.md`.
