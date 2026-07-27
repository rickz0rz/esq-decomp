    XDEF    ESQSHARED_ParseCompactEntryRecord




;------------------------------------------------------------------------------
; FUNC: ESQSHARED_ParseCompactEntryRecord   (Parse compact entry record and apply by title)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +11: arg_2 (via 15(A5))
;   stack +36: arg_3 (via 40(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A3/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQSHARED_UpdateMatchingEntriesByTitle
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Parses compact record fields (group/type/title/key byte) and forwards update
;   payload to ESQSHARED_UpdateMatchingEntriesByTitle.
; NOTES:
;   Title field is read up to delimiter 0x12 (or 8 bytes max) before dispatch.
;------------------------------------------------------------------------------
ESQSHARED_ParseCompactEntryRecord:
    LINK.W  A5,#-16
    MOVEM.L D2/D4-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.B  (A3)+,D6
    MOVE.B  (A3)+,D5
    MOVEQ   #0,D7

.branch:
    MOVE.B  (A3)+,D0
    MOVE.B  D0,-15(A5,D7.W)
    MOVEQ   #18,D1
    CMP.B   D1,D0
    BEQ.S   .lab_0C09

    MOVEQ   #8,D0
    CMP.W   D0,D7
    BGE.S   .lab_0C09

    ADDQ.W  #1,D7
    BRA.S   .branch

.lab_0C09:
    CLR.B   -15(A5,D7.W)
    MOVE.B  (A3)+,D4
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D4,D2
    MOVE.L  A3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -15(A5)
    BSR.W   ESQSHARED_UpdateMatchingEntriesByTitle

    MOVEM.L -40(A5),D2/D4-D7/A3
    UNLK    A5
    RTS

;!======