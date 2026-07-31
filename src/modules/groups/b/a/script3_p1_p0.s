    XDEF    _SCRIPT_BeginBannerCharTransition


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_BeginBannerCharTransition   (Configure and start banner-char transition)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: 1 if a transition was started, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   _GCOMMAND_GetBannerChar, SCRIPT3_JMPTBL_MATH_DivS32, _SCRIPT3_JMPTBL_MATH_Mulu32
; READS:
;   _CONFIG_LRBN_FlagChar/_CONFIG_MSN_FlagChar, _Global_WORD_SELECT_CODE_IS_RAVESC, _SCRIPT_BannerTransitionActive
; WRITES:
;   _SCRIPT_BannerTransitionTargetChar/2353/2354, _SCRIPT_BannerTransitionStepBudget, _SCRIPT_BannerTransitionActive, _SCRIPT_PendingBannerSpeedMs
; DESC:
;   Prepares parameters for a banner-char transition toward a target value.
; NOTES:
;   Clamps target to 130..226 and rate to 0..$1D4C. Uses current banner char
;   from _GCOMMAND_GetBannerChar; returns 0 if already at target or busy.
;------------------------------------------------------------------------------
_SCRIPT_BeginBannerCharTransition:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6

    MOVEQ   #0,D5
    MOVE.B  _CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return

    CMPI.W  #130,D7
    BGE.S   .begin_banner_clamp_high_check

    MOVE.W  #130,D7
    BRA.S   .begin_banner_after_target_clamp

.begin_banner_clamp_high_check:
    CMPI.W  #226,D7
    BLE.S   .begin_banner_after_target_clamp

    MOVE.W  #226,D7

.begin_banner_after_target_clamp:
    MOVEQ   #0,D0
    CMP.W   D0,D6
    BCC.S   .begin_banner_clamp_rate_high_check

    MOVE.L  D0,D6
    BRA.S   .begin_banner_after_rate_clamp

.begin_banner_clamp_rate_high_check:
    CMPI.W  #$1d4c,D6
    BLS.S   .begin_banner_after_rate_clamp

    MOVE.W  #$1d4c,D6

.begin_banner_after_rate_clamp:
    JSR     _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.W  D0,-12(A5)
    TST.W   _SCRIPT_BannerTransitionActive
    BNE.W   .return

    CMP.W   D7,D0
    BEQ.W   .return

    MOVE.L  D7,D1
    MOVE.L  D7,D2
    EXT.L   D2
    EXT.L   D0
    SUB.L   D0,D2
    MOVE.L  D2,D4
    MOVE.B  D1,_SCRIPT_BannerTransitionTargetChar
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  _CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .config_msn_flag_not_m

.selectCodeIsNotRAVSEC:
    TST.L   D4
    BPL.S   .begin_banner_default_rate_if_forward

    MOVE.L  #7500,D0
    BRA.S   .begin_banner_after_rate_override

.begin_banner_default_rate_if_forward:
    MOVEQ   #0,D0

.begin_banner_after_rate_override:
    MOVE.L  D0,D6

.config_msn_flag_not_m:
    MOVE.L  D6,D0
    MULU    #60,D0
    MOVE.L  #1000,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,-10(A5)
    BGT.S   .begin_banner_compute_step

    MOVE.L  D4,D1
    MOVE.W  D1,_SCRIPT_BannerTransitionStepDelta
    BRA.S   .begin_banner_activate

.begin_banner_compute_step:
    TST.L   D4
    BPL.S   .begin_banner_direction_positive

    MOVEQ   #-1,D1
    BRA.S   .begin_banner_direction_selected

.begin_banner_direction_positive:
    MOVEQ   #1,D1

.begin_banner_direction_selected:
    MOVE.W  D1,_SCRIPT_BannerTransitionStepSign
    TST.L   D4
    BPL.S   .begin_banner_abs_delta_positive

    MOVE.L  D4,D2
    NEG.L   D2
    BRA.S   .begin_banner_abs_delta_ready

.begin_banner_abs_delta_positive:
    MOVE.L  D4,D2

.begin_banner_abs_delta_ready:
    MOVE.L  D2,D4
    MOVE.L  D4,D0
    MOVE.L  -10(A5),D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,_SCRIPT_BannerTransitionStepDelta
    EXT.L   D0
    MOVE.L  -10(A5),D1
    JSR     _SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D4
    BLE.S   .begin_banner_no_remainder

    MOVE.L  -10(A5),D0
    MOVE.L  D4,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,_SCRIPT_BannerTransitionStepBudget
    BRA.S   .begin_banner_finalize_step_sign

.begin_banner_no_remainder:
    CLR.W   _SCRIPT_BannerTransitionStepBudget

.begin_banner_finalize_step_sign:
    MOVE.W  _SCRIPT_BannerTransitionStepDelta,D0
    MULS    _SCRIPT_BannerTransitionStepSign,D0
    MOVE.W  D0,_SCRIPT_BannerTransitionStepDelta

.begin_banner_activate:
    MOVE.L  D6,D0
    MOVEQ   #1,D5
    MOVE.W  D5,_SCRIPT_BannerTransitionActive
    MOVE.W  D0,_SCRIPT_PendingBannerSpeedMs

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======