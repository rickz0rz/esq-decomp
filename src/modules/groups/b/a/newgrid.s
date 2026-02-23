    XDEF    NEWGRID_AdjustClockStringBySlot
    XDEF    NEWGRID_AdjustClockStringBySlotWithOffset
    XDEF    NEWGRID_ClearHighlightArea
    XDEF    NEWGRID_ComputeDaySlotFromClock
    XDEF    NEWGRID_ComputeDaySlotFromClockWithOffset
    XDEF    NEWGRID_DrawAwaitingListingsMessage
    XDEF    NEWGRID_DrawClockFormatHeader
    XDEF    NEWGRID_DrawDateBanner
    XDEF    NEWGRID_DrawGridFrame
    XDEF    NEWGRID_DrawGridTopBars
    XDEF    NEWGRID_DrawTopBorderLine
    XDEF    NEWGRID_DrawWrappedText
    XDEF    NEWGRID_FillGridRects
    XDEF    NEWGRID_InitGridResources
    XDEF    NEWGRID_IsGridReadyForInput
    XDEF    NEWGRID_MapSelectionToMode
    XDEF    NEWGRID_ProcessGridMessages
    XDEF    NEWGRID_SelectNextMode
    XDEF    NEWGRID_ShouldOpenEditor
    XDEF    NEWGRID_ShutdownGridResources
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList
    XDEF    NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds
    XDEF    NEWGRID_JMPTBL_DATETIME_SecondsToStruct
    XDEF    NEWGRID_JMPTBL_DISPTEXT_FreeBuffers
    XDEF    NEWGRID_JMPTBL_DISPTEXT_InitBuffers
    XDEF    NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING
    XDEF    NEWGRID_JMPTBL_MATH_DivS32
    XDEF    NEWGRID_JMPTBL_MATH_Mulu32
    XDEF    NEWGRID_JMPTBL_MEMORY_AllocateMemory
    XDEF    NEWGRID_JMPTBL_MEMORY_DeallocateMemory
    XDEF    NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN
    XDEF    NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel

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
;   NEWGRID2_EnsureBuffersAllocated, NEWGRID_JMPTBL_DISPTEXT_InitBuffers, NEWGRID_InitShowtimeBuckets, NEWGRID_JMPTBL_MEMORY_AllocateMemory, _LVOInitRastPort,
;   _LVOSetDrMd, _LVOSetFont, NEWGRID_DrawTopBorderLine,
;   _LVOTextLength, NEWGRID_JMPTBL_MATH_DivS32
; READS:
;   NEWGRID_GridResourcesInitializedFlag, Global_HANDLE_PREVUEC_FONT, Global_STR_44_44_44
; WRITES:
;   NEWGRID_GridResourcesInitializedFlag, NEWGRID_MainRastPortPtr/2, NEWGRID_RowHeightPx-232B
; DESC:
;   Allocates two RastPorts, attaches bitmaps/fonts, and computes layout metrics
;   for the grid header/banner area.
; NOTES:
;   Early-outs if already initialized (NEWGRID_GridResourcesInitializedFlag != 0) or allocation fails.
;------------------------------------------------------------------------------
NEWGRID_InitGridResources:
    TST.W   NEWGRID_GridResourcesInitializedFlag
    BNE.W   .return_init_status

    MOVE.W  #1,NEWGRID_GridResourcesInitializedFlag
    JSR     NEWGRID2_EnsureBuffersAllocated(PC)

    JSR     NEWGRID_JMPTBL_DISPTEXT_InitBuffers(PC)

    JSR     NEWGRID_InitShowtimeBuckets(PC)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     99.W
    PEA     Global_STR_NEWGRID_C_1
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_MainRastPortPtr
    TST.L   D0
    BEQ.W   .return_init_status

    MOVEA.L D0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L NEWGRID_MainRastPortPtr,A0
    MOVE.L  #Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L NEWGRID_MainRastPortPtr,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L NEWGRID_MainRastPortPtr,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     100.W
    PEA     112.W
    PEA     Global_STR_NEWGRID_C_2
    JSR     NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_HeaderRastPortPtr
    TST.L   D0
    BEQ.W   .return_init_status

    MOVEA.L D0,A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOInitRastPort(A6)

    MOVEA.L NEWGRID_HeaderRastPortPtr,A0
    MOVE.L  #WDISP_BannerGridBitmapStruct,4(A0)
    MOVEA.L NEWGRID_HeaderRastPortPtr,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L NEWGRID_HeaderRastPortPtr,A1
    MOVEA.L Global_HANDLE_PREVUEC_FONT,A0
    JSR     _LVOSetFont(A6)

    BSR.W   NEWGRID_DrawTopBorderLine

    MOVEQ   #8,D0
    MOVEA.L NEWGRID_MainRastPortPtr,A1
    LEA     Global_STR_44_44_44,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  D0,NEWGRID_SampleTimeTextWidthPx
    ADDI.W  #12,D0
    MOVE.W  D0,NEWGRID_ColumnStartXPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  #624,D0
    SUB.L   D1,D0
    MOVEQ   #3,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,NEWGRID_ColumnWidthPx
    MOVEA.L NEWGRID_MainRastPortPtr,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  20(A0),D0
    SUBQ.L  #1,D0
    ADD.L   D0,D0
    ADDQ.L  #8,D0
    MOVE.W  D0,NEWGRID_RowHeightPx
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,D0
    MOVEQ   #2,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    TST.L   D1
    BEQ.S   .align_even

    MOVE.W  NEWGRID_RowHeightPx,D0
    SUBQ.W  #1,D0
    MOVE.W  D0,NEWGRID_RowHeightPx

