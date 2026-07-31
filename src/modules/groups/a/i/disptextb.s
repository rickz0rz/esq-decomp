    XDEF    _DISPTEXT_ComputeVisibleLineCount


;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_ComputeVisibleLineCount   (Compute visible line countuncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: line count or offset
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D5/D6/D7
; CALLS:
;   _DISPTEXT_FinalizeLineTable, _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AI_JMPTBL_STR_FindCharPtr
; READS:
;   _DISPTEXT_TargetLineIndex/21D6/21DC/21D3, _NEWGRID_RowHeightPx
; WRITES:
;   (none observed)
; DESC:
;   Computes a derived line count with optional prefix adjustments.
; NOTES:
;   Uses booleanize pattern on _DISPTEXT_ControlMarkersEnabledFlag.
;------------------------------------------------------------------------------
_DISPTEXT_ComputeVisibleLineCount:
    LINK.W  A5,#-12
    MOVEM.L D5-D7,-(A7)
    MOVE.L  8(A5),D7
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    CMP.L   D7,D0
    BGE.S   .line_index_ok

    MOVE.L  D7,D1
    BRA.S   .use_max_lines

.line_index_ok:
    MOVEQ   #0,D1
    MOVE.W  D0,D1

.use_max_lines:
    MOVE.L  D1,D6
    MOVEQ   #0,D1
    MOVE.W  _NEWGRID_RowHeightPx,D1
    MOVE.L  D6,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    TST.L   D0
    BPL.S   .add_leading

    ADDQ.L  #3,D0

.add_leading:
    ASR.L   #2,D0
    MOVE.L  D0,D5
    MOVEQ   #1,D0
    CMP.L   D0,D6
    BNE.S   .no_leading

    MOVEQ   #2,D0
    BRA.S   .apply_leading

.no_leading:
    MOVEQ   #0,D0

.apply_leading:
    ADD.L   D0,D5
    TST.W   _DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .return

    MOVE.W  _DISPTEXT_TargetLineIndex,D0
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    ASL.L   #2,D1
    LEA     _DISPTEXT_TextBufferPtr,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.L  A1,-12(A5)
    BEQ.S   .return

    PEA     19.W
    MOVE.L  A1,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    PEA     20.W
    MOVE.L  -12(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .return

    ADDQ.L  #2,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======