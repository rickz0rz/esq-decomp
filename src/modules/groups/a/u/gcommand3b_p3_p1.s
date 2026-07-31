    XDEF    _GCOMMAND_BuildBannerBlock


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_BuildBannerBlock   (BuildBannerBlock)
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
;   _GCOMMAND_TickPresetWorkEntries
; READS:
;   _Global_UIBusyFlag, _GCOMMAND_PresetValueTable.._GCOMMAND_PresetWorkEntry3_ValueIndex, _GCOMMAND_PresetFallbackValue0.._GCOMMAND_PresetFallbackValue3
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
_GCOMMAND_BuildBannerBlock:
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
    PEA     _GCOMMAND_PresetWorkEntry1
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     6.W
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     6.W
    PEA     _GCOMMAND_PresetWorkEntry2
    BSR.W   _GCOMMAND_InitPresetWorkEntry

    MOVE.L  -12(A5),(A7)
    PEA     7.W
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     7.W
    PEA     _GCOMMAND_PresetWorkEntry3
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
    MOVE.L  _GCOMMAND_PresetWorkEntry0_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset0

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue0,D1
    BRA.S   .store_preset0

.use_preset0:
    MOVE.L  _GCOMMAND_PresetWorkEntryTable,D1
    ASL.L   #7,D1
    LEA     _GCOMMAND_PresetValueTable,A1
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
    MOVE.L  _GCOMMAND_PresetWorkEntry1_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset1

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue1,D1
    BRA.S   .store_preset1

.use_preset1:
    MOVE.L  _GCOMMAND_PresetWorkEntry1,D1
    ASL.L   #7,D1
    LEA     _GCOMMAND_PresetValueTable,A1
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
    MOVE.L  _GCOMMAND_PresetWorkEntry2_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset2

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue2,D1
    BRA.S   .store_preset2

.use_preset2:
    MOVE.L  _GCOMMAND_PresetWorkEntry2,D1
    ASL.L   #7,D1
    LEA     _GCOMMAND_PresetValueTable,A1
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
    MOVE.L  _GCOMMAND_PresetWorkEntry3_ValueIndex,D0
    TST.L   D0
    BPL.S   .use_preset3

    MOVEQ   #0,D1
    MOVE.B  _GCOMMAND_PresetFallbackValue3,D1
    BRA.S   .store_preset3

.use_preset3:
    MOVE.L  _GCOMMAND_PresetWorkEntry3,D1
    ASL.L   #7,D1
    LEA     _GCOMMAND_PresetValueTable,A1
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
    BSR.W   _GCOMMAND_TickPresetWorkEntries

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