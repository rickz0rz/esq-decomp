    XDEF    GCOMMAND_BuildBannerRow
    XDEF    GCOMMAND_ClearBannerQueue
    XDEF    _GCOMMAND_GetBannerChar
    XDEF    GCOMMAND_RebuildBannerTablesFromBounds
    XDEF    GCOMMAND_TickPresetWorkEntries
    XDEF    GCOMMAND_UpdateBannerBounds
    XDEF    GCOMMAND_UpdateBannerRowPointers

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_TickPresetWorkEntries   (Advance and clamp preset work-entry accumulators)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3
; DESC:
;   Advances preset work entry accumulators and clamps them to bounds.
; NOTES:
;   Accumulator 16(A0) uses 1000 as the carry threshold.
;------------------------------------------------------------------------------
GCOMMAND_TickPresetWorkEntries:
    LINK.W  A5,#-8
    MOVE.L  D7,-(A7)
    MOVEQ   #0,D7
    MOVE.L  #_GCOMMAND_PresetWorkEntryTable,-4(A5)

.entry_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .done

    MOVEA.L -4(A5),A0
    TST.L   20(A0)
    BEQ.S   .maybe_advance

    SUBQ.L  #1,20(A0)
    BRA.S   .next_entry

.maybe_advance:
    MOVE.L  12(A0),D0
    TST.L   D0
    BLE.S   .next_entry

    MOVE.L  8(A0),D1
    CMP.L   4(A0),D1
    BGE.S   .next_entry

    ADD.L   D0,16(A0)

.carry_loop:
    MOVEA.L -4(A5),A0
    MOVE.L  16(A0),D0
    CMPI.L  #1000,D0
    BLT.S   .check_bounds

    ADDQ.L  #1,8(A0)
    SUBI.L  #1000,16(A0)
    BRA.S   .carry_loop

.check_bounds:
    MOVEA.L -4(A5),A0
    MOVE.L  4(A0),D0
    MOVE.L  8(A0),D1
    CMP.L   D0,D1
    BLE.S   .next_entry

    CLR.L   12(A0)
    MOVE.L  4(A0),8(A0)

.next_entry:
    ADDQ.L  #1,D7
    MOVEQ   #24,D0
    ADD.L   D0,-4(A5)
    BRA.S   .entry_loop

.done:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerBounds   (Cache banner geometry parameters used by the display routines.)
; ARGS:
;   stack +4: left
;   stack +8: top
;   stack +12: right
;   stack +16: bottom
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A6
; CALLS:
;   _GCOMMAND_ComputePresetIncrement, _LVODisable, _LVOEnable
; READS:
;   _Global_UIBusyFlag
; WRITES:
;   GCOMMAND_BannerBoundLeft, GCOMMAND_BannerBoundTop, GCOMMAND_BannerBoundRight, GCOMMAND_BannerBoundBottom,
;   GCOMMAND_BannerStepLeft..GCOMMAND_BannerStepBottom, GCOMMAND_BannerRebuildPendingFlag
; DESC:
;   Cache banner geometry parameters used by the display routines.
; NOTES:
;   Sets GCOMMAND_BannerRebuildPendingFlag to request a banner-table rebuild on the next tick.
;------------------------------------------------------------------------------
GCOMMAND_UpdateBannerBounds:
    LINK.W  A5,#-4
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.L  20(A5),D4
    MOVE.L  D7,GCOMMAND_BannerBoundLeft
    MOVE.L  D6,GCOMMAND_BannerBoundTop
    MOVE.L  D5,GCOMMAND_BannerBoundRight
    MOVE.L  D4,GCOMMAND_BannerBoundBottom
    TST.W   _Global_UIBusyFlag
    BEQ.S   .use_zero

    MOVEQ   #0,D0
    BRA.S   .seed_base

.use_zero:
    MOVEQ   #17,D0

