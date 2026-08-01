    XDEF    _Global_STR_TEXTDISP_C_1
    XDEF    _TEXTDISP_DefaultSpacePad
; ========== TEXTDISP.c ==========

_Global_STR_TEXTDISP_C_1:
    NStr    "TEXTDISP.c"
;------------------------------------------------------------------------------
; SYM: _TEXTDISP_DefaultSpacePad   (default source-config pad)
; TYPE: char[2]
; PURPOSE: Default single-space string copied into source-config buffer fields.
; USED BY: _TEXTDISP_HandleScriptCommand
; NOTES: NUL-terminated.
;------------------------------------------------------------------------------
_TEXTDISP_DefaultSpacePad:
    NStr    " "