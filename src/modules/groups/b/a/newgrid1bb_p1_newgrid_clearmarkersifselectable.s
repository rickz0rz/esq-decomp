    XDEF    _NEWGRID_ClearMarkersIfSelectable


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ClearMarkersIfSelectable   (Clear markers if selectable)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _NEWGRID_TestEntrySelectable
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_SecondaryGroupPresentFlag
; WRITES:
;   entry flag bytes (bit #5 cleared)
; DESC:
;   Clears marker bits for entries that pass selection checks.
;------------------------------------------------------------------------------
_NEWGRID_ClearMarkersIfSelectable:
    LINK.W  A5,#-16
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.W  14(A5),D6
    MOVEQ   #1,D0
    CMP.W   D0,D6
    BLE.S   .list1_done

    MOVEQ   #0,D5

.list1_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .list1_done

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list1_done

    PEA     1.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     1.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   _NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list1_next

    MOVEQ   #1,D4

.list1_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list1_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list1_clear_flags

.list1_next:
    ADDQ.L  #1,D5
    BRA.S   .list1_loop

.list1_done:
    MOVEQ   #0,D5

.list2_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D5
    BGE.S   .return

    TST.B   _TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D5,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    PEA     2.W
    MOVE.L  D5,-(A7)
    MOVE.L  D0,-4(A5)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    MOVE.L  D7,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-8(A5)
    BSR.W   _NEWGRID_TestEntrySelectable

    LEA     24(A7),A7
    TST.L   D0
    BEQ.S   .list2_next

    MOVEQ   #1,D4

.list2_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D4
    BGE.S   .list2_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D4.L)
    ADDQ.L  #1,D4
    BRA.S   .list2_clear_flags

.list2_next:
    ADDQ.L  #1,D5
    BRA.S   .list2_loop

.return:
    MOVEM.L (A7)+,D4-D7
    UNLK    A5
    RTS

;!======