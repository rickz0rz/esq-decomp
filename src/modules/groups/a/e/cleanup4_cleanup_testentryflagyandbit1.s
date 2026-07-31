    XDEF    _CLEANUP_TestEntryFlagYAndBit1



;------------------------------------------------------------------------------
; FUNC: _CLEANUP_TestEntryFlagYAndBit1   (TestEntryFlagYAndBit1uncertain)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
;   stack +12: arg_3 (via 16(A5))
; RET:
;   D0: 0/1 result
; CLOBBERS:
;   D0-D1/D5-D7/A0-A3
; CALLS:
;   _COI_GetAnimFieldPointerByMode
; READS:
;   entryPtr+40 (bit 1), entry data at fieldOffset
; WRITES:
;   (none)
; DESC:
;   Looks up entry data for entryIndex and returns 1 if the selected byte
;   equals 'Y' and a flag bit is set in the entry.
; NOTES:
;   - Uses _COI_GetAnimFieldPointerByMode to resolve the entry record.
;------------------------------------------------------------------------------
_CLEANUP_TestEntryFlagYAndBit1:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    PEA     7.W
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   _COI_GetAnimFieldPointerByMode

    LEA     12(A7),A7
    MOVE.L  D0,-4(A5)
    BEQ.S   .return_false

    TST.L   D6
    BMI.S   .return_false

    MOVEQ   #5,D1
    CMP.L   D1,D6
    BGT.S   .return_false

    MOVEQ   #89,D0
    MOVEA.L -4(A5),A0
    CMP.B   0(A0,D6.L),D0
    BNE.S   .return_false

    BTST    #1,40(A3)
    BEQ.S   .return_false

    MOVEQ   #1,D0
    BRA.S   .done

.return_false:
    MOVEQ   #0,D0

.done:
    MOVE.L  D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======