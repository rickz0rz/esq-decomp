    XDEF    _COI_AppendAnimFieldWithTrailingSpace

    XDEF    COI_AppendAnimFieldWithTrailingSpace_Return


_COI_AppendAnimFieldWithTrailingSpace:
    LINK.W  A5,#-4
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   COI_AppendAnimFieldWithTrailingSpace_Return

    MOVEA.L A2,A0

.lab_037A:
    TST.B   (A0)+
    BNE.S   .lab_037A

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    MOVE.L  A0,D0
    MOVEA.L A2,A1
    ADDA.L  D0,A1
    MOVE.L  -4(A5),-(A7)
    PEA     _COI_FMT_WIDE_STR_WITH_TRAILING_SPACE
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7

;------------------------------------------------------------------------------
; FUNC: COI_AppendAnimFieldWithTrailingSpace_Return   (Routine at COI_AppendAnimFieldWithTrailingSpace_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D7
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
COI_AppendAnimFieldWithTrailingSpace_Return:
    MOVE.L  A2,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS
