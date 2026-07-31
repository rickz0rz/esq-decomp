    XDEF    GCOMMAND_RefreshBannerTables
    XDEF    _GCOMMAND_ServiceHighlightMessages
    XDEF    GCOMMAND_TickHighlightState


;------------------------------------------------------------------------------
; FUNC: GCOMMAND_RefreshBannerTables   (Rebuild active rows in both banner copper tables)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A1
; CALLS:
;   _GCOMMAND_BuildBannerRow
; READS:
;   _GCOMMAND_BannerRowByteOffsetCurrent, _GCOMMAND_BannerRowByteOffsetPrevious, _GCOMMAND_BannerPhaseIndexCurrent, _WDISP_BannerRowScratchRasterTable0.._WDISP_BannerRowScratchRasterTable2, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; WRITES:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, _ESQPARS2_BannerSnapshotPlane1DstPtr, _ESQPARS2_BannerSnapshotPlane2DstPtr
; DESC:
;   Rebuilds banner rows for both tables and refreshes row pointer globals.
; NOTES:
;   Uses _GCOMMAND_BannerRowByteOffsetCurrent as the active row index and _GCOMMAND_BannerPhaseIndexCurrent as the base offset.
;------------------------------------------------------------------------------
GCOMMAND_RefreshBannerTables:
    MOVE.L  _GCOMMAND_BannerRowByteOffsetCurrent,-(A7)
    PEA     98.W
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerA
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_BuildBannerRow

    MOVEQ   #88,D0
    ADD.L   _GCOMMAND_BannerRowByteOffsetCurrent,D0
    MOVE.L  D0,(A7)
    PEA     98.W
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerB
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   _GCOMMAND_BuildBannerRow

    LEA     36(A7),A7
    MOVE.L  _GCOMMAND_BannerRowByteOffsetPrevious,D0
    MOVEA.L _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane0DstPtr
    MOVEA.L _WDISP_BannerRowScratchRasterTable1,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane1DstPtr
    MOVEA.L _WDISP_BannerRowScratchRasterTable2,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane2DstPtr
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ServiceHighlightMessages   (Poll/process highlight messages and drive banner updates)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1, A6
; CALLS:
;   _LVOGetMsg, _LVOReplyMsg, _GCOMMAND_LoadPresetWorkEntries,
;   GCOMMAND_RefreshBannerTables, _GCOMMAND_ConsumeBannerQueueEntry,
;   _GCOMMAND_ResetPresetWorkTables, _GCOMMAND_TickPresetWorkEntries,
;   _ESQSHARED4_CopyPlanesFromContextToSnapshot, ESQSHARED4_CopyLivePlanesToSnapshot, _GCOMMAND_MapKeycodeToPreset
; READS:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_PresetWorkResetPendingFlag, _ESQ_HighlightMsgPort, _GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28
; WRITES:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28, message fields at 20/24/28/32/52/54(A0)
; DESC:
;   Polls the highlight message port, processes active messages, and updates
;   banner/preset state each tick.
; NOTES:
;   Replies to messages when their countdown at 52(A0) reaches zero.
;   Message layout (inferred): +20/+24/+28 saved longs, +32 preset record ptr,
;   +52 countdown, +54 keycode/preset trigger byte.
;------------------------------------------------------------------------------
_GCOMMAND_ServiceHighlightMessages:
    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BNE.S   .update_tables

    MOVEA.L _ESQ_HighlightMsgPort,A0
    MOVEA.L AbsExecBase,A6
    JSR     _LVOGetMsg(A6)

    MOVE.L  D0,_GCOMMAND_ActiveHighlightMsgPtr
    TST.L   D0
    BEQ.S   .update_tables

    MOVEA.L D0,A0
    MOVE.L  32(A0),D1                     ; A0+32 = preset record ptr (or -1)
    TST.L   D1
    BMI.S   .maybe_store_msg

    MOVE.L  D0,-(A7)
    BSR.W   _GCOMMAND_LoadPresetWorkEntries

    ADDQ.W  #4,A7

.maybe_store_msg:
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  20(A0),_GCOMMAND_ActiveMsgSavedField20 ; A0+20 = saved field 0
    MOVE.L  24(A0),_GCOMMAND_ActiveMsgSavedField24 ; A0+24 = saved field 1
    MOVE.L  28(A0),_GCOMMAND_ActiveMsgSavedField28 ; A0+28 = saved field 2
    MOVE.B  54(A0),D0                       ; A0+54 = keycode/preset trigger
    TST.B   D0
    BEQ.S   .update_tables

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _GCOMMAND_MapKeycodeToPreset

    ADDQ.W  #4,A7
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    CLR.B   54(A0)

.update_tables:
    BSR.W   GCOMMAND_RefreshBannerTables

    BSR.W   _GCOMMAND_ConsumeBannerQueueEntry

    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BEQ.W   .no_active_msg

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .handle_active_msg

    JSR     ESQSHARED4_CopyLivePlanesToSnapshot(PC)

    BRA.S   .check_countdown

