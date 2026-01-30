;!======
;------------------------------------------------------------------------------
; FUNC: NEWGRID_InitGridResources   (Initialize grid rastports and layout)
; ARGS:
;   (none)
; RET:
;   D0: none (implicit via globals)
; CLOBBERS:
;   D0-D3/A0-A1/A6
; CALLS:
;   LAB_1333, LAB_1026, LAB_1240, JMP_TBL_ALLOCATE_MEMORY_3, _LVOInitRastPort,
;   _LVOSetDrMd, _LVOSetFont, DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7,
;   _LVOTextLength, JMP_TBL_LAB_1A07_3
; READS:
;   LAB_1FFE, GLOB_HANDLE_PREVUEC_FONT, GLOB_STR_44_44_44
; WRITES:
;   LAB_1FFE, GLOB_REF_GRID_RASTPORT_MAYBE_1/2, LAB_2328-232B
; DESC:
;   Allocates two RastPorts, attaches bitmaps/fonts, and computes layout metrics
;   for the grid header/banner area.
; NOTES:
;   Early-outs if already initialized (LAB_1FFE != 0) or allocation fails.
;------------------------------------------------------------------------------
NEWGRID_InitGridResources:
LAB_0FA4:
    TST.W   LAB_1FFE
    BNE.W   .return

    MOVE.W  #1,LAB_1FFE
    JSR     LAB_1333(PC)

    JSR     LAB_1026(PC)

    JSR     LAB_1240(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     99.W
    PEA     GLOB_STR_NEWGRID_C_1
    JSR     JMP_TBL_ALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7
    MOVE.L  D0,GLOB_REF_GRID_RASTPORT_MAYBE_1
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A0
    MOVE.L  #GLOB_REF_696_400_BITMAP,4(A0)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     112.W
    PEA     GLOB_STR_NEWGRID_C_2
    JSR     JMP_TBL_ALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7
    MOVE.L  D0,GLOB_REF_GRID_RASTPORT_MAYBE_2
    TST.L   D0
    BEQ.W   .return

    MOVEA.L D0,A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A0
    MOVE.L  #LAB_221F,4(A0)
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEA.L GLOB_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

    MOVEQ   #8,D0
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    LEA     GLOB_STR_44_44_44,A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  D0,LAB_2329
    ADDI.W  #12,D0
    MOVE.W  D0,LAB_232A
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  #624,D0
    SUB.L   D1,D0
    MOVEQ   #3,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVE.W  D0,LAB_232B
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    SUBQ.L  #1,D0
    ADD.L   D0,D0
    ADDQ.L  #8,D0
    MOVE.W  D0,LAB_2328
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    TST.L   D1
    BEQ.S   .align_even

    MOVE.W  LAB_2328,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,LAB_2328

.align_even:
    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

.return:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ShutdownGridResources   (Free grid rastports and reset state)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/A0/A6
; CALLS:
;   JMP_TBL_DEALLOCATE_MEMORY_3, LAB_1335, LAB_1023, LAB_1243
; READS:
;   GLOB_REF_GRID_RASTPORT_MAYBE_1
; WRITES:
;   GLOB_REF_GRID_RASTPORT_MAYBE_1, LAB_1FFE
; DESC:
;   Frees the grid rastport allocation and resets grid state flags.
; NOTES:
;   Always clears LAB_1FFE and triggers dependent cleanup routines.
;------------------------------------------------------------------------------
NEWGRID_ShutdownGridResources:
LAB_0FA7:
    TST.L   GLOB_REF_GRID_RASTPORT_MAYBE_1
    BEQ.S   .skip_free

    PEA     100.W
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_1,-(A7)
    PEA     148.W
    PEA     GLOB_STR_NEWGRID_C_3
    JSR     JMP_TBL_DEALLOCATE_MEMORY_3(PC)

    LEA     16(A7),A7

.skip_free:
    JSR     LAB_1335(PC)

    JSR     LAB_1023(PC)

    CLR.W   LAB_1FFE
    JSR     LAB_1243(PC)

    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ClearHighlightArea   (Clear highlight overlay region)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A6
; CALLS:
;   _LVODisable/_LVOEnable, GCOMMAND_ResetHighlightMessages, _LVOSetAPen, _LVORectFill
; READS:
;   LAB_225F
; WRITES:
;   none
; DESC:
;   Resets highlight message state and fills the highlight area if inactive.
; NOTES:
;   Uses Exec Disable/Enable around message reset.
;------------------------------------------------------------------------------
NEWGRID_ClearHighlightArea:
LAB_0FA9:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    JSR     GCOMMAND_ResetHighlightMessages(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    TST.L   LAB_225F
    BNE.S   .return

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,68 to 695,267
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_1,A1
    MOVEQ   #0,D0
    MOVEQ   #68,D1
    MOVE.L  #695,D2
    MOVE.L  #267,D3
    JSR     _LVORectFill(A6)

.return:
    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_IsGridReadyForInput   (Check gating flags)
; ARGS:
;   stack +8: D7 = mode selector??
; RET:
;   D0: 1 if allowed, 0 if blocked
; CLOBBERS:
;   D0-D1/D6-D7
; CALLS:
;   none
; READS:
;   LAB_222E/LAB_222F, LAB_224A/LAB_2231
; WRITES:
;   none
; DESC:
;   Checks multiple gating flags and counters to decide if input/action is allowed.
; NOTES:
;   Returns 0 when either gate is active with a positive counter.
;------------------------------------------------------------------------------
NEWGRID_IsGridReadyForInput:
LAB_0FAB:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .check_second_gate

    TST.B   LAB_222E
    BEQ.S   .allow

    MOVE.W  LAB_222F,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow

.check_second_gate:
    TST.B   LAB_224A
    BEQ.S   .allow

    MOVE.W  LAB_2231,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow

    MOVEQ   #0,D0
    BRA.S   .return

.allow:
    MOVEQ   #1,D0

.return:
    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: NEWGRID_SelectNextMode   (Advance grid mode selection??)
; ARGS:
;   stack +8: D7 = desired mode index??
; RET:
;   D0: selected mode (or 12 sentinel)
; CLOBBERS:
;   D0-D7
; CALLS:
;   NEWGRID_IsGridReadyForInput (LAB_0FAB)
; READS:
;   LAB_1BB7, LAB_1BBE, LAB_2003-200A, LAB_1BA4/1BA5/1BAD,
;   LAB_22D1/22D2/22D6/22E5, LAB_224A/2231/222E/222F
; WRITES:
;   LAB_2003-200A
; DESC:
;   Cycles through candidate grid modes based on current day/state and
;   gating flags, returning the next valid mode.
; NOTES:
;   Uses two switch/jumptable blocks to select flag sources and timers.
;------------------------------------------------------------------------------
NEWGRID_SelectNextMode:
LAB_0FAF:
    LINK.W  A5,#-40
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D5
    LEA     LAB_200B,A0
    LEA     -38(A5),A1
    MOVEQ   #6,D0

.copy_mode_table:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_mode_table
    MOVE.B  LAB_1BB7,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .select_next_slot

    MOVE.L  LAB_1BBE,D0
    TST.L   D0
    BLE.S   .force_select_current

    MOVE.L  LAB_2003,D1
    TST.L   D1
    BGT.S   .decrement_cycle_counter

    MOVE.L  LAB_200A,D7
    MOVE.L  D0,LAB_2003
    BRA.S   .select_next_slot

.decrement_cycle_counter:
    SUBQ.L  #1,LAB_2003
    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.S   .select_next_slot

.force_select_current:
    MOVEQ   #12,D6
    MOVEQ   #1,D5

.select_next_slot:
    TST.W   D5
    BNE.W   .return

    MOVE.L  LAB_200A,D0
    ASL.L   #2,D0
    MOVE.L  -38(A5,D0.L),D6
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BNE.S   .advance_slot_index

    MOVEQ   #0,D0
    MOVE.L  D0,LAB_200A
    BRA.S   .check_mode_group

.advance_slot_index:
    ADDQ.L  #1,LAB_200A

.check_mode_group:
    MOVE.B  LAB_1BB7,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .switch_group2_entry

    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .check_cycle_match

    CMPI.L  #$8,D0
    BGE.W   .check_cycle_match

    ADD.W   D0,D0
    MOVE.W  .switch_group1_jumptable(PC,D0.W),D0
    JMP     .switch_group1_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_group1_jumptable:
    DC.W    .case_group1_0-.switch_group1_jumptable-2
    DC.W    .case_group1_1-.switch_group1_jumptable-2
    DC.W    .case_group1_2-.switch_group1_jumptable-2
    DC.W    .case_group1_3-.switch_group1_jumptable-2
    DC.W    .case_group1_4-.switch_group1_jumptable-2
    DC.W    .case_group1_5-.switch_group1_jumptable-2
    DC.W    .case_group1_default-.switch_group1_jumptable-2
    DC.W    .case_group1_default-.switch_group1_jumptable-2

.case_group1_1:
    MOVE.B  LAB_1BA4,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .check_cycle_match

.case_group1_2:
    MOVE.B  LAB_1BA5,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .check_cycle_match

.case_group1_3:
    MOVE.B  LAB_1BAD,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .check_cycle_match

.case_group1_0:
    TST.L   LAB_22D1
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .check_cycle_match

.case_group1_4:
    TST.L   LAB_22D6
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .check_cycle_match

.case_group1_5:
    TST.L   LAB_22E5
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5

.case_group1_default:
.check_cycle_match:
    TST.W   D5
    BNE.W   .select_next_slot

    MOVE.L  LAB_200A,D0
    CMP.L   D7,D0
    BNE.W   .select_next_slot

    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.W   .select_next_slot

.switch_group2_entry:
    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .select_next_slot

    CMPI.L  #$8,D0
    BGE.W   .select_next_slot

    ADD.W   D0,D0
    MOVE.W  .switch_group2_jumptable(PC,D0.W),D0
    JMP     .switch_group2_jumptable+2(PC,D0.W)

; switch/jumptable
.switch_group2_jumptable:
    DC.W    .case_group2_0-.switch_group2_jumptable-2
    DC.W    .case_group2_1-.switch_group2_jumptable-2
    DC.W    .case_group2_2-.switch_group2_jumptable-2
    DC.W    .case_group2_3-.switch_group2_jumptable-2
    DC.W    .case_group2_4-.switch_group2_jumptable-2
    DC.W    .case_group2_5-.switch_group2_jumptable-2
    DC.W    .select_next_slot-.switch_group2_jumptable-2
    DC.W    .case_group2_7-.switch_group2_jumptable-2

.case_group2_1:
    MOVE.B  (LAB_1BA4).L,D0
    TST.B   D0
    BLE.S   .case_group2_1_done

    SUBQ.B  #1,LAB_2005
    BGT.S   .case_group2_1_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_1_commit

.case_group2_1_done:
    MOVEQ   #0,D1

.case_group2_1_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2005
    BRA.W   .select_next_slot

.case_group2_2:
    MOVE.B  LAB_1BA5,D0
    TST.B   D0
    BLE.S   .case_group2_2_done

    SUBQ.B  #1,LAB_2004
    BGT.S   .case_group2_2_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_2_commit

.case_group2_2_done:
    MOVEQ   #0,D1

.case_group2_2_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2004
    BRA.W   .select_next_slot

.case_group2_3:
    MOVE.B  LAB_1BAD,D0
    TST.B   D0
    BLE.S   .case_group2_3_done

    SUBQ.B  #1,LAB_2006
    BGT.S   .case_group2_3_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_3_commit

.case_group2_3_done:
    MOVEQ   #0,D1

.case_group2_3_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2006
    BRA.W   .select_next_slot

.case_group2_0:
    MOVE.L  LAB_22D1,D0
    TST.L   D0
    BLE.S   .case_group2_0_done

    SUBQ.B  #1,LAB_2007
    BGT.S   .case_group2_0_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_0_commit

.case_group2_0_done:
    MOVEQ   #0,D1

.case_group2_0_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2007
    BRA.W   .select_next_slot

.case_group2_4:
    MOVE.L  LAB_22D6,D0
    TST.L   D0
    BLE.S   .case_group2_4_done

    SUBQ.B  #1,LAB_2008
    BGT.S   .case_group2_4_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_4_commit

.case_group2_4_done:
    MOVEQ   #0,D1

.case_group2_4_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2008
    BRA.W   .select_next_slot

.case_group2_5:
    MOVE.L  LAB_22E5,D0
    TST.L   D0
    BLE.S   .case_group2_5_done

    SUBQ.B  #1,LAB_2009
    BGT.S   .case_group2_5_done

    MOVEQ   #1,D1
    BRA.S   .case_group2_5_commit

.case_group2_5_done:
    MOVEQ   #0,D1

.case_group2_5_commit:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .select_next_slot

    MOVE.B  D0,LAB_2009
    BRA.W   .select_next_slot

.case_group2_7:
    MOVEQ   #1,D5
    BRA.W   .select_next_slot

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7
    UNLK    A5
    RTS

;!======

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
;   NEWGRID_IsGridReadyForInput (LAB_0FAB), NEWGRID_SelectNextMode (LAB_0FAF)
; READS:
;   LAB_22D1/22D2
; WRITES:
;   LAB_22D1 (cleared when case 0x3E hit)
; DESC:
;   Uses a switch/jumptable to map selection indices to mode IDs and gates
;   certain modes based on flags and readiness checks.
; NOTES:
;   Returns 0 when input is out of range.
;------------------------------------------------------------------------------
NEWGRID_MapSelectionToMode:
LAB_0FC9:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7
    MOVE.W  18(A7),D6
    MOVE.L  D7,D0
    CMPI.L  #$d,D0
    BCC.S   .out_of_range

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
    BRA.S   .done

.case_sel_1:
    MOVEQ   #2,D7
    BRA.S   .done

.case_sel_2:
    MOVEQ   #3,D7
    BRA.S   .done

.case_sel_3:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    BSR.W   LAB_0FAB

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .case_sel_3_not_ready

    MOVEQ   #11,D0
    BRA.S   .case_sel_3_set

.case_sel_3_not_ready:
    MOVEQ   #4,D0

.case_sel_3_set:
    MOVE.L  D0,D7
    BRA.S   .done

.case_sel_4:
    TST.L   LAB_22D2
    BEQ.S   .case_sel_4_fallback

    MOVEQ   #5,D7
    CLR.L   LAB_22D1
    BRA.S   .done

.case_sel_5:
.case_sel_4_fallback:
    BSR.W   LAB_0FAF

    MOVE.L  D0,D7
    BRA.S   .done

.case_sel_6:
    MOVEQ   #1,D7
    BRA.S   .done

.out_of_range:
    MOVEQ   #0,D7

.done:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawClockFormatHeader   (Draw clock header row)
; ARGS:
;   stack +8: A3 = base rastport/struct
;   stack +12: D7 = start index
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOSetDrMd, LAB_102F, _LVOSetAPen, _LVORectFill, LAB_133D, LAB_1348,
;   JMP_TBL_LAB_1A06_6, _LVOTextLength, _LVOMove, _LVOText, LAB_1038
; READS:
;   LAB_232A/232B, LAB_2328
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the grid header bar and column labels for three day slots.
; NOTES:
;   Uses wraparound at 48 and centers text within computed column widths.
;------------------------------------------------------------------------------
NEWGRID_DrawClockFormatHeader:
LAB_0FD1:
    LINK.W  A5,#-108
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    LEA     60(A3),A0
    MOVE.L  A0,-102(A5)

    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_102F(PC)

    MOVEA.L -102(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -102(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -102(A5),-(A7)
    JSR     LAB_133D(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D6

.loop_columns:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.W   .done_columns

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .wrap_index

    SUB.L   D1,D0
    BRA.S   .use_index

.wrap_index:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.use_index:
    MOVE.L  D0,D5
    PEA     -97(A5)
    MOVE.L  D5,-(A7)
    JSR     LAB_1348(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    MOVE.L  D0,28(A7)
    MOVE.L  D6,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    MOVE.L  28(A7),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #36,D0
    ADD.L   D0,D4
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .calc_column_edge

    MOVE.L  #695,D0
    BRA.S   .draw_column_bg

.calc_column_edge:
    MOVEQ   #0,D0
    MOVE.W  LAB_232B,D0
    ADD.L   D4,D0
    SUBQ.L  #1,D0

.draw_column_bg:
    PEA     33.W
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -102(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     LAB_133D(PC)

    LEA     20(A7),A7

    MOVEA.L -102(A5),A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

.measure_label:
    TST.B   (A1)+
    BNE.S   .measure_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOTextLength(A6)

    MOVEQ   #0,D1
    MOVE.W  LAB_232B,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_label

    ADDQ.L  #1,D1

.center_label:
    ASR.L   #1,D1
    ADDQ.L  #2,D1
    ADD.L   D1,D4
    MOVEA.L -102(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_label_y

    ADDQ.L  #1,D1

.center_label_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D4,D0
    JSR     _LVOMove(A6)

    LEA     -97(A5),A0
    MOVEA.L A0,A1

.draw_label:
    TST.B   (A1)+
    BNE.S   .draw_label

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L -102(A5),A1
    JSR     _LVOText(A6)

    ADDQ.L  #1,D6
    BRA.W   .loop_columns

.done_columns:
    MOVE.W  #17,52(A3)
    PEA     64.W
    MOVE.L  A3,-(A7)
    JSR     LAB_1038(PC)

    MOVEQ   #0,D0
    MOVE.W  52(A3),D0
    MOVE.L  D0,32(A3)

    MOVEM.L -136(A5),D2-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawDateBanner   (Draw date banner line)
; ARGS:
;   stack +8: A3 = base rastport/struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   JMP_TBL_GENERATE_GRID_DATE_STRING, _LVOSetDrMd, LAB_102F, _LVOSetAPen,
;   _LVORectFill, LAB_133D, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   LAB_232A/232B
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Builds a date string and draws it centered in the top banner.
; NOTES:
;   Uses raster sub-struct at 60(A3).
;------------------------------------------------------------------------------
NEWGRID_DrawDateBanner:
LAB_0FDC:

.rastport   = -108

    LINK.W  A5,#-116
    MOVEM.L D2-D3/D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     -100(A5)
    MOVE.L  A0,.rastport(A5)
    JSR     JMP_TBL_GENERATE_GRID_DATE_STRING(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     7.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     LAB_102F(PC)

    MOVEA.L .rastport(A5),A1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Fill in the blue background for behind the date string
    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     LAB_133D(PC)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     LAB_133D(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #3,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVE.W  LAB_232B,D1
    MULU    #3,D1
    LEA     -100(A5),A0
    MOVEA.L A0,A1

.measure_date:
    TST.B   (A1)+
    BNE.S   .measure_date

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  D0,68(A7)
    MOVE.L  D1,72(A7)
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOTextLength(A6)

    MOVE.L  72(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_date

    ADDQ.L  #1,D1

.center_date:
    ASR.L   #1,D1
    MOVE.L  68(A7),D0
    ADD.L   D1,D0
    MOVE.L  D0,D7
    MOVEQ   #36,D1
    ADD.L   D1,D7
    MOVEA.L .rastport(A5),A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_date_y

    ADDQ.L  #1,D1

.center_date_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVE.L  D7,D0
    JSR     _LVOMove(A6)

    LEA     -100(A5),A0
    MOVEA.L A0,A1

.draw_date:
    TST.B   (A1)+
    BNE.S   .draw_date

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L .rastport(A5),A1
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)

    MOVEM.L -132(A5),D2-D3/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawAwaitingListingsMessage   (Draw waiting banner)
; ARGS:
;   stack +8: A3 = base rastport/struct
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A3/A6
; CALLS:
;   LAB_0FF4, _LVOSetAPen, _LVOTextLength, _LVOMove, LAB_0FFB, LAB_133D
; READS:
;   LAB_2328, GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the “Awaiting Listings Data” banner centered in the grid area.
; NOTES:
;   Uses text length to center the string within the 624px region.
;------------------------------------------------------------------------------
NEWGRID_DrawAwaitingListingsMessage:
LAB_0FE1:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    BSR.W   LAB_0FF4

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    LEA     60(A3),A1
    MOVEA.L GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2

.measure_message:
    TST.B   (A2)+
    BNE.S   .measure_message

    SUBQ.L  #1,A2
    SUBA.L  GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2
    MOVE.L  A0,32(A7)
    MOVE.L  A2,D0

    ; Get the length of the Awaiting Listings Data text and subtract it from 624
    MOVEA.L GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A0
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
    MOVE.W  LAB_2328,D0
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
    MOVE.L  GLOB_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,-(A7)
    PEA     612.W
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  52(A7),-(A7)
    BSR.W   LAB_0FFB

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  LAB_2328,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_133D(PC)

    LEA     60(A7),A7
    MOVE.W  LAB_2328,D0
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
; FUNC: NEWGRID_ComputeDaySlotFromClock   (Compute day slot index)
; ARGS:
;   stack +8: A3 = clockdata struct
; RET:
;   D0: slot index (1..48) or 0 on invalid
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   LAB_134A
; READS:
;   LAB_1BB7, LAB_2003
; WRITES:
;   none
; DESC:
;   Copies clockdata, computes a slot index from date fields, and clamps to range.
; NOTES:
;   Returns 0 when month/day out of supported bounds.
;------------------------------------------------------------------------------
NEWGRID_ComputeDaySlotFromClock:
LAB_0FE5:
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
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVE.W  -16(A5),D0
    MOVEQ   #50,D1
    CMP.W   D1,D0
    BGE.S   .range_ok

    MOVEQ   #20,D1
    CMP.W   D1,D0
    BLT.S   .return

    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return

.range_ok:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ComputeDaySlotFromClockWithOffset   (Compute slot with offset)
; ARGS:
;   stack +8: A3 = clockdata struct
; RET:
;   D0: slot index (1..48) or 0 on invalid
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   LAB_134A
; READS:
;   LAB_22D8
; WRITES:
;   none
; DESC:
;   Computes a day slot index using a dynamic offset (LAB_22D8) and clamps it.
; NOTES:
;   Similar to NEWGRID_ComputeDaySlotFromClock but adjusts thresholds.
;------------------------------------------------------------------------------
NEWGRID_ComputeDaySlotFromClockWithOffset:
LAB_0FE9:
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
    JSR     LAB_134A(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVEQ   #60,D0
    MOVE.L  LAB_22D8,D1
    SUB.L   D1,D0
    MOVE.W  -16(A5),D2
    EXT.L   D2
    CMP.L   D0,D2
    BGE.S   .range_ok

    MOVEQ   #30,D0
    SUB.L   D1,D0
    MOVE.W  -16(A5),D1
    EXT.L   D1
    CMP.L   D0,D1
    BLT.S   .return

    MOVE.W  -16(A5),D0
    MOVEQ   #29,D1
    CMP.W   D1,D0
    BGT.S   .return

.range_ok:
    ADDQ.L  #1,D7
    MOVEQ   #48,D0
    CMP.L   D0,D7
    BLE.S   .return

    MOVEQ   #1,D7

.return:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D2/D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AdjustClockStringBySlot   (Adjust clock string and validate)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_1028, JMP_TBL_LAB_1A07_3, JMP_TBL_LAB_1A06_6, LAB_101F, NEWGRID_ComputeDaySlotFromClock
; READS:
;   LAB_1DD8
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Copies clock string, converts it to slot seconds, and validates via slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
NEWGRID_AdjustClockStringBySlot:
LAB_0FED:
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
    JSR     LAB_1028(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #60,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_101F(PC)

    PEA     -22(A5)
    BSR.W   LAB_0FE5

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AdjustClockStringBySlotWithOffset   (Adjust clock string with offset)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: ??
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_1028, JMP_TBL_LAB_1A07_3, JMP_TBL_LAB_1A06_6, LAB_101F, NEWGRID_ComputeDaySlotFromClockWithOffset
; READS:
;   LAB_1DD8
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Like NEWGRID_AdjustClockStringBySlot but uses the offset-based slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
NEWGRID_AdjustClockStringBySlotWithOffset:
LAB_0FEF:
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
    JSR     LAB_1028(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  LAB_1DD8,D0
    MOVEQ   #30,D1
    JSR     JMP_TBL_LAB_1A07_3(PC)

    MOVEQ   #60,D0
    JSR     JMP_TBL_LAB_1A06_6(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     LAB_101F(PC)

    PEA     -22(A5)
    BSR.W   LAB_0FE9

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawTopBorderLine   (Draw filled rect 0,0..695,1)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill
; READS:
;   GLOB_REF_GRID_RASTPORT_MAYBE_2
; WRITES:
;   none
; DESC:
;   Draws a 1-pixel-tall horizontal bar at the top of the grid area.
; NOTES:
;   Uses pen 7 on the secondary grid rastport.
;------------------------------------------------------------------------------
NEWGRID_DrawTopBorderLine:
DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,0 to 695,1
    MOVEA.L GLOB_REF_GRID_RASTPORT_MAYBE_2,A1
    MOVEQ   #0,D0               ; x.min = 0
    MOVE.L  D0,D1               ; y.min = 0
    MOVE.L  #695,D2             ; x.max = 695
    MOVEQ   #1,D3               ; y.max = 1
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_FillGridRects   (Fill two grid rectangles)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = pen for first rect
;   stack +16: D6 = pen for second rect
;   stack +20: D5 = y2 for first rect
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _LVOSetAPen, _LVORectFill
; READS:
;   LAB_232A
; WRITES:
;   none
; DESC:
;   Fills two horizontal rectangles in the grid header region with different pens.
; NOTES:
;   Uses SetOffsetForStack macro for parameters.
;------------------------------------------------------------------------------
NEWGRID_FillGridRects:
LAB_0FF2:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    SetOffsetForStack 6

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7
    MOVE.L  .stackOffsetBytes+12(A7),D6
    MOVE.L  .stackOffsetBytes+16(A7),D5

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVE.L  D0,D2
    MOVE.L  D5,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    JSR     _LVORectFill(A6)

    MOVEA.L A3,A1
    MOVE.L  D6,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  LAB_232A,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L A3,A1
    MOVEQ   #0,D1
    MOVE.L  #695,D2
    JSR     _LVORectFill(A6)

    MOVEM.L (A7)+,D2-D3/D5-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridTopBars   (Draw top header bars)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A3
; CALLS:
;   NEWGRID_FillGridRects (LAB_0FF2)
; READS:
;   GLOB_REF_GRID_RASTPORT_MAYBE_2
; WRITES:
;   none
; DESC:
;   Draws the top bar rectangles using fixed parameters.
; NOTES:
;   Wrapper around NEWGRID_FillGridRects.
;------------------------------------------------------------------------------
NEWGRID_DrawGridTopBars:
LAB_0FF3:
    PEA     1.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  GLOB_REF_GRID_RASTPORT_MAYBE_2,-(A7)
    BSR.S   LAB_0FF2

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawGridFrame   (Draw grid frame sections)
; ARGS:
;   stack +8: A3 = grid struct/rastport
;   stack +16: D7 = pen for first fill
;   stack +20: D6 = pen for second fill
;   stack +24: D5 = y2 for first fill
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   LAB_102F, NEWGRID_FillGridRects (LAB_0FF2)
; READS:
;   LAB_232A
; WRITES:
;   none
; DESC:
;   Draws header frame segments using pens and coordinates.
; NOTES:
;   Uses LAB_102F to set pens before filling.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrame:
LAB_0FF4:
    LINK.W  A5,#-8
    MOVEM.L D5-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5

    LEA     60(A3),A0
    MOVE.L  D7,-(A7)
    PEA     -1.W
    MOVE.L  A3,-(A7)
    MOVE.L  A0,28(A7)
    JSR     LAB_102F(PC)

    MOVE.L  D6,(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,40(A7)
    JSR     LAB_102F(PC)

    MOVE.L  D5,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  44(A7),-(A7)
    MOVE.L  44(A7),-(A7)
    BSR.W   LAB_0FF2

    MOVEM.L -24(A5),D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ShouldOpenEditor   (Check if entry is editable??)
; ARGS:
;   stack +8: A3 = entry pointer
; RET:
;   D0: 1 if editable, 0 otherwise
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   LAB_134B
; READS:
;   entry fields at 1(A3)/19(A3), bit 5 at 27(A3)
; WRITES:
;   none
; DESC:
;   Checks text fields and flags to decide whether to open the editor.
; NOTES:
;   Returns true when both strings are empty and flag bit 5 is set.
;------------------------------------------------------------------------------
NEWGRID_ShouldOpenEditor:
LAB_0FF5:
    LINK.W  A5,#-12
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return_zero

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     LAB_134B(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-12(A5)
    MOVE.L  A0,-8(A5)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   -12(A5)
    BEQ.S   .check_second

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BNE.S   .has_text

.check_second:
    TST.L   D0
    BEQ.S   .check_flag

    MOVEA.L D0,A0
    TST.B   (A0)
    BNE.S   .has_text

.check_flag:
    BTST    #5,27(A3)
    BEQ.S   .has_text

    MOVEQ   #1,D0
    BRA.S   .store_result

.has_text:
    MOVEQ   #0,D0

.store_result:
    MOVE.L  D0,D7

.return_zero:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawWrappedText   (Draw and wrap text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = x
;   stack +16: D6 = y
;   stack +20: D5 = max width
;   stack +24: A2 = text pointer
;   stack +28: ?? (draw flag)
; RET:
;   D0: pointer to next word (or current)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   LAB_134B, LAB_1029, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   GLOB_STR_SINGLE_SPACE, LAB_200D, LAB_200E
; WRITES:
;   local buffers -74(A5)
; DESC:
;   Draws words from a string with wrapping based on available width, returning
;   the next pointer to continue from.
; NOTES:
;   When draw flag is zero, calculates positions without drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawWrappedText:
LAB_0FFB:
    LINK.W  A5,#-80
    MOVEM.L D5-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    MOVE.L  20(A5),D5
    MOVEA.L 24(A5),A2

    MOVEQ   #0,D0
    MOVE.L  D0,-16(A5)
    MOVE.L  D0,-12(A5)
    MOVE.L  A2,D0
    BEQ.S   .init_input

    MOVE.L  A2,-(A7)
    JSR     LAB_134B(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-20(A5)
    BRA.S   .setup_word_ptr

.init_input:
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)

.setup_word_ptr:
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L A3,A1

    ; Get the width of a single space
    LEA     GLOB_STR_SINGLE_SPACE,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

.process_words:
    TST.L   -20(A5)
    BEQ.W   .return

    PEA     LAB_200D
    PEA     50.W
    PEA     -74(A5)
    MOVE.L  -20(A5),-(A7)
    JSR     LAB_1029(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-20(A5)
    JSR     LAB_134B(PC)

    LEA     16(A7),A7
    MOVE.B  -74(A5),D1
    MOVE.L  D0,-20(A5)
    TST.B   D1
    BNE.S   .word_found

    MOVEQ   #0,D0
    BRA.W   .return

.word_found:
    LEA     -74(A5),A0
    MOVEA.L A0,A1

.measure_word:
    TST.B   (A1)+
    BNE.S   .measure_word

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVE.L  D0,-4(A5)
    CMP.L   D1,D0
    BGT.S   .word_too_long

    TST.L   28(A5)
    BEQ.S   .advance_word

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.draw_word:
    TST.B   (A1)+
    BNE.S   .draw_word

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,20(A7)
    MOVEA.L A3,A1
    MOVE.L  20(A7),D0
    JSR     _LVOText(A6)

.advance_word:
    MOVE.L  -4(A5),D0
    ADD.L   D0,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    BRA.S   .check_next_word

.word_too_long:
    CMP.L   D5,D0
    BLE.S   .return_last_ptr

    LEA     -74(A5),A0
    MOVEA.L A0,A1

.measure_word_trim:
    TST.B   (A1)+
    BNE.S   .measure_word_trim

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-16(A5)

.shrink_word:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .draw_trimmed_word

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    CMP.L   D1,D0
    BLE.S   .draw_trimmed_word

    SUBQ.L  #1,-16(A5)
    BRA.S   .shrink_word

.draw_trimmed_word:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .return_ptr

    TST.L   28(A5)
    BEQ.S   .return_ptr

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.return_ptr:
    MOVEA.L -24(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -16(A5),A1
    MOVE.L  A1,D0
    BRA.S   .return

.return_last_ptr:
    MOVE.L  -24(A5),D0
    BRA.S   .return

.check_next_word:
    MOVEA.L -20(A5),A0
    TST.B   (A0)
    BEQ.W   .process_words

    MOVE.L  -8(A5),D0
    ADD.L   -12(A5),D0
    CMP.L   D5,D0
    BGT.S   .return_next_ptr

    TST.L   28(A5)
    BEQ.S   .draw_space

    ; Draw a single space
    MOVEA.L A3,A1
    LEA     LAB_200E,A0
    MOVEQ   #1,D0
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.draw_space:
    MOVE.L  -8(A5),D0
    ADD.L   D0,-12(A5)
    BRA.W   .process_words

.return_next_ptr:
    MOVE.L  -24(A5),D0

.return:
    MOVEM.L (A7)+,D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessGridMessages   (Handle grid UI messages)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   NEWGRID_InitGridResources, NEWGRID_ClearHighlightArea, CLEANUP_DrawClockBanner,
;   NEWGRID_AdjustClockStringBySlot, CLEANUP_DrawClockFormatList/Frame, LAB_1332,
;   NEWGRID_MapSelectionToMode, _LVOGetMsg, LAB_1038, NEWGRID_DrawClockFormatHeader,
;   NEWGRID_DrawDateBanner, NEWGRID_DrawAwaitingListingsMessage, LAB_132A, LAB_0FC9,
;   GCOMMAND_UpdatePresetEntryCache, _LVOPutMsg, NEWGRID_DrawGridTopBars
; READS:
;   LAB_2263, LAB_1F45, LAB_225F, LAB_200F, LAB_200F/2010/2011/2012, LAB_1DC6
; WRITES:
;   LAB_200F, LAB_225F, LAB_1F45, LAB_2010-2012
; DESC:
;   Main event loop for grid editing: initializes UI state, pulls messages,
;   dispatches by mode, and updates selection and redraws.
; NOTES:
;   Uses switch/jumptable for mode handling; resets highlight when needed.
;------------------------------------------------------------------------------
NEWGRID_ProcessGridMessages:
LAB_100D:
    LINK.W  A5,#-4
    TST.W   LAB_2263
    BNE.W   .done

    MOVE.W  LAB_1F45,D0
    CMPI.W  #$101,D0
    BNE.S   .check_reinit

    CLR.W   LAB_1F45
    BRA.W   .done

.check_reinit:
    TST.L   LAB_225F
    BEQ.S   .reset_selection

    MOVEQ   #1,D0
    CMP.L   LAB_225F,D0
    BNE.S   .maybe_init_ui

.reset_selection:
    MOVEQ   #0,D0
    MOVE.L  D0,LAB_200F

.maybe_init_ui:
    TST.L   LAB_200F
    BNE.S   .get_msg

    BSR.W   LAB_0FA4

    BSR.W   LAB_0FA9

    JSR     LAB_1024(PC)

    PEA     LAB_2274
    BSR.W   LAB_0FED

    MOVE.L  D0,(A7)
    JSR     JMP_TBL_CLEANUP_DrawClockFormatList(PC)

    JSR     JMP_TBL_CLEANUP_DrawClockFormatFrame(PC)

    CLR.W   LAB_1F45
    MOVEQ   #2,D0
    MOVE.L  D0,LAB_225F
    JSR     LAB_1332(PC)

    CLR.L   (A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F

.get_msg:
    MOVEA.L LAB_1DC6,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .done

    MOVEA.L D0,A0
    CLR.W   52(A0)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     LAB_1038(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    CLR.L   32(A0)

.dispatch_mode:
    MOVE.L  LAB_200F,D0
    SUBQ.L  #1,D0
    BLT.W   .finish_message

    CMPI.L  #12,D0
    BGE.W   .finish_message

    ADD.W   D0,D0
    MOVE.W  .mode_jumptable(PC,D0.W),D0
    JMP     .mode_jumptable+2(PC,D0.W)

; switch/jumptable
.mode_jumptable:
    DC.W    .case_mode_0-.mode_jumptable-2
    DC.W    .case_mode_1-.mode_jumptable-2
    DC.W    .case_mode_2-.mode_jumptable-2
    DC.W    .case_mode_3-.mode_jumptable-2
    DC.W    .case_mode_4-.mode_jumptable-2
    DC.W    .case_mode_5-.mode_jumptable-2
    DC.W    .case_mode_6-.mode_jumptable-2
    DC.W    .case_mode_7-.mode_jumptable-2
    DC.W    .case_mode_8-.mode_jumptable-2
    DC.W    .case_mode_9-.mode_jumptable-2
    DC.W    .case_mode_10-.mode_jumptable-2
    DC.W    .case_mode_11-.mode_jumptable-2

.case_mode_0:
    MOVEA.L -4(A5),A0
    ADDA.W  #$3c,A0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     LAB_102A(PC)

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.W   .finish_message

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_1:
    PEA     LAB_223A
    BSR.W   LAB_0FE5

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FED

    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FD1

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    LEA     16(A7),A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_2:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FDC

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_10:
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FE1

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_3:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   .finish_message

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_4:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     5.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   .finish_message

    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_5:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode5_continue

    MOVE.W  #1,LAB_2012
    BRA.W   .finish_message

.case_mode5_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_6:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     3.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode6_continue

    MOVE.W  #1,LAB_2012
    BRA.W   .finish_message

.case_mode6_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_7:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.W  LAB_2011,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     4.W
    JSR     LAB_132A(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode7_continue

    MOVE.W  #1,LAB_2012
    BRA.W   .finish_message

.case_mode7_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_8:
    PEA     LAB_223A
    BSR.W   LAB_0FE9

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FEF

    MOVE.W  LAB_2010,D1
    EXT.L   D1
    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     6.W
    JSR     LAB_132A(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .case_mode8_continue

    MOVE.W  #1,LAB_2012
    BRA.W   .finish_message

.case_mode8_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.W   .finish_message

.case_mode_9:
    PEA     LAB_223A
    BSR.W   LAB_0FE5

    PEA     LAB_2274
    MOVE.W  D0,LAB_2010
    BSR.W   LAB_0FED

    MOVE.W  LAB_2010,D1
    EXT.L   D1
    MOVE.W  D0,LAB_2011
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     7.W
    JSR     LAB_132A(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .case_mode9_continue

    MOVE.W  #1,LAB_2012
    BRA.S   .finish_message

.case_mode9_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F
    BRA.S   .finish_message

.case_mode_11:
    TST.W   LAB_2012
    BEQ.S   .case_mode11_continue

    MOVE.W  LAB_2011,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   LAB_0FD1

    ADDQ.W  #8,A7
    CLR.W   LAB_2012

.case_mode11_continue:
    MOVE.W  LAB_2010,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  LAB_200F,-(A7)
    BSR.W   LAB_0FC9

    ADDQ.W  #8,A7
    MOVE.L  D0,LAB_200F

.finish_message:
    MOVEA.L -4(A5),A0
    CMPI.W  #0,52(A0)
    BLS.W   .dispatch_mode

    MOVE.L  -4(A5),-(A7)
    JSR     GCOMMAND_UpdatePresetEntryCache(PC)

    ADDQ.W  #4,A7
    MOVEA.L LAB_1DC5,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    TST.W   LAB_2012
    BEQ.S   .draw_top_border_line

    BSR.W   LAB_0FF3

    BRA.S   .done

.draw_top_border_line:
    BSR.W   DRAW_FILLED_RECT_0_0_TO_695_1_PEN_7

.done:
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_1A07   (Jump stub)
; ARGS:
;   ?? (see LAB_1A07)
; RET:
;   ?? (see LAB_1A07)
; CLOBBERS:
;   ?? (see LAB_1A07)
; CALLS:
;   LAB_1A07
; DESC:
;   Jump table entry that forwards to LAB_1A07.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_1A07:
JMP_TBL_LAB_1A07_3:
    JMP     LAB_1A07

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_05C7   (Jump stub)
; ARGS:
;   ?? (see LAB_05C7)
; RET:
;   ?? (see LAB_05C7)
; CLOBBERS:
;   ?? (see LAB_05C7)
; CALLS:
;   LAB_05C7
; DESC:
;   Jump table entry that forwards to LAB_05C7.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_05C7:
LAB_101F:
    JMP     LAB_05C7

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_GenerateGridDateString   (Jump stub)
; ARGS:
;   ?? (see GENERATE_GRID_DATE_STRING)
; RET:
;   ?? (see GENERATE_GRID_DATE_STRING)
; CLOBBERS:
;   ?? (see GENERATE_GRID_DATE_STRING)
; CALLS:
;   GENERATE_GRID_DATE_STRING
; DESC:
;   Jump table entry that forwards to GENERATE_GRID_DATE_STRING.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_GenerateGridDateString:
JMP_TBL_GENERATE_GRID_DATE_STRING:
    JMP     GENERATE_GRID_DATE_STRING

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_DeallocateMemory   (Jump stub)
; ARGS:
;   ?? (see DEALLOCATE_MEMORY)
; RET:
;   ?? (see DEALLOCATE_MEMORY)
; CLOBBERS:
;   ?? (see DEALLOCATE_MEMORY)
; CALLS:
;   DEALLOCATE_MEMORY
; DESC:
;   Jump table entry that forwards to DEALLOCATE_MEMORY.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_DeallocateMemory:
JMP_TBL_DEALLOCATE_MEMORY_3:
    JMP     DEALLOCATE_MEMORY

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_Cleanup_DrawClockFormatList   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_DrawClockFormatList)
; RET:
;   ?? (see CLEANUP_DrawClockFormatList)
; CLOBBERS:
;   ?? (see CLEANUP_DrawClockFormatList)
; CALLS:
;   CLEANUP_DrawClockFormatList
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockFormatList.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_Cleanup_DrawClockFormatList:
JMP_TBL_CLEANUP_DrawClockFormatList:
LAB_1022:
    JMP     CLEANUP_DrawClockFormatList

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_058A   (Jump stub)
; ARGS:
;   ?? (see LAB_058A)
; RET:
;   ?? (see LAB_058A)
; CLOBBERS:
;   ?? (see LAB_058A)
; CALLS:
;   LAB_058A
; DESC:
;   Jump table entry that forwards to LAB_058A.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_058A:
LAB_1023:
    JMP     LAB_058A

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_DrawClockBanner   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_DrawClockBanner)
; RET:
;   ?? (see CLEANUP_DrawClockBanner)
; CLOBBERS:
;   ?? (see CLEANUP_DrawClockBanner)
; CALLS:
;   CLEANUP_DrawClockBanner
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockBanner.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_DrawClockBanner:
LAB_1024:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_AllocateMemory   (Jump stub)
; ARGS:
;   ?? (see ALLOCATE_MEMORY)
; RET:
;   ?? (see ALLOCATE_MEMORY)
; CLOBBERS:
;   ?? (see ALLOCATE_MEMORY)
; CALLS:
;   ALLOCATE_MEMORY
; DESC:
;   Jump table entry that forwards to ALLOCATE_MEMORY.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_AllocateMemory:
JMP_TBL_ALLOCATE_MEMORY_3:
    JMP     ALLOCATE_MEMORY

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_0588   (Jump stub)
; ARGS:
;   ?? (see LAB_0588)
; RET:
;   ?? (see LAB_0588)
; CLOBBERS:
;   ?? (see LAB_0588)
; CALLS:
;   LAB_0588
; DESC:
;   Jump table entry that forwards to LAB_0588.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_0588:
LAB_1026:
    JMP     LAB_0588

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_Cleanup_DrawClockFormatFrame   (Jump stub)
; ARGS:
;   ?? (see CLEANUP_DrawClockFormatFrame)
; RET:
;   ?? (see CLEANUP_DrawClockFormatFrame)
; CLOBBERS:
;   ?? (see CLEANUP_DrawClockFormatFrame)
; CALLS:
;   CLEANUP_DrawClockFormatFrame
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockFormatFrame.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_Cleanup_DrawClockFormatFrame:
JMP_TBL_CLEANUP_DrawClockFormatFrame:
LAB_1027:
    JMP     CLEANUP_DrawClockFormatFrame

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_05D3   (Jump stub)
; ARGS:
;   ?? (see LAB_05D3)
; RET:
;   ?? (see LAB_05D3)
; CLOBBERS:
;   ?? (see LAB_05D3)
; CALLS:
;   LAB_05D3
; DESC:
;   Jump table entry that forwards to LAB_05D3.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_05D3:
LAB_1028:
    JMP     LAB_05D3

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_1970   (Jump stub)
; ARGS:
;   ?? (see LAB_1970)
; RET:
;   ?? (see LAB_1970)
; CLOBBERS:
;   ?? (see LAB_1970)
; CALLS:
;   LAB_1970
; DESC:
;   Jump table entry that forwards to LAB_1970.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_1970:
LAB_1029:
    JMP     LAB_1970

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_18C2   (Jump stub)
; ARGS:
;   ?? (see LAB_18C2)
; RET:
;   ?? (see LAB_18C2)
; CLOBBERS:
;   ?? (see LAB_18C2)
; CALLS:
;   LAB_18C2
; DESC:
;   Jump table entry that forwards to LAB_18C2.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_18C2:
LAB_102A:
    JMP     LAB_18C2

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMP_TBL_LAB_1A06   (Jump stub)
; ARGS:
;   ?? (see LAB_1A06)
; RET:
;   ?? (see LAB_1A06)
; CLOBBERS:
;   ?? (see LAB_1A06)
; CALLS:
;   LAB_1A06
; DESC:
;   Jump table entry that forwards to LAB_1A06.
;------------------------------------------------------------------------------
NEWGRID_JMP_TBL_LAB_1A06:
JMP_TBL_LAB_1A06_6:
    JMP     LAB_1A06
