    XDEF    _Global_STR_DISPLIB_C_1
    XDEF    _Global_STR_DISPLIB_C_2
    XDEF    _DISPTEXT_ControlMarkerXOffsetPx
; ========== DISPLIB.c ==========

_Global_STR_DISPLIB_C_1:
    NStr    "DISPLIB.c"
_Global_STR_DISPLIB_C_2:
    NStr    "DISPLIB.c"
;------------------------------------------------------------------------------
; SYM: _DISPTEXT_ControlMarkerXOffsetPx   (control-marker x offset)
; TYPE: s32
; PURPOSE: Per-line horizontal pixel offset applied when special inline markers are rendered.
; USED BY: _DISPTEXT_RenderCurrentLine, NEWGRID1_*
; NOTES: Set to 4 when marker rendering path is used; otherwise 0.
;------------------------------------------------------------------------------
_DISPTEXT_ControlMarkerXOffsetPx:
    DS.L    1
