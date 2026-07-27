    XDEF    _ESQSHARED_MatchSelectionCodeWithOptionalSuffix
    XDEF    ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return


;------------------------------------------------------------------------------
; FUNC: _ESQSHARED_MatchSelectionCodeWithOptionalSuffix   (Match selection code with optional suffix wildcard)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +5: arg_2 (via 9(A5))
;   stack +6: arg_3 (via 10(A5))
;   stack +22: arg_4 (via 26(A5))
;   stack +26: arg_5 (via 30(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _ESQSHARED_JMPTBL_ESQ_WildcardMatch
; READS:
;   _ESQ_SelectCodeBuffer, _ESQ_STR_A, _ESQPARS_SelectionSuffixBuffer
; WRITES:
;   (none observed)
; DESC:
;   Parses a selection token with optional '.' suffix split, wildcard-matches the
;   base code against _ESQ_SelectCodeBuffer, and optionally matches suffix text
;   against _ESQPARS_SelectionSuffixBuffer before returning boolean success.
; NOTES:
;   Requires fallback marker char (-9(A5)) to remain default for success.
;------------------------------------------------------------------------------
_ESQSHARED_MatchSelectionCodeWithOptionalSuffix:
    LINK.W  A5,#-32
    MOVEM.L D4-D7/A3,-(A7)

    MOVEA.L 8(A5),A3

    CLR.B   -10(A5)
    MOVE.B  _ESQ_STR_A,D0
    MOVEQ   #0,D6
    MOVE.B  D0,-8(A5)
    MOVE.B  D0,-9(A5)

.branch:
    MOVE.B  (A3)+,D4
    TST.B   D4
    BEQ.S   .lab_0C13

    MOVEQ   #0,D0
    MOVE.B  D4,D0
    SUBI.W  #$2e,D0
    BEQ.S   .lab_0C0F

    SUBI.W  #12,D0
    BNE.S   .lab_0C10

    MOVE.B  -8(A5),D0
    MOVEQ   #63,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C0C

    MOVEQ   #42,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C0C

    TST.W   D6
    BNE.S   .lab_0C0D

.lab_0C0C:
    MOVE.B  _ESQ_STR_A,-9(A5)
    BRA.S   .branch_1

.lab_0C0D:
    MOVE.B  D0,-9(A5)

.branch_1:
    MOVEQ   #0,D6
    BRA.S   .branch

.lab_0C0F:
    CLR.B   -26(A5,D6.W)
    MOVE.B  #$1,-10(A5)
    MOVEQ   #0,D6
    BRA.S   .branch

.lab_0C10:
    MOVE.B  D4,-8(A5)
    TST.B   -10(A5)
    BEQ.S   .branch_2

    MOVE.B  D4,-30(A5,D6.W)
    BRA.S   .branch_3

.branch_2:
    MOVE.B  D4,-26(A5,D6.W)

.branch_3:
    ADDQ.W  #1,D6
    BRA.S   .branch

.lab_0C13:
    TST.B   -10(A5)
    BEQ.S   .branch_4

    MOVEQ   #0,D0
    MOVE.B  D0,-30(A5,D6.W)
    BRA.S   .branch_5

.branch_4:
    CLR.B   -26(A5,D6.W)

.branch_5:
    LEA     -26(A5),A0
    MOVEA.L A0,A1

.branch_6:
    TST.B   (A1)+
    BNE.S   .branch_6

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    BNE.S   .branch_7

    MOVEQ   #-1,D7
    BRA.S   .branch_8

.branch_7:
    MOVE.L  A0,-(A7)
    PEA     _ESQ_SelectCodeBuffer
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D7
    EXT.W   D7

.branch_8:
    MOVEQ   #0,D5
    MOVEQ   #1,D0
    CMP.B   -10(A5),D0
    BNE.S   .branch_9

    PEA     -30(A5)
    PEA     _ESQPARS_SelectionSuffixBuffer
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    MOVE.B  D0,D5
    EXT.W   D5

.branch_9:
    TST.W   D7
    BNE.S   .branch_10

    TST.W   D5
    BNE.S   .branch_10

    MOVE.B  _ESQ_STR_A,D0
    MOVE.B  -9(A5),D1
    CMP.B   D0,D1
    BNE.S   .branch_10

    MOVEQ   #1,D0
    BRA.S   ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return

.branch_10:
    MOVEQ   #0,D0

;------------------------------------------------------------------------------
; FUNC: ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return   (Return tail for selection-code matcher)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D4
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Shared return tail for _ESQSHARED_MatchSelectionCodeWithOptionalSuffix.
; NOTES:
;   Restores D4-D7/A3 and frame state.
;------------------------------------------------------------------------------
ESQSHARED_MatchSelectionCodeWithOptionalSuffix_Return:
    MOVEM.L (A7)+,D4-D7/A3
    UNLK    A5
    RTS

;!======