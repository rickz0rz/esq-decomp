    XDEF    NEWGRID_MapSelectionToMode


;------------------------------------------------------------------------------
; FUNC: NEWGRID_MapSelectionToMode   (Map selection index to mode)
; ARGS:
;   stack +8: D7 = selection index
;   stack +12: D6 = mode argument
; RET:
;   D0: mapped mode id
; CLOBBERS:
;   D0-D7
; CALLS:
;   _NEWGRID_IsGridReadyForInput (_NEWGRID_IsGridReadyForInput), _NEWGRID_SelectNextMode (_NEWGRID_SelectNextMode)
; READS:
;   _GCOMMAND_NicheModeCycleCount/_GCOMMAND_NicheForceMode5Flag
; WRITES:
;   _GCOMMAND_NicheModeCycleCount (cleared when case 0x3E hit)
; DESC:
;   Uses a switch/jumptable to map selection indices to mode IDs and gates
;   certain modes based on flags and readiness checks.
; NOTES:
;   Returns 0 when input is out of range.
;------------------------------------------------------------------------------
NEWGRID_MapSelectionToMode:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.W  18(A7),D6
    MOVE.L  D7,D0
    CMPI.L  #$d,D0
    BCC.S   .selection_out_of_range

    ADD.W   D0,D0
    MOVE.W  .switch_selection_jumptable(PC,D0.W),D0
    JMP     .switch_selection_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_selection_jumptable:
    DC.W    .case_sel_0-.switch_selection_jumptable-2
    DC.W    .case_sel_1-.switch_selection_jumptable-2
    DC.W    .case_sel_2-.switch_selection_jumptable-2
    DC.W    .case_sel_3-.switch_selection_jumptable-2
    DC.W    .case_sel_4-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_5-.switch_selection_jumptable-2
    DC.W    .case_sel_6-.switch_selection_jumptable-2
    DC.W    .case_sel_0-.switch_selection_jumptable-2

.case_sel_0:
    MOVEQ   #1,D7
    BRA.S   .return_mapped_mode

.case_sel_1:
    MOVEQ   #2,D7
    BRA.S   .return_mapped_mode

.case_sel_2:
    MOVEQ   #3,D7
    BRA.S   .return_mapped_mode

.case_sel_3:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   _NEWGRID_IsGridReadyForInput

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .case_sel_3_fallback_mode4

    MOVEQ   #11,D0
    BRA.S   .case_sel_3_store_mode

.case_sel_3_fallback_mode4:
    MOVEQ   #4,D0

.case_sel_3_store_mode:
    MOVE.L  D0,D7
    BRA.S   .return_mapped_mode

.case_sel_4:
    TST.L   _GCOMMAND_NicheForceMode5Flag
    BEQ.S   .case_sel_5

    MOVEQ   #5,D7
    CLR.L   _GCOMMAND_NicheModeCycleCount
    BRA.S   .return_mapped_mode

.case_sel_5:
    BSR.W   _NEWGRID_SelectNextMode

    MOVE.L  D0,D7
    BRA.S   .return_mapped_mode

.case_sel_6:
    MOVEQ   #1,D7
    BRA.S   .return_mapped_mode

.selection_out_of_range:
    MOVEQ   #0,D7

.return_mapped_mode:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======