.align_even:
    BSR.W   NEWGRID_DrawTopBorderLine

.return_init_status:
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
;   NEWGRID_JMPTBL_MEMORY_DeallocateMemory, NEWGRID2_FreeBuffersIfAllocated, NEWGRID_JMPTBL_DISPTEXT_FreeBuffers, NEWGRID_ResetShowtimeBuckets
; READS:
;   NEWGRID_MainRastPortPtr
; WRITES:
;   NEWGRID_MainRastPortPtr, NEWGRID_GridResourcesInitializedFlag
; DESC:
;   Frees the grid rastport allocation and resets grid state flags.
; NOTES:
;   Always clears NEWGRID_GridResourcesInitializedFlag and triggers dependent cleanup routines.
;------------------------------------------------------------------------------
NEWGRID_ShutdownGridResources:
    TST.L   NEWGRID_MainRastPortPtr
    BEQ.S   .skip_free

    PEA     100.W
    MOVE.L  NEWGRID_MainRastPortPtr,-(A7)
    PEA     148.W
    PEA     Global_STR_NEWGRID_C_3
    JSR     NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.skip_free:
    JSR     NEWGRID2_FreeBuffersIfAllocated(PC)

    JSR     NEWGRID_JMPTBL_DISPTEXT_FreeBuffers(PC)

    CLR.W   NEWGRID_GridResourcesInitializedFlag
    JSR     NEWGRID_ResetShowtimeBuckets(PC)

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
;   NEWGRID_RefreshStateFlag
; WRITES:
;   none
; DESC:
;   Resets highlight message state and fills the highlight area if inactive.
; NOTES:
;   Uses Exec Disable/Enable around message reset.
;------------------------------------------------------------------------------
NEWGRID_ClearHighlightArea:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    JSR     GCOMMAND_ResetHighlightMessages(PC)

    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    TST.L   NEWGRID_RefreshStateFlag
    BNE.S   .return

    MOVEA.L NEWGRID_MainRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,68 to 695,267
    MOVEA.L NEWGRID_MainRastPortPtr,A1
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
; FUNC: NEWGRID_IsGridReadyForInput   (Check input gating flags)
; ARGS:
;   (none observed)
; RET:
;   D0: 1 if allowed, 0 if blocked
; CLOBBERS:
;   D0-D1/D6-D7
; CALLS:
;   none
; READS:
;   TEXTDISP_SecondaryGroupPresentFlag/TEXTDISP_SecondaryGroupEntryCount, TEXTDISP_PrimaryGroupPresentFlag/TEXTDISP_PrimaryGroupEntryCount
; WRITES:
;   none
; DESC:
;   Checks multiple gating flags and counters to decide if input/action is allowed.
; NOTES:
;   Returns 0 when either gate is active with a positive counter.
;------------------------------------------------------------------------------
NEWGRID_IsGridReadyForInput:
    MOVEM.L D6-D7,-(A7)
    MOVE.L  12(A7),D7

    MOVEQ   #1,D0
    CMP.L   D0,D7
    BNE.S   .check_primary_gate

    TST.B   TEXTDISP_SecondaryGroupPresentFlag
    BEQ.S   .allow_input

    MOVE.W  TEXTDISP_SecondaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow_input

.check_primary_gate:
    TST.B   TEXTDISP_PrimaryGroupPresentFlag
    BEQ.S   .allow_input

    MOVE.W  TEXTDISP_PrimaryGroupEntryCount,D0
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BLS.S   .allow_input

    MOVEQ   #0,D0
    BRA.S   .return_ready_flag

.allow_input:
    MOVEQ   #1,D0

.return_ready_flag:
    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D6-D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: NEWGRID_SelectNextMode   (Advance grid mode selection)
; ARGS:
;   stack +34: arg_1 (via 38(A5))
; RET:
;   D0: selected mode (or 12 sentinel)
; CLOBBERS:
;   D0-D7
; CALLS:
;   NEWGRID_IsGridReadyForInput (NEWGRID_IsGridReadyForInput)
; READS:
;   CONFIG_ModeCycleEnabledFlag, CONFIG_ModeCycleGateDuration, NEWGRID_ModeCycleCountdown-200A, CONFIG_NicheModeCycleBudget_Y/1BA5/1BAD,
;   GCOMMAND_NicheModeCycleCount/GCOMMAND_NicheForceMode5Flag/GCOMMAND_MplexModeCycleCount, GCOMMAND_PpvModeCycleCount, TEXTDISP_PrimaryGroupPresentFlag/2231/222E/222F
; WRITES:
;   NEWGRID_ModeCycleCountdown-200A
; DESC:
;   Cycles through candidate grid modes based on current day/state and
;   gating flags, returning the next valid mode.
; NOTES:
;   Uses two switch/jumptable blocks to select flag sources and timers.
;------------------------------------------------------------------------------
NEWGRID_SelectNextMode:
    LINK.W  A5,#-40
    MOVEM.L D5-D7,-(A7)
    MOVEQ   #0,D5
    LEA     NEWGRID_ModeSelectionTable,A0
    LEA     -38(A5),A1
    MOVEQ   #6,D0

.copy_mode_table:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.copy_mode_table
    MOVE.B  CONFIG_ModeCycleEnabledFlag,D0
    MOVEQ   #'Y',D1
    CMP.B   D1,D0
    BNE.S   .evaluate_next_candidate

    MOVE.L  CONFIG_ModeCycleGateDuration,D0
    TST.L   D0
    BLE.S   .force_select_current

    MOVE.L  NEWGRID_ModeCycleCountdown,D1
    TST.L   D1
    BGT.S   .decrement_cycle_counter

    MOVE.L  NEWGRID_ModeCandidateIndex,D7
    MOVE.L  D0,NEWGRID_ModeCycleCountdown
    BRA.S   .evaluate_next_candidate

