; ========== DST.c ==========
DST_PATH_DF0_COLON_DST_DOT_DAT:
    NStr    "df0:dst.dat"
DST_DefaultDatPathPtr:
    DC.L    DST_PATH_DF0_COLON_DST_DOT_DAT
DST_FMT_PCT_C_InTimePrefixChar:
    NStr    "%c"
DST_FMT_PCT_04D_PCT_03D_InTimeDateCode:
    NStr    "%04d%03d"
DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock:
    NStr    "%02d:%02d"
DST_STR_NO_IN_TIME:
    NStr    " NO IN TIME "
DST_FMT_PCT_C_OutTimePrefixChar:
    NStr    "%c"
DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode:
    NStr    "%04d%03d"
DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock:
    NStr    "%02d:%02d"
DST_STR_NO_OUT_TIME:
    NStr    " NO OUT TIME "
DST_STR_NO_DST_DATA:
    NStr    " NO DST DATA "
DST_STR_G2_COLON:
    NStr    " g2:"
DST_STR_G3_COLON:
    NStr    " g3:"
Global_STR_DST_C_1:
    NStr    "DST.c"
Global_STR_DST_C_2:
    NStr    "DST.c"
Global_STR_DST_C_3:
    NStr    "DST.c"
Global_STR_DST_C_4:
    NStr    "DST.c"
Global_STR_DST_C_5:
    NStr    "DST.c"
Global_STR_DST_C_6:
    NStr    "DST.c"
Global_STR_G2:
    NStr    "g2"
Global_STR_G3:
    NStr    "g3"
Global_STR_DST_C_7:
    NStr    "DST.c"
DST_FMT_PCT_S_COLON_PCT_S_PCT_S_PCT_02D_PCT_:
    NStr2   "%s:  %s%s%02d, '%d (%03d) %2d:%02d:%02d %s %s %s",TextLineFeed
DST_TAG_PM:
    NStr    "PM"
DST_TAG_AM:
    NStr    "AM"
DST_TAG_DST:
    NStr    "DST"
DST_TAG_STD:
    NStr    "STD"
DST_STR_LEAP_YEAR:
    NStr    "Leap Year"
DST_STR_NORM_YEAR:
    NStr    "Norm Year"
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_MenuStateId   (editor menu state id)
; TYPE: u16
; PURPOSE: Tracks active editor/menu substate for ED/ED1/ED2/ED3 dispatch.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, CLEANUP2_*, ESQFUNC_*
; NOTES: Used as a jump-dispatch selector in ED handlers.
;------------------------------------------------------------------------------
ED_MenuStateId:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: ED_MenuDispatchReentryGuard   (ED dispatch reentry gate)
; TYPE: u32 flag
; PURPOSE: Prevents nested/reentrant ED_DispatchEscMenuState execution.
; USED BY: ED_DispatchEscMenuState
; NOTES: Cleared while dispatch is active and restored to 1 on exit.
;------------------------------------------------------------------------------
ED_MenuDispatchReentryGuard:
    DC.L    1
;------------------------------------------------------------------------------
; SYM: ED_TextModeReinitPendingFlag   (text-mode reinit pending)
; TYPE: u32 flag
; PURPOSE: Marks one-shot editor text/cursor reinitialization after text-mode force path.
; USED BY: ED_HandleEditorInput
; NOTES: Set in force-text-mode case and consumed/cleared on next handler entry.
;------------------------------------------------------------------------------
ED_TextModeReinitPendingFlag:
    DC.L    1
