    XDEF    _SCRIPT_PrimeBannerTransitionFromHexCode


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_PrimeBannerTransitionFromHexCode   (PrimeBannerTransitionFromHexCode)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D2/D3/D7
; CALLS:
;   _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
; READS:
;   _CONFIG_BannerCopperHeadByte (target banner char)
; WRITES:
;   _SCRIPT_BannerTransitionStepBudget, _SCRIPT_BannerTransitionActive, _SCRIPT_BannerTransitionTargetChar, _SCRIPT_BannerTransitionStepDelta, _SCRIPT_BannerTransitionStepSign
; DESC:
;   Initializes transition-step globals to move the current banner character
;   directly toward _CONFIG_BannerCopperHeadByte.
; NOTES:
;   _SCRIPT_BannerTransitionStepBudget is reset to 0; transition is enabled only when
;   current and target characters differ.
;------------------------------------------------------------------------------
_SCRIPT_PrimeBannerTransitionFromHexCode:
    MOVEM.L D2-D3/D7,-(A7)

    JSR     _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_BannerTransitionActive
    MOVE.W  _CONFIG_BannerCopperHeadByte,D1
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D7,D3
    EXT.L   D3
    SUB.L   D3,D2
    MOVE.B  D1,_SCRIPT_BannerTransitionTargetChar
    MOVE.W  D2,_SCRIPT_BannerTransitionStepDelta
    BGE.S   .step_positive_or_zero

    MOVEQ   #-1,D1
    BRA.S   .store_step_sign

.step_positive_or_zero:
    MOVEQ   #1,D1

.store_step_sign:
    MOVE.W  D0,_SCRIPT_BannerTransitionStepBudget
    MOVE.W  D1,_SCRIPT_BannerTransitionStepSign
    TST.W   D2
    BEQ.S   .set_transition_inactive

    MOVE.W  #1,_SCRIPT_BannerTransitionActive
    BRA.S   .return

.set_transition_inactive:
    MOVE.W  D0,_SCRIPT_BannerTransitionActive

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======