.seed_base:
    MOVE.L  D0,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  D0,-4(A5)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,GCOMMAND_BannerStepLeft
    MOVE.L  -4(A5),(A7)
    MOVE.L  D6,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,GCOMMAND_BannerStepTop
    MOVE.L  -4(A5),(A7)
    MOVE.L  D5,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,GCOMMAND_BannerStepRight
    MOVE.L  -4(A5),(A7)
    MOVE.L  D4,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,GCOMMAND_BannerStepBottom
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #1,GCOMMAND_BannerRebuildPendingFlag
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D4-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_RebuildBannerTablesFromBounds   (RebuildBannerTablesFromBounds)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _GCOMMAND_InitPresetWorkEntry, GCOMMAND_TickPresetWorkEntries
; READS:
;   GCOMMAND_BannerBoundLeft..GCOMMAND_BannerStepBottom, GCOMMAND_PresetValueTable..GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_PresetFallbackValue0..GCOMMAND_PresetFallbackValue3, _Global_UIBusyFlag
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Rebuilds banner tables from the cached bounds and preset definitions.
; NOTES:
;   Uses _GCOMMAND_PresetFallbackValue0..GCOMMAND_PresetFallbackValue3 as fallback values when preset tables are negative.
;   Writes both _ESQ_CopperListBannerA and _ESQ_CopperListBannerB from +$80 onward.
;   The row loop runs 17 iterations (D7 = 0..16), using 32-byte row stride.
;   Per-row gradient words land at offsets +6/+10/+14/+18 in each 32-byte entry.
;------------------------------------------------------------------------------
GCOMMAND_RebuildBannerTablesFromBounds:
    LINK.W  A5,#-24
    MOVEM.L D2/D6-D7/A2-A3,-(A7)
    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVE.L  #_ESQ_CopperListBannerB,-8(A5)
    MOVEA.L -4(A5),A0
    ADDA.W  #$80,A0
    MOVEA.L -8(A5),A1
    ADDA.W  #$80,A1
    MOVE.L  A0,-12(A5)
    MOVE.L  A1,-16(A5)
    TST.W   _Global_UIBusyFlag
    BEQ.S   .use_zero

    MOVEQ   #0,D0
    BRA.S   .seed_entries

.use_zero:
    MOVEQ   #17,D0

.seed_entries:
    MOVE.L  D0,D6
    MOVE.L  GCOMMAND_BannerStepLeft,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  GCOMMAND_BannerBoundLeft,-(A7)
    PEA     _GCOMMAND_PresetWorkEntryTable
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  GCOMMAND_BannerStepTop,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  GCOMMAND_BannerBoundTop,-(A7)
    PEA     GCOMMAND_PresetWorkEntry1
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  GCOMMAND_BannerStepRight,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  GCOMMAND_BannerBoundRight,-(A7)
    PEA     GCOMMAND_PresetWorkEntry2
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  GCOMMAND_BannerStepBottom,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  GCOMMAND_BannerBoundBottom,-(A7)
    PEA     GCOMMAND_PresetWorkEntry3
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    LEA     52(A7),A7
    MOVEQ   #0,D7

.row_loop:
    MOVEQ   #17,D0
    CMP.L   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  GCOMMAND_PresetWorkEntry0_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset0

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue0,D2
    BRA.S   .store_entry0

.use_preset0:
    MOVE.L  _GCOMMAND_PresetWorkEntryTable,D2
    ASL.L   #7,D2
    LEA     GCOMMAND_PresetValueTable,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    ADD.L   D1,D1
    ADDA.L  D1,A1
    MOVEQ   #0,D1
    MOVE.W  (A1),D1
    MOVE.L  D1,D2

