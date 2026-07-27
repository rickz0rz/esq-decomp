    XDEF    _NEWGRID_InitSelectionWindow


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_InitSelectionWindow   (Initialize selection bounds and active row window)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +10: arg_2 (via 14(A5))
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode, _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex, SCRIPT3_JMPTBL_MATH_DivS32
; READS:
;   _TEXTDISP_PrimaryGroupEntryCount, _CLOCK_DaySlotIndex, _GCOMMAND_PpvSelectionWindowMinutes
; WRITES:
;   0(A3)..24(A3)
; DESC:
;   Initializes selection bounds and visible window values.
; NOTES:
;   Scans entries for bit #4 to seed min/max indices.
;------------------------------------------------------------------------------
_NEWGRID_InitSelectionWindow:
    LINK.W  A5,#-8
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.L  A3,D0
    BEQ.W   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)
    TST.W   D7
    BEQ.S   .default_bounds

    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D1
    MOVE.L  D1,12(A3)
    MOVE.L  D0,D6

.scan_forward:
    CMP.L   12(A3),D6
    BGE.S   .scan_forward_done

    PEA     1.W
    MOVE.L  D6,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .scan_forward_next

    MOVE.L  D6,12(A3)

.scan_forward_next:
    ADDQ.L  #1,D6
    BRA.S   .scan_forward

.scan_forward_done:
    MOVE.L  12(A3),16(A3)
    MOVEQ   #0,D6
    MOVE.W  _TEXTDISP_PrimaryGroupEntryCount,D6

.scan_reverse:
    CMP.L   16(A3),D6
    BLE.S   .store_row

    MOVE.L  D6,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    MOVEA.L D0,A0
    BTST    #4,47(A0)
    BEQ.S   .scan_reverse_next

    MOVE.L  D6,16(A3)

.scan_reverse_next:
    SUBQ.L  #1,D6
    BRA.S   .scan_reverse

.default_bounds:
    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVE.L  D0,16(A3)

.store_row:
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   .store_window

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   .offset_row

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .store_window

.offset_row:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

.store_window:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    MOVEQ   #29,D0
    ADD.L   _GCOMMAND_PpvSelectionWindowMinutes,D0
    MOVEQ   #30,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  20(A3),D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.W  D1,24(A3)
    MOVEQ   #96,D0
    CMP.W   D0,D1
    BLE.S   .clamp_done

    MOVE.W  D0,24(A3)

.clamp_done:
    ADDQ.W  #1,24(A3)

.return:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======