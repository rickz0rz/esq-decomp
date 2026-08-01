    XDEF    _Global_STR_TLIBA1_C_1
    XDEF    _Global_STR_TLIBA1_C_2
    XDEF    _Global_STR_TLIBA1_C_3
    XDEF    _TLIBA1_STR_TLIBA1_DOT_C
    XDEF    _TLIBA1_FormatFallbackBuffer
    XDEF    _TLIBA1_FormatFallbackFieldPtr0
    XDEF    _TLIBA1_FormatFallbackFieldPtr1
    XDEF    _TLIBA1_FormatFallbackFieldPtr2
    XDEF    _TLIBA1_FormatFallbackFieldPtr3
    XDEF    _TLIBA1_FMT_PCT_C_PCT_S
    XDEF    _TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X
    XDEF    _TLIBA1_STR_TLFormatStructOpenBraceLine
    XDEF    _TLIBA1_FMT_TLF_COLOR_PCT_D
    XDEF    _TLIBA1_FMT_TLF_OFFSET_PCT_D
    XDEF    _TLIBA1_FMT_TLF_FONTSEL_PCT_D
    XDEF    _TLIBA1_FMT_TLF_ALIGN_PCT_D
    XDEF    _TLIBA1_FMT_TLF_PREGAP_PCT_D
    XDEF    _TLIBA1_STR_TLFormatStructCloseBraceLine
    XDEF    _TLIBA1_PatternTableInitGuard
    XDEF    _TEXTDISP_LrbnEntryWidthPx
    XDEF    _TLIBA1_FMT_PCT_03LD_VerticalScaleTick
    XDEF    _TLIBA1_FMT_PCT_03LD_HorizontalScaleTick
    XDEF    _TLIBA1_FMT_VIEWMODE_PCT_LD
    XDEF    _TLIBA1_CurrentViewModeIndex
    XDEF    _TLIBA1_DiagDiwOffset
    XDEF    _TLIBA1_DiagDdfOffset
    XDEF    _TLIBA1_DiagBplcon1Value
    XDEF    _TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF
    XDEF    _TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L
    XDEF    _TLIBA1_STR_PatternDumpSeparatorNewline
    XDEF    _Global_STR_VM_ARRAY_1
    XDEF    _Global_STR_VM_ARRAY_2
    XDEF    _TLIBA1_STR_PatternDumpLoopNewline
    XDEF    _TLIBA1_PreviewSlotRefreshState
    XDEF    _TLIBA1_PreviewSlotRenderResult
    XDEF    _TLIBA1_DayEntryModeCounter
    XDEF    _WDISP_StatusDayEntry0
    XDEF    _WDISP_StatusDayEntry1
    XDEF    _WDISP_StatusDayEntry2
    XDEF    _WDISP_StatusDayEntry3
    XDEF    _TLIBA1_StatusBannerPropagateGuard
; ========== TLIBA1.c ==========

_Global_STR_TLIBA1_C_1:
    NStr    "TLIBA1.c"
_Global_STR_TLIBA1_C_2:
    NStr    "TLIBA1.c"
_Global_STR_TLIBA1_C_3:
    NStr    "TLIBA1.c"
_TLIBA1_STR_TLIBA1_DOT_C:
    DC.B    "TLIBA1.c",0
_TLIBA1_FormatFallbackBuffer:
    DS.B    1
    DS.W    1
_TLIBA1_FormatFallbackFieldPtr0:
    DS.W    1
_TLIBA1_FormatFallbackFieldPtr1:
    DS.W    1
_TLIBA1_FormatFallbackFieldPtr2:
    DS.W    1
_TLIBA1_FormatFallbackFieldPtr3:
    DS.W    1
_TLIBA1_FMT_PCT_C_PCT_S:
    NStr    "%c%s"
_TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X:
    NStr2   "struct TLFormat @ 0x%x =",TextLineFeed
_TLIBA1_STR_TLFormatStructOpenBraceLine:
    NStr2   "{",TextLineFeed
_TLIBA1_FMT_TLF_COLOR_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Color =   %d",TextLineFeed
_TLIBA1_FMT_TLF_OFFSET_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Offset =  %d",TextLineFeed
_TLIBA1_FMT_TLF_FONTSEL_PCT_D:
    NStr3   TextHorizontalTab,"tlf_FontSel = %d",TextLineFeed
_TLIBA1_FMT_TLF_ALIGN_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Align =   %d",TextLineFeed
_TLIBA1_FMT_TLF_PREGAP_PCT_D:
    NStr3   TextHorizontalTab,"tlf_Pregap =  %d",TextLineFeed
