    XDEF    NEWGRID_ProcessGridMessages
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame
    XDEF    NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList
    XDEF    NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds
    XDEF    NEWGRID_JMPTBL_DATETIME_SecondsToStruct
    XDEF    _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers
    XDEF    NEWGRID_JMPTBL_DISPTEXT_InitBuffers
    XDEF    _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING
    XDEF    NEWGRID_JMPTBL_MATH_DivS32
    XDEF    _NEWGRID_JMPTBL_MATH_Mulu32
    XDEF    _NEWGRID_JMPTBL_MEMORY_AllocateMemory
    XDEF    _NEWGRID_JMPTBL_MEMORY_DeallocateMemory
    XDEF    _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN
    XDEF    NEWGRID_JMPTBL_WDISP_UpdateSelectionPreviewPanel


;------------------------------------------------------------------------------
; FUNC: NEWGRID_ProcessGridMessages   (Handle grid UI messages)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A6
; CALLS:
;   NEWGRID_InitGridResources, _NEWGRID_ClearHighlightArea, _CLEANUP_DrawClockBanner,
;   NEWGRID_AdjustClockStringBySlot, _CLEANUP_DrawClockFormatList/Frame, _NEWGRID2_DispatchOperationDefault,
;   NEWGRID_MapSelectionToMode, _LVOGetMsg, _NEWGRID_ValidateSelectionCode, _NEWGRID_DrawClockFormatHeader,
;   _NEWGRID_DrawDateBanner, NEWGRID_DrawAwaitingListingsMessage, _NEWGRID2_DispatchGridOperation, NEWGRID_MapSelectionToMode,
;   GCOMMAND_UpdatePresetEntryCache, _LVOPutMsg, _NEWGRID_DrawGridTopBars
; READS:
;   _Global_UIBusyFlag, _ESQPARS2_ReadModeFlags, _NEWGRID_RefreshStateFlag, NEWGRID_MainModeState, NEWGRID_MainModeState/2010/2011/2012, _ESQ_HighlightReplyPort
; WRITES:
;   NEWGRID_MainModeState, _NEWGRID_RefreshStateFlag, _ESQPARS2_ReadModeFlags, NEWGRID_SelectedDaySlot-2012
; DESC:
;   Main event loop for grid editing: initializes UI state, pulls messages,
;   dispatches by mode, and updates selection and redraws.
; NOTES:
;   Uses switch/jumptable for mode handling; resets highlight when needed.
;------------------------------------------------------------------------------
NEWGRID_ProcessGridMessages:
    LINK.W  A5,#-4
    TST.W   _Global_UIBusyFlag
    BNE.W   .return_from_loop

    MOVE.W  _ESQPARS2_ReadModeFlags,D0
    CMPI.W  #$101,D0
    BNE.S   .check_reinit

    CLR.W   _ESQPARS2_ReadModeFlags
    BRA.W   .return_from_loop

.check_reinit:
    TST.L   _NEWGRID_RefreshStateFlag
    BEQ.S   .reset_selection

    MOVEQ   #1,D0
    CMP.L   _NEWGRID_RefreshStateFlag,D0
    BNE.S   .maybe_init_ui

.reset_selection:
    MOVEQ   #0,D0
    MOVE.L  D0,NEWGRID_MainModeState

.maybe_init_ui:
    TST.L   NEWGRID_MainModeState
    BNE.S   .poll_highlight_message

    BSR.W   NEWGRID_InitGridResources

    BSR.W   _NEWGRID_ClearHighlightArea

    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockBanner(PC)

    PEA     _CLOCK_CurrentDayOfWeekIndex
    BSR.W   NEWGRID_AdjustClockStringBySlot

    MOVE.L  D0,(A7)
    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList(PC)

    JSR     NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame(PC)

    CLR.W   _ESQPARS2_ReadModeFlags
    MOVEQ   #2,D0
    MOVE.L  D0,_NEWGRID_RefreshStateFlag
    JSR     _NEWGRID2_DispatchOperationDefault(PC)

    CLR.L   (A7)
    MOVE.L  NEWGRID_MainModeState,-(A7)
    BSR.W   NEWGRID_MapSelectionToMode

    ADDQ.W  #8,A7
    MOVE.L  D0,NEWGRID_MainModeState

