    XDEF    GCOMMAND_RebuildBannerTablesFromBounds
    XDEF    GCOMMAND_TickPresetWorkEntries
    XDEF    GCOMMAND_UpdateBannerBounds


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