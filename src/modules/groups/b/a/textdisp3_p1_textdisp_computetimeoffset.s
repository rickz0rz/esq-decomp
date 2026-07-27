    XDEF    _TEXTDISP_ComputeTimeOffset


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_ComputeTimeOffset   (Compute time offset in minutes)
; ARGS:
;   stack +10: index (word)
;   stack +12: entryPtr (A3)
;   stack +18: value (word)
; RET:
;   D0: offsetMinutes
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow, _TLIBA2_ComputeBroadcastTimeWindow, _MATH_DivS32, _MATH_Mulu32
; READS:
;   _CLOCK_CurrentMonthIndex/2276/2277
; DESC:
;   Computes a time offset (minutes) based on entry data and current time.
;------------------------------------------------------------------------------
_TEXTDISP_ComputeTimeOffset:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A3,-(A7)
    MOVE.W  10(A5),D7
    MOVEA.L 12(A5),A3
    MOVE.W  18(A5),D6
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D6,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.B  498(A3),D3
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D0,36(A7)
    MOVE.L  D1,40(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    EXT.L   D0
    PEA     -8(A5)
    PEA     -20(A5)
    MOVE.L  D0,-(A7)
    MOVE.L  52(A7),-(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  56(A7),-(A7)
    JSR     _TLIBA2_ComputeBroadcastTimeWindow(PC)

    LEA     32(A7),A7
    MOVE.W  _CLOCK_CurrentYearValue,D0
    EXT.L   D0
    MOVE.L  -20(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    TST.L   D4
    BNE.S   .fallback_offset_1

    MOVE.W  _CLOCK_CurrentMonthIndex,D0
    EXT.L   D0
    MOVE.L  -16(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

.fallback_offset_1:
    TST.L   D4
    BNE.S   .fallback_offset_2

    MOVE.W  _CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.L  -12(A5),D1
    SUB.L   D0,D1
    MOVE.L  D1,D4

.fallback_offset_2:
    MOVE.L  -8(A5),D0
    MOVEQ   #60,D1
    JSR     _MATH_Mulu32(PC)

    ADD.L   -4(A5),D0
    MOVE.L  D0,D5
    MOVE.W  _Global_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     _MATH_DivS32(PC)

    TST.W   _CLOCK_CurrentAmPmFlag
    BEQ.S   .use_zero_bias

    MOVEQ   #12,D0
    BRA.S   .apply_hour_bias

.use_zero_bias:
    MOVEQ   #0,D0

.apply_hour_bias:
    ADD.L   D0,D1
    MOVEQ   #60,D0
    JSR     _MATH_Mulu32(PC)

    MOVE.W  _Global_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    ADD.L   D1,D0
    SUB.L   D0,D5
    MOVE.L  D4,D0
    MOVE.L  #$5a0,D1
    JSR     _MATH_Mulu32(PC)

    ADD.L   D0,D5
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS

;!======