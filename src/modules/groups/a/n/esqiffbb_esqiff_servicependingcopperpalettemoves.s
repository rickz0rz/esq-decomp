    XDEF    _ESQIFF_ServicePendingCopperPaletteMoves


;------------------------------------------------------------------------------
; FUNC: _ESQIFF_ServicePendingCopperPaletteMoves   (Service pending copper index moves for four accumulator rows)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A4/A7/D0/D1
; CALLS:
;   _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd, _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _ACCUMULATOR_Row0_SaturateFlag, _ACCUMULATOR_Row1_SaturateFlag, _ACCUMULATOR_Row2_SaturateFlag, _ACCUMULATOR_Row3_SaturateFlag, _WDISP_AccumulatorRow0_MoveFlags, _WDISP_AccumulatorRow0_CopperIndexStart, _WDISP_AccumulatorRow0_CopperIndexEnd, _WDISP_AccumulatorRow1_MoveFlags, _WDISP_AccumulatorRow1_CopperIndexStart, _WDISP_AccumulatorRow1_CopperIndexEnd, _WDISP_AccumulatorRow2_MoveFlags, _WDISP_AccumulatorRow2_CopperIndexStart, _WDISP_AccumulatorRow2_CopperIndexEnd, _WDISP_AccumulatorRow3_MoveFlags, _WDISP_AccumulatorRow3_CopperIndexStart, _WDISP_AccumulatorRow3_CopperIndexEnd
; WRITES:
;   _ACCUMULATOR_Row0_SaturateFlag, _ACCUMULATOR_Row1_SaturateFlag, _ACCUMULATOR_Row2_SaturateFlag, _ACCUMULATOR_Row3_SaturateFlag
; DESC:
;   Checks per-row move countdown words and, when armed, steps the configured
;   copper index range toward start or end for rows 0..3.
; NOTES:
;   Uses move-flag bit1 as direction: set=toward end, clear=toward start.
;------------------------------------------------------------------------------
_ESQIFF_ServicePendingCopperPaletteMoves:
    MOVE.L  A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    MOVE.W  _ACCUMULATOR_Row0_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row1_pending_move

    TST.W   _WDISP_AccumulatorRow0_MoveFlags
    BEQ.S   .service_row1_pending_move

    CLR.W   _ACCUMULATOR_Row0_SaturateFlag
    MOVE.W  _WDISP_AccumulatorRow0_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row0_toward_start

    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row1_pending_move

.move_row0_toward_start:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow0_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row1_pending_move:
    MOVE.W  _ACCUMULATOR_Row1_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row2_pending_move

    TST.W   _WDISP_AccumulatorRow1_MoveFlags
    BEQ.S   .service_row2_pending_move

    CLR.W   _ACCUMULATOR_Row1_SaturateFlag
    MOVE.W  _WDISP_AccumulatorRow1_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row1_toward_start

    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row2_pending_move

.move_row1_toward_start:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow1_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row2_pending_move:
    MOVE.W  _ACCUMULATOR_Row2_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .service_row3_pending_move

    TST.W   _WDISP_AccumulatorRow2_MoveFlags
    BEQ.S   .service_row3_pending_move

    CLR.W   _ACCUMULATOR_Row2_SaturateFlag
    MOVE.W  _WDISP_AccumulatorRow2_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row2_toward_start

    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .service_row3_pending_move

.move_row2_toward_start:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow2_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.service_row3_pending_move:
    MOVE.W  _ACCUMULATOR_Row3_SaturateFlag,D0
    SUBQ.W  #1,D0
    BNE.S   .return_service_pending_copper_moves

    TST.W   _WDISP_AccumulatorRow3_MoveFlags
    BEQ.S   .return_service_pending_copper_moves

    CLR.W   _ACCUMULATOR_Row3_SaturateFlag
    MOVE.W  _WDISP_AccumulatorRow3_MoveFlags,D0
    BTST    #1,D0
    BEQ.S   .move_row3_toward_start

    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardEnd(PC)

    ADDQ.W  #8,A7
    BRA.S   .return_service_pending_copper_moves

.move_row3_toward_start:
    MOVEQ   #0,D0
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexStart,D0
    MOVEQ   #0,D1
    MOVE.B  _WDISP_AccumulatorRow3_CopperIndexEnd,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _ESQIFF_JMPTBL_ESQ_MoveCopperEntryTowardStart(PC)

    ADDQ.W  #8,A7

.return_service_pending_copper_moves:
    MOVEA.L (A7)+,A4
    RTS

;!======