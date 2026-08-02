    XDEF    _P_TYPE_STR_SOURCE_CONFIG
    XDEF    _PARSEINI_DelimSpaceTab_Section1
_P_TYPE_STR_SOURCE_CONFIG:
    NStr    "SOURCE CONFIG"
_PARSEINI_DelimSpaceTab_Section1:
    NStr2   " ",9

; ---- joined from data/parseini.s by tools/data_merge.py ----
    XDEF    _Global_STR_PARSEINI_C_1
    XDEF    _PARSEINI_DelimSpaceTab_Section2
    XDEF    _PARSEINI_DelimSpaceTab_Section4_5
    XDEF    _PARSEINI_DelimSpaceTab_Section6
    XDEF    _PARSEINI_DelimSpaceTab_Section7
    XDEF    _PARSEINI_DelimSpaceTab_Section8
    XDEF    _Global_STR_PARSEINI_C_2
    XDEF    _PARSEINI_CurrentRangeTableIndex
    XDEF    _PARSEINI_DelimSpaceTab_RangeKey
    XDEF    _PARSEINI_DelimSpaceSemicolonTab_RangeValue
    XDEF    _PARSEINI_TAG_TABLE
; ========== PARSEINI.c ==========

_Global_STR_PARSEINI_C_1:
    NStr    "PARSEINI.c"
_PARSEINI_DelimSpaceTab_Section2:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section4_5:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section6:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section7:
    NStr2   " ",9
_PARSEINI_DelimSpaceTab_Section8:
    NStr2   " ",9
_Global_STR_PARSEINI_C_2:
    NStr    "PARSEINI.c"
;------------------------------------------------------------------------------
; SYM: _PARSEINI_CurrentRangeTableIndex   (current TABLE/COLOR range index)
; TYPE: s32
; PURPOSE: Holds the active TABLE/COLOR index while parsing range assignment lines.
; USED BY: _PARSEINI_ParseRangeKeyValue, _PARSEINI_ProcessWeatherBlocks
; NOTES: Sentinel is -1 when no valid index is active.
;------------------------------------------------------------------------------
_PARSEINI_CurrentRangeTableIndex:
    DC.L    $ffffffff
_PARSEINI_DelimSpaceTab_RangeKey:
    NStr2   " ",9
_PARSEINI_DelimSpaceSemicolonTab_RangeValue:
    NStr2   " ;",9
_PARSEINI_TAG_TABLE:
    NStr    "TABLE"