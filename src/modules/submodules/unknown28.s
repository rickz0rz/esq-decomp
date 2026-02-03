;------------------------------------------------------------------------------
; FUNC: WDISP_FormatWithCallback   (FormatWithCallback??)
; ARGS:
;   stack +4: outputFunc (called with D0=byte)
;   stack +8: formatStr
;   stack +12: varArgsPtr (pointer to arguments)
; RET:
;   D0: ?? (format parser return)
; CLOBBERS:
;   D0, D7, A2-A3
; CALLS:
;   LAB_1A3B, outputFunc
; READS:
;   [formatStr], [varArgsPtr]
; WRITES:
;   (none)
; DESC:
;   Core printf-style formatter that emits bytes via a callback.
; NOTES:
;   Handles %% and delegates spec parsing to LAB_1A3B.
;------------------------------------------------------------------------------
WDISP_FormatWithCallback:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)

    MOVEA.L 32(A7),A3
    MOVEA.L 36(A7),A2
    MOVE.L  16(A5),-10(A5)

.LAB_1A72:
    MOVE.B  (A2)+,D7
    TST.B   D7
    BEQ.S   .return

    MOVEQ   #'%',D0
    CMP.B   D0,D7
    BNE.S   .LAB_1A74

    CMP.B   (A2),D0
    BNE.S   .LAB_1A73

    ADDQ.L  #1,A2
    BRA.S   .LAB_1A74

.LAB_1A73:
    MOVE.L  A3,-(A7)
    PEA     -10(A5)
    MOVE.L  A2,-(A7)
    BSR.W   LAB_1A3B

    LEA     12(A7),A7
    MOVE.L  D0,-6(A5)
    BEQ.S   .LAB_1A74

    MOVEA.L D0,A2
    BRA.S   .LAB_1A72

.LAB_1A74:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     (A3)

    ADDQ.W  #4,A7
    BRA.S   .LAB_1A72

.return:
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
