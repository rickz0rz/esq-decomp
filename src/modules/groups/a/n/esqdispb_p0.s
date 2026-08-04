    XDEF    _ESQDISP_FillProgramInfoHeaderFields
    XDEF    _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
    XDEF    _ESQDISP_JMPTBL_GRAPHICS_AllocRaster
    XDEF    ESQDISP_FillProgramInfoHeaderFields_Return




    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _NEWGRID_ProcessGridMessages
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages:
    JMP     _NEWGRID_ProcessGridMessages

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_JMPTBL_GRAPHICS_AllocRaster   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _GRAPHICS_AllocRaster
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQDISP_JMPTBL_GRAPHICS_AllocRaster:
    JMP     _GRAPHICS_AllocRaster

;!======

;------------------------------------------------------------------------------
; FUNC: _ESQDISP_FillProgramInfoHeaderFields   (Populate program-info header fields)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0/D4/D5/D6/D7
; CALLS:
;   _ESQFUNC_JMPTBL_STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Writes status/time/flag bytes into the program-info header and copies a
;   2-byte code string into header offset 43, then zero-terminates offset 45.
; NOTES:
;   Returns early if destination pointer is NULL.
;------------------------------------------------------------------------------
_ESQDISP_FillProgramInfoHeaderFields:
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 28(A7),A3
    MOVE.B  35(A7),D7
    MOVE.W  38(A7),D6
    MOVE.B  43(A7),D5
    MOVE.B  47(A7),D4
    MOVEA.L 48(A7),A2
    MOVE.L  A3,D0
    BEQ.S   ESQDISP_FillProgramInfoHeaderFields_Return

    MOVE.B  D7,40(A3)
    MOVE.W  D6,46(A3)
    MOVE.B  D5,41(A3)
    MOVE.B  D4,42(A3)
    LEA     43(A3),A0
    PEA     2.W
    MOVE.L  A2,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    CLR.B   45(A3)

;------------------------------------------------------------------------------
; FUNC: ESQDISP_FillProgramInfoHeaderFields_Return   (Return tail for program-info header fill)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQDISP_FillProgramInfoHeaderFields.
; NOTES:
;   Restores D4-D7/A2-A3 and returns.
;------------------------------------------------------------------------------
ESQDISP_FillProgramInfoHeaderFields_Return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======