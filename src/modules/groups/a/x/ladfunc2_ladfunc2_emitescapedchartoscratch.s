    XDEF    _LADFUNC2_EmitEscapedCharToScratch


;------------------------------------------------------------------------------
; FUNC: _LADFUNC2_EmitEscapedCharToScratch   (Routine at _LADFUNC2_EmitEscapedCharToScratch)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer
; READS:
;   _LADFUNC_FMT_ControlCharCaretEscape, _LADFUNC_FMT_ReplacementQuoteChar, _LADFUNC_FMT_ReplacementCommaChar, _LADFUNC_FMT_HexEscapeByte, _LADFUNC_FMT_LiteralChar
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_LADFUNC2_EmitEscapedCharToScratch:
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
    PEA     _LADFUNC_FMT_ControlCharCaretEscape
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    PEA     _LADFUNC_FMT_ReplacementQuoteChar
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

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
    PEA     _LADFUNC_FMT_ReplacementCommaChar
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.lab_0EFF:
    MOVEQ   #126,D0
    CMP.B   D0,D7
    BLS.S   .branch

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     _LADFUNC_FMT_HexEscapeByte
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7
    BRA.S   .lab_0F01

.branch:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    PEA     _LADFUNC_FMT_LiteralChar
    JSR     _GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(PC)

    ADDQ.W  #8,A7

.lab_0F01:
    MOVE.L  (A7)+,D7
    RTS

;!======