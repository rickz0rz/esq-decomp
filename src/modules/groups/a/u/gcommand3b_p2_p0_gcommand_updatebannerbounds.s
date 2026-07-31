    XDEF    _GCOMMAND_UpdateBannerBounds


;------------------------------------------------------------------------------
; FUNC: _GCOMMAND_UpdateBannerBounds   (Cache banner geometry parameters used by the display routines.)
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
;   _GCOMMAND_BannerBoundLeft, _GCOMMAND_BannerBoundTop, _GCOMMAND_BannerBoundRight, _GCOMMAND_BannerBoundBottom,
;   _GCOMMAND_BannerStepLeft.._GCOMMAND_BannerStepBottom, _GCOMMAND_BannerRebuildPendingFlag
; DESC:
;   Cache banner geometry parameters used by the display routines.
; NOTES:
;   Sets _GCOMMAND_BannerRebuildPendingFlag to request a banner-table rebuild on the next tick.
;------------------------------------------------------------------------------
_GCOMMAND_UpdateBannerBounds:
    LINK.W  A5,#-4
    MOVEM.L D4-D7,-(A7)
    MOVE.L  8(A5),D7
    MOVE.L  12(A5),D6
    MOVE.L  16(A5),D5
    MOVE.L  20(A5),D4
    MOVE.L  D7,_GCOMMAND_BannerBoundLeft
    MOVE.L  D6,_GCOMMAND_BannerBoundTop
    MOVE.L  D5,_GCOMMAND_BannerBoundRight
    MOVE.L  D4,_GCOMMAND_BannerBoundBottom
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

    MOVE.L  D0,_GCOMMAND_BannerStepLeft
    MOVE.L  -4(A5),(A7)
    MOVE.L  D6,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,_GCOMMAND_BannerStepTop
    MOVE.L  -4(A5),(A7)
    MOVE.L  D5,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,_GCOMMAND_BannerStepRight
    MOVE.L  -4(A5),(A7)
    MOVE.L  D4,-(A7)
    BSR.W   _GCOMMAND_ComputePresetIncrement

    MOVE.L  D0,_GCOMMAND_BannerStepBottom
    MOVEA.L AbsExecBase,A6
    JSR     _LVODisable(A6)

    MOVE.W  #1,_GCOMMAND_BannerRebuildPendingFlag
    JSR     _LVOEnable(A6)

    MOVEM.L -20(A5),D4-D7
    UNLK    A5
    RTS

;!======