.handle_active_msg:
    TST.W   _GCOMMAND_PresetWorkResetPendingFlag
    BEQ.S   .tick_active_msg

    BSR.W   _GCOMMAND_ResetPresetWorkTables

.tick_active_msg:
    BSR.W   _GCOMMAND_TickPresetWorkEntries

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A1
    JSR     _ESQSHARED4_CopyPlanesFromContextToSnapshot(PC)

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVE.L  D0,D1
    SUBQ.W  #1,D1
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  D1,52(A0)                       ; A0+52 = countdown ticks

.check_countdown:
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  52(A0),D0                       ; A0+52 = countdown ticks
    MOVEQ   #0,D1
    CMP.W   D1,D0
    BHI.S   .return

    MOVE.L  _GCOMMAND_ActiveMsgSavedField20,20(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField24,24(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField28,28(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.W  D1,52(A0)                       ; A0+52 = countdown reset to 0
    CLR.L   32(A0)                          ; A0+32 = clear preset record ptr
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOReplyMsg(A6)

    CLR.L   _GCOMMAND_ActiveHighlightMsgPtr
    BRA.S   .return

.no_active_msg:
    JSR     ESQSHARED4_CopyLivePlanesToSnapshot(PC)

.return:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_TickHighlightState   (Advance banner/highlight ring counters for one tick)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A4
; CALLS:
;   _GCOMMAND_RebuildBannerTablesFromBounds, _GCOMMAND_ServiceHighlightMessages
; READS:
;   _GCOMMAND_BannerRebuildPendingFlag, _GCOMMAND_BannerRowByteOffsetResetValue, _GCOMMAND_BannerPhaseIndexCurrent, _GCOMMAND_BannerRowByteOffsetCurrent, _ESQSHARED4_InterleaveCopyTailOffsetReset, _GCOMMAND_BannerQueueSlotCurrent, _GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   _GCOMMAND_BannerPhaseIndexCurrent, _GCOMMAND_BannerRowByteOffsetCurrent, _ESQSHARED4_InterleaveCopyTailOffsetCurrent, _GCOMMAND_BannerQueueSlotPrevious, _GCOMMAND_BannerQueueSlotCurrent, _GCOMMAND_BannerRowIndexPrevious, _GCOMMAND_BannerRowIndexCurrent
; DESC:
;   Advances highlight/cycle counters and updates related globals.
; NOTES:
;   Counter wrap thresholds inferred from constants (98, 88, 32).
;   98 = queue/table ring length, 88 = second-table byte offset delta.
;------------------------------------------------------------------------------
GCOMMAND_TickHighlightState:
    MOVEM.L D2/A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    TST.W   _GCOMMAND_BannerRebuildPendingFlag
    BEQ.S   .skip_rebuild

    BSR.W   _GCOMMAND_RebuildBannerTablesFromBounds

.skip_rebuild:
    ADDQ.L  #1,_GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  _GCOMMAND_BannerRowByteOffsetCurrent,_GCOMMAND_BannerRowByteOffsetPrevious
    MOVEQ   #98,D0
    CMP.L   _GCOMMAND_BannerPhaseIndexCurrent,D0
    BNE.S   .advance_indices

    MOVEQ   #0,D1
    MOVE.L  D1,_GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  _GCOMMAND_BannerRowByteOffsetResetValue,D2
    MOVE.L  D2,_GCOMMAND_BannerRowByteOffsetCurrent
    MOVE.L  _ESQSHARED4_InterleaveCopyTailOffsetReset,D2
    MOVE.L  D2,_ESQSHARED4_InterleaveCopyTailOffsetCurrent
    BRA.S   .update_counters

.advance_indices:
    MOVEQ   #88,D1
    ADD.L   D1,D1
    ADD.L   D1,_GCOMMAND_BannerRowByteOffsetCurrent
    MOVEQ   #32,D1
    ADD.L   D1,_ESQSHARED4_InterleaveCopyTailOffsetCurrent

.update_counters:
    MOVE.W  _GCOMMAND_BannerQueueSlotCurrent,D1
    MOVE.W  D1,_GCOMMAND_BannerQueueSlotPrevious
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,_GCOMMAND_BannerQueueSlotCurrent
    BGE.S   .maybe_reset_slot

    MOVE.W  #$61,_GCOMMAND_BannerQueueSlotCurrent

.maybe_reset_slot:
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D1
    MOVE.L  D1,_GCOMMAND_BannerRowIndexPrevious
    ADDQ.L  #1,_GCOMMAND_BannerRowIndexCurrent
    CMP.L   _GCOMMAND_BannerRowIndexCurrent,D0
    BNE.S   .service_messages

    CLR.L   _GCOMMAND_BannerRowIndexCurrent

.service_messages:
    BSR.W   _GCOMMAND_ServiceHighlightMessages

    MOVEM.L (A7)+,D2/A4
    RTS

;!======