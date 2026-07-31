    XDEF    _GCOMMAND_RebuildBannerTablesFromBounds

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_RebuildBannerTablesFromBounds   (RebuildBannerTablesFromBounds)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D7, A0-A3
; CALLS:
;   _GCOMMAND_InitPresetWorkEntry, _GCOMMAND_TickPresetWorkEntries
; READS:
;   _GCOMMAND_BannerBoundLeft.._GCOMMAND_BannerStepBottom, _GCOMMAND_PresetValueTable.._GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_PresetFallbackValue0.._GCOMMAND_PresetFallbackValue3, _Global_UIBusyFlag
; WRITES:
;   _GCOMMAND_PresetWorkEntryTable.._GCOMMAND_PresetWorkEntry3, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Rebuilds banner tables from the cached bounds and preset definitions.
; NOTES:
;   Uses _GCOMMAND_PresetFallbackValue0.._GCOMMAND_PresetFallbackValue3 as fallback values when preset tables are negative.
;   Writes both _ESQ_CopperListBannerA and _ESQ_CopperListBannerB from +$80 onward.
;   The row loop runs 17 iterations (D7 = 0..16), using 32-byte row stride.
;   Per-row gradient words land at offsets +6/+10/+14/+18 in each 32-byte entry.
;------------------------------------------------------------------------------
_GCOMMAND_RebuildBannerTablesFromBounds:
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
    MOVE.L  _GCOMMAND_BannerStepLeft,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  _GCOMMAND_BannerBoundLeft,-(A7)
    PEA     _GCOMMAND_PresetWorkEntryTable
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  _GCOMMAND_BannerStepTop,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  _GCOMMAND_BannerBoundTop,-(A7)
    PEA     _GCOMMAND_PresetWorkEntry1
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  _GCOMMAND_BannerStepRight,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  _GCOMMAND_BannerBoundRight,-(A7)
    PEA     _GCOMMAND_PresetWorkEntry2
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  _GCOMMAND_BannerStepBottom,(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  _GCOMMAND_BannerBoundBottom,-(A7)
    PEA     _GCOMMAND_PresetWorkEntry3
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    LEA     52(A7),A7
    MOVEQ   #0,D7

.row_loop:
    MOVEQ   #17,D0
    CMP.L   D0,D7
    BGE.W   .done

    MOVE.L  D7,D0
    ASL.L   #5,D0
    MOVE.L  _GCOMMAND_PresetWorkEntry0_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset0

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue0,D2
    BRA.S   .store_entry0

.use_preset0:
    MOVE.L  _GCOMMAND_PresetWorkEntryTable,D2
    ASL.L   #7,D2
    LEA     _GCOMMAND_PresetValueTable,A0
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
    MOVE.L  _GCOMMAND_PresetWorkEntry1_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset1

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue1,D2
    BRA.S   .store_entry1

.use_preset1:
    MOVE.L  _GCOMMAND_PresetWorkEntry1,D2
    ASL.L   #7,D2
    LEA     _GCOMMAND_PresetValueTable,A2
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
    MOVE.L  _GCOMMAND_PresetWorkEntry2_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset2

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue2,D2
    BRA.S   .store_entry2

.use_preset2:
    MOVE.L  _GCOMMAND_PresetWorkEntry2,D2
    ASL.L   #7,D2
    LEA     _GCOMMAND_PresetValueTable,A2
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
    MOVE.L  _GCOMMAND_PresetWorkEntry3_ValueIndex,D1
    TST.L   D1
    BPL.S   .use_preset3

    MOVEQ   #0,D2
    MOVE.B  _GCOMMAND_PresetFallbackValue3,D2
    BRA.S   .store_entry3

.use_preset3:
    MOVE.L  _GCOMMAND_PresetWorkEntry3,D2
    ASL.L   #7,D2
    LEA     _GCOMMAND_PresetValueTable,A0
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
    BSR.W   _GCOMMAND_TickPresetWorkEntries

    ADDQ.L  #1,D7
    BRA.W   .row_loop

.done:
    CLR.W   _GCOMMAND_BannerRebuildPendingFlag
    MOVEM.L (A7)+,D2/D6-D7/A2-A3
    UNLK    A5
    RTS

;!======