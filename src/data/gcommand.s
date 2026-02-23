; ========== GCOMMAND.c ==========

DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_1F66:
    NStr    "DF0:Digital_Niche.dat"
Global_STR_GCOMMAND_C_1:
    NStr    "GCOMMAND.c"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_NICHE_DOT_DAT_1F68:
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
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_1F6A:
    NStr    "DF0:Digital_Mplex.dat"
Global_STR_GCOMMAND_C_2:
    NStr    "GCOMMAND.c"
DATA_GCOMMAND_FMT_PCT_T_1F6C:
    NStr    "%T"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_MPLEX_DOT_DAT_1F6D:
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
DATA_GCOMMAND_FMT_PCT_T_1F70:
    NStr    "%T"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_1F71:
    NStr    "DF0:Digital_PPV3.dat"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_1F72:
    NStr    "DF0:Digital_PPV.dat"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV_DOT_DAT_1F73:
    NStr    "DF0:Digital_PPV.dat"
Global_STR_GCOMMAND_C_3:
    NStr    "GCOMMAND.c"
DATA_GCOMMAND_PATH_DF0_COLON_DIGITAL_PPV3_DOT_DAT_1F75:
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
    DS.L    1
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
DATA_GCOMMAND_STR_NO_FREE_STORE_1F78:
    NStr    "NO_FREE_STORE"
DATA_GCOMMAND_STR_TASK_TABLE_FULL_1F79:
    NStr    "TASK_TABLE_FULL"
DATA_GCOMMAND_STR_BAD_TEMPLATE_1F7A:
    NStr    "BAD_TEMPLATE"
DATA_GCOMMAND_STR_BAD_NUMBER_1F7B:
    NStr    "BAD_NUMBER"
DATA_GCOMMAND_STR_REQUIRED_ARG_MISSING_1F7C:
    NStr    "REQUIRED_ARG_MISSING"
DATA_GCOMMAND_STR_KEY_NEEDS_ARG_1F7D:
    NStr    "KEY_NEEDS_ARG"
DATA_GCOMMAND_STR_TOO_MANY_ARGS_1F7E:
    NStr    "TOO_MANY_ARGS"
DATA_GCOMMAND_STR_UNMATCHED_QUOTES_1F7F:
    NStr    "UNMATCHED_QUOTES"
DATA_GCOMMAND_STR_LINE_TOO_LONG_1F80:
    NStr    "LINE_TOO_LONG"
DATA_GCOMMAND_STR_FILE_NOT_OBJECT_1F81:
    NStr    "FILE_NOT_OBJECT"
DATA_GCOMMAND_STR_INVALID_RESIDENT_LIBRARY_1F82:
    NStr    "INVALID_RESIDENT_LIBRARY"
DATA_GCOMMAND_STR_NO_DEFAULT_DIR_1F83:
    NStr    "NO_DEFAULT_DIR"
DATA_GCOMMAND_STR_OBJECT_IN_USE_1F84:
    NStr    "OBJECT_IN_USE"
DATA_GCOMMAND_STR_OBJECT_EXISTS_1F85:
    NStr    "OBJECT_EXISTS"
DATA_GCOMMAND_STR_DIR_NOT_FOUND_1F86:
    NStr    "DIR_NOT_FOUND"
DATA_GCOMMAND_STR_OBJECT_NOT_FOUND_1F87:
    NStr    "OBJECT_NOT_FOUND"
DATA_GCOMMAND_STR_BAD_STREAM_NAME_1F88:
    NStr    "BAD_STREAM_NAME"
DATA_GCOMMAND_STR_OBJECT_TOO_LARGE_1F89:
    NStr    "OBJECT_TOO_LARGE"
DATA_GCOMMAND_STR_ACTION_NOT_KNOWN_1F8A:
    NStr    "ACTION_NOT_KNOWN"
DATA_GCOMMAND_STR_INVALID_COMPONENT_NAME_1F8B:
    NStr    "INVALID_COMPONENT_NAME"
DATA_GCOMMAND_STR_INVALID_LOCK_1F8C:
    NStr    "INVALID_LOCK"
DATA_GCOMMAND_STR_OBJECT_WRONG_TYPE_1F8D:
    NStr    "OBJECT_WRONG_TYPE"
DATA_GCOMMAND_STR_DISK_NOT_VALIDATED_1F8E:
    NStr    "DISK_NOT_VALIDATED"
DATA_GCOMMAND_STR_DISK_WRITE_PROTECTED_1F8F:
    NStr    "DISK_WRITE_PROTECTED"
DATA_GCOMMAND_STR_RENAME_ACROSS_DEVICES_1F90:
    NStr    "RENAME_ACROSS_DEVICES"
DATA_GCOMMAND_STR_DIRECTORY_NOT_EMPTY_1F91:
    NStr    "DIRECTORY_NOT_EMPTY"
DATA_GCOMMAND_STR_TOO_MANY_LEVELS_1F92:
    NStr    "TOO_MANY_LEVELS"
DATA_GCOMMAND_STR_DEVICE_NOT_MOUNTED_1F93:
    NStr    "DEVICE_NOT_MOUNTED"
DATA_GCOMMAND_STR_SEEK_ERROR_1F94:
    NStr    "SEEK_ERROR"
DATA_GCOMMAND_STR_COMMENT_TOO_BIG_1F95:
    NStr    "COMMENT_TOO_BIG"
DATA_GCOMMAND_STR_DISK_FULL_1F96:
    NStr    "DISK_FULL"
DATA_GCOMMAND_STR_DELETE_PROTECTED_1F97:
    NStr    "DELETE_PROTECTED"
DATA_GCOMMAND_STR_WRITE_PROTECTED_1F98:
    NStr    "WRITE_PROTECTED"
DATA_GCOMMAND_STR_READ_PROTECTED_1F99:
    NStr    "READ_PROTECTED"
DATA_GCOMMAND_STR_NOT_A_DOS_DISK_1F9A:
    NStr    "NOT_A_DOS_DISK"
DATA_GCOMMAND_STR_NO_DISK_1F9B:
    NStr    "NO_DISK"
DATA_GCOMMAND_STR_NO_MORE_ENTRIES_1F9C:
    NStr    "NO_MORE_ENTRIES"
DATA_GCOMMAND_STR_UNKNOWN_1F9D:
    NStr    "UNKNOWN!"

    DC.L    DATA_GCOMMAND_STR_NO_FREE_STORE_1F78
    DC.L    DATA_GCOMMAND_STR_TASK_TABLE_FULL_1F79
    DC.L    DATA_GCOMMAND_STR_BAD_TEMPLATE_1F7A
    DC.L    DATA_GCOMMAND_STR_BAD_NUMBER_1F7B
    DC.L    DATA_GCOMMAND_STR_REQUIRED_ARG_MISSING_1F7C
    DC.L    DATA_GCOMMAND_STR_KEY_NEEDS_ARG_1F7D
    DC.L    DATA_GCOMMAND_STR_TOO_MANY_ARGS_1F7E
    DC.L    DATA_GCOMMAND_STR_UNMATCHED_QUOTES_1F7F
    DC.L    DATA_GCOMMAND_STR_LINE_TOO_LONG_1F80
    DC.L    DATA_GCOMMAND_STR_FILE_NOT_OBJECT_1F81
    DC.L    DATA_GCOMMAND_STR_INVALID_RESIDENT_LIBRARY_1F82
    DC.L    DATA_GCOMMAND_STR_NO_DEFAULT_DIR_1F83
    DC.L    DATA_GCOMMAND_STR_OBJECT_IN_USE_1F84
    DC.L    DATA_GCOMMAND_STR_OBJECT_EXISTS_1F85
    DC.L    DATA_GCOMMAND_STR_DIR_NOT_FOUND_1F86
    DC.L    DATA_GCOMMAND_STR_OBJECT_NOT_FOUND_1F87
    DC.L    DATA_GCOMMAND_STR_BAD_STREAM_NAME_1F88
    DC.L    DATA_GCOMMAND_STR_OBJECT_TOO_LARGE_1F89
    DC.L    DATA_GCOMMAND_STR_ACTION_NOT_KNOWN_1F8A
    DC.L    DATA_GCOMMAND_STR_INVALID_COMPONENT_NAME_1F8B
    DC.L    DATA_GCOMMAND_STR_INVALID_LOCK_1F8C
    DC.L    DATA_GCOMMAND_STR_OBJECT_WRONG_TYPE_1F8D
    DC.L    DATA_GCOMMAND_STR_DISK_NOT_VALIDATED_1F8E
    DC.L    DATA_GCOMMAND_STR_DISK_WRITE_PROTECTED_1F8F
    DC.L    DATA_GCOMMAND_STR_RENAME_ACROSS_DEVICES_1F90
    DC.L    DATA_GCOMMAND_STR_DIRECTORY_NOT_EMPTY_1F91
    DC.L    DATA_GCOMMAND_STR_TOO_MANY_LEVELS_1F92
    DC.L    DATA_GCOMMAND_STR_DEVICE_NOT_MOUNTED_1F93
    DC.L    DATA_GCOMMAND_STR_SEEK_ERROR_1F94
    DC.L    DATA_GCOMMAND_STR_COMMENT_TOO_BIG_1F95
    DC.L    DATA_GCOMMAND_STR_DISK_FULL_1F96
    DC.L    DATA_GCOMMAND_STR_DELETE_PROTECTED_1F97
    DC.L    DATA_GCOMMAND_STR_WRITE_PROTECTED_1F98
    DC.L    DATA_GCOMMAND_STR_READ_PROTECTED_1F99
    DC.L    DATA_GCOMMAND_STR_NOT_A_DOS_DISK_1F9A
    DC.L    DATA_GCOMMAND_STR_NO_DISK_1F9B
    DC.L    DATA_GCOMMAND_STR_NO_MORE_ENTRIES_1F9C
    DC.L    DATA_GCOMMAND_STR_UNKNOWN_1F9D

DATA_GCOMMAND_PATH_GFX_COLON_1F9E:
    NStr    "GFX:"
DATA_GCOMMAND_STR_WORK_COLON_1F9F:
    NStr    "WORK:"
DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_LOGO_DOT_LS_1FA0:
    NStr    "COPY >NIL: GFX:LOGO.LST DH2: CLONE"
DATA_GCOMMAND_CMD_COPY_NIL_COLON_GFX_COLON_WORK_COLON__1FA1:
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
DATA_GCOMMAND_FMT_PCT_S_COLON_1FAA:
    NStr2   "%s:",TextLineFeed
DATA_GCOMMAND_STR_GRADIENT_1FAB:
    NStr2   "[GRADIENT]",TextLineFeed
DATA_GCOMMAND_FMT_COLOR_PCT_D_PCT_D_1FAC:
    NStr3   TextLineFeed,"COLOR%d = %d",TextLineFeed
DATA_GCOMMAND_FMT_PCT_D_PCT_03X_1FAD:
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
