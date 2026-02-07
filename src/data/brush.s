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
