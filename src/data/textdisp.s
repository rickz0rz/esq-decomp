; ========== TEXTDISP.c ==========

Global_STR_TEXTDISP_C_1:
    NStr    "TEXTDISP.c"
DATA_TEXTDISP_SPACE_VALUE_214E:
    NStr    " "
Global_STR_TEXTDISP_C_2:
    NStr    "TEXTDISP.c"
Global_STR_DF0_SOURCECFG_INI_2:
    NStr    "df0:SourceCfg.ini"
Global_STR_TEXTDISP_C_3:
    NStr    "TEXTDISP.c"
Global_STR_TEXTDISP_C_4:
    NStr    "TEXTDISP.c"
    DS.W    1
;------------------------------------------------------------------------------
; SYM: TEXTDISP_ActiveGroupId   (active listing group id)
; TYPE: u16
; PURPOSE: Selects which group/table (primary vs secondary) textdisp routines use.
; USED BY: TEXTDISP_*, TEXTDISP3_* selection/render paths
; NOTES: Commonly tested as 0/1 style branch state.
;------------------------------------------------------------------------------
TEXTDISP_ActiveGroupId:
    DC.W    $0001
DATA_TEXTDISP_CONST_LONG_2154:
    DC.L    $19202020
    DS.W    1
DATA_TEXTDISP_CONST_LONG_2155:
    DC.L    $18191919
    DS.W    1
DATA_TEXTDISP_CONST_LONG_2156:
    DC.L    DATA_TEXTDISP_CONST_LONG_2154
    DC.L    DATA_TEXTDISP_CONST_LONG_2155
    DC.L    $7f020408,$10204001,$3e3e0000,$00000024
    DC.L    $42617f7f
    DS.L    1
    DC.L    $7e1e3e3e,$14001819
    DS.B    1
DATA_TEXTDISP_CONST_BYTE_2157:
    DC.B    TextAlignCenter,0
DATA_TEXTDISP_CONST_BYTE_2158:
    DC.B    TextAlignLeft,0,0
DATA_TEXTDISP_TAG_PPV_2159:
    NStr    "PPV"
DATA_TEXTDISP_TAG_SBE_215A:
    NStr    "SBE"
DATA_TEXTDISP_TAG_SPORTS_215B:
    NStr    "SPORTS"
DATA_TEXTDISP_TAG_SPT_215C:
    NStr    "SPT"
Global_STR_ASTERISK_2:
    NStr    "*"
DATA_TEXTDISP_TAG_FIND1_215E:
    NStr    "FIND1"
Global_STR_ASTERISK_3:
    NStr    "*"
DATA_TEXTDISP_TAG_SPT_2160:
    NStr    "SPT"
