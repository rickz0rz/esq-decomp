    XDEF    _COI_ClearAnimObjectStrings
    XDEF    COI_ClearAnimObjectStrings_Return


;------------------------------------------------------------------------------
; FUNC: _COI_ClearAnimObjectStrings   (Routine at _COI_ClearAnimObjectStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0
; CALLS:
;   _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_COI_ClearAnimObjectStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .lab_02D2

    MOVEA.L 48(A3),A0
    BRA.S   .lab_02D3

.lab_02D2:
    SUBA.L  A0,A0

.lab_02D3:
    MOVEA.L A0,A2
    MOVE.L  A2,D0
    BEQ.S   COI_ClearAnimObjectStrings_Return

    MOVEQ   #0,D0
    MOVE.B  D0,(A2)
    MOVE.B  D0,1(A2)
    MOVE.B  D0,2(A2)
    MOVE.B  D0,3(A2)
    MOVE.L  4(A2),-(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,4(A2)
    MOVE.L  8(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,8(A2)
    MOVE.L  12(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,12(A2)
    MOVE.L  16(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,16(A2)
    MOVE.L  20(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,20(A2)
    MOVE.L  24(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    MOVE.L  D0,24(A2)
    MOVE.L  28(A2),(A7)
    CLR.L   -(A7)
    JSR     _GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    LEA     32(A7),A7
    MOVE.L  D0,28(A2)
    CLR.L   32(A2)

;------------------------------------------------------------------------------
; FUNC: COI_ClearAnimObjectStrings_Return   (Routine at COI_ClearAnimObjectStrings_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
COI_ClearAnimObjectStrings_Return:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======