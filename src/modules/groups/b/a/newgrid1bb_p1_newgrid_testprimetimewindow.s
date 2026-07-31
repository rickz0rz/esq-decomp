    XDEF    _NEWGRID_TestPrimeTimeWindow


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_TestPrimeTimeWindow   (Test primetime-window gate for row/index)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: 1 if in window, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   none
; READS:
;   48(A3)
; DESC:
;   Checks an entry flag and applies a time window test.
; NOTES:
;   Treats 'N'/'P' as mode hints and applies 18..22 window for 'P'.
;------------------------------------------------------------------------------
_NEWGRID_TestPrimeTimeWindow:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #0,D5
    MOVE.L  A3,D0
    BEQ.S   .return

    MOVEA.L 48(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.L  A0,D0
    BEQ.S   .return

    MOVE.B  1(A0),D6
    MOVE.B  D6,D0
    EXT.W   D0
    SUBI.W  #'N',D0 ; Does it equal 'N'?
    BEQ.S   .equalsN

    SUBQ.W  #('P'-'N'),D0 ; Does it equal 'P'?
    BEQ.S   .equalsP

    SUBI.W  #('n'-'P'),D0 ; Does it equal 'n'?
    BEQ.S   .equalsN

    SUBQ.W  #('p'-'n'),D0 ; Does it equal 'p'?
    BEQ.S   .equalsP

    BRA.S   .equalsNeither

.equalsN:
    MOVEQ   #0,D5
    BRA.S   .return

.equalsP:
    ; Is D7 less than 18?
    MOVEQ   #18,D0
    CMP.L   D0,D7
    BLE.S   .return

    ; Is D7 greater than 22?
    MOVEQ   #22,D0
    CMP.L   D0,D7
    BGE.S   .return

    ; If it's between 18 and 22 put 1 in D5 and return.
    MOVEQ   #1,D5
    BRA.S   .return

.equalsNeither:
    MOVEQ   #1,D5

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS
