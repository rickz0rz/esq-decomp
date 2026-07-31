    XDEF    _GCOMMAND_UpdateBannerOffset


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_UpdateBannerOffset   (Apply signed row-index delta with ring wrap and pointer refresh)
; ARGS:
;   stack +8: delta (byte)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1, D7
; CALLS:
;   _GCOMMAND_UpdateBannerRowPointers
; READS:
;   _GCOMMAND_BannerRowIndexCurrent
; WRITES:
;   _GCOMMAND_BannerRowIndexPrevious, _GCOMMAND_BannerRowIndexCurrent, _ESQ_CopperListBannerA, _ESQ_CopperListBannerB
; DESC:
;   Applies a signed delta to _GCOMMAND_BannerRowIndexCurrent, wrapping it into 0..97, then updates
;   banner tables via _GCOMMAND_UpdateBannerRowPointers.
; NOTES:
;   Skips all work when delta is zero.
;------------------------------------------------------------------------------
_GCOMMAND_UpdateBannerOffset:
    MOVE.L  D7,-(A7)
    MOVE.B  11(A7),D7
    TST.B   D7
    BEQ.S   .lab_0DF0

    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D0
    MOVE.L  D0,_GCOMMAND_BannerRowIndexPrevious
    MOVE.L  D7,D1
    EXT.W   D1
    EXT.L   D1
    SUB.L   D1,_GCOMMAND_BannerRowIndexCurrent

.lab_0DED:
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D0
    MOVEQ   #98,D1
    CMP.L   D1,D0
    BLT.S   .lab_0DEE

    MOVEQ   #98,D1
    SUB.L   D1,_GCOMMAND_BannerRowIndexCurrent
    BRA.S   .lab_0DED

.lab_0DEE:
    MOVE.L  _GCOMMAND_BannerRowIndexCurrent,D0
    TST.L   D0
    BPL.S   .lab_0DEF

    MOVEQ   #98,D1
    ADD.L   D1,_GCOMMAND_BannerRowIndexCurrent
    BRA.S   .lab_0DEE

.lab_0DEF:
    PEA     _ESQ_CopperListBannerA
    BSR.W   _GCOMMAND_UpdateBannerRowPointers

    PEA     _ESQ_CopperListBannerB
    BSR.W   _GCOMMAND_UpdateBannerRowPointers

    ADDQ.W  #8,A7

.lab_0DF0:
    MOVE.L  (A7)+,D7
    RTS

;!======