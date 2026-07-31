    XDEF    _CLEANUP_FormatClockFormatEntry



;------------------------------------------------------------------------------
; FUNC: _CLEANUP_FormatClockFormatEntry   (FormatClockFormatEntryuncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1/D6-D7/A0-A3
; CALLS:
;   _GROUP_AG_JMPTBL_MATH_DivS32, _GROUP_AG_JMPTBL_MATH_Mulu32
; READS:
;   _CLOCK_FormatVariantCode, _Global_REF_STR_CLOCK_FORMAT
; WRITES:
;   outText buffer (A3)
; DESC:
;   Copies a clock-format string for slotIndex into outText and optionally
;   adjusts two digit positions based on _CLOCK_FormatVariantCode.
; NOTES:
;   - Wraps slotIndex by subtracting 48 until within range.
;------------------------------------------------------------------------------
_CLEANUP_FormatClockFormatEntry:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVE.L  20(A7),D7
    MOVEA.L 24(A7),A3

.wrap_slot_index_loop:
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .slot_index_ready

    SUB.L   D0,D7
    BRA.S   .wrap_slot_index_loop

.slot_index_ready:
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D1,D6
    MOVE.L  D7,D0
    ASL.L   #2,D0
    MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A2

.copy_format_loop:
    MOVE.B  (A1)+,(A2)+
    BNE.S   .copy_format_loop

    TST.L   D6
    BLE.S   .done

    MOVE.B  3(A3),D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    ADD.L   D0,D6
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    MOVEQ   #10,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)

.done:
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======