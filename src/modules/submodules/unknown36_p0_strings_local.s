; The two string constants from unknown36_p0_strings.s whose ONLY reader is C.
;
; UNKNOWN36_ShowAbortRequester builds both into stack locals now, so nothing
; references these symbols in the maximum-C build and
; src/c/strings_now_local_unknown36.c replaces this module with an empty
; object. The module stays here because src/Prevue.asm is what the BYTE-EXACT
; build assembles.
;
; Their three former neighbours are in unknown36_p0_strings.s and cannot move:
; a DATA table holds their addresses.
    XDEF    _UNKNOWN36_STR_BreakPrefix
    XDEF    _UNKNOWN36_STR_IntuitionLibrary

_UNKNOWN36_STR_BreakPrefix:
    DC.B    "*** Break: ",0

_UNKNOWN36_STR_IntuitionLibrary:
    DC.B    "intuition.library",0

;!======

    ; Alignment
    DS.W    3
    DC.W    $7061
