    XDEF    _NEWGRID_Apply24HourFormatting


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_Apply24HourFormatting   (Patch time string for 24h)
; ARGS:
;   stack +8: A3 = string pointer
;   stack +12: D7 = hour index
;   stack +19: D6 = minute index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _PARSEINI_JMPTBL_STR_FindCharPtr, _NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow
; READS:
;   _Global_REF_STR_USE_24_HR_CLOCK, _Global_JMPTBL_HALF_HOURS_24_HR_FMT
; WRITES:
;   A3 string contents
; DESC:
;   If 24-hour clock flag is set and format matches, updates HH:MM digits in-place.
; NOTES:
;   Expects string with ':' at offset 3.
;------------------------------------------------------------------------------
_NEWGRID_Apply24HourFormatting:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.W  14(A5),D7
    MOVE.B  19(A5),D6
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .done

    MOVE.L  A3,D0
    BEQ.S   .done

    PEA     40.W
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.S   .done

    MOVEQ   #58,D0
    MOVEA.L -4(A5),A0
    CMP.B   3(A0),D0
    BNE.S   .done

    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,1(A0)
    MOVE.L  D7,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D6,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    LEA     _Global_JMPTBL_HALF_HOURS_24_HR_FMT,A0
    ADDA.L  D1,A0
    MOVEA.L (A0),A1
    ADDQ.L  #1,A1
    MOVE.B  (A1),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,2(A0)

.done:
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======