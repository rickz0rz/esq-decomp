    XDEF    _GCOMMAND_BuildBannerRow

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_BuildBannerRow   (Emit one banner copper row from bitmap/preset state)
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
;   _GCOMMAND_UpdateBannerRowPointers
; READS:
;   _GCOMMAND_PresetWorkEntryTable.._GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_BannerRowFallbackOnFirstRowFlag
; WRITES:
;   [tablePtr + offsets], _GCOMMAND_BannerRowFallbackOnFirstRowFlag?
; DESC:
;   Writes banner row pointer fields and color values into the table.
; NOTES:
;   Uses rowIndex when > 0, otherwise fallbackIndex. Row stride is 32 bytes.
;   Color words land at row-local offsets `+$2EA/+2EE/+2F2/+2F6`.
;------------------------------------------------------------------------------
_GCOMMAND_BuildBannerRow:
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
    TST.W   _GCOMMAND_BannerRowFallbackOnFirstRowFlag
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
    LEA     _GCOMMAND_PresetValueTable,A1
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  _GCOMMAND_PresetWorkEntry0_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  _GCOMMAND_PresetWorkEntry1,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  _GCOMMAND_PresetWorkEntry1_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  _GCOMMAND_PresetWorkEntry2,D0
    ASL.L   #7,D0
    MOVEA.L A1,A0
    ADDA.L  D0,A0
    MOVE.L  _GCOMMAND_PresetWorkEntry2_ValueIndex,D0
    ADD.L   D0,D0
    ADDA.L  D0,A0
    MOVE.W  (A0),(A6)
    MOVE.L  A6,-12(A5)
    ADDQ.L  #4,A6
    MOVE.L  _GCOMMAND_PresetWorkEntry3,D0
    ASL.L   #7,D0
    ADDA.L  D0,A1
    MOVE.L  _GCOMMAND_PresetWorkEntry3_ValueIndex,D0
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
    BSR.W   _GCOMMAND_UpdateBannerRowPointers

    MOVEM.L -44(A5),D2/D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======