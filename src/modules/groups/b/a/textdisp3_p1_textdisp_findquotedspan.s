    XDEF    _TEXTDISP_FindQuotedSpan


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_FindQuotedSpan   (Find quoted span in text)
; ARGS:
;   stack +8: textPtr (A3)
;   stack +12: outStartPtr (A2)
;   stack +16: endPtr (optional)
;   stack +20: outHasQuotes (ptr)
; RET:
;   D0: span length (bytes)
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   _STR_FindCharPtr
; READS:
;   _WDISP_CharClassTable
; WRITES:
;   (outStartPtr), (outHasQuotes)
; DESC:
;   Finds a quoted segment or falls back to the full string/end pointer,
;   then trims leading/trailing control bytes.
; NOTES:
;   Uses 0x22 (\") as the delimiter.
;------------------------------------------------------------------------------
_TEXTDISP_FindQuotedSpan:
    LINK.W  A5,#-12
    MOVEM.L D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    CLR.L   -8(A5)
    MOVEA.L 20(A5),A0
    CLR.L   (A0)
    PEA     34.W
    MOVE.L  A3,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .check_second_quote

    MOVEA.L D0,A0
    ADDQ.L  #1,A0
    PEA     34.W
    MOVE.L  A0,-(A7)
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)

.check_second_quote:
    TST.L   -8(A5)
    BNE.S   .mark_has_quotes

    TST.L   -4(A5)
    BNE.S   .maybe_skip_prefix

    MOVEA.L A3,A0
    MOVE.L  A0,-4(A5)

.maybe_skip_prefix:
    MOVEQ   #40,D0
    MOVEA.L -4(A5),A0
    CMP.B   (A0),D0
    BNE.S   .select_end_ptr

    ADDQ.L  #8,-4(A5)

.select_end_ptr:
    MOVEA.L 16(A5),A0
    MOVE.L  A0,-8(A5)
    BEQ.S   .scan_to_end

    SUBQ.L  #1,-8(A5)
    BRA.S   .trim_leading_ctrl

.scan_to_end:
    MOVEA.L A3,A0

.scan_to_end_loop:
    TST.B   (A0)+
    BNE.S   .scan_to_end_loop

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-8(A5)
    BRA.S   .trim_leading_ctrl

.mark_has_quotes:
    MOVEQ   #1,D0
    MOVEA.L 20(A5),A0
    MOVE.L  D0,(A0)

.trim_leading_ctrl:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .trim_trailing_ctrl

    ADDQ.L  #1,-4(A5)
    BRA.S   .trim_leading_ctrl

.trim_trailing_ctrl:
    MOVEA.L -8(A5),A0
    MOVE.B  (A0),D0
    EXT.W   D0
    EXT.L   D0
    LEA     _WDISP_CharClassTable,A1
    ADDA.L  D0,A1
    BTST    #3,(A1)
    BEQ.S   .return

    SUBQ.L  #1,-8(A5)
    BRA.S   .trim_trailing_ctrl

.return:
    MOVEA.L -4(A5),A0
    MOVE.L  A0,(A2)
    MOVE.L  -8(A5),D0
    SUB.L   -4(A5),D0
    MOVE.L  D0,D7
    ADDQ.L  #1,D7
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A2-A3
    UNLK    A5
    RTS

;!======