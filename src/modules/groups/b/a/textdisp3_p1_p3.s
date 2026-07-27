    XDEF    TEXTDISP_FormatEntryTimeForIndex


;------------------------------------------------------------------------------
; FUNC: TEXTDISP_FormatEntryTimeForIndex   (Format time using entry table)
; ARGS:
;   stack +8: outPtr (A3)
;   stack +14: entryIndex (word)
;   stack +16: entryTablePtr (A2)
; RET:
;   none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow, _MATH_DivS32, _MATH_Mulu32, _TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry
; READS:
;   entryTable+56, entryTable+498, _CLOCK_FormatVariantCode, _Global_REF_STR_CLOCK_FORMAT
; DESC:
;   Formats a time string for a given entry index using the provided table.
; NOTES:
;   Falls back to numeric minutes when no HH:MM text exists.
;------------------------------------------------------------------------------
TEXTDISP_FormatEntryTimeForIndex:
    LINK.W  A5,#-12
    MOVEM.L D5-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.L  D7,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVE.L  56(A2,D0.L),-4(A5)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  498(A2),D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D5
    TST.L   -4(A5)
    BEQ.W   .clear_output

    MOVEA.L -4(A5),A0
    TST.B   (A0)
    BEQ.W   .clear_output

    MOVEQ   #40,D0
    CMP.B   (A0),D0
    BNE.S   .format_minutes

    MOVEQ   #58,D0
    CMP.B   3(A0),D0
    BEQ.S   .parse_hhmm

.format_minutes:
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.parse_hhmm:
    MOVEQ   #0,D0
    MOVE.B  4(A0),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     _MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A0),D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  D5,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D5
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #30,D1
    JSR     _MATH_DivS32(PC)

    MOVEQ   #0,D0
    MOVE.B  _CLOCK_FormatVariantCode,D0
    MOVE.L  D1,24(A7)
    MOVEQ   #30,D1
    JSR     _MATH_DivS32(PC)

    MOVE.L  24(A7),D0
    CMP.L   D1,D0
    BGE.S   .round_hour

    ADDQ.W  #1,D5

.round_hour:
    MOVE.L  D6,D0
    EXT.L   D0
    DIVS    #$1e,D0
    SWAP    D0
    MOVE.L  D0,D6
    MOVEQ   #48,D0
    CMP.W   D0,D5
    BLE.S   .wrap_hour

    SUBI.W  #$30,D5

.wrap_hour:
    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L _Global_REF_STR_CLOCK_FORMAT,A0
    ADDA.L  D0,A0
    MOVEA.L (A0),A1
    MOVEA.L A3,A6

.copy_clock_format:
    MOVE.B  (A1)+,(A6)+
    BNE.S   .copy_clock_format

    MOVEQ   #0,D0
    MOVE.B  3(A3),D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVEQ   #10,D1
    JSR     _MATH_Mulu32(PC)

    MOVE.L  D6,D1
    EXT.L   D1
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     _MATH_DivS32(PC)

    MOVEQ   #48,D1
    ADD.L   D1,D0
    MOVE.B  D0,3(A3)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #10,D1
    JSR     _MATH_DivS32(PC)

    MOVEQ   #48,D0
    ADD.L   D0,D1
    MOVE.B  D1,4(A3)
    BRA.S   .return

.clear_output:
    CLR.B   (A3)

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======