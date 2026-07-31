    XDEF    _ESQSHARED_CompressClosedCaptionedTag



;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_CompressClosedCaptionedTag   (Compress "Closed Captioned" token)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A6/A7/D0
; CALLS:
;   _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold, _LVOCopyMem
; READS:
;   AbsExecBase, _Global_STR_CLOSED_CAPTIONED
; WRITES:
;   (none observed)
; DESC:
;   Finds "Closed Captioned" in-place and compresses it to a single marker byte,
;   shifting the remaining tail text left.
; NOTES:
;   Uses marker byte 0x7C at token start.
;------------------------------------------------------------------------------
_ESQSHARED_CompressClosedCaptionedTag:
    LINK.W  A5,#-4
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 8(A5),A3

    PEA     _Global_STR_CLOSED_CAPTIONED
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AS_JMPTBL_ESQ_FindSubstringCaseFold(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .lab_0C34

    MOVEA.L D0,A0
    MOVE.B  #$7c,(A0)+
    LEA     3(A0),A1
    MOVEA.L A1,A2

.lab_0C33:
    TST.B   (A2)+
    BNE.S   .lab_0C33

    SUBQ.L  #1,A2
    SUBA.L  A1,A2
    MOVE.L  A2,D0
    ADDQ.L  #1,D0
    MOVE.L  A0,-4(A5)
    MOVEA.L A1,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOCopyMem(A6)

.lab_0C34:
    MOVEM.L (A7)+,A2-A3
    UNLK    A5
    RTS

;!======