_TLIBA1_STR_TLFormatStructCloseBraceLine:
    NStr2   "}",TextLineFeed
_TLIBA1_PatternTableInitGuard:
    DS.W    1
_TEXTDISP_LrbnEntryWidthPx:
    DC.B    1,"("
_TLIBA1_FMT_PCT_03LD_VerticalScaleTick:
    NStr    "%03ld"
_TLIBA1_FMT_PCT_03LD_HorizontalScaleTick:
    NStr    "%03ld"
_TLIBA1_FMT_VIEWMODE_PCT_LD:
    NStr    "ViewMode = %ld"
_TLIBA1_CurrentViewModeIndex:
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _TLIBA1_DiagDiwOffset/_TLIBA1_DiagDdfOffset/_TLIBA1_DiagBplcon1Value   (pattern register dump values)
; TYPE: u16/u16/u16
; PURPOSE: Captured DIW offset, DDF offset, and BPLCON1 value for view-mode diagnostics.
; USED BY: _TLIBA3_FormatPatternRegisterDump
; NOTES: Printed in `$%04lx` format by the diagnostic VM-array dump path.
;------------------------------------------------------------------------------
_TLIBA1_DiagDiwOffset:
    DS.W    1
_TLIBA1_DiagDdfOffset:
    DS.W    1
_TLIBA1_DiagBplcon1Value:
    DS.W    1
_TLIBA1_FMT_PCT_S_COLON_DIWOFFSET_PCT_04LX_DDFOF:
    NStr2   "%s: diwoffset=$%04lx, ddfoffset=$%04lx, bplcon1=$%04lx",TextLineFeed
_TLIBA1_FMT_DIWSTRT_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DIWSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_DIWSTOP_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DIWSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_DDFSTRT_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DDFSTRT: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_DDFSTOP_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "DDFSTOP: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPL1MOD_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPL2MOD_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2MOD: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPLCON0_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON0: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPLCON1_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON1: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPLCON2_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPLCON2: 0x%04lx 0x%04lx, (%ld)",TextLineFeed
_TLIBA1_FMT_BPL1PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1PTH: 0x%04lx 0x%04lx",TextLineFeed
_TLIBA1_FMT_BPL1PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL1PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
_TLIBA1_FMT_BPL2PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2PTH: 0x%04lx 0x%04lx",TextLineFeed
_TLIBA1_FMT_BPL2PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL2PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
_TLIBA1_FMT_BPL3PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL3PTH: 0x%04lx 0x%04lx",TextLineFeed
_TLIBA1_FMT_BPL3PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL3PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
_TLIBA1_FMT_BPL4PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL4PTH: 0x%04lx 0x%04lx",TextLineFeed
_TLIBA1_FMT_BPL4PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL4PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
_TLIBA1_FMT_BPL5PTH_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL5PTH: 0x%04lx 0x%04lx",TextLineFeed
_TLIBA1_FMT_BPL5PTL_COLON_0X_PCT_04LX_0X_PCT_04L:
    NStr2   "BPL5PTL: 0x%04lx 0x%04lx, ($%08lx)",TextLineFeed
_TLIBA1_STR_PatternDumpSeparatorNewline:
    NStr    10
_Global_STR_VM_ARRAY_1:
    NStr    "VM[ARRAY[%ld]"
_Global_STR_VM_ARRAY_2:
    NStr    "VM[ARRAY[%ld]"
_TLIBA1_STR_PatternDumpLoopNewline:
    NStr    10
    DS.W    1
_TLIBA1_PreviewSlotRefreshState:
    DS.L    1
_TLIBA1_PreviewSlotRenderResult:
    DS.L    1
_TLIBA1_DayEntryModeCounter:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _WDISP_StatusDayEntry0.._WDISP_StatusDayEntry3   (status-day entry ring)
; TYPE: struct[4]
; PURPOSE: Four consecutive day-entry structs consumed by banner/status rendering and shifted each update tick.
; USED BY: UNKNOWN_ParseListAndUpdateEntries, _ESQDISP_DrawStatusBanner, WDISP_DrawStatusBannerSlots
; NOTES: Per-entry layout is likely: +0 day code, +4/+8/+12 numeric fields, +16 active/pending flag.
;------------------------------------------------------------------------------
_WDISP_StatusDayEntry0:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry1:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry2:
    DC.L    0,1,0,0,1
_WDISP_StatusDayEntry3:
    DC.L    0,1,0,0
_TLIBA1_StatusBannerPropagateGuard:
    DC.L    1