.poll_highlight_message:
    MOVEA.L _ESQ_HighlightReplyPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,-4(A5)
    TST.L   D0
    BEQ.W   .return_from_loop

    MOVEA.L D0,A0
    CLR.W   52(A0)
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    JSR     _NEWGRID_ValidateSelectionCode(PC)

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
    PEA     _CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClock

    PEA     _CLOCK_CurrentDayOfWeekIndex
    MOVE.W  D0,NEWGRID_SelectedDaySlot
    BSR.W   NEWGRID_AdjustClockStringBySlot

    MOVE.W  D0,NEWGRID_RenderDaySlot
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  -4(A5),-(A7)
    BSR.W   _NEWGRID_DrawClockFormatHeader

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
    BSR.W   _NEWGRID_DrawDateBanner

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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    PEA     _CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClockWithOffset

    PEA     _CLOCK_CurrentDayOfWeekIndex
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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    PEA     _CLOCK_DaySlotIndex
    BSR.W   NEWGRID_ComputeDaySlotFromClock

    PEA     _CLOCK_CurrentDayOfWeekIndex
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
    JSR     _NEWGRID2_DispatchGridOperation(PC)

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
    BSR.W   _NEWGRID_DrawClockFormatHeader

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
    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVEA.L -4(A5),A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOPutMsg(A6)

    TST.W   NEWGRID_HeaderRedrawPending
    BEQ.S   .draw_top_border_line

    BSR.W   _NEWGRID_DrawGridTopBars

    BRA.S   .return_from_loop

.draw_top_border_line:
    BSR.W   _NEWGRID_DrawTopBorderLine

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
;   _MATH_DivS32
; DESC:
;   Jump table entry that forwards to _MATH_DivS32.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_MATH_DivS32:
    JMP     _MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DATETIME_SecondsToStruct   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_SecondsToStruct
; DESC:
;   Jump table entry that forwards to _DATETIME_SecondsToStruct.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DATETIME_SecondsToStruct:
    JMP     _DATETIME_SecondsToStruct

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING   (Jump stub)
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
_NEWGRID_JMPTBL_GENERATE_GRID_DATE_STRING:
    JMP     GENERATE_GRID_DATE_STRING

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MEMORY_DeallocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_DeallocateMemory
; DESC:
;   Jump table entry that forwards to _MEMORY_DeallocateMemory.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MEMORY_DeallocateMemory:
    JMP     _MEMORY_DeallocateMemory

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _CLEANUP_DrawClockFormatList
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockFormatList.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockFormatList:
    JMP     _CLEANUP_DrawClockFormatList

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_DISPTEXT_FreeBuffers   (Jump stub)
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
_NEWGRID_JMPTBL_DISPTEXT_FreeBuffers:
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
;   _CLEANUP_DrawClockBanner
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockBanner.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockBanner:
    ; Reuse cleanup module to draw the shared clock banner.
    JMP     _CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_MEMORY_AllocateMemory   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MEMORY_AllocateMemory
; DESC:
;   Jump table entry that forwards to _MEMORY_AllocateMemory.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MEMORY_AllocateMemory:
    JMP     _MEMORY_AllocateMemory

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
;   _CLEANUP_DrawClockFormatFrame
; DESC:
;   Jump table entry that forwards to _CLEANUP_DrawClockFormatFrame.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_CLEANUP_DrawClockFormatFrame:
    JMP     _CLEANUP_DrawClockFormatFrame

;------------------------------------------------------------------------------
; FUNC: NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DATETIME_NormalizeStructToSeconds
; DESC:
;   Jump table entry that forwards to _DATETIME_NormalizeStructToSeconds.
;------------------------------------------------------------------------------
NEWGRID_JMPTBL_DATETIME_NormalizeStructToSeconds:
    JMP     _DATETIME_NormalizeStructToSeconds

;------------------------------------------------------------------------------
; FUNC: _NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN   (Jump stub)
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
_NEWGRID_JMPTBL_STR_CopyUntilAnyDelimN:
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
; FUNC: _NEWGRID_JMPTBL_MATH_Mulu32   (Jump stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _MATH_Mulu32
; DESC:
;   Jump table entry that forwards to _MATH_Mulu32.
;------------------------------------------------------------------------------
_NEWGRID_JMPTBL_MATH_Mulu32:
    JMP     _MATH_Mulu32
