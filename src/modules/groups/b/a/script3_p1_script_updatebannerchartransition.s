    XDEF    _SCRIPT_UpdateBannerCharTransition



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_UpdateBannerCharTransition   (UpdateBannerCharTransitionuncertain)
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
_SCRIPT_UpdateBannerCharTransition:
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