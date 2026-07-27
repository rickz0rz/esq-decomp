    XDEF    GENERATE_GRID_DATE_STRING
    XDEF    SCRIPT_BeginBannerCharTransition
    XDEF    SCRIPT_CheckPathExists
    XDEF    SCRIPT_PrimeBannerTransitionFromHexCode
    XDEF    SCRIPT_UpdateBannerCharTransition




;!======

;------------------------------------------------------------------------------
; FUNC: GENERATE_GRID_DATE_STRING   (GenerateGridDateStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A3
; CALLS:
;   _PARSEINI_JMPTBL_WDISP_SPrintf
; READS:
;   _CLOCK_CurrentDayOfWeekIndex/2275/2276/2277, Global_JMPTBL_DAYS_OF_WEEK, Global_JMPTBL_MONTHS
; WRITES:
;   outBuffer
; DESC:
;   Formats the current grid date string into outBuffer.
; NOTES:
;   Uses Global_STR_GRID_DATE_FORMAT_STRING as the template.
;------------------------------------------------------------------------------
GENERATE_GRID_DATE_STRING:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0
    MOVE.W  _CLOCK_CurrentMonthIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_MONTHS,A1
    ADDA.L  D0,A1
    MOVE.W  _CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CurrentYearValue,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     Global_STR_GRID_DATE_FORMAT_STRING
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CopyWeatherUpdateForString   (CopyWeatherUpdateForStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1/A3
; CALLS:
;   (none)
; READS:
;   Global_STR_WEATHER_UPDATE_FOR
; WRITES:
;   outBuffer
; DESC:
;   Copies the "Weather Update For" string into outBuffer.
; NOTES:
;   Previously unlabeled; appears unused in current build.
;------------------------------------------------------------------------------
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    LEA     Global_STR_WEATHER_UPDATE_FOR,A0
    MOVEA.L A3,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CheckPathExists   (CheckPathExistsuncertain)
; ARGS:
;   stack +8: path (char *)
; RET:
;   D0: 1 if lock/unlock succeeds, 0 otherwise
; CLOBBERS:
;   D0-D2/D6-D7/A3
; CALLS:
;   _LVOLock, _LVOUnLock
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Attempts a DOS lock on path and returns whether it succeeds.
; NOTES:
;   Uses lock mode -2 (shared read).
;------------------------------------------------------------------------------
SCRIPT_CheckPathExists:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateBannerCharTransition   (UpdateBannerCharTransitionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A4
; CALLS:
;   _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar, _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
; READS:
;   _SCRIPT_BannerTransitionStepBudget/_SCRIPT_BannerTransitionActive/_SCRIPT_BannerTransitionStepCursor, _SCRIPT_BannerTransitionTargetChar/2353/2354
; WRITES:
;   _SCRIPT_BannerTransitionActive/_SCRIPT_BannerTransitionStepCursor, banner character (via _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset)
; DESC:
;   Advances an in-progress banner character transition toward its target.
; NOTES:
;   Disables the transition when the target is reached.
;------------------------------------------------------------------------------
SCRIPT_UpdateBannerCharTransition:
    MOVEM.L D2-D7/A4,-(A7)

    LEA     _Global_REF_LONG_FILE_SCRATCH,A4
    TST.W   _SCRIPT_BannerTransitionActive
    BEQ.W   .done

    JSR     _SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  _SCRIPT_BannerTransitionTargetChar,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .advance_step

    MOVEQ   #0,D1
    MOVE.W  D1,_SCRIPT_BannerTransitionActive
    MOVE.W  D1,_SCRIPT_BannerTransitionStepCursor
    BRA.W   .done

.advance_step:
    MOVE.W  _SCRIPT_BannerTransitionStepDelta,D5
    MOVE.W  _SCRIPT_BannerTransitionStepBudget,D1
    MOVEQ   #0,D2
    CMP.W   D2,D1
    BLS.S   .calc_candidate

    ADDQ.W  #1,_SCRIPT_BannerTransitionStepCursor
    MOVE.W  _SCRIPT_BannerTransitionStepCursor,D3
    CMP.W   D1,D3
    BLT.S   .calc_candidate

    MOVE.W  _SCRIPT_BannerTransitionStepSign,D3
    ADD.W   D3,D5
    MOVE.W  D2,_SCRIPT_BannerTransitionStepCursor

.calc_candidate:
    MOVE.L  D5,D7
    ADD.W   D6,D7
    MOVE.W  _SCRIPT_BannerTransitionStepSign,D3
    TST.W   D3
    BPL.S   .check_positive_step

    MOVE.L  D7,D4
    EXT.L   D4
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    CMP.L   D1,D4
    BLT.S   .snap_to_target

.check_positive_step:
    TST.W   D3
    BLE.S   .check_zero_step

    MOVE.L  D7,D1
    EXT.L   D1
    MOVEQ   #0,D3
    MOVE.B  D0,D3
    CMP.L   D3,D1
    BGT.S   .snap_to_target

.check_zero_step:
    TST.W   _SCRIPT_BannerTransitionStepDelta
    BNE.S   .apply_step

    TST.W   _SCRIPT_BannerTransitionStepBudget
    BNE.S   .apply_step

.snap_to_target:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D6,D0
    EXT.L   D0
    SUB.L   D0,D1
    MOVE.L  D1,D5

.apply_step:
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(PC)

    ADDQ.W  #4,A7

.done:
    MOVEM.L (A7)+,D2-D7/A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_BeginBannerCharTransition   (Configure and start banner-char transition)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: 1 if a transition was started, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   _GCOMMAND_GetBannerChar, SCRIPT3_JMPTBL_MATH_DivS32, SCRIPT3_JMPTBL_MATH_Mulu32
; READS:
;   _CONFIG_LRBN_FlagChar/CONFIG_MSN_FlagChar, Global_WORD_SELECT_CODE_IS_RAVESC, _SCRIPT_BannerTransitionActive
; WRITES:
;   _SCRIPT_BannerTransitionTargetChar/2353/2354, _SCRIPT_BannerTransitionStepBudget, _SCRIPT_BannerTransitionActive, SCRIPT_PendingBannerSpeedMs
; DESC:
;   Prepares parameters for a banner-char transition toward a target value.
; NOTES:
;   Clamps target to 130..226 and rate to 0..$1D4C. Uses current banner char
;   from _GCOMMAND_GetBannerChar; returns 0 if already at target or busy.
;------------------------------------------------------------------------------
SCRIPT_BeginBannerCharTransition:
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
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  CONFIG_MSN_FlagChar,D0
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
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

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
    MOVE.W  D0,SCRIPT_PendingBannerSpeedMs

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_PrimeBannerTransitionFromHexCode   (PrimeBannerTransitionFromHexCode)
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
SCRIPT_PrimeBannerTransitionFromHexCode:
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
