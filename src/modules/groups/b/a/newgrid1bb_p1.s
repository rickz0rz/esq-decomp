    XDEF    _NEWGRID_TestEntrySelectable



;------------------------------------------------------------------------------
; FUNC: _NEWGRID_TestEntrySelectable   (Test whether entry is selectable under current mode)
; ARGS:
;   stack +8: A3 = entry header
;   stack +12: A2 = entry data
;   stack +16: D7 = mode selector (0/1)
; RET:
;   D0: 1 if selectable, 0 otherwise
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2
; READS:
;   27(A3), 40(A3)
; DESC:
;   Checks entry flags and mode rules to decide if selection is allowed.
;------------------------------------------------------------------------------
_NEWGRID_TestEntrySelectable:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVEA.L 24(A7),A2
    MOVE.L  28(A7),D7
    MOVEQ   #0,D6
    TST.L   D7
    BEQ.S   .check_args

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .return

.check_args:
    MOVE.L  A3,D0
    BEQ.S   .set_false

    MOVE.L  A2,D0
    BEQ.S   .set_false

    BTST    #7,40(A3)
    BEQ.S   .set_false

    TST.L   D7
    BNE.S   .check_mode1

    BTST    #2,27(A3)
    BNE.S   .set_true

.check_mode1:
    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .set_false

    MOVE.L  A3,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_TestEntryBits0And2(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .set_false

.set_true:
    MOVEQ   #1,D1
    BRA.S   .store_result

.set_false:
    MOVEQ   #0,D1

.store_result:
    MOVE.L  D1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======