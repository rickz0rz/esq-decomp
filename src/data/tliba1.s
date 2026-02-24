; ========== TLIBA1.c ==========

Global_STR_TLIBA1_C_1:
    NStr    "TLIBA1.c"
Global_STR_TLIBA1_C_2:
    NStr    "TLIBA1.c"
Global_STR_TLIBA1_C_3:
    NStr    "TLIBA1.c"
TLIBA1_STR_TLIBA1_DOT_C:
    DC.B    "TLIBA1.c",0
TLIBA1_FormatFallbackBuffer:
    DS.B    1
    DS.W    1
TLIBA1_FormatFallbackFieldPtr0:
    DS.W    1
TLIBA1_FormatFallbackFieldPtr1:
    DS.W    1
TLIBA1_FormatFallbackFieldPtr2:
    DS.W    1
TLIBA1_FormatFallbackFieldPtr3:
    DS.W    1
TLIBA1_FMT_PCT_C_PCT_S:
    NStr    "%c%s"
TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X:
    NStr2   "struct TLFormat @ 0x%x =",TextLineFeed
TLIBA1_STR_TLFormatStructOpenBraceLine:
    NStr2   "{",TextLineFeed
TLIBA1_FMT_TLF_COLOR_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Color =   %d",TextLineFeed
TLIBA1_FMT_TLF_OFFSET_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Offset =  %d",TextLineFeed
TLIBA1_FMT_TLF_FONTSEL_PCT_D:
    NStr3   TextHorizontalTab,"tlf_FontSel = %d",TextLineFeed
TLIBA1_FMT_TLF_ALIGN_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Align =   %d",TextLineFeed
TLIBA1_FMT_TLF_PREGAP_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Pregap =  %d",TextLineFeed
TLIBA1_STR_TLFormatStructCloseBraceLine:
    NStr2   "}",TextLineFeed
TLIBA1_PatternTableInitGuard:
    DS.W    1
TEXTDISP_LrbnEntryWidthPx:
    DC.B    1,"("
TLIBA1_FMT_PCT_03LD_VerticalScaleTick:
    NStr    "%03ld"
TLIBA1_FMT_PCT_03LD_HorizontalScaleTick:
    NStr    "%03ld"
TLIBA1_FMT_VIEWMODE_PCT_LD:
    NStr    "ViewMode = %ld"
TLIBA1_CurrentViewModeIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: TLIBA1_DiagDiwOffset/TLIBA1_DiagDdfOffset/TLIBA1_DiagBplcon1Value   (pattern register dump values)
; TYPE: u16/u16/u16
; PURPOSE: Captured DIW offset, DDF offset, and BPLCON1 value for view-mode diagnostics.
; USED BY: TLIBA3_FormatPatternRegisterDump
; NOTES: Printed in `$%04lx` format by the diagnostic VM-array dump path.
;------------------------------------------------------------------------------
TLIBA1_DiagDiwOffset:
    DS.W    1
TLIBA1_DiagDdfOffset:
    DS.W    1
TLIBA1_DiagBplcon1Value:
    DS.W    1
TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF:
    NStr2   "%s: diwoffset=$%04lx, ddfoffset=$%04lx, bplcon1=$%04lx",TextLineFeed
TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DIWSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DIWSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DDFSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DDFSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON0: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON1: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON2: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1PTH: 0x%04lx 0x%04lx",TextLineFeed
TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2PTH: 0x%04lx 0x%04lx",TextLineFeed
TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL3PTH: 0x%04lx 0x%04lx",TextLineFeed
TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL3PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL4PTH: 0x%04lx 0x%04lx",TextLineFeed
TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL4PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL5PTH: 0x%04lx 0x%04lx",TextLineFeed
TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL5PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
TLIBA1_STR_PatternDumpSeparatorNewline:
    NStr    10
Global_STR_VM_ARRAY_1:
    NStr    "VM[ARRAY[%ld]"
Global_STR_VM_ARRAY_2:
    NStr    "VM[ARRAY[%ld]"
TLIBA1_STR_PatternDumpLoopNewline:
    NStr    10
    DS.W    1
TLIBA1_PreviewSlotRefreshState:
    DS.L    1
TLIBA1_PreviewSlotRenderResult:
    DS.L    1
TLIBA1_DayEntryModeCounter:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: WDISP_StatusDayEntry0..WDISP_StatusDayEntry3   (status-day entry ring)
; TYPE: struct[4]
; PURPOSE: Four consecutive day-entry structs consumed by banner/status rendering and shifted each update tick.
; USED BY: UNKNOWN_ParseListAndUpdateEntries, ESQDISP_DrawStatusBanner, WDISP_DrawStatusBannerSlots
; NOTES: Per-entry layout is likely: +0 day code, +4/+8/+12 numeric fields, +16 active/pending flag.
;------------------------------------------------------------------------------
WDISP_StatusDayEntry0:
    DC.L    0,1,0,0,1
WDISP_StatusDayEntry1:
    DC.L    0,1,0,0,1
WDISP_StatusDayEntry2:
    DC.L    0,1,0,0,1
WDISP_StatusDayEntry3:
    DC.L    0,1,0,0
TLIBA1_StatusBannerPropagateGuard:
    DC.L    1
