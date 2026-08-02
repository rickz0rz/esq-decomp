    XDEF    _ED_MenuStateId
    XDEF    _ED_MenuDispatchReentryGuard
    XDEF    _ED_TextModeReinitPendingFlag
;------------------------------------------------------------------------------
; SYM: _ED_MenuStateId   (editor menu state id)
; TYPE: u16
; PURPOSE: Tracks active editor/menu substate for ED/ED1/ED2/ED3 dispatch.
; USED BY: ED_*, ED1_*, ED2_*, ED3_*, CLEANUP2_*, ESQFUNC_*
; NOTES: Used as a jump-dispatch selector in ED handlers.
;------------------------------------------------------------------------------
_ED_MenuStateId:
    DS.W    1
;------------------------------------------------------------------------------
; SYM: _ED_MenuDispatchReentryGuard   (ED dispatch reentry gate)
; TYPE: u32 flag
; PURPOSE: Prevents nested/reentrant _ED_DispatchEscMenuState execution.
; USED BY: _ED_DispatchEscMenuState
; NOTES: Cleared while dispatch is active and restored to 1 on exit.
;------------------------------------------------------------------------------
_ED_MenuDispatchReentryGuard:
    DC.L    1
;------------------------------------------------------------------------------
; SYM: _ED_TextModeReinitPendingFlag   (text-mode reinit pending)
; TYPE: u32 flag
; PURPOSE: Marks one-shot editor text/cursor reinitialization after text-mode force path.
; USED BY: _ED_HandleEditorInput
; NOTES: Set in force-text-mode case and consumed/cleared on next handler entry.
;------------------------------------------------------------------------------
_ED_TextModeReinitPendingFlag:
    DC.L    1

; ---- joined from data/ed2.s by tools/data_merge.py ----
    XDEF    _ED2_STR_PAGE
; ========== ED2.c ==========

_ED2_STR_PAGE:
    NStr    " Page"