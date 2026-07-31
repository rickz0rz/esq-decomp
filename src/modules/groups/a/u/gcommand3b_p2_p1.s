    XDEF    _GCOMMAND_BuildBannerRow
    XDEF    _GCOMMAND_ClearBannerQueue
    XDEF    _GCOMMAND_UpdateBannerRowPointers

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_UpdateBannerRowPointers   (Refresh per-row linked pointer words in banner copper table)
; ARGS:
;   stack +4: tablePtr (banner table base)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, D6-D7, A0-A1, A3
; CALLS:
;   (none)
; READS:
;   _GCOMMAND_BannerRowIndexPrevious, _GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   [tablePtr + index*32 + $2FA], [tablePtr + index*32 + $2FE]
; DESC:
;   Updates pointer words in the banner table based on current/previous indices.
; NOTES:
;   Special-cases _GCOMMAND_BannerRowIndexPrevious == 97 to use the tail entry at offset 3876.
;   Row stride is 32 bytes (`ASL.L #5`); writes pointer words at `+$2FA`/`+$2FE`.
;------------------------------------------------------------------------------
_GCOMMAND_UpdateBannerRowPointers:
    MOVEM.L D2-D3/D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.L  _GCOMMAND_BannerRowIndexPrevious,D0
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D1
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
    MOVE.L  _GCOMMAND_BannerRowIndexPrevious,D0
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
;   _GCOMMAND_PresetWorkEntryTable..GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_BannerRowFallbackOnFirstRowFlag
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
    BSR.W   _GCOMMAND_UpdateBannerRowPointers

    MOVEM.L -44(A5),D2/D4-D7/A2-A3/A6
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_ClearBannerQueue   (Clear queued banner control bytes)
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
_GCOMMAND_ClearBannerQueue:
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
    MOVE.L  _GCOMMAND_BannerPhaseIndexCurrent,D6
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