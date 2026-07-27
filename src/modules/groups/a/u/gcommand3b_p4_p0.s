    XDEF    GCOMMAND_AdjustBannerCopperOffset
    XDEF    GCOMMAND_SeedBannerDefaults
    XDEF    _GCOMMAND_SeedBannerFromPrefs
    XDEF    GCOMMAND_UpdateBannerOffset

;------------------------------------------------------------------------------
; FUNC: GCOMMAND_UpdateBannerOffset   (Apply signed row-index delta with ring wrap and pointer refresh)
; ARGS:
;   stack +8: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7
; CALLS:
;   GCOMMAND_UpdateBannerRowPointers
; READS:
;   GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   GCOMMAND_BannerRowIndexPrevious, GCOMMAND_BannerRowIndexCurrent, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Applies a signed delta to GCOMMAND_BannerRowIndexCurrent, wrapping it into 0..97, then updates
;   banner tables via GCOMMAND_UpdateBannerRowPointers.
; NOTES:
;   Skips all work when delta is zero.
;------------------------------------------------------------------------------
GCOMMAND_UpdateBannerOffset:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    TST.B   D7
    BEQ.S   .lab_0DF0

    MOVE.L  GCOMMAND_BannerRowIndexCurrent,D0
    MOVE.L  D0,GCOMMAND_BannerRowIndexPrevious
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    SUB.L   D1,GCOMMAND_BannerRowIndexCurrent

.lab_0DED:
    MOVE.L  GCOMMAND_BannerRowIndexCurrent,D0
    MOVEQ   #98,D1
    CMP.L   D1,D0
    BLT.S   .lab_0DEE

    MOVEQ   #98,D1
    SUB.L   D1,GCOMMAND_BannerRowIndexCurrent
    BRA.S   .lab_0DED

.lab_0DEE:
    MOVE.L  GCOMMAND_BannerRowIndexCurrent,D0
    TST.L   D0
    BPL.S   .lab_0DEF

    MOVEQ   #98,D1
    ADD.L   D1,GCOMMAND_BannerRowIndexCurrent
    BRA.S   .lab_0DEE

.lab_0DEF:
    PEA     _ESQ_CopperListBannerA
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    PEA     _ESQ_CopperListBannerB
    BSR.W   GCOMMAND_UpdateBannerRowPointers

    ADDQ.W  #8,A7

.lab_0DF0:
    MOVE.L  (A7)+,D7
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_AdjustBannerCopperOffset   (Range-check and apply banner copper offset adjustment)
; ARGS:
;   stack +4: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7, A0
; CALLS:
;   _GCOMMAND_AddBannerTableByteDelta, GCOMMAND_UpdateBannerOffset
; READS:
;   _ESQ_CopperListBannerA
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Applies a signed offset to banner tables when in range.
; NOTES:
;   Uses _GCOMMAND_AddBannerTableByteDelta/GCOMMAND_UpdateBannerOffset helpers
;   to update the banner data.
;------------------------------------------------------------------------------
GCOMMAND_AdjustBannerCopperOffset:
    LINK.W  A5,#-4
    MOVE.L  D7,-(A7)
    MOVE.B  11(A5),D7
    LEA     _ESQ_CopperListBannerA,A0
    MOVE.L  A0,-4(A5)
    TST.B   D7
    BEQ.S   .lab_0DF2

    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    ADD.L   D1,D0
    MOVEQ   #65,D1
    ADD.L   D1,D1
    CMP.L   D1,D0
    BLT.S   .lab_0DF2

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    BSR.W   _GCOMMAND_AddBannerTableByteDelta

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    PEA     _ESQ_CopperListBannerB
    BSR.W   _GCOMMAND_AddBannerTableByteDelta

    MOVE.L  D7,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    BSR.W   GCOMMAND_UpdateBannerOffset

    LEA     12(A7),A7

.lab_0DF2:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GCOMMAND_SeedBannerDefaults   (Reset banner buffers to the default values embedded in the binary.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D3, A0
; CALLS:
;   _GCOMMAND_BuildBannerTables
; READS:
;   (none)
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Reset banner buffers to the default values embedded in the binary.
; NOTES:
;   Seeds both tables with fixed sentinel bytes and invokes _GCOMMAND_BuildBannerTables.
;------------------------------------------------------------------------------

; Reset banner buffers to the default values embedded in the binary.
GCOMMAND_SeedBannerDefaults:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)
    PEA     1.W
    MOVE.L  #$fffe,-(A7)
    PEA     32.W
    BSR.W   _GCOMMAND_BuildBannerTables

    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVEQ   #31,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D1
    MOVE.B  D1,1(A0)
    MOVEQ   #-2,D2
    MOVE.W  D2,2(A0)
    MOVEQ   #-8,D3
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVE.L  #_ESQ_CopperListBannerB,-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVE.B  D1,1(A0)
    MOVE.W  D2,2(A0)
    MOVE.B  D3,3916(A0)
    MOVE.B  D1,3917(A0)
    MOVE.W  D2,3918(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_SeedBannerFromPrefs   (Seed banner buffers using values read from preferences.)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   D0-D2, A0
; CALLS:
;   _GCOMMAND_BuildBannerTables
; READS:
;   _CONFIG_BannerCopperHeadByte
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Seed banner buffers using values read from preferences.
; NOTES:
;   Seeds the leading bytes from _CONFIG_BannerCopperHeadByte and applies defaults.
;------------------------------------------------------------------------------

; Seed banner buffers using values read from preferences.
_GCOMMAND_SeedBannerFromPrefs:
    LINK.W  A5,#-4
    MOVE.L  D2,-(A7)
    CLR.L   -(A7)
    MOVE.L  #$80fe,-(A7)
    PEA     128.W
    BSR.W   _GCOMMAND_BuildBannerTables

    MOVE.L  #_ESQ_CopperListBannerA,-4(A5)
    MOVE.W  _CONFIG_BannerCopperHeadByte,D0
    MOVEA.L -4(A5),A0
    MOVE.B  D0,(A0)
    MOVEQ   #-39,D0
    MOVE.B  D0,1(A0)
    MOVEQ   #-2,D1
    MOVE.W  D1,2(A0)
    MOVE.L  #_ESQ_CopperListBannerB,-4(A5)
    MOVE.W  _CONFIG_BannerCopperHeadByte,D2
    MOVEA.L -4(A5),A0
    MOVE.B  D2,(A0)
    MOVE.B  D0,1(A0)
    MOVE.W  D1,2(A0)
    MOVE.L  -8(A5),D2
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
