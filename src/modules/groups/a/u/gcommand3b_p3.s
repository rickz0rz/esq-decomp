    XDEF    GCOMMAND_BuildBannerBlock
    XDEF    _GCOMMAND_BuildBannerTables
    XDEF    GCOMMAND_CopyImageDataToBitmap
    XDEF    GCOMMAND_RefreshBannerTables
    XDEF    _GCOMMAND_ResetHighlightMessages
    XDEF    GCOMMAND_ServiceHighlightMessages
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
;   GCOMMAND_BuildBannerRow
; READS:
;   GCOMMAND_BannerRowByteOffsetCurrent, GCOMMAND_BannerRowByteOffsetPrevious, GCOMMAND_BannerPhaseIndexCurrent, _WDISP_BannerRowScratchRasterTable0..WDISP_BannerRowScratchRasterTable2, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; WRITES:
;   _ESQPARS2_BannerSnapshotPlane0DstPtr, ESQPARS2_BannerSnapshotPlane1DstPtr, ESQPARS2_BannerSnapshotPlane2DstPtr
; DESC:
;   Rebuilds banner rows for both tables and refreshes row pointer globals.
; NOTES:
;   Uses GCOMMAND_BannerRowByteOffsetCurrent as the active row index and GCOMMAND_BannerPhaseIndexCurrent as the base offset.
;------------------------------------------------------------------------------
GCOMMAND_RefreshBannerTables:
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,-(A7)
    PEA     98.W
    MOVE.L  GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerA
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   GCOMMAND_BuildBannerRow

    MOVEQ   #88,D0
    ADD.L   GCOMMAND_BannerRowByteOffsetCurrent,D0
    MOVE.L  D0,(A7)
    PEA     98.W
    MOVE.L  GCOMMAND_BannerPhaseIndexCurrent,-(A7)
    PEA     _ESQ_CopperListBannerB
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   GCOMMAND_BuildBannerRow

    LEA     36(A7),A7
    MOVE.L  GCOMMAND_BannerRowByteOffsetPrevious,D0
    MOVEA.L _WDISP_BannerRowScratchRasterTable0,A0
    ADDA.L  D0,A0
    MOVE.L  A0,_ESQPARS2_BannerSnapshotPlane0DstPtr
    MOVEA.L WDISP_BannerRowScratchRasterTable1,A0
    ADDA.L  D0,A0
    MOVE.L  A0,ESQPARS2_BannerSnapshotPlane1DstPtr
    MOVEA.L WDISP_BannerRowScratchRasterTable2,A0
    ADDA.L  D0,A0
    MOVE.L  A0,ESQPARS2_BannerSnapshotPlane2DstPtr
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ServiceHighlightMessages   (Poll/process highlight messages and drive banner updates)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0-A1, A6
; CALLS:
;   _LVOGetMsg, _LVOReplyMsg, _GCOMMAND_LoadPresetWorkEntries,
;   GCOMMAND_RefreshBannerTables, _GCOMMAND_ConsumeBannerQueueEntry,
;   GCOMMAND_ResetPresetWorkTables, GCOMMAND_TickPresetWorkEntries,
;   _ESQSHARED4_CopyPlanesFromContextToSnapshot, ESQSHARED4_CopyLivePlanesToSnapshot, _GCOMMAND_MapKeycodeToPreset
; READS:
;   _GCOMMAND_ActiveHighlightMsgPtr, _GCOMMAND_PresetWorkResetPendingFlag, _ESQ_HighlightMsgPort, GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28
; WRITES:
;   _GCOMMAND_ActiveHighlightMsgPtr, GCOMMAND_ActiveMsgSavedField20.._GCOMMAND_ActiveMsgSavedField28, message fields at 20/24/28/32/52/54(A0)
; DESC:
;   Polls the highlight message port, processes active messages, and updates
;   banner/preset state each tick.
; NOTES:
;   Replies to messages when their countdown at 52(A0) reaches zero.
;   Message layout (inferred): +20/+24/+28 saved longs, +32 preset record ptr,
;   +52 countdown, +54 keycode/preset trigger byte.
;------------------------------------------------------------------------------
GCOMMAND_ServiceHighlightMessages:
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
    MOVE.L  20(A0),GCOMMAND_ActiveMsgSavedField20 ; A0+20 = saved field 0
    MOVE.L  24(A0),GCOMMAND_ActiveMsgSavedField24 ; A0+24 = saved field 1
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

    BSR.W   GCOMMAND_ResetPresetWorkTables