.store_entry0:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,6(A0,D0.L)
    MOVEA.L -16(A5),A1
    MOVE.W  D2,6(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  GCOMMAND_PresetWorkEntry1_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset1

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue1,D2
    BRA.S   .store_entry1

.use_preset1:
    MOVE.L  GCOMMAND_PresetWorkEntry1,D2
    ASL.L   #7,D2
    LEA     GCOMMAND_PresetValueTable,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

.store_entry1:
    MOVE.W  D2,10(A0,D0.L)
    MOVE.W  D2,10(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  GCOMMAND_PresetWorkEntry2_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset2

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue2,D2
    BRA.S   .store_entry2

.use_preset2:
    MOVE.L  GCOMMAND_PresetWorkEntry2,D2
    ASL.L   #7,D2
    LEA     GCOMMAND_PresetValueTable,A2
    MOVEA.L A2,A3
    ADDA.L  D2,A3
    ADD.L   D1,D1
    ADDA.L  D1,A3
    MOVEQ   #0,D1
    MOVE.W  (A3),D1
    MOVE.L  D1,D2

.store_entry2:
    MOVE.W  D2,14(A0,D0.L)
    MOVE.W  D2,14(A1,D0.L)
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  GCOMMAND_PresetWorkEntry3_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset3

    MOVEQ   #0,D2
    MOVE.B  GCOMMAND_PresetFallbackValue3,D2
    BRA.S   .store_entry3

.use_preset3:
    MOVE.L  GCOMMAND_PresetWorkEntry3,D2
    ASL.L   #7,D2
    LEA     GCOMMAND_PresetValueTable,A0
    ADDA.L  D2,A0
    ADD.L   D1,D1
    ADDA.L  D1,A0
    MOVEQ   #0,D1
    MOVE.W  (A0),D1
    MOVE.L  D1,D2

.store_entry3:
    MOVEA.L -12(A5),A0
    MOVE.W  D2,18(A0,D0.L)
    MOVE.W  D2,18(A1,D0.L)
    BSR.W   GCOMMAND_TickPresetWorkEntries

    ADDQ.L  #1,D7
    BRA.W   .row_loop

.done:
    CLR.W   GCOMMAND_BannerRebuildPendingFlag
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_GetBannerChar   (Return the current banner character stored at _ESQ_CopperListBannerA.)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A5/D0
; CALLS:
;   (none)
; READS:
;   _ESQ_CopperListBannerA
; WRITES:
;   (none observed)
; DESC:
;   Return the current banner character stored at _ESQ_CopperListBannerA.
; NOTES:
;   Reads byte 0 from `_ESQ_CopperListBannerA` and returns it zero-extended.
;------------------------------------------------------------------------------

; Return the current banner character stored at _ESQ_CopperListBannerA.
_GCOMMAND_GetBannerChar:
    LINK.W  A5,#-4
    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  (A0),D0
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerRowPointers   (Refresh per-row linked pointer words in banner copper table)
; ARGS:
;   stack +4: tablePtr (banner table base)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, D6-D7, A0-A1, A3
; CALLS:
;   (none)
; READS:
;   GCOMMAND_BannerRowIndexPrevious, GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   [tablePtr + index*32 + $2FA], [tablePtr + index*32 + $2FE]
; DESC:
;   Updates pointer words in the banner table based on current/previous indices.
; NOTES:
;   Special-cases GCOMMAND_BannerRowIndexPrevious == 97 to use the tail entry at offset 3876.
;   Row stride is 32 bytes (`ASL.L #5`); writes pointer words at `+$2FA`/`+$2FE`.
;------------------------------------------------------------------------------
GCOMMAND_UpdateBannerRowPointers:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  GCOMMAND_BannerRowIndexPrevious,D0
    MOVE.L  GCOMMAND_BannerRowIndexCurrent,D1
    CMP.L   D0,D1
    BEQ.W   .return

    ASL.L   #5,D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D2
    CLR.W   D2
    SWAP    D2
    MOVE.L  D2,D7
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     772(A0),A1
    MOVE.L  A1,D0
    MOVE.L  #$ffff,D2
    AND.L   D2,D0
    MOVE.L  D0,D6
    ASL.L   #5,D1
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    CLR.W   D0
    SWAP    D0
    MOVE.L  D1,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D0,0(A3,D3.L)
    LEA     3916(A3),A0
    MOVE.L  A0,D0
    AND.L   D2,D0
    MOVE.L  D1,D3
    ADDI.L  #$2fe,D3
    MOVE.W  D0,0(A3,D3.L)
    MOVE.L  GCOMMAND_BannerRowIndexPrevious,D0
    MOVEQ   #97,D1
    CMP.L   D1,D0
    BNE.S   .store_prev_ptr

    ASL.L   #5,D0
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    CLR.W   D1
    SWAP    D1
    MOVE.L  D0,D3
    ADDI.L  #$2fa,D3
    MOVE.W  D1,0(A3,D3.L)
    LEA     3876(A3),A0
    MOVE.L  A0,D1
    ANDI.L  #$ffff,D1
    MOVE.L  D0,D2
    ADDI.L  #$2fe,D2
    MOVE.W  D1,0(A3,D2.L)
    BRA.S   .return

.store_prev_ptr:
    ASL.L   #5,D0
    MOVE.L  D0,D1
    ADDI.L  #$2fa,D1
    MOVE.W  D7,0(A3,D1.L)
    MOVE.L  D0,D1
    ADDI.L  #$2fe,D1
    MOVE.W  D6,0(A3,D1.L)

.return:
    MOVEM.L (A7)+,D2-D3/D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_BuildBannerRow   (Emit one banner copper row from bitmap/preset state)
; ARGS:
;   stack +4: bitmapPtr
;   stack +8: tablePtr (banner table base)
;   stack +12: rowIndex (or 0 for fallback)
;   stack +16: fallbackIndex
;   stack +20: baseOffset
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A6
; CALLS:
;   GCOMMAND_UpdateBannerRowPointers
; READS:
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3_ValueIndex, GCOMMAND_BannerRowFallbackOnFirstRowFlag
; WRITES:
;   [tablePtr + offsets], GCOMMAND_BannerRowFallbackOnFirstRowFlag?
; DESC:
;   Writes banner row pointer fields and color values into the table.
; NOTES:
;   Uses rowIndex when > 0, otherwise fallbackIndex. Row stride is 32 bytes.
;   Color words land at row-local offsets `+$2EA/+2EE/+2F2/+2F6`.
;------------------------------------------------------------------------------
GCOMMAND_BuildBannerRow:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7/A2-A3/A6,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7
    MOVE.L  20(A5),D6
    MOVE.L  24(A5),D5
    MOVEA.L A2,A0
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D1
    CLR.W   D1
    SWAP    D1
    MOVE.W  D1,730(A0)
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     744(A1),A6
    MOVE.L  A6,D0
    MOVE.L  #$ffff,D1
    AND.L   D1,D0
    MOVE.W  D0,734(A0)
    MOVE.L  8(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,714(A0)
    MOVE.L  8(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,718(A0)
    MOVE.L  12(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,694(A0)
    MOVE.L  12(A3),D0
    ADD.L   D5,D0
    AND.L   D1,D0
    MOVE.W  D0,698(A0)
    MOVE.L  16(A3),D0
    MOVE.L  D0,D2
    ADD.L   D5,D2
    CLR.W   D2
    SWAP    D2
    MOVE.W  D2,702(A0)
    MOVE.L  16(A3),D0
    ADD.L   D5,D0
    ANDI.L  #$ffff,D0
    MOVE.W  D0,706(A0)
    MOVEM.L A0,-4(A5)
    TST.L   D7
    BLE.S   .use_fallback_index

    MOVE.L  D7,D0
    BRA.S   .index_ready

.use_fallback_index:
    MOVE.L  D6,D0

.index_ready:
    MOVE.L  D0,D4
    SUBQ.L  #1,D4
    TST.W   GCOMMAND_BannerRowFallbackOnFirstRowFlag
    BEQ.S   .write_from_tables

    TST.L   D4
    BLE.W   .write_defaults

.write_from_tables:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.L  _GCOMMAND_PresetWorkEntryTable,D0
    ASL.L   #7,D0
    LEA     GCOMMAND_PresetValueTable,A1
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  GCOMMAND_PresetWorkEntry0_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  GCOMMAND_PresetWorkEntry1,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  GCOMMAND_PresetWorkEntry1_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  GCOMMAND_PresetWorkEntry2,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  GCOMMAND_PresetWorkEntry2_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  GCOMMAND_PresetWorkEntry3,D0
    ASL.L   #7,D0
    ADDA.L  D0,A1
    MOVE.L  GCOMMAND_PresetWorkEntry3_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A1
    MOVE.W  (A1),(A6)
    MOVE.L  A6,-12(A5)
    BRA.S   .update_row_ptrs

.write_defaults:
    MOVE.L  D4,D0
    ASL.L   #5,D0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    LEA     746(A1),A6
    MOVE.W  #$f0,D0
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.W  D0,(A6)
    MOVE.L  A6,-12(A5)

.update_row_ptrs:
    MOVE.L  -4(A5),-(A7)
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    MOVEM.L -44(A5),D2/D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_ClearBannerQueue   (Clear queued banner control bytes)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D7, A0
; CALLS:
;   (none)
; READS:
;   (none)
; WRITES:
;   _ESQPARS2_BannerQueueAttentionCountdown, _ESQPARS2_BannerQueueBuffer
; DESC:
;   Clears the banner queue buffer and resets the queue state.
; NOTES:
;   Zeros 98 bytes in _ESQPARS2_BannerQueueBuffer and sets _ESQPARS2_BannerQueueAttentionCountdown to -1.
;------------------------------------------------------------------------------
GCOMMAND_ClearBannerQueue:
    MOVE.L  D7,-(A7)
    MOVE.W  #(-1),_ESQPARS2_BannerQueueAttentionCountdown
    MOVEQ   #0,D7

.clear_loop:
    MOVEQ   #98,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _ESQPARS2_BannerQueueBuffer,A0
    ADDA.L  D7,A0
    CLR.B   (A0)
    ADDQ.L  #1,D7
    BRA.S   .clear_loop

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======

    ; Dead code.
    LINK.W  A5,#-16
    MOVEM.L D2-D3/D6-D7,-(A7)
    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVE.L  #_ESQ_CopperListBannerB,-8(A5)
    MOVEQ   #0,D7

.lab_0DBF:
    MOVEQ   #16,D0
    CMP.L   D0,D7
    BGE.W   .lab_0DC0

    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$86,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8a,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$8e,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    ADDQ.L  #1,D7
    BRA.W   .lab_0DBF

.lab_0DC0:
    MOVE.L  GCOMMAND_BannerPhaseIndexCurrent,D6
    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  D6,D1
    ASL.L   #5,D1
    MOVEA.L -4(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEA.L -8(A5),A0
    MOVE.L  D1,D2
    ADDI.L  #$2ea,D2
    MOVE.L  D0,D3
    ADDI.L  #$86,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2ee,D2
    MOVE.L  D0,D3
    ADDI.L  #$8a,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVE.L  D1,D2
    ADDI.L  #$2f2,D2
    MOVE.L  D0,D3
    ADDI.L  #$8e,D3
    MOVE.W  0(A0,D2.L),0(A0,D3.L)
    MOVEM.L (A7)+,D2-D3/D6-D7
    UNLK    A5
    RTS

;!======