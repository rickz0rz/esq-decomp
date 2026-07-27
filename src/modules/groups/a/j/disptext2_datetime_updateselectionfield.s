    XDEF    _DATETIME_UpdateSelectionField

;------------------------------------------------------------------------------
; FUNC: _DATETIME_UpdateSelectionField   (Update A3 based on time comparisonuncertain)
; ARGS:
;   stack +8: A3 = struct pointer
; RET:
;   D0: boolean changed
; CLOBBERS:
;   A3/A7/D0/D5/D6/D7
; CALLS:
;   _DATETIME_BuildFromGlobals, _DATETIME_ClassifyValueInRange
; READS:
;   A3+16
; WRITES:
;   A3+16
; DESC:
;   Recomputes a selection value and stores it if changed.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DATETIME_UpdateSelectionField:
    LINK.W  A5,#-32
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D6
    MOVE.L  A3,D0
    BEQ.S   .return

    PEA     -26(A5)
    BSR.W   _DATETIME_BuildFromGlobals

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _DATETIME_ClassifyValueInRange

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    MOVE.W  16(A3),D0
    CMP.W   D5,D0
    BEQ.S   .return

    MOVE.W  D5,16(A3)
    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======