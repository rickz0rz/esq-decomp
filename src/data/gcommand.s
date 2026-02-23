; ========== GCOMMAND.c ==========

GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_DefaultTable:
    NStr    "DF0:Digital_Niche.dat"
Global_STR_GCOMMAND_C_1:
    NStr    "GCOMMAND.c"
GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_CommandFile:
    NStr    "DF0:Digital_Niche.dat"
;------------------------------------------------------------------------------
; SYM: GCOMMAND_NicheParseScratchSeedWord   (niche option-parse scratch seed word)
; TYPE: u16 (used as first half of a 4-byte seed copy)
; PURPOSE: Seed word copied into local parse scratch before reading niche option flags.
; USED BY: GCOMMAND_ParseCommandOptions
; NOTES:
;   Callsite copies 4 bytes starting at this symbol into `-12(A5)..-9(A5)` before
;   parsing (`MOVE.B (A0)+` x4). Bytes 2..3 are layout-coupled with immediately
;   following data and should be treated as legacy parse seeding behavior.
;------------------------------------------------------------------------------
GCOMMAND_NicheParseScratchSeedWord:
    DS.W    1
GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateLoad:
    NStr    "DF0:Digital_Mplex.dat"
Global_STR_GCOMMAND_C_2:
    NStr    "GCOMMAND.c"
GCOMMAND_FMT_PCT_T_MplexTemplateLoad:
    NStr    "%T"
GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_TemplateSave:
    NStr    "DF0:Digital_Mplex.dat"
;------------------------------------------------------------------------------
; SYM: GCOMMAND_MplexTemplateFieldSeparatorByteStorage/GCOMMAND_PpvTemplateFieldSeparatorByteStorage   (template field separator byte storage)
; TYPE: u32/u32 (first byte used)
; PURPOSE: Backing storage for one-byte separator written between two serialized template strings.
; USED BY: GCOMMAND_LoadMplexFile, GCOMMAND_LoadPPVTemplate
; NOTES:
;   Callers pass `count=1` to WriteBufferedBytes, so only the first byte (`0x12`)
;   is emitted; remaining bytes are padding/legacy storage.
;------------------------------------------------------------------------------
GCOMMAND_MplexTemplateFieldSeparatorByteStorage:
    DC.L    $12001200
;------------------------------------------------------------------------------
; SYM: GCOMMAND_MplexParseScratchSeedWord   (mplex option-parse scratch seed word)
; TYPE: u16 (used as first half of a 4-byte seed copy)
; PURPOSE: Seed word copied into local parse scratch before reading mplex option flags.
; USED BY: GCOMMAND_ParseCommandString
; NOTES:
;   Callsite copies 4 bytes starting at this symbol into `-12(A5)..-9(A5)` before
;   parsing (`MOVE.B (A0)+` x4). Bytes 2..3 are layout-coupled with immediately
;   following data and should be treated as legacy parse seeding behavior.
;------------------------------------------------------------------------------
GCOMMAND_MplexParseScratchSeedWord:
    DS.W    1
GCOMMAND_FMT_PCT_T_MplexTemplateParse:
    NStr    "%T"
GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplatePrimaryLoad:
    NStr    "DF0:Digital_PPV3.dat"
GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackLoad:
    NStr    "DF0:Digital_PPV.dat"
GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_TemplateFallbackDelete:
    NStr    "DF0:Digital_PPV.dat"
Global_STR_GCOMMAND_C_3:
    NStr    "GCOMMAND.c"
GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_TemplateSave:
    NStr    "DF0:Digital_PPV3.dat"
GCOMMAND_PpvTemplateFieldSeparatorByteStorage:
    DC.L    $12001200
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PpvParseScratchSeedLong   (ppv option-parse scratch seed long)
; TYPE: u32 seed + trailing u32 list (legacy/unresolved)
; PURPOSE: 4-byte seed copied into local parse scratch before PPV option parsing.
; USED BY: GCOMMAND_ParsePPVCommand
; NOTES:
;   Callsite copies 4 bytes starting at this symbol into `-12(A5)..-9(A5)` before
;   parsing (`MOVE.B (A0)+` x4).
;   The following longword list is contiguous legacy data with no direct symbolic
;   references yet; keep together until a confirmed reader is traced.
;------------------------------------------------------------------------------
GCOMMAND_PpvParseScratchSeedLong:
    DC.L    $00000000
    DC.L    $00000067,$00000069,$00000072,$00000073
    DC.L    $00000074,$00000075,$00000076,$00000077
    DC.L    $00000078,$00000079,$0000007a,$000000c9
    DC.L    $000000ca,$000000cb,$000000cc,$000000cd
    DC.L    $000000ce,$000000cf,$000000d1,$000000d2
    DC.L    $000000d3,$000000d4,$000000d5,$000000d6
    DC.L    $000000d7,$000000d8,$000000d9,$000000da
    DC.L    $000000db,$000000dc,$000000dd,$000000de
    DC.L    $000000df,$000000e0,$000000e1,$000000e2
    DC.L    $000000e8,$ffffffff
