; ========== TEXTDISP.c ==========

Global_STR_TEXTDISP_C_1:
    NStr    "TEXTDISP.c"
;------------------------------------------------------------------------------
; SYM: TEXTDISP_DefaultSpacePad   (default source-config pad)
; TYPE: char[2]
; PURPOSE: Default single-space string copied into source-config buffer fields.
; USED BY: TEXTDISP_HandleScriptCommand
; NOTES: NUL-terminated.
;------------------------------------------------------------------------------
TEXTDISP_DefaultSpacePad:
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
;------------------------------------------------------------------------------
; SYM: TEXTDISP_FormatEntryFallbackWord0   (fallback table word 0??)
; TYPE: u32
; PURPOSE: First literal word consumed by TEXTDISP fallback format-entry table.
; USED BY: TEXTDISP_FormatEntryFallbackTable
; NOTES: Field-level semantics are still unresolved; kept as table-member alias.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryFallbackWord0:
    DC.B    TextAlignLeft,"   ",0,0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_FormatEntryFallbackWord1   (fallback table word 1??)
; TYPE: u32
; PURPOSE: Second literal word consumed by TEXTDISP fallback format-entry table.
; USED BY: TEXTDISP_FormatEntryFallbackTable
; NOTES: Field-level semantics are still unresolved; kept as table-member alias.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryFallbackWord1:
    DC.B    TextAlignCenter,TextAlignLeft,TextAlignLeft,TextAlignLeft,0,0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_FormatEntryFallbackTable   (format entry fallback table)
; TYPE: struct/table ??
; PURPOSE: Read-only fallback template data used while building formatted entry text.
; USED BY: TLIBA1_FormatClockFormatEntry
; NOTES: Includes pointers to Word0/Word1 followed by packed literal rows.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryFallbackTable:
    DC.L    TEXTDISP_FormatEntryFallbackWord0
    DC.L    TEXTDISP_FormatEntryFallbackWord1
    DC.L    $7f020408,$10204001,$3e3e0000,$00000024
    DC.L    $42617f7f,$00000000,$7e1e3e3e,$14001819
    DC.B    0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_CenterAlignToken   (center-align control token)
; TYPE: u8[2]
; PURPOSE: Prefix token sequence that requests centered text formatting.
; USED BY: TEXTDISP_BuildEntryShortName, CLEANUP3_*, CLEANUP4_*
; NOTES: First byte is TextAlignCenter.
;------------------------------------------------------------------------------
TEXTDISP_CenterAlignToken:
    DC.B    TextAlignCenter,0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_LeftAlignToken   (left-align control token)
; TYPE: u8[3]
; PURPOSE: Prefix token sequence that requests left-aligned text formatting.
; USED BY: CLEANUP3_*
; NOTES: First byte is TextAlignLeft.
;------------------------------------------------------------------------------
TEXTDISP_LeftAlignToken:
    DC.B    TextAlignLeft,0,0
;------------------------------------------------------------------------------
; SYM: TEXTDISP_Tag_PPV/TEXTDISP_Tag_SBE/TEXTDISP_Tag_SPORTS/TEXTDISP_Tag_SPT_Filter/TEXTDISP_Tag_FIND1/TEXTDISP_Tag_SPT_Select   (filter tags)
; TYPE: char[] strings
; PURPOSE: Pattern tokens used by TEXTDISP wildcard/filter and selection logic.
; USED BY: TEXTDISP_BuildMatchIndexList, TEXTDISP_SelectBestMatchFromList
; NOTES: Two distinct SPT tokens are retained because they are used in different phases.
;------------------------------------------------------------------------------
TEXTDISP_Tag_PPV:
    NStr    "PPV"
TEXTDISP_Tag_SBE:
    NStr    "SBE"
TEXTDISP_Tag_SPORTS:
    NStr    "SPORTS"
TEXTDISP_Tag_SPT_Filter:
    NStr    "SPT"
Global_STR_ASTERISK_2:
    NStr    "*"
TEXTDISP_Tag_FIND1:
    NStr    "FIND1"
Global_STR_ASTERISK_3:
    NStr    "*"
TEXTDISP_Tag_SPT_Select:
    NStr    "SPT"