.decrement_cycle_counter:
    SUBQ.L  #1,NEWGRID_ModeCycleCountdown
    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.S   .evaluate_next_candidate

.force_select_current:
    MOVEQ   #12,D6
    MOVEQ   #1,D5

.evaluate_next_candidate:
    TST.W   D5
    BNE.W   .return_selected_mode

    MOVE.L  NEWGRID_ModeCandidateIndex,D0
    ASL.L   #2,D0
    MOVE.L  -38(A5,D0.L),D6
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BNE.S   .advance_slot_index

    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_ModeCandidateIndex
    BRA.S   .dispatch_mode_family

.advance_slot_index:
    ADDQ.L  #1,NEWGRID_ModeCandidateIndex

.dispatch_mode_family:
    MOVE.B  CONFIG_ModeCycleEnabledFlag,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .dispatch_non_y_mode_group2

    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .validate_cycle_gate

    CMPI.L  #$8,D0
    BGE.W   .validate_cycle_gate

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
    DC.W    .validate_cycle_gate-.switch_group1_jumptable-2
    DC.W    .validate_cycle_gate-.switch_group1_jumptable-2

.case_group1_1:
    MOVE.B  CONFIG_NicheModeCycleBudget_Y,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_2:
    MOVE.B  CONFIG_NicheModeCycleBudget_Static,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_3:
    MOVE.B  CONFIG_NicheModeCycleBudget_Custom,D0
    SNE     D1
    NEG.B   D1
    EXT.W   D1
    EXT.L   D1
    MOVE.L  D1,D5
    BRA.S   .validate_cycle_gate

.case_group1_0:
    TST.L   GCOMMAND_NicheModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .validate_cycle_gate

.case_group1_4:
    TST.L   GCOMMAND_MplexModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5
    BRA.S   .validate_cycle_gate

.case_group1_5:
    TST.L   GCOMMAND_PpvModeCycleCount
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D5

.validate_cycle_gate:
    TST.W   D5
    BNE.W   .evaluate_next_candidate

    MOVE.L  NEWGRID_ModeCandidateIndex,D0
    CMP.L   D7,D0
    BNE.W   .evaluate_next_candidate

    MOVEQ   #12,D6
    MOVEQ   #1,D5
    BRA.W   .evaluate_next_candidate

.dispatch_non_y_mode_group2:
    MOVE.L  D6,D0
    SUBQ.L  #5,D0
    BLT.W   .evaluate_next_candidate

    CMPI.L  #$8,D0
    BGE.W   .evaluate_next_candidate

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
    DC.W    .evaluate_next_candidate-.switch_group2_jumptable-2
    DC.W    .case_group2_7-.switch_group2_jumptable-2

.case_group2_1:
    MOVE.B  (CONFIG_NicheModeCycleBudget_Y).L,D0
    TST.B   D0
    BLE.S   .case_group2_1_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Y
    BGT.S   .case_group2_1_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_1_store_gate

.case_group2_1_gate_false:
    MOVEQ   #0,D1

.case_group2_1_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Y
    BRA.W   .evaluate_next_candidate

.case_group2_2:
    MOVE.B  CONFIG_NicheModeCycleBudget_Static,D0
    TST.B   D0
    BLE.S   .case_group2_2_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Static
    BGT.S   .case_group2_2_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_2_store_gate

.case_group2_2_gate_false:
    MOVEQ   #0,D1

.case_group2_2_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Static
    BRA.W   .evaluate_next_candidate

.case_group2_3:
    MOVE.B  CONFIG_NicheModeCycleBudget_Custom,D0
    TST.B   D0
    BLE.S   .case_group2_3_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Custom
    BGT.S   .case_group2_3_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_3_store_gate

.case_group2_3_gate_false:
    MOVEQ   #0,D1

.case_group2_3_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Custom
    BRA.W   .evaluate_next_candidate

.case_group2_0:
    MOVE.L  GCOMMAND_NicheModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_0_gate_false

    SUBQ.B  #1,NEWGRID_NicheModeCycleBudget_Global
    BGT.S   .case_group2_0_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_0_store_gate

.case_group2_0_gate_false:
    MOVEQ   #0,D1

.case_group2_0_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_NicheModeCycleBudget_Global
    BRA.W   .evaluate_next_candidate

.case_group2_4:
    MOVE.L  GCOMMAND_MplexModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_4_gate_false

    SUBQ.B  #1,NEWGRID_MplexModeCycleBudget
    BGT.S   .case_group2_4_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_4_store_gate

.case_group2_4_gate_false:
    MOVEQ   #0,D1

.case_group2_4_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_MplexModeCycleBudget
    BRA.W   .evaluate_next_candidate

.case_group2_5:
    MOVE.L  GCOMMAND_PpvModeCycleCount,D0
    TST.L   D0
    BLE.S   .case_group2_5_gate_false

    SUBQ.B  #1,NEWGRID_PpvModeCycleBudget
    BGT.S   .case_group2_5_gate_false

    MOVEQ   #1,D1
    BRA.S   .case_group2_5_store_gate

.case_group2_5_gate_false:
    MOVEQ   #0,D1

.case_group2_5_store_gate:
    MOVE.L  D1,D5
    TST.W   D5
    BEQ.W   .evaluate_next_candidate

    MOVE.B  D0,NEWGRID_PpvModeCycleBudget
    BRA.W   .evaluate_next_candidate