GCOMMAND_STR_NO_FREE_STORE:
    NStr    "NO_FREE_STORE"
GCOMMAND_STR_TASK_TABLE_FULL:
    NStr    "TASK_TABLE_FULL"
GCOMMAND_STR_BAD_TEMPLATE:
    NStr    "BAD_TEMPLATE"
GCOMMAND_STR_BAD_NUMBER:
    NStr    "BAD_NUMBER"
GCOMMAND_STR_REQUIRED_ARG_MISSING:
    NStr    "REQUIRED_ARG_MISSING"
GCOMMAND_STR_KEY_NEEDS_ARG:
    NStr    "KEY_NEEDS_ARG"
GCOMMAND_STR_TOO_MANY_ARGS:
    NStr    "TOO_MANY_ARGS"
GCOMMAND_STR_UNMATCHED_QUOTES:
    NStr    "UNMATCHED_QUOTES"
GCOMMAND_STR_LINE_TOO_LONG:
    NStr    "LINE_TOO_LONG"
GCOMMAND_STR_FILE_NOT_OBJECT:
    NStr    "FILE_NOT_OBJECT"
GCOMMAND_STR_INVALID_RESIDENT_LIBRARY:
    NStr    "INVALID_RESIDENT_LIBRARY"
GCOMMAND_STR_NO_DEFAULT_DIR:
    NStr    "NO_DEFAULT_DIR"
GCOMMAND_STR_OBJECT_IN_USE:
    NStr    "OBJECT_IN_USE"
GCOMMAND_STR_OBJECT_EXISTS:
    NStr    "OBJECT_EXISTS"
GCOMMAND_STR_DIR_NOT_FOUND:
    NStr    "DIR_NOT_FOUND"
GCOMMAND_STR_OBJECT_NOT_FOUND:
    NStr    "OBJECT_NOT_FOUND"
GCOMMAND_STR_BAD_STREAM_NAME:
    NStr    "BAD_STREAM_NAME"
GCOMMAND_STR_OBJECT_TOO_LARGE:
    NStr    "OBJECT_TOO_LARGE"
GCOMMAND_STR_ACTION_NOT_KNOWN:
    NStr    "ACTION_NOT_KNOWN"
GCOMMAND_STR_INVALID_COMPONENT_NAME:
    NStr    "INVALID_COMPONENT_NAME"
GCOMMAND_STR_INVALID_LOCK:
    NStr    "INVALID_LOCK"
GCOMMAND_STR_OBJECT_WRONG_TYPE:
    NStr    "OBJECT_WRONG_TYPE"
GCOMMAND_STR_DISK_NOT_VALIDATED:
    NStr    "DISK_NOT_VALIDATED"
GCOMMAND_STR_DISK_WRITE_PROTECTED:
    NStr    "DISK_WRITE_PROTECTED"
GCOMMAND_STR_RENAME_ACROSS_DEVICES:
    NStr    "RENAME_ACROSS_DEVICES"
GCOMMAND_STR_DIRECTORY_NOT_EMPTY:
    NStr    "DIRECTORY_NOT_EMPTY"
GCOMMAND_STR_TOO_MANY_LEVELS:
    NStr    "TOO_MANY_LEVELS"
GCOMMAND_STR_DEVICE_NOT_MOUNTED:
    NStr    "DEVICE_NOT_MOUNTED"
GCOMMAND_STR_SEEK_ERROR:
    NStr    "SEEK_ERROR"
GCOMMAND_STR_COMMENT_TOO_BIG:
    NStr    "COMMENT_TOO_BIG"
GCOMMAND_STR_DISK_FULL:
    NStr    "DISK_FULL"
GCOMMAND_STR_DELETE_PROTECTED:
    NStr    "DELETE_PROTECTED"
GCOMMAND_STR_WRITE_PROTECTED:
    NStr    "WRITE_PROTECTED"
GCOMMAND_STR_READ_PROTECTED:
    NStr    "READ_PROTECTED"
GCOMMAND_STR_NOT_A_DOS_DISK:
    NStr    "NOT_A_DOS_DISK"
