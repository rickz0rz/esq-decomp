    XDEF    _TEXTDISP_InitRastAndResetFlag


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_InitRastAndResetFlag   (Init rast + reset flag)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/A0
; CALLS:
;   _TLIBA3_BuildDisplayContextForViewMode, _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples
; READS:
;   (none)
; WRITES:
;   _WDISP_DisplayContextBase, _WDISP_AccumulatorFlushPending
; DESC:
;   Allocates/sets the working rastport then resets _WDISP_AccumulatorFlushPending.
; NOTES:
;   Unlabeled entry in original binary; added for documentation.
;------------------------------------------------------------------------------
;   This block carried no label. The extract for whatever precedes it ran
;   on into it and reported that function as larger than it is. The label
;   below is byte-neutral and separates the two again. It is deliberately
;   not XDEF'd: no other module refers to it.
;------------------------------------------------------------------------------
_TEXTDISP_InitRastAndResetFlag:
    PEA     3.W
    CLR.L   -(A7)
    PEA     4.W
    JSR     _TLIBA3_BuildDisplayContextForViewMode(PC)

    MOVE.L  D0,_WDISP_DisplayContextBase
    JSR     _WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(PC)

    LEA     12(A7),A7
    CLR.W   _WDISP_AccumulatorFlushPending
    RTS

;!======