.case_group2_7:
    MOVEQ   #1,D5
    BRA.W   .evaluate_next_candidate

.return_selected_mode:
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
;   NEWGRID_IsGridReadyForInput (NEWGRID_IsGridReadyForInput), NEWGRID_SelectNextMode (NEWGRID_SelectNextMode)
; READS:
;   GCOMMAND_NicheModeCycleCount/GCOMMAND_NicheForceMode5Flag
; WRITES:
;   GCOMMAND_NicheModeCycleCount (cleared when case 0x3E hit)
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
    BSR.W   NEWGRID_IsGridReadyForInput

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
    TST.L   GCOMMAND_NicheForceMode5Flag
    BEQ.S   .case_sel_5

    MOVEQ   #5,D7
    CLR.L   GCOMMAND_NicheModeCycleCount
    BRA.S   .return_mapped_mode

.case_sel_5:
    BSR.W   NEWGRID_SelectNextMode

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
;   _LVOSetDrMd, NEWGRID_SetRowColor, _LVOSetAPen, _LVORectFill, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry,
;   NEWGRID_JMPTBL_MATH_Mulu32, _LVOTextLength, _LVOMove, _LVOText, NEWGRID_ValidateSelectionCode
; READS:
;   NEWGRID_ColumnStartXPx/232B, NEWGRID_RowHeightPx
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the grid header bar and column labels for three day slots.
; NOTES:
;   Uses wraparound at 48 and centers text within computed column widths.
;------------------------------------------------------------------------------
NEWGRID_DrawClockFormatHeader:
    LINK.W  A5,#-108
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7

    LEA     60(A3),A0
    MOVE.L  A0,-102(A5)

    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_SetRowColor(PC)

    MOVEA.L -102(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L -102(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -102(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     28(A7),A7
    MOVEQ   #0,D6

.loop_columns:
    MOVEQ   #3,D0
    CMP.L   D0,D6
    BGE.W   .finish_columns

    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #48,D1
    CMP.L   D1,D0
    BLE.S   .use_wrapped_slot_index

    SUB.L   D1,D0
    BRA.S   .use_current_slot_index

.use_wrapped_slot_index:
    MOVE.L  D7,D0
    ADD.L   D6,D0

.use_current_slot_index:
    MOVE.L  D0,D5
    PEA     -97(A5)
    MOVE.L  D5,-(A7)
    JSR     NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #0,D1
    MOVE.W  NEWGRID_ColumnWidthPx,D1
    MOVE.L  D0,28(A7)
    MOVE.L  D6,D0
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  28(A7),D1
    ADD.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #36,D0
    ADD.L   D0,D4
    MOVEQ   #2,D0
    CMP.L   D0,D6
    BNE.S   .compute_column_right_edge

    MOVE.L  #695,D0
    BRA.S   .draw_column_frame_bg

.compute_column_right_edge:
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D0
    ADD.L   D4,D0
    SUBQ.L  #1,D0

.draw_column_frame_bg:
    PEA     33.W
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  -102(A5),-(A7)
    MOVE.L  D0,-16(A5)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     20(A7),A7

    MOVEA.L -102(A5),A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
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
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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

.finish_columns:
    MOVE.W  #17,52(A3)
    PEA     64.W
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_ValidateSelectionCode(PC)

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
;   NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING, _LVOSetDrMd, NEWGRID_SetRowColor, _LVOSetAPen,
;   _LVORectFill, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   NEWGRID_ColumnStartXPx/232B
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Builds a date string and draws it centered in the top banner.
; NOTES:
;   Uses raster sub-struct at 60(A3).
;------------------------------------------------------------------------------
NEWGRID_DrawDateBanner:

.rastport   = -108

    LINK.W  A5,#-116
    MOVEM.L D2-D3/D7/A3,-(A7)

    MOVEA.L 8(A5),A3
    LEA     60(A3),A0
    PEA     -100(A5)
    MOVE.L  A0,.rastport(A5)
    JSR     NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    PEA     7.W
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    JSR     NEWGRID_SetRowColor(PC)

    MOVEA.L .rastport(A5),A1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Fill in the blue background for behind the date string
    MOVEA.L .rastport(A5),A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVE.L  #695,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  .rastport(A5),-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L .rastport(A5),A1
    MOVEQ   #3,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
    MOVE.W  NEWGRID_ColumnWidthPx,D1
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
;   NEWGRID_DrawGridFrame, _LVOSetAPen, _LVOTextLength, _LVOMove, NEWGRID_DrawWrappedText, NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight
; READS:
;   NEWGRID_RowHeightPx, Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION
; WRITES:
;   52(A3), 32(A3)
; DESC:
;   Draws the “Awaiting Listings Data” banner centered in the grid area.
; NOTES:
;   Uses text length to center the string within the 624px region.
;------------------------------------------------------------------------------
NEWGRID_DrawAwaitingListingsMessage:
    LINK.W  A5,#-4
    MOVEM.L D2/A2-A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVEQ   #4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    BSR.W   NEWGRID_DrawGridFrame

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    LEA     60(A3),A1
    MOVEA.L Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2

.measure_message:
    TST.B   (A2)+
    BNE.S   .measure_message

    SUBQ.L  #1,A2
    SUBA.L  Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A2
    MOVE.L  A0,32(A7)
    MOVE.L  A2,D0

    ; Get the length of the Awaiting Listings Data text and subtract it from 624
    MOVEA.L Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,A0
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
    MOVE.W  NEWGRID_RowHeightPx,D0
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
    MOVE.L  Global_PTR_STR_ER007_AWAITING_LISTINGS_DATA_TRANSMISSION,-(A7)
    PEA     612.W
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  52(A7),-(A7)
    BSR.W   NEWGRID_DrawWrappedText

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  NEWGRID_RowHeightPx,D0
    SUBQ.L  #1,D0
    MOVE.L  D0,(A7)
    PEA     695.W
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A7),A7
    MOVE.W  NEWGRID_RowHeightPx,D0
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
;   NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   CONFIG_ModeCycleEnabledFlag, NEWGRID_ModeCycleCountdown
; WRITES:
;   none
; DESC:
;   Copies clockdata, computes a slot index from date fields, and clamps to range.
; NOTES:
;   Returns 0 when month/day out of supported bounds.
;------------------------------------------------------------------------------
NEWGRID_ComputeDaySlotFromClock:
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
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

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
; FUNC: NEWGRID_ComputeDaySlotFromClockWithOffset   (Compute slot with offset)
; ARGS:
;   stack +8: A3 = clockdata struct
; RET:
;   D0: slot index (1..48) or 0 on invalid
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex
; READS:
;   GCOMMAND_MplexClockOffsetMinutes
; WRITES:
;   none
; DESC:
;   Computes a day slot index using a dynamic offset (GCOMMAND_MplexClockOffsetMinutes) and clamps it.
; NOTES:
;   Similar to NEWGRID_ComputeDaySlotFromClock but adjusts thresholds.
;------------------------------------------------------------------------------
NEWGRID_ComputeDaySlotFromClockWithOffset:
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
    JSR     NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D7
    MOVE.W  D0,D7
    MOVEQ   #60,D0
    MOVE.L  GCOMMAND_MplexClockOffsetMinutes,D1
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
; FUNC: NEWGRID_AdjustClockStringBySlot   (Adjust clock string and validate)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds, NEWGRID_JMPTBL_MATH_DivS32, NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_DATETIME_SecondsToStruct, NEWGRID_ComputeDaySlotFromClock
; READS:
;   CLOCK_FormatVariantCode
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Copies clock string, converts it to slot seconds, and validates via slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
NEWGRID_AdjustClockStringBySlot:
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
    JSR     NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #60,D0
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     NEWGRID_JMPTBL_DATETIME_SecondsToStruct(PC)

    PEA     -22(A5)
    BSR.W   NEWGRID_ComputeDaySlotFromClock

    MOVEM.L -36(A5),D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_AdjustClockStringBySlotWithOffset   (Adjust clock string with offset)
; ARGS:
;   stack +8: A3 = clockdata pointer
; RET:
;   D0: result/status
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds, NEWGRID_JMPTBL_MATH_DivS32, NEWGRID_JMPTBL_MATH_Mulu32, NEWGRID_JMPTBL_DATETIME_SecondsToStruct, NEWGRID_ComputeDaySlotFromClockWithOffset
; READS:
;   CLOCK_FormatVariantCode
; WRITES:
;   local buffer -22(A5)
; DESC:
;   Like NEWGRID_AdjustClockStringBySlot but uses the offset-based slot computation.
; NOTES:
;   Uses 22-byte copy (DBF runs D0+1 iterations).
;------------------------------------------------------------------------------
NEWGRID_AdjustClockStringBySlotWithOffset:
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
    JSR     NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.B  CLOCK_FormatVariantCode,D0
    MOVEQ   #30,D1
    JSR     NEWGRID_JMPTBL_MATH_DivS32(PC)

    MOVEQ   #60,D0
    JSR     NEWGRID_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D7
    PEA     -22(A5)
    MOVE.L  D7,-(A7)
    JSR     NEWGRID_JMPTBL_DATETIME_SecondsToStruct(PC)

    PEA     -22(A5)
    BSR.W   NEWGRID_ComputeDaySlotFromClockWithOffset

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
;   NEWGRID_HeaderRastPortPtr
; WRITES:
;   none
; DESC:
;   Draws a 1-pixel-tall horizontal bar at the top of the grid area.
; NOTES:
;   Uses pen 7 on the secondary grid rastport.
;------------------------------------------------------------------------------
NEWGRID_DrawTopBorderLine:
    MOVEM.L D2-D3,-(A7)

    MOVEA.L NEWGRID_HeaderRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    ; Draw a filled rect from 0,0 to 695,1
    MOVEA.L NEWGRID_HeaderRastPortPtr,A1
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
;   NEWGRID_ColumnStartXPx
; WRITES:
;   none
; DESC:
;   Fills two horizontal rectangles in the grid header region with different pens.
; NOTES:
;   Uses SetOffsetForStack macro for parameters.
;------------------------------------------------------------------------------
NEWGRID_FillGridRects:
    MOVEM.L D2-D3/D5-D7/A3,-(A7)

    SetOffsetForStack 6

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7
    MOVE.L  .stackOffsetBytes+12(A7),D6
    MOVE.L  .stackOffsetBytes+16(A7),D5

    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
    MOVE.W  NEWGRID_ColumnStartXPx,D0
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
;   NEWGRID_FillGridRects (NEWGRID_FillGridRects)
; READS:
;   NEWGRID_HeaderRastPortPtr
; WRITES:
;   none
; DESC:
;   Draws the top bar rectangles using fixed parameters.
; NOTES:
;   Wrapper around NEWGRID_FillGridRects.
;------------------------------------------------------------------------------
NEWGRID_DrawGridTopBars:
    PEA     1.W
    MOVEQ   #6,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_HeaderRastPortPtr,-(A7)
    BSR.S   NEWGRID_FillGridRects

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
;   NEWGRID_SetRowColor, NEWGRID_FillGridRects (NEWGRID_FillGridRects)
; READS:
;   NEWGRID_ColumnStartXPx
; WRITES:
;   none
; DESC:
;   Draws header frame segments using pens and coordinates.
; NOTES:
;   Uses NEWGRID_SetRowColor to set pens before filling.
;------------------------------------------------------------------------------
NEWGRID_DrawGridFrame:
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
    JSR     NEWGRID_SetRowColor(PC)

    MOVE.L  D6,(A7)
    CLR.L   -(A7)
    MOVE.L  A3,-(A7)
    MOVE.L  D0,40(A7)
    JSR     NEWGRID_SetRowColor(PC)

    MOVE.L  D5,(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  44(A7),-(A7)
    MOVE.L  44(A7),-(A7)
    BSR.W   NEWGRID_FillGridRects

    MOVEM.L -24(A5),D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_ShouldOpenEditor   (Check if entry can open editor)
; ARGS:
;   stack +8: A3 = entry pointer
; RET:
;   D0: 1 if editable, 0 otherwise
; CLOBBERS:
;   D0/D7/A0-A3
; CALLS:
;   NEWGRID2_JMPTBL_STR_SkipClass3Chars
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
    LINK.W  A5,#-12
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEQ   #0,D7
    MOVE.L  A3,D0
    BEQ.S   .return_open_flag

    LEA     19(A3),A0
    MOVE.L  A0,-(A7)
    MOVE.L  A0,-12(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     1(A3),A0
    MOVE.L  A0,(A7)
    MOVE.L  D0,-12(A5)
    MOVE.L  A0,-8(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-8(A5)
    TST.L   -12(A5)
    BEQ.S   .check_primary_text

    MOVEA.L -12(A5),A0
    TST.B   (A0)
    BNE.S   .reject_open

.check_primary_text:
    TST.L   D0
    BEQ.S   .check_editor_flag

    MOVEA.L D0,A0
    TST.B   (A0)
    BNE.S   .reject_open

.check_editor_flag:
    BTST    #5,27(A3)
    BEQ.S   .reject_open

    MOVEQ   #1,D0
    BRA.S   .store_open_decision

.reject_open:
    MOVEQ   #0,D0

.store_open_decision:
    MOVE.L  D0,D7

.return_open_flag:
    MOVE.L  D7,D0
    MOVEM.L (A7)+,D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_DrawWrappedText   (Draw and wrap text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +70: arg_7 (via 74(A5))
; RET:
;   D0: pointer to next word (or current)
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   NEWGRID2_JMPTBL_STR_SkipClass3Chars, NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN, _LVOTextLength, _LVOMove, _LVOText
; READS:
;   Global_STR_SINGLE_SPACE, NEWGRID_WrapWordSpacer, NEWGRID_WrapReturnSpacer
; WRITES:
;   local buffers -74(A5)
; DESC:
;   Draws words from a string with wrapping based on available width, returning
;   the next pointer to continue from.
; NOTES:
;   When draw flag is zero, calculates positions without drawing.
;------------------------------------------------------------------------------
NEWGRID_DrawWrappedText:
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
    BEQ.S   .init_empty_input

    MOVE.L  A2,-(A7)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-20(A5)
    BRA.S   .begin_word_scan

.init_empty_input:
    SUBA.L  A0,A0
    MOVE.L  A0,-20(A5)

.begin_word_scan:
    MOVE.L  -20(A5),-24(A5)
    MOVEA.L A3,A1

    ; Get the width of a single space
    LEA     Global_STR_SINGLE_SPACE,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,-8(A5)
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    JSR     _LVOMove(A6)

.process_words:
    TST.L   -20(A5)
    BEQ.W   .return_next_ptr_or_current

    PEA     NEWGRID_WrapWordSpacer
    PEA     50.W
    PEA     -74(A5)
    MOVE.L  -20(A5),-(A7)
    JSR     NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN(PC)

    MOVE.L  D0,(A7)
    MOVE.L  D0,-20(A5)
    JSR     NEWGRID2_JMPTBL_STR_SkipClass3Chars(PC)

    LEA     16(A7),A7
    MOVE.B  -74(A5),D1
    MOVE.L  D0,-20(A5)
    TST.B   D1
    BNE.S   .measure_current_word

    MOVEQ   #0,D0
    BRA.W   .return_next_ptr_or_current

.measure_current_word:
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
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    MOVE.L  D0,-4(A5)
    CMP.L   D1,D0
    BGT.S   .handle_word_overflow

    TST.L   28(A5)
    BEQ.S   .advance_after_word

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

.advance_after_word:
    MOVE.L  -4(A5),D0
    ADD.L   D0,-12(A5)
    MOVE.L  -20(A5),-24(A5)
    BRA.S   .check_following_word

.handle_word_overflow:
    CMP.L   D5,D0
    BLE.S   .return_previous_word_ptr

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
    BLE.S   .draw_trimmed_fragment

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D5,D1
    SUB.L   -12(A5),D1
    CMP.L   D1,D0
    BLE.S   .draw_trimmed_fragment

    SUBQ.L  #1,-16(A5)
    BRA.S   .shrink_word

.draw_trimmed_fragment:
    MOVE.L  -16(A5),D0
    TST.L   D0
    BLE.S   .return_trimmed_ptr

    TST.L   28(A5)
    BEQ.S   .return_trimmed_ptr

    MOVEA.L A3,A1
    LEA     -74(A5),A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.return_trimmed_ptr:
    MOVEA.L -24(A5),A0
    MOVEA.L A0,A1
    ADDA.L  -16(A5),A1
    MOVE.L  A1,D0
    BRA.S   .return_next_ptr_or_current

.return_previous_word_ptr:
    MOVE.L  -24(A5),D0
    BRA.S   .return_next_ptr_or_current

.check_following_word:
    MOVEA.L -20(A5),A0
    TST.B   (A0)
    BEQ.W   .process_words

    MOVE.L  -8(A5),D0
    ADD.L   -12(A5),D0
    CMP.L   D5,D0
    BGT.S   .return_word_boundary_ptr

    TST.L   28(A5)
    BEQ.S   .draw_space

    ; Draw a single space
    MOVEA.L A3,A1
    LEA     NEWGRID_WrapReturnSpacer,A0
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOText(A6)

.draw_space:
    MOVE.L  -8(A5),D0
    ADD.L   D0,-12(A5)
    BRA.W   .process_words

.return_word_boundary_ptr:
    MOVE.L  -24(A5),D0

.return_next_ptr_or_current:
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
;   NEWGRID_AdjustClockStringBySlot, CLEANUP_DrawClockFormatList/Frame, NEWGRID2_DispatchOperationDefault,
;   NEWGRID_MapSelectionToMode, _LVOGetMsg, NEWGRID_ValidateSelectionCode, NEWGRID_DrawClockFormatHeader,
;   NEWGRID_DrawDateBanner, NEWGRID_DrawAwaitingListingsMessage, NEWGRID2_DispatchGridOperation, NEWGRID_MapSelectionToMode,
;   GCOMMAND_UpdatePresetEntryCache, _LVOPutMsg, NEWGRID_DrawGridTopBars
; READS:
;   Global_UIBusyFlag, ESQPARS2_ReadModeFlags, NEWGRID_RefreshStateFlag, NEWGRID_MainModeState, NEWGRID_MainModeState/2010/2011/2012, ESQ_HighlightReplyPort
; WRITES:
;   NEWGRID_MainModeState, NEWGRID_RefreshStateFlag, ESQPARS2_ReadModeFlags, NEWGRID_SelectedDaySlot-2012
; DESC:
;   Main event loop for grid editing: initializes UI state, pulls messages,
;   dispatches by mode, and updates selection and redraws.
; NOTES:
;   Uses switch/jumptable for mode handling; resets highlight when needed.
;------------------------------------------------------------------------------
NEWGRID_ProcessGridMessages:
    LINK.W  A5,#-4
    TST.W   Global_UIBusyFlag
    BNE.W   .return_from_loop

    MOVE.W  ESQPARS2_ReadModeFlags,D0
    CMPI.W  #$101,D0
    BNE.S   .check_reinit

    CLR.W   ESQPARS2_ReadModeFlags
    BRA.W   .return_from_loop

.check_reinit:
    TST.L   NEWGRID_RefreshStateFlag
    BEQ.S   .reset_selection

    MOVEQ   #1,D0
    CMP.L   NEWGRID_RefreshStateFlag,D0
    BNE.S   .maybe_init_ui

.reset_selection:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_MainModeState

.maybe_init_ui:
    TST.L   NEWGRID_MainModeState
    BNE.S   .poll_highlight_message

    BSR.W   NEWGRID_InitGridResources

    BSR.W   NEWGRID_ClearHighlightArea

    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockBanner(PC)

    PEA     CLOCK_CurrentDayOfWeekIndex
    BSR.W   NEWGRID_AdjustClockStringBySlot

    MOVE.L  D0,(A7)
    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList(PC)

    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame(PC)

    CLR.W   ESQPARS2_ReadModeFlags
    MOVEQ   #2,D0
    MOVE.L  D0,NEWGRID_RefreshStateFlag
    JSR     NEWGRID2_DispatchOperationDefault(PC)

    CLR.L   (A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState

.poll_highlight_message:
    MOVEA.L ESQ_HighlightReplyPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return_from_loop

    MOVEA.L D0,A0
    CLR.W   52(A0)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     NEWGRID_ValidateSelectionCode(PC)

    ADDQ.W  #8,A7
    MOVEA.L -4(A5),A0
    CLR.L   32(A0)

.dispatch_main_mode:
    MOVE.L  NEWGRID_MainModeState,D0
    SUBQ.L  #1,D0
    BLT.W   .finalize_and_reply_message

    CMPI.L  #12,D0
    BGE.W   .finalize_and_reply_message

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
    JSR     NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel(PC)

    ADDQ.W  #8,A7
    TST.W   D0
    BNE.W   .finalize_and_reply_message

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_1:
    PEA     CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClock

    PEA     CLOCK_CurrentDayOfWeekIndex
    MOVE.W  D0,NEWGRID_SelectedDaySlot
    BSR.W   NEWGRID_AdjustClockStringBySlot

    MOVE.W  D0,NEWGRID_RenderDaySlot
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_DrawClockFormatHeader

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    LEA     16(A7),A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_2:
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_DrawDateBanner

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_10:
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_DrawAwaitingListingsMessage

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_3:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.W  NEWGRID_RenderDaySlot,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     1.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   .finalize_and_reply_message

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_4:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.W  NEWGRID_RenderDaySlot,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     5.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     16(A7),A7
    TST.L   D0
    BNE.W   .finalize_and_reply_message

    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_5:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.W  NEWGRID_RenderDaySlot,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     2.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode5_map_and_advance

    MOVE.W  #1,NEWGRID_HeaderRedrawPending
    BRA.W   .finalize_and_reply_message

.case_mode5_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_6:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.W  NEWGRID_RenderDaySlot,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     3.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode6_map_and_advance

    MOVE.W  #1,NEWGRID_HeaderRedrawPending
    BRA.W   .finalize_and_reply_message

.case_mode6_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_7:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.W  NEWGRID_RenderDaySlot,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     4.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     16(A7),A7
    TST.L   D0
    BEQ.S   .case_mode7_map_and_advance

    MOVE.W  #1,NEWGRID_HeaderRedrawPending
    BRA.W   .finalize_and_reply_message

.case_mode7_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_8:
    PEA     CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClockWithOffset

    PEA     CLOCK_CurrentDayOfWeekIndex
    MOVE.W  D0,NEWGRID_SelectedDaySlot
    BSR.W   NEWGRID_AdjustClockStringBySlotWithOffset

    MOVE.W  NEWGRID_SelectedDaySlot,D1
    EXT.L   D1
    MOVE.W  D0,NEWGRID_RenderDaySlot
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     6.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .case_mode8_map_and_advance

    MOVE.W  #1,NEWGRID_HeaderRedrawPending
    BRA.W   .finalize_and_reply_message

.case_mode8_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.W   .finalize_and_reply_message

.case_mode_9:
    PEA     CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClock

    PEA     CLOCK_CurrentDayOfWeekIndex
    MOVE.W  D0,NEWGRID_SelectedDaySlot
    BSR.W   NEWGRID_AdjustClockStringBySlot

    MOVE.W  NEWGRID_SelectedDaySlot,D1
    EXT.L   D1
    MOVE.W  D0,NEWGRID_RenderDaySlot
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    PEA     7.W
    JSR     NEWGRID2_DispatchGridOperation(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.S   .case_mode9_map_and_advance

    MOVE.W  #1,NEWGRID_HeaderRedrawPending
    BRA.S   .finalize_and_reply_message

.case_mode9_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState
    BRA.S   .finalize_and_reply_message

.case_mode_11:
    TST.W   NEWGRID_HeaderRedrawPending
    BEQ.S   .case_mode11_map_and_advance

    MOVE.W  NEWGRID_RenderDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   NEWGRID_DrawClockFormatHeader

    ADDQ.W  #8,A7
    CLR.W   NEWGRID_HeaderRedrawPending

.case_mode11_map_and_advance:
    MOVE.W  NEWGRID_SelectedDaySlot,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState

.finalize_and_reply_message:
    MOVEA.L -4(A5),A0
    CMPI.W  #0,52(A0)
    BLS.W   .dispatch_main_mode

    MOVE.L  -4(A5),-(A7)
    JSR     GCOMMAND_UpdatePresetEntryCache(PC)

    ADDQ.W  #4,A7
    MOVEA.L ESQ_HighlightMsgPort,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    TST.W   NEWGRID_HeaderRedrawPending
    BEQ.S   .draw_top_border_line

    BSR.W   NEWGRID_DrawGridTopBars

    BRA.S   .return_from_loop

.draw_top_border_line:
    BSR.W   NEWGRID_DrawTopBorderLine

.return_from_loop:
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD

;!======

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_MATH_DivS32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivS32
; DESC:
;   Jump table entry that forwards to MATH_DivS32.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DATETIME_SecondsToStruct   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DATETIME_SecondsToStruct
; DESC:
;   Jump table entry that forwards to DATETIME_SecondsToStruct.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DATETIME_SecondsToStruct:
    JMP     DATETIME_SecondsToStruct

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   GENERATE_GRID_DATE_STRING
; DESC:
;   Jump table entry that forwards to GENERATE_GRID_DATE_STRING.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING:
    JMP     GENERATE_GRID_DATE_STRING

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_MEMORY_DeallocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_DeallocateMemory
; DESC:
;   Jump table entry that forwards to MEMORY_DeallocateMemory.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_MEMORY_DeallocateMemory:
    JMP     MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawClockFormatList
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockFormatList.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList:
    JMP     CLEANUP_DrawClockFormatList

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DISPTEXT_FreeBuffers   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPTEXT_FreeBuffers
; DESC:
;   Jump table entry that forwards to DISPTEXT_FreeBuffers.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DISPTEXT_FreeBuffers:
    JMP     DISPTEXT_FreeBuffers

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_CLEANUP_DrawClockBanner   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawClockBanner
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockBanner.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockBanner:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_MEMORY_AllocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MEMORY_AllocateMemory
; DESC:
;   Jump table entry that forwards to MEMORY_AllocateMemory.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_MEMORY_AllocateMemory:
    JMP     MEMORY_AllocateMemory

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DISPTEXT_InitBuffers   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DISPTEXT_InitBuffers
; DESC:
;   Jump table entry that forwards to DISPTEXT_InitBuffers.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DISPTEXT_InitBuffers:
    JMP     DISPTEXT_InitBuffers

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawClockFormatFrame
; DESC:
;   Jump table entry that forwards to CLEANUP_DrawClockFormatFrame.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame:
    JMP     CLEANUP_DrawClockFormatFrame

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   DATETIME_NormalizeStructToSeconds
; DESC:
;   Jump table entry that forwards to DATETIME_NormalizeStructToSeconds.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds:
    JMP     DATETIME_NormalizeStructToSeconds

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STR_CopyUntilAnyDelimN
; DESC:
;   Jump table entry that forwards to STR_CopyUntilAnyDelimN.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN:
    JMP     STR_CopyUntilAnyDelimN

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   WDISP_UpdateSelectionPreviewPanel
; DESC:
;   Jump table entry that forwards to WDISP_UpdateSelectionPreviewPanel.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel:
    JMP     WDISP_UpdateSelectionPreviewPanel

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_MATH_Mulu32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; DESC:
;   Jump table entry that forwards to MATH_Mulu32.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32
