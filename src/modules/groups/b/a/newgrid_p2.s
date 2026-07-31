    XDEF    _NEWGRID_AdjustClockStringBySlot
    XDEF    _NEWGRID_AdjustClockStringBySlotWithOffset
    XDEF    _NEWGRID_ComputeDaySlotFromClock
    XDEF    _NEWGRID_ComputeDaySlotFromClockWithOffset
    XDEF    _NEWGRID_DrawAwaitingListingsMessage


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawAwaitingListingsMessage   (Draw waiting banner)
; ARGS:
;   stack +8: A3 = base rastport/struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _LVOSetAPen, _LVOTextLength, _LVOMove, _NEWGRID_DrawWrappedText, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _NEWGRID_RowHeightPx, Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the “Awaiting Listings Data” banner centered in the grid area on a single line.
; NOTES:
;   Uses text length to center the string within the 624px region. Seemingly truncates text if it's longer than 624px.
;------------------------------------------------------------------------------
_NEWGRID_DrawAwaitingListingsMessage:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_DrawGridFrame

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    LEA     60(A3),A1
    MOVEA.L Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2

.measure_message:
    TST.B   (A2)+
    BNE.S   .measure_message

    SUBQ.L  #1,A2
    SUBA.L  Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2
    MOVE.L  A0,32(A7)
    MOVE.L  A2,D0

    ; Get the length of the Awaiting Listings Data text and subtract it from 624
    MOVEA.L Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A0
    JSR     _LVOTextLength(A6)

    MOVE.L  #624,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .length_ok     ; if positive, keep

    ADDQ.L  #1,D1                                           ; compensate negative

.length_ok:
    ASR.L   #1,D1                                           ; Shift D1 right 1
    MOVEQ   #36,D0                                          ; 36 into D0
    ADD.L   D0,D1                                           ; Add D0 (36) into D1
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    SUB.L   D2,D0
    TST.L   D0
    BPL.S   .center_y

    ADDQ.L  #1,D0

.center_y:
    ASR.L   #1,D0
    MOVEQ   #0,D2
    MOVE.W  26(A0),D2
    ADD.L   D2,D0
    SUBQ.L  #1,D0
    PEA     1.W
    MOVE.L  Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,-(A7)
    PEA     612.W
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  52(A7),-(A7)
    BSR.W   _NEWGRID_DrawWrappedText

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A7),A7
    MOVE.W  _NEWGRID_RowHeightPx,D0
    LSR.W   #1,D0

    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L (A7)+,D2/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ComputeDaySlotFromClock   (Compute day slot index)
; ARGS:
;   stack +8: A3 = clockdata struct
; RET:
;   D0: slot index (1..48) or 0 on invalid
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   _CONFIG_ModeCycleEnabledFlag, _NEWGRID_ModeCycleCountdown
; WRITES:
;   none
; DESC:
;   Copies clockdata, computes a slot index from date fields, and clamps to range.
; NOTES:
;   Returns 0 when month/day out of supported bounds.
;------------------------------------------------------------------------------
_NEWGRID_ComputeDaySlotFromClock:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEA.L A3,A0
    LEA     -26(A5),A1
    MOVEQ   #4,D0

.copy_clockdata:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_clockdata

    MOVE.W  (A0),(A1)
    PEA     -26(A5)
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVE.W  -16(A5),D0
    MOVEQ   #50,D1
    CMP.W   D1,D0
    BGE.S   .slot_in_supported_range

    MOVEQ   #20,D1
    CMP.W   D1,D0
    BLT.S   .return_slot_index

    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return_slot_index

.slot_in_supported_range:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return_slot_index

    MOVEQ   #1,D7

.return_slot_index:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_ComputeDaySlotFromClockWithOffset   (Compute slot with offset)
; ARGS:
;   stack +8: A3 = clockdata struct
; RET:
;   D0: slot index (1..48) or 0 on invalid
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   _GCOMMAND_MplexClockOffsetMinutes
; WRITES:
;   none
; DESC:
;   Computes a day slot index using a dynamic offset (_GCOMMAND_MplexClockOffsetMinutes) and clamps it.
; NOTES:
;   Similar to _NEWGRID_ComputeDaySlotFromClock but adjusts thresholds.
;------------------------------------------------------------------------------
_NEWGRID_ComputeDaySlotFromClockWithOffset:
    LINK.W  A5,#-28
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEA.L A3,A0
    LEA     -26(A5),A1
    MOVEQ   #4,D0

.copy_clockdata:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_clockdata

    MOVE.W  (A0),(A1)
    PEA     -26(A5)
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVEQ   #60,D0
    MOVE.L  _GCOMMAND_MplexClockOffsetMinutes,D1
    SUB.L   D1,D0
    MOVE.W  -16(A5),D2
    EXT.L   D2
    CMP.L   D0,D2
    BGE.S   .slot_in_supported_range

    MOVEQ   #30,D0
    SUB.L   D1,D0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BLT.S   .return_slot_index

    MOVE.W  -16(A5),D0
    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return_slot_index

.slot_in_supported_range:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return_slot_index

    MOVEQ   #1,D7

.return_slot_index:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AdjustClockStringBySlot   (Adjust clock string and validate)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds, _NEWGRID_JMPTBL_MATH_DivS32, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_DATETIME_SecondsToStruct, _NEWGRID_ComputeDaySlotFromClock
; READS:
;   _CLOCK_FormatVariantCode
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Copies clock string, converts it to slot seconds, and validates via slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
_NEWGRID_AdjustClockStringBySlot:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #21,D0
    MOVEA.L A3,A0
    LEA     -22(A5),A1

.copy_clocktext:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_clocktext
    PEA     -22(A5)
    JSR     _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #60,D0
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID_JMPTBL_DATETIME_SecondsToStruct(PC)

    PEA     -22(A5)
    BSR.W   _NEWGRID_ComputeDaySlotFromClock

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_AdjustClockStringBySlotWithOffset   (Adjust clock string with offset)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds, _NEWGRID_JMPTBL_MATH_DivS32, _NEWGRID_JMPTBL_MATH_Mulu32, _NEWGRID_JMPTBL_DATETIME_SecondsToStruct, _NEWGRID_ComputeDaySlotFromClockWithOffset
; READS:
;   _CLOCK_FormatVariantCode
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Like _NEWGRID_AdjustClockStringBySlot but uses the offset-based slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
_NEWGRID_AdjustClockStringBySlotWithOffset:
    LINK.W  A5,#-28
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3

    MOVEQ   #21,D0
    MOVEA.L A3,A0
    LEA     -22(A5),A1

.copy_clocktext:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_clocktext

    PEA     -22(A5)
    JSR     _NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #60,D0
    JSR     _NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     _NEWGRID_JMPTBL_DATETIME_SecondsToStruct(PC)

    PEA     -22(A5)
    BSR.W   _NEWGRID_ComputeDaySlotFromClockWithOffset

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======