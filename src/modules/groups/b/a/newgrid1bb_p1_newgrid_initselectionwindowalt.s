    XDEF    _NEWGRID_InitSelectionWindowAlt


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_InitSelectionWindowAlt   (Init selection window alt)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   _CLOCK_DaySlotIndex, _CONFIG_NewgridWindowSpanHalfHoursPrimary, _CONFIG_NewgridWindowSpanHalfHoursAlt
; WRITES:
;   0(A3)..24(A3)
; DESC:
;   Initializes selection bounds using an alternate mode offset.
;------------------------------------------------------------------------------
_NEWGRID_InitSelectionWindowAlt:
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVE.L  28(A7),D6
    MOVE.L  A3,D0
    BEQ.S   .return

    SUBA.L  A0,A0
    MOVE.L  A0,(A3)
    MOVE.L  A0,4(A3)
    CLR.L   8(A3)
    MOVE.W  D7,20(A3)
    MOVEQ   #48,D0
    CMP.W   D0,D7
    BGE.S   .compute_bounds

    MOVEQ   #1,D0
    CMP.W   D0,D7
    BEQ.S   .adjust_row

    PEA     _CLOCK_DaySlotIndex
    JSR     _NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    SUBQ.W  #1,D0
    BNE.S   .compute_bounds

.adjust_row:
    MOVEQ   #48,D0
    ADD.W   D0,20(A3)

.compute_bounds:
    MOVE.W  20(A3),D0
    MOVE.W  D0,22(A3)
    TST.L   D6
    BNE.S   .mode_offset

    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursPrimary,D0
    EXT.W   D0
    EXT.L   D0
    BRA.S   .mode_offset_done

.mode_offset:
    MOVE.B  _CONFIG_NewgridWindowSpanHalfHoursAlt,D0
    EXT.W   D0
    EXT.L   D0

.mode_offset_done:
    MOVE.L  D0,D5
    MOVE.W  20(A3),D0
    EXT.L   D0
    ADD.L   D5,D0
    MOVE.W  D0,24(A3)
    MOVEQ   #96,D1
    CMP.W   D1,D0
    BLE.S   .clamp_end

    MOVE.W  D1,24(A3)

.clamp_end:
    ADDQ.W  #1,24(A3)

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======