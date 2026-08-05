; Three string constants that a DATA TABLE POINTS AT. They cannot become C.
;
; data_wdisp_p1.c builds DEBUG_AbortRequesterTagChain holding
; (char *)DEBUG_STR_UserAbortRequested, (char *)DEBUG_STR_Continue and
; (char *)DEBUG_STR_Abort, so all three need real linkable addresses -- a stack
; local cannot serve. And defining them in C makes them initialised statics,
; which SAS/C 6.51 places in `data`; AGENTS.md records that a DATA hunk which
; grows by even four bytes shifts every symbol after it and froze the display.
;
; So these three are the floor. Their two former neighbours had only C readers
; and moved into locals -- see unknown36_p0_strings_local.s.
    XDEF    _DEBUG_STR_UserAbortRequested
    XDEF    _DEBUG_STR_Continue
    XDEF    _DEBUG_STR_Abort

_DEBUG_STR_UserAbortRequested:
    DC.B    "** User Abort Requested **",0,0

_DEBUG_STR_Continue:
    DC.B    "CONTINUE",0,0

_DEBUG_STR_Abort:
    DC.B    "ABORT",0
