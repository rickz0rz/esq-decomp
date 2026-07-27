    XDEF    _DISKIO_WriteDecimalField


;------------------------------------------------------------------------------
; FUNC: _DISKIO_WriteDecimalField   (Routine at _DISKIO_WriteDecimalField)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +8: arg_3 (via 12(A5))
;   stack +16: arg_4 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D6/D7
; CALLS:
;   _GROUP_AE_JMPTBL_WDISP_SPrintf, _DISKIO_WriteBufferedBytes
; READS:
;   Global_STR_PERCENT_LD
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_DISKIO_WriteDecimalField:
    LINK.W  A5,#-12
    MOVEM.L D6-D7,-(A7)

    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6

    MOVE.L  D6,-(A7)
    PEA     Global_STR_PERCENT_LD
    PEA     -10(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     -10(A5),A0
    MOVEA.L A0,A1

.lab_03AA:
    TST.B   (A1)+
    BNE.S   .lab_03AA

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    BSR.W   _DISKIO_WriteBufferedBytes

    MOVEM.L -20(A5),D6-D7
    UNLK    A5
    RTS

;!======