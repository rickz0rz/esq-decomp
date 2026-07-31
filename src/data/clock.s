    XDEF    _Global_STR_EXTRA_TIME_FORMAT
    XDEF    _Global_STR_GRID_TIME_FORMAT
    XDEF    _Global_STR_GRID_TIME_FORMAT_DUPLICATE
    XDEF    _Global_STR_12_44_44_SINGLE_SPACE
    XDEF    _Global_STR_12_44_44_PM
    XDEF    _Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED
    XDEF    _CLOCK_STR_TEMPLATE_CODE_SET_FGN
    XDEF    _CLOCK_AlignedInsetRenderGateFlag
    XDEF    _CLOCK_FileEofMarkerCtrlZ
    XDEF    _COI_FieldDelimiterTab
    XDEF    _COI_RecordTerminatorCrLf
    XDEF    _CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY
    XDEF    _CLOCK_FMT_WRAP_CHAR_STRING_CHAR
    XDEF    _CLOCK_STR_DOUBLE_SPACE
    XDEF    _CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY
    XDEF    _CLOCK_STR_TOKEN_PAIR_DEFAULTS
    XDEF    _CLEANUP_TokenPairScratch
    XDEF    _CLOCK_STR_TOKEN_OUTPUT_TEMPLATE
    XDEF    _CLOCK_STR_BOOL_CHARS_YyNn
    XDEF    _CLOCK_STR_EMPTY_TOKEN_TEMPLATE
    XDEF    _CLOCK_STR_MISSING_TITLE_TEMPLATE
; ========== CLOCK.c ========== probably

_Global_STR_EXTRA_TIME_FORMAT: ; not sure where this is used.
    NStr    "%2d:%02d:%02d"
_Global_STR_GRID_TIME_FORMAT:
    NStr    "%2d:%02d:%02d"
_Global_STR_GRID_TIME_FORMAT_DUPLICATE:
    NStr    "%2d:%02d:%02d "
_Global_STR_12_44_44_SINGLE_SPACE:
    NStr    "12:44:44 "
_Global_STR_12_44_44_PM:
    NStr    "12:44:44 PM"
_Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED:
    NStr    "%s%s%ld  "
    DS.L    1
;------------------------------------------------------------------------------
; SYM: _CLOCK_STR_TEMPLATE_CODE_SET_FGN   (template code set)
; TYPE: cstring
; PURPOSE: Character set checked when selecting aligned status/time templates.
; USED BY: _CLEANUP_RenderAlignedStatusScreen
; NOTES: Membership test performed via _STR_FindCharPtr.
;------------------------------------------------------------------------------
_CLOCK_STR_TEMPLATE_CODE_SET_FGN:
    NStr    "FGN"
;------------------------------------------------------------------------------
; SYM: _CLOCK_AlignedInsetRenderGateFlag   (aligned inset render gate flag)
; TYPE: u8 flag in packed word storage
; PURPOSE: Enables framed/inset rendering path for inline styled text draw calls.
; USED BY: _CLEANUP_UpdateEntryFlagBytes, _TLIBA1_DrawInlineStyledText, SCRIPT_DrawCenteredStyledTextLine
; NOTES:
;   Accessed with byte ops (TST.B/MOVE.B/CLR.B). Remaining bytes are packed
;   adjacent constants; keep layout intact.
;------------------------------------------------------------------------------
_CLOCK_AlignedInsetRenderGateFlag:
    DC.W    $0004
    DC.B    $0c
;------------------------------------------------------------------------------
; SYM: _CLOCK_FileEofMarkerCtrlZ   (file EOF marker byte)
; TYPE: u8
; PURPOSE: Control-Z marker appended to serialized/log output files.
; USED BY: _PARSEINI_WriteErrorLogEntry, COI export writer
; NOTES: Value is $1A.
;------------------------------------------------------------------------------
_CLOCK_FileEofMarkerCtrlZ:
    DC.B    $1a
;------------------------------------------------------------------------------
; SYM: _COI_FieldDelimiterTab   (COI export field delimiter)
; TYPE: u8
; PURPOSE: Delimiter byte emitted between serialized COI fields.
; USED BY: COI_Write* export routines
; NOTES: Value is $09 (TAB).
;------------------------------------------------------------------------------
_COI_FieldDelimiterTab:
    DC.B    $09
_COI_RecordTerminatorCrLf:
    DC.B    $0d
    DC.W    $0a00
;------------------------------------------------------------------------------
; SYM: _CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY   (fallback entry flags)
; TYPE: cstring
; PURPOSE: Default token string used when the primary entry record is missing.
; USED BY: _CLEANUP_UpdateEntryFlagBytes
; NOTES: Format appears to be packed flag characters.
;------------------------------------------------------------------------------
_CLOCK_STR_FALLBACK_ENTRY_FLAGS_PRIMARY:
    NStr    "NYYYYYXX00"
_CLOCK_FMT_WRAP_CHAR_STRING_CHAR:
    NStr    "%c%s%c"
_CLOCK_STR_DOUBLE_SPACE:
    NStr    "  "
_CLOCK_STR_FALLBACK_ENTRY_FLAGS_SECONDARY:
    NStr    "NYYYYYXX00"
; Default pair bytes used by _CLEANUP_FormatEntryStringTokens replacement logic.
_CLOCK_STR_TOKEN_PAIR_DEFAULTS:
    NStr    "NYYYYYXX00"
_CLEANUP_TokenPairScratch:
    DS.W    1
; Output template loaded before token/jumptable substitutions.
_CLOCK_STR_TOKEN_OUTPUT_TEMPLATE:
    NStr    "NYYYYYXX00"
_CLOCK_STR_BOOL_CHARS_YyNn:
CLOCK_STR_BOOL_CHARS_YyNnAlias:
    NStr    "YyNn"
_CLOCK_STR_EMPTY_TOKEN_TEMPLATE:
    NStr    "NNNNNNXX00"
_CLOCK_STR_MISSING_TITLE_TEMPLATE:
    NStr    "NNNNNNXX00"
