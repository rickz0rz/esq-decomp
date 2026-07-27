    XDEF    _TLIBA2_FindLastCharInString


;------------------------------------------------------------------------------
; FUNC: _TLIBA2_FindLastCharInString   (FindLastCharInStringuncertain)
; ARGS:
;   stack +8: str (char *)
;   stack +12: targetChar (byte)
; RET:
;   D0: pointer to last match, or 0 if none
; CLOBBERS:
;   D0/D7/A0-A1/A3
; CALLS:
;   (none)
; READS:
;   str
; WRITES:
;   (none)
; DESC:
;   Scans to the end of str, then searches backward for targetChar.
; NOTES:
;   Returns 0 when no match is found.
;------------------------------------------------------------------------------
_TLIBA2_FindLastCharInString:
    LINK.W  A5,#-8
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  15(A5),D7
    CLR.L   -8(A5)
    MOVEA.L A3,A0

.if_ne_17D4:
    TST.B   (A0)+
    BNE.S   .if_ne_17D4

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D0
    MOVEA.L A3,A1
    ADDA.L  D0,A1
    SUBQ.L  #1,A1
    MOVE.L  A1,-4(A5)

.if_cc_17D5:
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    CMP.B   D7,D0
    BNE.S   .if_ne_17D6

    MOVE.L  A0,-8(A5)
    BRA.S   .skip_17D7

.if_ne_17D6:
    SUBQ.L  #1,-4(A5)
    MOVEA.L -4(A5),A0
    CMPA.L  A3,A0
    BCC.S   .if_cc_17D5

.skip_17D7:
    MOVE.L  -8(A5),D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======