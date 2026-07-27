    XDEF    _TEXTDISP_SkipControlCodes


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_SkipControlCodes   (Skip control/alignment bytes)
; ARGS:
;   stack +8: textPtr (A3)
; RET:
;   D0: advanced pointer (or NULL)
; CLOBBERS:
;   D0/A0/A3
; READS:
;   _WDISP_CharClassTable (char class table)
; DESC:
;   Skips leading control/alignment bytes and returns the first displayable char.
; NOTES:
;   Treats '@' (0x40) as a special 8-byte prefix.
;------------------------------------------------------------------------------
_TEXTDISP_SkipControlCodes:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEQ   #40,D0
    CMP.B   (A3),D0
    BNE.S   .scan_text

    ADDQ.L  #8,A3

.scan_text:
    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #3,(A0)
    BEQ.S   .return

    ADDQ.L  #1,A3
    BRA.S   .scan_text

.return:
    MOVE.L  A3,D0
    MOVEA.L (A7)+,A3
    RTS

;!======