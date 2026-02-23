    XDEF    LADFUNC2_EmitEscapedCharToScratch
    XDEF    LADFUNC2_EmitEscapedStringToScratch
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
;   LADFUNC2_EmitEscapedCharToScratch
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
    BSR.W   LADFUNC2_EmitEscapedCharToScratch

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
;   GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer, LADFUNC2_EmitEscapedCharToScratch, NEWGRID_JMPTBL_MATH_DivS32
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
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BNE.S   .branch_2

    TST.L   D6
    BLE.S   .branch_1

    PEA     LADFUNC_STR_QuoteAndNewline
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_1:
    PEA     LADFUNC_STR_Quote
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #4,A7

.branch_2:
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LADFUNC2_EmitEscapedCharToScratch

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

;------------------------------------------------------------------------------
; FUNC: LADFUNC2_EmitEscapedStringToScratch   (Routine at LADFUNC2_EmitEscapedStringToScratch)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   LADFUNC2_EmitEscapedCharToScratch
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC2_EmitEscapedStringToScratch:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  A3,D0
    BEQ.S   .lab_0EFB

.lab_0EFA:
    TST.B   (A3)
    BEQ.S   .lab_0EFB

    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   LADFUNC2_EmitEscapedCharToScratch

    ADDQ.W  #4,A7
    BRA.S   .lab_0EFA

.lab_0EFB:
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: LADFUNC2_EmitEscapedCharToScratch   (Routine at LADFUNC2_EmitEscapedCharToScratch)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   LADFUNC_FMT_ControlCharCaretEscape, LADFUNC_FMT_ReplacementQuoteChar, LADFUNC_FMT_ReplacementCommaChar, LADFUNC_FMT_HexEscapeByte, LADFUNC_FMT_LiteralChar
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
LADFUNC2_EmitEscapedCharToScratch:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    MOVEQ   #32,D0
    CMP.B   D0,D7
    BCC.S   .lab_0EFD

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #64,D1
    ADD.L   D1,D0
    MOVE.L  D0,-(A7)
    PEA     LADFUNC_FMT_ControlCharCaretEscape
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.lab_0EFD:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #84,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BNE.S   .lab_0EFE

    MOVEQ   #34,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LADFUNC_FMT_ReplacementQuoteChar
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.lab_0EFE:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVEQ   #86,D1
    NOT.B   D1
    CMP.L   D1,D0
    BNE.S   .lab_0EFF

    MOVEQ   #44,D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LADFUNC_FMT_ReplacementCommaChar
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.lab_0EFF:
    MOVEQ   #126,D0
    CMP.B   D0,D7
    BLS.S   .branch

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LADFUNC_FMT_HexEscapeByte
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.branch:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     LADFUNC_FMT_LiteralChar
    JSR     GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7

.lab_0F01:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Alignment
    ALIGN_WORD
