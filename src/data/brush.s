    XDEF    Global_STR_BRUSH_C_1
    XDEF    Global_STR_BRUSH_C_2
    XDEF    Global_STR_BRUSH_C_3
    XDEF    Global_STR_BRUSH_C_4
    XDEF    Global_STR_BRUSH_C_5
    XDEF    Global_STR_BRUSH_C_6
    XDEF    Global_STR_BRUSH_C_7
    XDEF    Global_STR_BRUSH_C_8
    XDEF    Global_STR_BRUSH_C_9
    XDEF    BRUSH_STR_IFF_FORM
    XDEF    Global_STR_BRUSH_C_10
    XDEF    Global_STR_BRUSH_C_11
    XDEF    Global_STR_BRUSH_C_12
    XDEF    Global_STR_BRUSH_C_13
    XDEF    Global_STR_BRUSH_C_14
    XDEF    Global_STR_BRUSH_C_15
    XDEF    Global_STR_BRUSH_C_16
    XDEF    Global_STR_BRUSH_C_17
    XDEF    Global_STR_BRUSH_C_18
    XDEF    Global_STR_BRUSH_C_19
    XDEF    BRUSH_STR_ALIAS_CODE_00
    XDEF    BRUSH_STR_ALIAS_CODE_11
    XDEF    BRUSH_STR_ALIAS_CODE_DT
    XDEF    BRUSH_STR_FALLBACK_DITHER
; ========== BRUSH.c ==========

Global_STR_BRUSH_C_1:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_2:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_3:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_4:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_5:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_6:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_7:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_8:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_9:
    NStr    "BRUSH.c"
;------------------------------------------------------------------------------
; SYM: BRUSH_STR_IFF_FORM   (IFF FORM chunk tag)
; TYPE: cstring
; PURPOSE: Signature used to validate brush asset files before ILBM decode.
; USED BY: BRUSH_LoadBrushAsset
; NOTES: Compared with STRING_CompareN using length 4.
;------------------------------------------------------------------------------
BRUSH_STR_IFF_FORM:
    NStr    "FORM"
Global_STR_BRUSH_C_10:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_11:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_12:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_13:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_14:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_15:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_16:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_17:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_18:
    NStr    "BRUSH.c"
Global_STR_BRUSH_C_19:
    NStr    "BRUSH.c"
;------------------------------------------------------------------------------
; SYM: BRUSH_STR_ALIAS_CODE_00   (legacy brush alias token)
; TYPE: cstring
; PURPOSE: Two-character brush alias accepted by BRUSH_SelectBrushByLabel.
; USED BY: BRUSH_SelectBrushByLabel
; NOTES: "00" and "11" are normalized to "DT"; "DITHER" is the fallback query.
;------------------------------------------------------------------------------
BRUSH_STR_ALIAS_CODE_00:
    NStr    "00"
BRUSH_STR_ALIAS_CODE_11:
    NStr    "11"
BRUSH_STR_ALIAS_CODE_DT:
    NStr    "DT"
BRUSH_STR_FALLBACK_DITHER:
    NStr    "DITHER"
    DS.W    1
