    XDEF    LADFUNC2_EmitEscapedStringWithLimit
    XDEF    LADFUNC2_EmitEscapedStringChunked_Return
    XDEF    LADFUNC2_EmitEscapedStringWithLimit_Return


    ; uncertain
    MOVEQ   #97,D0
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   LADFUNC2_EmitEscapedStringWithLimit_Return

;------------------------------------------------------------------------------
; FUNC: LADFUNC2_EmitEscapedStringWithLimit   (Routine at LADFUNC2_EmitEscapedStringWithLimit)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D6
; CALLS:
;   _LADFUNC2_EmitEscapedCharToScratch
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC2_EmitEscapedStringWithLimit:
    TST.B   (A3)
    BEQ.S   LADFUNC2_EmitEscapedStringWithLimit_Return

    MOVE.L  D6,D0
    ADDQ.L  #1,D6
    CMP.L   D7,D0
    BGE.S   LADFUNC2_EmitEscapedStringWithLimit_Return

    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _LADFUNC2_EmitEscapedCharToScratch

    ADDQ.W  #4,A7
    BRA.S   LADFUNC2_EmitEscapedStringWithLimit

;------------------------------------------------------------------------------
; FUNC: LADFUNC2_EmitEscapedStringWithLimit_Return   (Routine at LADFUNC2_EmitEscapedStringWithLimit_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D6/D7
; CALLS:
;   _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer, _LADFUNC2_EmitEscapedCharToScratch, _NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   LADFUNC_STR_QuoteAndNewline, LADFUNC_STR_Quote
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC2_EmitEscapedStringWithLimit_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVE.L  A3,D0
    BEQ.S   LADFUNC2_EmitEscapedStringChunked_Return

    MOVEQ   #0,D6

.branch:
    TST.B   (A3)
    BEQ.S   LADFUNC2_EmitEscapedStringChunked_Return

    MOVE.L  D6,D0
    MOVE.L  D7,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .branch_2

    TST.L   D6
    BLE.S   .branch_1

    PEA     LADFUNC_STR_QuoteAndNewline
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    PEA     LADFUNC_STR_Quote
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _LADFUNC2_EmitEscapedCharToScratch

    ADDQ.W  #4,A7
    ADDQ.L  #1,D6
    BRA.S   .branch

;------------------------------------------------------------------------------
; FUNC: LADFUNC2_EmitEscapedStringChunked_Return   (Routine at LADFUNC2_EmitEscapedStringChunked_Return)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D6
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
LADFUNC2_EmitEscapedStringChunked_Return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======