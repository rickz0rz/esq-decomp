; The five string constants that shared a module with
; _UNKNOWN36_ShowAbortRequester. They stay in ASSEMBLY on purpose: they live
; in the CODE section in the original, reached PC-relative, and a C string
; literal lands in `data`. AGENTS.md records that a DATA hunk which grows by
; even four bytes shifts every symbol after it and froze the display.
; Splitting them out is what lets the FUNCTION become C.
    XDEF    _DEBUG_STR_UserAbortRequested
    XDEF    _DEBUG_STR_Continue
    XDEF    _DEBUG_STR_Abort
    XDEF    _UNKNOWN36_STR_BreakPrefix
    XDEF    _UNKNOWN36_STR_IntuitionLibrary

_DEBUG_STR_UserAbortRequested:
    DC.B    "** User Abort Requested **",0,0

_DEBUG_STR_Continue:
    DC.B    "CONTINUE",0,0

_DEBUG_STR_Abort:
    DC.B    "ABORT",0

_UNKNOWN36_STR_BreakPrefix:
    DC.B    "*** Break: ",0

_UNKNOWN36_STR_IntuitionLibrary:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061