.tick_active_msg:
    BSR.W   GCOMMAND_TickPresetWorkEntries

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

    MOVE.L  GCOMMAND_ActiveMsgSavedField20,20(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  GCOMMAND_ActiveMsgSavedField24,24(A0)
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
;   GCOMMAND_RebuildBannerTablesFromBounds, GCOMMAND_ServiceHighlightMessages
; READS:
;   GCOMMAND_BannerRebuildPendingFlag, GCOMMAND_BannerRowByteOffsetResetValue, GCOMMAND_BannerPhaseIndexCurrent, GCOMMAND_BannerRowByteOffsetCurrent, _ESQSHARED4_InterleaveCopyTailOffsetReset, _GCOMMAND_BannerQueueSlotCurrent, GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   GCOMMAND_BannerPhaseIndexCurrent, GCOMMAND_BannerRowByteOffsetCurrent, ESQSHARED4_InterleaveCopyTailOffsetCurrent, _GCOMMAND_BannerQueueSlotPrevious, _GCOMMAND_BannerQueueSlotCurrent, GCOMMAND_BannerRowIndexPrevious, GCOMMAND_BannerRowIndexCurrent
; DESC:
;   Advances highlight/cycle counters and updates related globals.
; NOTES:
;   Counter wrap thresholds inferred from constants (98, 88, 32).
;   98 = queue/table ring length, 88 = second-table byte offset delta.
;------------------------------------------------------------------------------
GCOMMAND_TickHighlightState:
    MOVEM.L D2/A4,-(A7)
    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    TST.W   GCOMMAND_BannerRebuildPendingFlag
    BEQ.S   .skip_rebuild

    BSR.W   GCOMMAND_RebuildBannerTablesFromBounds

.skip_rebuild:
    ADDQ.L  #1,GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,GCOMMAND_BannerRowByteOffsetPrevious
    MOVEQ   #98,D0
    CMP.L   GCOMMAND_BannerPhaseIndexCurrent,D0
    BNE.S   .advance_indices

    MOVEQ   #0,D1
    MOVE.L  D1,GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  GCOMMAND_BannerRowByteOffsetResetValue,D2
    MOVE.L  D2,GCOMMAND_BannerRowByteOffsetCurrent
    MOVE.L  _ESQSHARED4_InterleaveCopyTailOffsetReset,D2
    MOVE.L  D2,ESQSHARED4_InterleaveCopyTailOffsetCurrent
    BRA.S   .update_counters

.advance_indices:
    MOVEQ   #88,D1
    ADD.L   D1,D1
    ADD.L   D1,GCOMMAND_BannerRowByteOffsetCurrent
    MOVEQ   #32,D1
    ADD.L   D1,ESQSHARED4_InterleaveCopyTailOffsetCurrent

.update_counters:
    MOVE.W  _GCOMMAND_BannerQueueSlotCurrent,D1
    MOVE.W  D1,_GCOMMAND_BannerQueueSlotPrevious
    MOVE.L  D1,D2
    SUBQ.W  #1,D2
    MOVE.W  D2,_GCOMMAND_BannerQueueSlotCurrent
    BGE.S   .maybe_reset_slot

    MOVE.W  #$61,_GCOMMAND_BannerQueueSlotCurrent

.maybe_reset_slot:
    MOVE.L  GCOMMAND_BannerRowIndexCurrent,D1
    MOVE.L  D1,GCOMMAND_BannerRowIndexPrevious
    ADDQ.L  #1,GCOMMAND_BannerRowIndexCurrent
    CMP.L   GCOMMAND_BannerRowIndexCurrent,D0
    BNE.S   .service_messages

    CLR.L   GCOMMAND_BannerRowIndexCurrent

.service_messages:
    BSR.W   GCOMMAND_ServiceHighlightMessages

    MOVEM.L (A7)+,D2/A4
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ResetHighlightMessages   (Clear active/highlight message slots and restore saved fields)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_ActiveHighlightMsgPtr, GCOMMAND_ActiveMsgSavedField20, GCOMMAND_ActiveMsgSavedField24, _GCOMMAND_ActiveMsgSavedField28
; WRITES:
;   _GCOMMAND_HighlightMessageSlotTable.., _GCOMMAND_ActiveHighlightMsgPtr
; DESC:
;   Clears pending highlight message records and resets message state.
; NOTES:
;   Writes into a sequence of structs starting at _GCOMMAND_HighlightMessageSlotTable.
;------------------------------------------------------------------------------
_GCOMMAND_ResetHighlightMessages:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)

    TST.L   _GCOMMAND_ActiveHighlightMsgPtr
    BEQ.S   .clear_message_slots

    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  GCOMMAND_ActiveMsgSavedField20,20(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  GCOMMAND_ActiveMsgSavedField24,24(A0)
    MOVEA.L _GCOMMAND_ActiveHighlightMsgPtr,A0
    MOVE.L  _GCOMMAND_ActiveMsgSavedField28,28(A0)

.clear_message_slots:
    MOVEQ   #0,D7
    MOVE.L  #_GCOMMAND_HighlightMessageSlotTable,-4(A5)

.slot_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .clear_queue

    MOVEA.L -4(A5),A0
    CLR.W   52(A0)
    CLR.B   54(A0)
    ADDQ.L  #1,D7
    MOVEQ   #80,D0
    ADD.L   D0,D0
    ADD.L   D0,-4(A5)
    BRA.S   .slot_loop

.clear_queue:
    MOVEQ   #98,D0
    MOVEQ   #0,D1
    LEA     _ESQPARS2_BannerQueueBuffer,A0

.queue_loop:
    MOVE.B  D1,(A0)+
    DBF     D0,.queue_loop

    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_BuildBannerBlock   (BuildBannerBlock)
; ARGS:
;   stack +4: outPtr
;   stack +8: count
;   stack +12: srcPtr
;   stack +16: argByte0
;   stack +20: argWord0
;   stack +24: argByte1
; RET:
;   D0: outPtr after last entry
; CLOBBERS:
;   D0-D7, A0-A3, A6
; CALLS:
;   _GCOMMAND_ComputePresetIncrement, _GCOMMAND_InitPresetWorkEntry,
;   GCOMMAND_TickPresetWorkEntries
; READS:
;   _Global_UIBusyFlag, GCOMMAND_PresetValueTable..GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_PresetFallbackValue0..GCOMMAND_PresetFallbackValue3
; WRITES:
;   [outPtr] (writes 32-byte entries)
; DESC:
;   Emits a block of banner/copper entries using preset tables and source bytes.
; NOTES:
;   Entry count comes from stack +8; uses _Global_UIBusyFlag to optionally force count=0.
;   Emitted entry format is 32 bytes/row (offsets from A0 row base):
;     +0  u8  source byte (from *srcPtr, incremented each row by argByte1)
;     +1  u8  argByte0
;     +2  u16 argWord0
;     +4  u16 $0188, +6  u16 color0
;     +8  u16 $018A, +10 u16 color1
;     +12 u16 $018C, +14 u16 color2
;     +16 u16 $018E, +18 u16 color3
;     +20 u16 $0084, +22 u16 nextPtr_hi
;     +24 u16 $0086, +26 u16 nextPtr_lo
;     +28 u16 $008A, +30 u16 0
;   colorN words come from preset work entries, or ESQ_* fallback bytes when
;   the corresponding value index is negative.
;------------------------------------------------------------------------------
GCOMMAND_BuildBannerBlock:
    LINK.W  A5,#-12
    MOVEM.L D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVEA.L 16(A5),A2
    MOVE.B  23(A5),D6
    MOVE.W  26(A5),D5
    MOVE.B  31(A5),D4
    MOVE.L  A3,-4(A5)
    TST.W   _Global_UIBusyFlag
    BEQ.S   .use_count

    MOVEQ   #0,D0
    BRA.S   .seed_tables

.use_count:
    MOVE.L  D7,D0

.seed_tables:
    MOVE.L  D0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D0,-12(A5)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    CLR.L   -(A7)
    PEA     _GCOMMAND_PresetWorkEntryTable
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     5.W
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     5.W
    PEA     GCOMMAND_PresetWorkEntry1
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     6.W
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     6.W
    PEA     GCOMMAND_PresetWorkEntry2
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     7.W
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     7.W
    PEA     GCOMMAND_PresetWorkEntry3
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    LEA     68(A7),A7
    CLR.L   -8(A5)

.emit_loop:
    MOVE.L  -8(A5),D0
    CMP.L   D7,D0
    BGE.W   .done

    MOVE.B  (A2),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    ADD.B   D4,(A2)
    MOVE.B  D6,1(A0)
    MOVE.W  D5,2(A0)
    MOVE.W  #$188,4(A0)
    MOVE.L  GCOMMAND_PresetWorkEntry0_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset0

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue0,D1
    BRA.S   .store_preset0

.use_preset0:
    MOVE.L  _GCOMMAND_PresetWorkEntryTable,D1
    ASL.L   #7,D1
    LEA     GCOMMAND_PresetValueTable,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset0:
    MOVE.W  D1,6(A0)
    MOVE.W  #$18a,8(A0)
    MOVE.L  GCOMMAND_PresetWorkEntry1_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset1

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue1,D1
    BRA.S   .store_preset1

.use_preset1:
    MOVE.L  GCOMMAND_PresetWorkEntry1,D1
    ASL.L   #7,D1
    LEA     GCOMMAND_PresetValueTable,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset1:
    MOVE.W  D1,10(A0)
    MOVE.W  #$18c,12(A0)
    MOVE.L  GCOMMAND_PresetWorkEntry2_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset2

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue2,D1
    BRA.S   .store_preset2

.use_preset2:
    MOVE.L  GCOMMAND_PresetWorkEntry2,D1
    ASL.L   #7,D1
    LEA     GCOMMAND_PresetValueTable,A1
    MOVEA.L A1,A6
    ADDA.L  D1,A6
    ADD.L   D0,D0
    ADDA.L  D0,A6
    MOVEQ   #0,D0
    MOVE.W  (A6),D0
    MOVE.L  D0,D1

.store_preset2:
    MOVE.W  D1,14(A0)
    MOVE.W  #$18e,16(A0)
    MOVE.L  GCOMMAND_PresetWorkEntry3_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset3

    MOVEQ   #0,D1
    MOVE.B  GCOMMAND_PresetFallbackValue3,D1
    BRA.S   .store_preset3

.use_preset3:
    MOVE.L  GCOMMAND_PresetWorkEntry3,D1
    ASL.L   #7,D1
    LEA     GCOMMAND_PresetValueTable,A1
    ADDA.L  D1,A1
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVEQ   #0,D0
    MOVE.W  (A1),D0
    MOVE.L  D0,D1

.store_preset3:
    MOVE.W  D1,18(A0)
    MOVE.W  #$84,20(A0)
    LEA     32(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$86,24(A0)
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,26(A0)
    MOVE.W  #$8a,28(A0)
    CLR.W   30(A0)
    BSR.W   GCOMMAND_TickPresetWorkEntries

    ADDQ.L  #1,-8(A5)
    MOVEQ   #32,D0
    ADD.L   D0,-4(A5)
    BRA.W   .emit_loop

.done:
    MOVE.L  -4(A5),D0
    MOVEM.L (A7)+,D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_CopyImageDataToBitmap   (Emit banner copper template and row block into target table)
; ARGS:
;   stack +4: bitmapPtr
;   stack +8: tablePtr
;   stack +12: length
;   stack +16: baseOffset
;   stack +20: argWord0
;   stack +24: argByte0
; RET:
;   D0: tablePtr (echoed)
; CLOBBERS:
;   D0-D7, A0-A3, A6
; CALLS:
;   GCOMMAND_BuildBannerBlock
; READS:
;   _WDISP_BannerWorkRasterPtr, [A3+8/12/16]
; WRITES:
;   [tablePtr] (copper list entries)
; DESC:
;   Emits a banner copper-list block into tablePtr using source offsets.
; NOTES:
;   Seeds a fixed copper prologue, then appends per-row words via
;   GCOMMAND_BuildBannerBlock.
;------------------------------------------------------------------------------
GCOMMAND_CopyImageDataToBitmap:
    LINK.W  A5,#-4
    MOVEM.L D2-D7/A2-A3/A6,-(A7)

    UseLinkStackLong    MOVEA.L,1,A3
    UseLinkStackLong    MOVEA.L,2,A2
    UseLinkStackLong    MOVE.L,3,D7
    UseLinkStackLong    MOVE.L,4,D6
    MOVE.W  30(A5),D5
    MOVE.B  35(A5),D4

    MOVE.L  A2,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  #$8e,(A0)
    MOVE.B  #$d9,1(A0)
    MOVE.W  #$fffe,2(A0)
    MOVE.W  #$92,4(A0)
    MOVE.W  #$30,6(A0)
    MOVE.W  #$94,8(A0)
    MOVE.W  #$d8,10(A0)
    MOVE.W  #$8e,12(A0)
    MOVE.W  #$1769,14(A0)
    MOVE.W  #$90,16(A0)
    MOVE.W  #$ffc5,18(A0)
    MOVE.W  #$108,20(A0)
    MOVEQ   #88,D0
    MOVE.W  D0,22(A0)
    MOVE.W  #$10a,24(A0)
    MOVE.W  D0,26(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,28(A0)
    MOVE.W  #$9306,30(A0)
    MOVE.W  #$102,32(A0)
    MOVEQ   #0,D1
    MOVE.W  D1,34(A0)
    MOVE.W  #$182,D2
    MOVE.W  D2,36(A0)
    MOVEQ   #3,D3
    MOVE.W  D3,38(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,40(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D0
    MOVE.L  D0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,42(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,44(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D1
    MOVE.L  #$ffff,D0
    AND.L   D0,D1
    MOVE.W  D1,46(A0)
    MOVE.W  #$180,48(A0)
    MOVE.W  D3,50(A0)
    MOVE.W  D2,52(A0)
    MOVE.W  D3,54(A0)
    MOVE.W  #$184,56(A0)
    MOVE.W  #$111,58(A0)
    MOVE.W  #$186,60(A0)
    MOVE.W  #$cc0,62(A0)
    MOVE.W  #$188,64(A0)
    MOVE.W  #$512,66(A0)
    MOVE.W  #$18a,68(A0)
    MOVE.W  #$16a,70(A0)
    MOVE.W  #$18c,72(A0)
    MOVE.W  #$555,74(A0)
    MOVE.W  #$18e,76(A0)
    MOVE.W  D3,78(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D1
    MOVE.B  D1,80(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,81(A0)
    MOVE.W  D5,82(A0)
    MOVE.W  #$e0,84(A0)
    MOVE.L  8(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,86(A0)
    MOVE.W  #$e2,88(A0)
    MOVE.L  8(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,90(A0)
    MOVE.W  #$e4,92(A0)
    MOVE.L  12(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,94(A0)
    MOVE.W  #$e6,96(A0)
    MOVE.L  12(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,98(A0)
    MOVE.W  #$e8,100(A0)
    MOVE.L  16(A3),D1
    MOVE.L  D1,D3
    ADD.L   D7,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,102(A0)
    MOVE.W  #$ea,104(A0)
    MOVE.L  16(A3),D1
    ADD.L   D7,D1
    AND.L   D0,D1
    MOVE.W  D1,106(A0)
    MOVE.W  D2,108(A0)
    MOVE.W  #$aaa,110(A0)
    MOVE.W  #$100,112(A0)
    MOVE.W  #$b306,114(A0)
    MOVE.W  #$84,116(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,118(A0)
    MOVE.W  #$86,120(A0)
    LEA     132(A0),A6
    MOVE.L  A6,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,122(A0)
    MOVE.W  #$8a,124(A0)
    CLR.W   126(A0)
    LEA     128(A0),A6
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  A1,-(A7)
    PEA     17.W
    MOVE.L  A6,-(A7)
    BSR.W   GCOMMAND_BuildBannerBlock

    LEA     24(A7),A7
    MOVEA.L 24(A5),A0
    MOVE.B  (A0),D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,672(A0)
    MOVEA.L 24(A5),A1
    ADD.B   D4,(A1)
    MOVE.B  #$d9,673(A0)
    MOVE.W  D5,674(A0)
    MOVE.W  #$100,D0
    MOVE.W  D0,676(A0)
    MOVE.W  #$9306,678(A0)
    MOVE.W  #$182,D1
    MOVE.W  D1,680(A0)
    MOVE.W  #3,682(A0)
    MOVE.W  #$e0,D2
    MOVE.W  D2,684(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D3
    MOVE.L  D3,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,686(A0)
    MOVE.W  #$e2,D0
    MOVE.W  D0,688(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D3
    MOVE.L  #$ffff,D1
    AND.L   D1,D3
    MOVE.W  D3,690(A0)
    MOVE.W  #$e4,692(A0)
    MOVE.L  12(A3),D3
    MOVE.L  D3,D0
    ADD.L   D6,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,694(A0)
    MOVE.W  #$e6,696(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.W  #$e8,700(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D3
    ADD.L   D6,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,702(A0)
    MOVE.W  #$ea,704(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,706(A0)
    MOVE.B  (A1),D0
    MOVE.B  D0,708(A0)
    ADD.B   D4,(A1)
    MOVE.B  #$db,709(A0)
    MOVE.W  D5,710(A0)
    MOVE.W  D2,712(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D6,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.W  #$e2,716(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.W  #$182,720(A0)
    MOVE.W  #$aaa,722(A0)
    MOVE.W  #$100,724(A0)
    MOVE.W  #$b306,726(A0)
    MOVE.W  #$84,728(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,730(A0)
    MOVE.W  #$86,732(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,734(A0)
    MOVE.W  #$8a,736(A0)
    CLR.W   738(A0)
    LEA     740(A0),A1
    MOVEQ   #0,D0
    MOVE.W  D5,D0
    MOVEQ   #0,D1
    MOVE.B  D4,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     221.W
    MOVE.L  24(A5),-(A7)
    PEA     98.W
    MOVE.L  A1,-(A7)
    BSR.W   GCOMMAND_BuildBannerBlock

    MOVE.L  D6,(A7)
    PEA     98.W
    CLR.L   -(A7)
    MOVE.L  A2,-(A7)
    MOVE.L  A3,-(A7)
    BSR.W   GCOMMAND_BuildBannerRow

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.B  #$80,3916(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,3917(A0)
    MOVE.W  #$80fe,3918(A0)
    MOVE.W  #$100,3920(A0)
    MOVE.W  #$9306,3922(A0)
    MOVE.W  #$182,3924(A0)
    MOVE.W  #3,3926(A0)
    MOVE.W  #$e0,D1
    MOVE.W  D1,3928(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D2
    MOVE.L  D2,D3
    CLR.W   D3
    SWAP    D3
    MOVE.W  D3,3930(A0)
    MOVE.W  #$e2,D2
    MOVE.W  D2,3932(A0)
    MOVE.L  _WDISP_BannerWorkRasterPtr,D3
    MOVE.L  #$ffff,D2
    AND.L   D2,D3
    MOVE.W  D3,3934(A0)
    MOVEQ   #-1,D3
    MOVE.B  D3,3936(A0)
    MOVE.B  D3,3937(A0)
    MOVE.W  #$fffe,3938(A0)
    MOVEA.L 24(A5),A1
    MOVE.B  (A1),D3
    MOVE.B  D3,3876(A0)
    ADD.B   D4,(A1)
    MOVE.B  D0,3877(A0)
    MOVE.W  D5,3878(A0)
    MOVE.W  D1,3880(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3882(A0)
    MOVE.W  #$e2,3884(A0)
    MOVE.L  8(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3886(A0)
    MOVE.W  #$e4,3888(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3890(A0)
    MOVE.W  #$e6,3892(A0)
    MOVE.L  12(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3894(A0)
    MOVE.W  #$e8,3896(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D1
    ADD.L   D6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,3898(A0)
    MOVE.W  #$ea,3900(A0)
    MOVE.L  16(A3),D0
    ADD.L   D6,D0
    AND.L   D2,D0
    MOVE.W  D0,3902(A0)
    MOVE.W  #$84,3904(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    CLR.W   D0
    SWAP    D0
    MOVE.W  D0,3906(A0)
    MOVE.W  #$86,3908(A0)
    LEA     744(A0),A1
    MOVE.L  A1,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,3910(A0)
    MOVE.W  #$8a,3912(A0)
    CLR.W   3914(A0)

    MOVEM.L (A7)+,D2-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_BuildBannerTables   (Reset counters and rebuild both banner copper tables)
; ARGS:
;   stack +8: arg0 (byte, low byte used)
;   stack +12: arg1 (word, low word used)
;   stack +16: arg2 (byte, low byte used)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A6
; CALLS:
;   _LVODisable, _LVOEnable, GCOMMAND_ResetPresetWorkTables,
;   GCOMMAND_ClearBannerQueue, GCOMMAND_CopyImageDataToBitmap
; READS:
;   GCOMMAND_BannerRowByteOffsetResetValue, _ESQSHARED4_InterleaveCopyTailOffsetReset, _Global_REF_696_400_BITMAP
; WRITES:
;   GCOMMAND_BannerPhaseIndexCurrent, GCOMMAND_BannerRowByteOffsetCurrent, GCOMMAND_BannerRowByteOffsetPrevious, _GCOMMAND_BannerQueueSlotPrevious..GCOMMAND_BannerRowIndexCurrent, ESQSHARED4_InterleaveCopyTailOffsetCurrent, ED2_HighlightTickEnabledFlag, _ESQPARS2_ReadModeFlags
; DESC:
;   Resets banner-related globals and rebuilds the banner tables into the bitmap.
; NOTES:
;   Argument bytes/words are forwarded into GCOMMAND_CopyImageDataToBitmap calls.
;   Seeds queue slots to 97/96 and row indices to 84/85 before first tick.
;------------------------------------------------------------------------------
_GCOMMAND_BuildBannerTables:
    LINK.W  A5,#-4
    MOVEM.L D2/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    MOVE.W  14(A5),D6
    MOVE.B  19(A5),D5
    MOVE.B  D7,-1(A5)
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    BSR.W   GCOMMAND_ResetPresetWorkTables

    MOVEQ   #0,D0
    MOVE.L  D0,GCOMMAND_BannerPhaseIndexCurrent
    MOVE.L  D0,GCOMMAND_BannerRowByteOffsetPrevious
    MOVE.L  GCOMMAND_BannerRowByteOffsetResetValue,D0
    MOVE.L  D0,GCOMMAND_BannerRowByteOffsetCurrent
    MOVE.L  _ESQSHARED4_InterleaveCopyTailOffsetReset,ESQSHARED4_InterleaveCopyTailOffsetCurrent
    MOVEQ   #97,D0
    MOVE.W  D0,_GCOMMAND_BannerQueueSlotPrevious
    SUBQ.W  #1,D0
    MOVE.W  D0,_GCOMMAND_BannerQueueSlotCurrent
    MOVEQ   #84,D0
    MOVE.L  D0,GCOMMAND_BannerRowIndexPrevious
    MOVEQ   #85,D0
    MOVE.L  D0,GCOMMAND_BannerRowIndexCurrent
    MOVEQ   #0,D0
    MOVE.W  D6,D0
    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -1(A5)
    MOVE.L  GCOMMAND_BannerRowByteOffsetCurrent,-(A7)
    PEA     2992.W
    PEA     _ESQ_CopperListBannerA
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   GCOMMAND_CopyImageDataToBitmap

    MOVE.B  D7,-1(A5)
    MOVEQ   #88,D0
    ADD.L   GCOMMAND_BannerRowByteOffsetCurrent,D0
    MOVEQ   #0,D1
    MOVE.W  D6,D1
    MOVEQ   #0,D2
    MOVE.B  D5,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  D0,-(A7)
    PEA     3080.W
    PEA     _ESQ_CopperListBannerB
    PEA     _Global_REF_696_400_BITMAP
    BSR.W   GCOMMAND_CopyImageDataToBitmap

    BSR.W   GCOMMAND_ClearBannerQueue

    MOVE.W  #1,ED2_HighlightTickEnabledFlag
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVEA.L AbsExecBase,A6
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D2/D5-D7
    UNLK    A5
    RTS

;!======