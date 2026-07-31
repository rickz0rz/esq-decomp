    XDEF    _NEWGRID_AdjustClockStringBySlot
    XDEF    _NEWGRID_AdjustClockStringBySlotWithOffset
    XDEF    _NEWGRID_ComputeDaySlotFromClock
    XDEF    _NEWGRID_ComputeDaySlotFromClockWithOffset


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