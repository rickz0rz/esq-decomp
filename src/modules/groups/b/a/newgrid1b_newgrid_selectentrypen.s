    XDEF    _NEWGRID_SelectEntryPen


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_SelectEntryPen   (Select pen index for entry)
; ARGS:
;   stack +8: A3 = entry pointer
; RET:
;   D0: pen index (0..15)
; CLOBBERS:
;   D0-D2/D7/A3
; CALLS:
;   none
; READS:
;   _NEWGRID_GridOperationId, _GCOMMAND_NicheTextPen/_GCOMMAND_NicheFramePen/_GCOMMAND_MplexDetailLayoutPen/_GCOMMAND_MplexDetailRowPen, _GCOMMAND_PpvShowtimesLayoutPen, _GCOMMAND_PpvShowtimesRowPen, 27(A3), 41(A3), 42(A3)
; WRITES:
;   _NEWGRID_OverridePenIndex
; DESC:
;   Computes a pen index based on entry flags and current selection mode.
; NOTES:
;   Uses switch/jumptable lookups for default/override pen selection.
;------------------------------------------------------------------------------
_NEWGRID_SelectEntryPen:
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEQ   #0,D7
    MOVEQ   #0,D7
    NOT.B   D7
    MOVE.L  A3,D0
    BEQ.S   .pen_selected

    MOVEQ   #0,D0
    MOVE.B  41(A3),D0
    MOVEQ   #0,D1
    NOT.B   D1
    CMP.L   D1,D0
    BEQ.S   .check_flag_bit1

    MOVEQ   #0,D7
    MOVE.B  D0,D7
    BRA.S   .pen_selected

.check_flag_bit1:
    BTST    #1,27(A3)
    BEQ.S   .check_flag_bit6

    MOVEQ   #4,D7
    BRA.S   .pen_selected

.check_flag_bit6:
    BTST    #6,27(A3)
    BEQ.S   .check_flag_bit4

    MOVEQ   #5,D7
    BRA.S   .pen_selected

.check_flag_bit4:
    BTST    #4,27(A3)
    BEQ.S   .pen_selected

    MOVEQ   #7,D7

.pen_selected:
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D7
    BNE.S   .pen_ready

    MOVE.L  _NEWGRID_GridOperationId,D0
    SUBQ.L  #1,D0
    BLT.S   .out_of_range

    CMPI.L  #$7,D0
    BGE.S   .out_of_range

    ADD.W   D0,D0
    MOVE.W  .default_jumptable(PC,D0.W),D0
    JMP     .default_jumptable+2(PC,D0.W)

; switch/jumptable
.default_jumptable:
    DC.W    .out_of_range-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_default_pen-.default_jumptable-2
    DC.W    .case_pen_from_niche_frame_pen-.default_jumptable-2
    DC.W    .case_pen_from_mplex_detail_row_pen-.default_jumptable-2
    DC.W    .case_pen_from_ppv_showtimes_row_pen-.default_jumptable-2

.case_default_pen:
    MOVEQ   #6,D7
    BRA.S   .pen_ready

.case_pen_from_niche_frame_pen:
    MOVE.L  _GCOMMAND_NicheFramePen,D7
    BRA.S   .pen_ready

.case_pen_from_mplex_detail_row_pen:
    MOVE.L  _GCOMMAND_MplexDetailRowPen,D7
    BRA.S   .pen_ready

.case_pen_from_ppv_showtimes_row_pen:
    MOVE.L  _GCOMMAND_PpvShowtimesRowPen,D7
    BRA.S   .pen_ready

.out_of_range:
    MOVEQ   #7,D7

.pen_ready:
    TST.L   D7
    BMI.S   .pen_invalid

    MOVEQ   #15,D0
    CMP.L   D0,D7
    BLE.S   .pen_clamp_done

.pen_invalid:
    MOVEQ   #7,D7

.pen_clamp_done:
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,_NEWGRID_OverridePenIndex
    MOVE.L  A3,D1
    BEQ.S   .check_override

    MOVEQ   #0,D1
    MOVE.B  42(A3),D1
    CMP.L   D0,D1
    BEQ.S   .check_override

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D2,_NEWGRID_OverridePenIndex

.check_override:
    CMP.L   _NEWGRID_OverridePenIndex,D0
    BNE.S   .clamp_override

    MOVE.L  _NEWGRID_GridOperationId,D0
    SUBQ.L  #1,D0
    BLT.S   .override_default

    CMPI.L  #$7,D0
    BGE.S   .override_default

    ADD.W   D0,D0
    MOVE.W  .override_jumptable(PC,D0.W),D0
    JMP     .override_jumptable+2(PC,D0.W)

; switch/jumptable
.override_jumptable:
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_default-.override_jumptable-2
    DC.W    .override_niche_text_pen-.override_jumptable-2
    DC.W    .override_mplex_detail_layout_pen-.override_jumptable-2
    DC.W    .override_ppv_showtimes_layout_pen-.override_jumptable-2

.override_niche_text_pen:
    MOVE.L  _GCOMMAND_NicheTextPen,_NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_mplex_detail_layout_pen:
    MOVE.L  _GCOMMAND_MplexDetailLayoutPen,_NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_ppv_showtimes_layout_pen:
    MOVE.L  _GCOMMAND_PpvShowtimesLayoutPen,_NEWGRID_OverridePenIndex
    ; MOVE.L  Global_GCOMMAND_PpvShowtimesLayoutPen(A4),_NEWGRID_OverridePenIndex
    BRA.S   .clamp_override

.override_default:
    MOVEQ   #1,D0
    MOVE.L  D0,_NEWGRID_OverridePenIndex

.clamp_override:
    MOVE.L  _NEWGRID_OverridePenIndex,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BLT.S   .override_clamp_default

    MOVEQ   #3,D2
    CMP.L   D2,D0
    BLE.S   .done

.override_clamp_default:
    MOVE.L  D1,_NEWGRID_OverridePenIndex

.done:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    RTS

;!======