    XDEF    _GCOMMAND_AdjustBannerCopperOffset

;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_AdjustBannerCopperOffset   (Range-check and apply banner copper offset adjustment)
; ARGS:
;   stack +4: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7, A0
; CALLS:
;   _GCOMMAND_AddBannerTableByteDelta, _GCOMMAND_UpdateBannerOffset
; READS:
;   _ESQ_CopperListBannerA
; WRITES:
;   _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Applies a signed offset to banner tables when in range.
; NOTES:
;   Uses _GCOMMAND_AddBannerTableByteDelta/_GCOMMAND_UpdateBannerOffset helpers
;   to update the banner data.
;------------------------------------------------------------------------------
_GCOMMAND_AdjustBannerCopperOffset:
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
    BSR.W   _GCOMMAND_UpdateBannerOffset

    LEA     12(A7),A7

.lab_0DF2:
    MOVE.L  (A7)+,D7
    UNLK    A5
    RTS

;!======