GCOMMAND_STR_NO_DISK:
    NStr    "NO_DISK"
GCOMMAND_STR_NO_MORE_ENTRIES:
    NStr    "NO_MORE_ENTRIES"
GCOMMAND_STR_UNKNOWN:
    NStr    "UNKNOWN!"

    DC.L    GCOMMAND_STR_NO_FREE_STORE
    DC.L    GCOMMAND_STR_TASK_TABLE_FULL
    DC.L    GCOMMAND_STR_BAD_TEMPLATE
    DC.L    GCOMMAND_STR_BAD_NUMBER
    DC.L    GCOMMAND_STR_REQUIRED_ARG_MISSING
    DC.L    GCOMMAND_STR_KEY_NEEDS_ARG
    DC.L    GCOMMAND_STR_TOO_MANY_ARGS
    DC.L    GCOMMAND_STR_UNMATCHED_QUOTES
    DC.L    GCOMMAND_STR_LINE_TOO_LONG
    DC.L    GCOMMAND_STR_FILE_NOT_OBJECT
    DC.L    GCOMMAND_STR_INVALID_RESIDENT_LIBRARY
    DC.L    GCOMMAND_STR_NO_DEFAULT_DIR
    DC.L    GCOMMAND_STR_OBJECT_IN_USE
    DC.L    GCOMMAND_STR_OBJECT_EXISTS
    DC.L    GCOMMAND_STR_DIR_NOT_FOUND
    DC.L    GCOMMAND_STR_OBJECT_NOT_FOUND
    DC.L    GCOMMAND_STR_BAD_STREAM_NAME
    DC.L    GCOMMAND_STR_OBJECT_TOO_LARGE
    DC.L    GCOMMAND_STR_ACTION_NOT_KNOWN
    DC.L    GCOMMAND_STR_INVALID_COMPONENT_NAME
    DC.L    GCOMMAND_STR_INVALID_LOCK
    DC.L    GCOMMAND_STR_OBJECT_WRONG_TYPE
    DC.L    GCOMMAND_STR_DISK_NOT_VALIDATED
    DC.L    GCOMMAND_STR_DISK_WRITE_PROTECTED
    DC.L    GCOMMAND_STR_RENAME_ACROSS_DEVICES
    DC.L    GCOMMAND_STR_DIRECTORY_NOT_EMPTY
    DC.L    GCOMMAND_STR_TOO_MANY_LEVELS
    DC.L    GCOMMAND_STR_DEVICE_NOT_MOUNTED
    DC.L    GCOMMAND_STR_SEEK_ERROR
    DC.L    GCOMMAND_STR_COMMENT_TOO_BIG
    DC.L    GCOMMAND_STR_DISK_FULL
    DC.L    GCOMMAND_STR_DELETE_PROTECTED
    DC.L    GCOMMAND_STR_WRITE_PROTECTED
    DC.L    GCOMMAND_STR_READ_PROTECTED
    DC.L    GCOMMAND_STR_NOT_A_DOS_DISK
    DC.L    GCOMMAND_STR_NO_DISK
    DC.L    GCOMMAND_STR_NO_MORE_ENTRIES
    DC.L    GCOMMAND_STR_UNKNOWN

GCOMMAND_PATH_GFX_COLON:
    NStr    "GFX:"
GCOMMAND_STR_WORK_COLON:
    NStr    "WORK:"
GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS:
    NStr    "COPY >NIL: GFX:LOGO.LST DH2: CLONE"
GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON_:
    NStr    "COPY >NIL: GFX:#? WORK: CLONE ALL"
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PresetSeedPackedWordTable   (preset seed packed-word table)
; TYPE: u16 stream (packed in mixed DC.L/DS.* form)
; PURPOSE: Seed data for GCOMMAND_InitPresetTableFromPalette.
; USED BY: GCOMMAND_InitPresetTableFromPalette
; NOTES:
;   Access pattern is word-based, using source offset `(row * 62) + (col * 2)`.
;   Initializer currently consumes rows 0..15 and cols 0..15 (first 16 words/row).
;   Total size is 992 bytes (`16 * 62`), i.e. 496 words / 248 longs.
;------------------------------------------------------------------------------
GCOMMAND_PresetSeedPackedWordTable_RowCount        = 16
GCOMMAND_PresetSeedPackedWordTable_RowStrideBytes  = 62
GCOMMAND_PresetSeedPackedWordTable_Size            = 992
GCOMMAND_PresetSeedPackedWordTable:
    DC.L    $00030000
    DS.L    14
    DC.L    $00000aaa
    DS.L    15
    DC.L    $01110000
    DS.L    14
    DC.L    $00000cc0
    DS.L    15
    DC.L    $05120512,$04000500,$06000700,$08000900
    DC.L    $0a000b00,$0b110b22,$0b330b44,$0b550b66
    DC.L    $0b770f44,$0f550f66,$0f770f88,$0f990faa
    DC.L    $0fbb0fcc,$0fdd0fff,$01000200,$0300016a
    DC.L    $016a0075,$00860187,$01970298,$03a903ba
    DC.L    $04bb05cc,$06cc07dd,$08de09de,$0aef0f0f
    DC.L    $0f1f0f2f,$0f3f0f4f,$0f5f0f6f,$0f7f0f8f
    DC.L    $0f9f0faf,$0fbf0fcf,$0fdf0fff,$05550555
    DC.L    $01010202,$03030404,$05050606,$07070808
    DC.L    $09090a0a,$0b0b0c0c,$0d0d0e0e,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0003,$00030116
    DC.L    $01170118,$0119011a,$011b011c,$011d011e
    DC.L    $011f022f,$033f044f,$055f066f,$066f077f
    DC.L    $088f099f,$0aaf0bbf,$0ccf0ddf,$0fff0001
    DC.L    $00020003,$00040005
    DS.L    1
    DC.L    $04140515,$06260727,$08280929,$09390a3a
    DC.L    $0b3b0b3c,$0b4c0b4d,$0b5d0b5e,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
    DS.L    1
    DC.L    $01200131,$01410252,$02620373,$04840594
    DC.L    $05950696,$07a708b8,$09b90aca,$0f0f0f1f
    DC.L    $0f2f0f3f,$0f4f0f5f,$0f6f0f7f,$0f8f0f9f
    DC.L    $0faf0fbf,$0fcf0fdf,$0fff0000,$00000120
    DC.L    $01310141,$02520262,$03730484,$05940595
    DC.L    $069607a7,$08b809b9,$0aca0f0f,$0f1f0f2f
    DC.L    $0f3f0f4f,$0f5f0f6f,$0f7f0f8f,$0f9f0faf
    DC.L    $0fbf0fcf,$0fdf0fff
;------------------------------------------------------------------------------
; SYM: GCOMMAND_PresetWorkResetPendingFlag   (preset-work reset pending flag)
; TYPE: u16 flag
; PURPOSE: Requests one-time reset of preset work entries before active highlight message tick.
; USED BY: GCOMMAND_ValidatePresetTable, GCOMMAND_ResetPresetWorkTables, GCOMMAND_ServiceHighlightMessages
; NOTES:
;   Set when preset defaults are copied/validated and cleared by GCOMMAND_ResetPresetWorkTables.
;------------------------------------------------------------------------------
GCOMMAND_PresetWorkResetPendingFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerRebuildPendingFlag   (banner rebuild pending flag)
; TYPE: u16 flag
; PURPOSE: Defers banner-table rebuild until the next highlight tick.
; USED BY: GCOMMAND_UpdateBannerBounds, GCOMMAND_RebuildBannerTablesFromBounds, GCOMMAND_TickHighlightState
; NOTES:
;   Set after bounds/step updates, consumed then cleared by rebuild path.
;------------------------------------------------------------------------------
GCOMMAND_BannerRebuildPendingFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerRowFallbackOnFirstRowFlag   (first-row fallback toggle)
; TYPE: u16 flag
; PURPOSE: Toggles alternate row-0 write behavior in banner-row builder.
; USED BY: GCOMMAND_BuildBannerRow, ED2 command toggle path
; NOTES:
;   When set and computed row index <= 0, builder follows `.write_defaults` path.
;   Exact visual intent remains uncertain (`??`) but behavior is trace-confirmed.
;------------------------------------------------------------------------------
GCOMMAND_BannerRowFallbackOnFirstRowFlag:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_ActiveHighlightMsgPtr   (active highlight message node)
; TYPE: pointer (Exec message)
; PURPOSE: Holds the current in-flight highlight message while countdown/tick logic runs.
; USED BY: GCOMMAND_ServiceHighlightMessages, GCOMMAND_ResetHighlightMessages
; NOTES: Null when no message is active; replied and cleared when countdown reaches zero.
;------------------------------------------------------------------------------
GCOMMAND_ActiveHighlightMsgPtr:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerRowByteOffsetResetValue   (banner row-byte offset reset seed)
; TYPE: u32 scalar
; PURPOSE: Initial/reset byte offset for banner row fetches.
; USED BY: GCOMMAND_BuildBannerTables, GCOMMAND_TickHighlightState
; NOTES:
;   Value is $00001760 (5984 decimal), loaded whenever the 98-step banner ring wraps.
;   Not a table; this is a single longword constant.
;------------------------------------------------------------------------------
GCOMMAND_BannerRowByteOffsetResetValueDefault = 5984
GCOMMAND_BannerRowByteOffsetResetValue:
    DC.L    GCOMMAND_BannerRowByteOffsetResetValueDefault
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerPhaseIndexCurrent   (banner phase/ring index)
; TYPE: u32 scalar
; PURPOSE: Tracks the current phase index for banner row generation.
; USED BY: GCOMMAND_BuildBannerTables, GCOMMAND_TickHighlightState, GCOMMAND_RefreshBannerTables, GCOMMAND_BuildBannerRow
; NOTES:
;   Increments once per highlight tick and wraps at 98 (`0..97`).
;   Passed as the `baseRowIndex` argument into GCOMMAND_BuildBannerRow.
;------------------------------------------------------------------------------
GCOMMAND_BannerPhaseIndexCurrent:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: GCOMMAND_HighlightHoldoffTickCount   (highlight holdoff countdown)
; TYPE: u16 scalar (byte access in hot paths)
; PURPOSE: Short countdown that delays status/read-mode transitions during highlight updates.
; USED BY: GCOMMAND_ConsumeBannerQueueEntry, ESQSHARED4_TickCopperAndBannerTransitions, ESQFUNC_ProcessUiFrameTick
; NOTES:
;   Seeded to 2 when a banner queue control step is consumed, then decremented once per frame.
;   Non-zero blocks ESQDISP status-indicator refresh and keeps the banner blit path in holdoff mode.
;------------------------------------------------------------------------------
GCOMMAND_HighlightHoldoffTickCount:
    DS.W    1
