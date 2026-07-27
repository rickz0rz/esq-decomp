    XDEF    _NEWGRID_ClearEntryMarkerBits


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ClearEntryMarkerBits   (Clear bit-5 marker flags across eligible entries)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _TEXTDISP_SecondaryGroupEntryCount, _TEXTDISP_PrimaryGroupPresentFlag, _TEXTDISP_SecondaryGroupPresentFlag
; WRITES:
;   entry flag bytes (bit #5 cleared)
; DESC:
;   Walks entry lists and clears marker bits when entries are active.
;------------------------------------------------------------------------------
_NEWGRID_ClearEntryMarkerBits:
    LINK.W  A5,#-16
    MOVEM.L D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVEQ   #1,D0
    CMP.W   D0,D7
    BLE.S   .list2_init

    MOVEQ   #0,D6

.list1_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .list2_init

    TST.B   _TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .list2_init

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .list1_next

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

.list1_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   .list1_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   .list1_clear_flags

.list1_next:
    ADDQ.L  #1,D6
    BRA.S   .list1_loop

.list2_init:
    MOVEQ   #0,D6

.list2_loop:
    MOVEQ   #0,D0
    MOVE.W  _TEXTDISP_SecondaryGroupEntryCount,D0
    CMP.L   D0,D6
    BGE.S   .return

    TST.B   _TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .return

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .list2_next

    PEA     2.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    MOVE.L  D0,-8(A5)

.list2_clear_flags:
    MOVEQ   #49,D0
    CMP.L   D0,D5
    BGE.S   .list2_next

    MOVEA.L -8(A5),A0
    BCLR    #5,7(A0,D5.L)
    ADDQ.L  #1,D5
    BRA.S   .list2_clear_flags

.list2_next:
    ADDQ.L  #1,D6
    BRA.S   .list2_loop

.return:
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======