GCOMMAND_FMT_PCT_S_COLON:
    NStr2   "%s:",TextLineFeed
GCOMMAND_STR_GRADIENT:
    NStr2   "[GRADIENT]",TextLineFeed
GCOMMAND_FMT_COLOR_PCT_D_PCT_D:
    NStr3   TextLineFeed,"COLOR%d = %d",TextLineFeed
GCOMMAND_FMT_PCT_D_PCT_03X:
    NStr2   "   %d = %03X",TextLineFeed
;------------------------------------------------------------------------------
; SYM: GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE   (gradient table dump footer)
; TYPE: cstr
; PURPOSE: Footer text emitted after gradient/preset table debug dump output.
; USED BY: GCOMMAND_DisableHighlight debug formatter path
; NOTES:
;   Begins with byte value 10 (LF), so output starts with a blank line before
;   "TABLE = DONE".
;------------------------------------------------------------------------------
GCOMMAND_FMT_TABLE_DONE_WITH_LEADING_BLANK_LINE:
    DC.B    10
    NStr3   "TABLE = DONE",TextLineFeed,TextLineFeed
;------------------------------------------------------------------------------
; SYM: GCOMMAND_BannerFadeResetPendingFlag   (banner fade reset pending)
; TYPE: u16 gate (stored in long slot)
; PURPOSE: One-shot startup/runtime gate that triggers GCOMMAND banner fade-state rebuild.
; USED BY: GCOMMAND_ResetBannerFadeState
; NOTES:
;   Tested and immediately cleared by GCOMMAND_ResetBannerFadeState.
;   Initialized with low word = 1 so first reset path runs once after startup.
;------------------------------------------------------------------------------
GCOMMAND_BannerFadeResetPendingFlag:
    DC.L    $00010000
;------------------------------------------------------------------------------
; SYM: GCOMMAND_DriveProbeRequestedFlag   (drive probe request latch)
; TYPE: u16 (boolean)
; PURPOSE: Requests a disk-drive probe/assignment refresh on the next UI frame tick.
; USED BY: GCOMMAND_ProcessCtrlCommand, ESQFUNC_ProcessUiFrameTick, DISKIO_ProbeDrivesAndAssignPaths
; NOTES:
;   Set when ctrl command type 15 or 16 is received.
;   Cleared inside DISKIO_ProbeDrivesAndAssignPaths after probe cycle setup.
;------------------------------------------------------------------------------
GCOMMAND_DriveProbeRequestedFlag:
    DC.W    $0001
Global_STR_INPUTDEVICE:
    NStr    "inputdevice"
Global_STR_CONSOLEDEVICE:
    NStr    "consoledevice"
Global_STR_INPUT_DEVICE:
    NStr    "input.device"
Global_STR_CONSOLE_DEVICE:
    NStr    "console.device"
