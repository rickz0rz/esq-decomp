    XDEF    _ED2_HandleDiagnosticsMenuActions


;------------------------------------------------------------------------------
; FUNC: _ED2_HandleDiagnosticsMenuActions   (Handle diagnostics menu actionsuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0/D1
; CALLS:
;   _GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides, _ED_FindNextCharInTable, _ED_DrawDiagnosticModeText, _ESQIFF_JMPTBL_MATH_Mulu32,
;   _DISPLIB_DisplayTextAtPosition, _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte, _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn,
;   _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight,
;   _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight,
;   _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default,
;   _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   _GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow,
;   _GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _Global_REF_RASTPORT_1, _ED_DiagTextModeChar, _ED2_TAG_NRLS, _ED2_STR_NYYLLZ, _ED2_TAG_NYLRS, _ED2_STR_SILENCE, _ED2_STR_LEFT, _ED2_STR_RIGHT, _ED2_STR_BACKGROUND, _ED2_STR_EXT_DOT_VIDEO_ONLY, _ED2_STR_COMPUTER_ONLY, _ED2_STR_OVERLAY_EXT_DOT_VIDEO, _ED2_STR_NEGATIVE_VIDEO, _ED2_STR_VIDEO_SWITCH, _ED2_STR_OPEN, _ED2_STR_CLOSED, _ED2_STR_START_TAPE_VIDEO, _ED2_STR_STOP, _ED_DiagScrollSpeedChar, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _ED_DiagAvailMemMask, _ED_DiagnosticsViewMode, _ED_StateRingIndex, _ED_StateRingTable, case_adjust_1bc4, case_adjust_1dd6, case_adjust_1dd7, case_assert_ctrl_line, case_clear_error_counters, case_copper_all_off, case_copper_all_on, case_copper_default, case_copper_on_highlight, case_cycle_1dcd_digit, case_deassert_ctrl_line, case_default_help, case_increment_226a, case_refresh_rastport_1, case_set_1df1_bit0, case_set_1df1_bit1, case_set_1df1_bit2, case_show_ciab_bit5, case_toggle_1df0_low3, case_toggle_226a, case_transition_0, case_transition_1, case_transition_2, case_transition_3, return
; WRITES:
;   _DATACErrs, _Global_WORD_MAX_VALUE, _ED_DiagTextModeChar, _ED_DiagScrollSpeedChar, _ED_DiagGraphModeChar, _ED_DiagVinModeChar, _ED_DiagAvailMemMask, ED_DiagAvailMemPresetBits, _ED_BlockOffset, _ED_LastKeyCode, _ED_TextLimit, _ED_DiagnosticsScreenActive, _ED_DiagnosticsViewMode, _CTRL_HDeltaMax, _ESQIFF_ParseAttemptCount, _ESQIFF_LineErrorCount, _SCRIPT_CtrlCmdCount, _SCRIPT_CtrlCmdChecksumErrorCount, _SCRIPT_CtrlCmdLengthErrorCount
; DESC:
;   Handles diagnostic/special menu selections, toggling flags, counters, and
;   invoking test patterns or copper effects.
; NOTES:
;   Uses a switch-like chain on _ED_StateRingTable selection.
;------------------------------------------------------------------------------
_ED2_HandleDiagnosticsMenuActions:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  (A0),D0
    MOVE.B  D0,_ED_LastKeyCode
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    SUBQ.W  #1,D1
    BEQ.W   .case_toggle_1df0_low3

    SUBQ.W  #2,D1
    BEQ.W   .case_set_1df1_bit0

    SUBQ.W  #3,D1
    BEQ.W   .case_set_1df1_bit1

    SUBQ.W  #1,D1
    BEQ.W   .case_refresh_rastport_1

    SUBQ.W  #6,D1
    BEQ.W   .case_set_1df1_bit2

    SUBQ.W  #5,D1
    BEQ.W   .case_clear_error_counters

    SUBI.W  #15,D1
    BEQ.W   .case_adjust_1bc4

    SUBQ.W  #2,D1
    BEQ.W   .case_cycle_1dcd_digit

    SUBQ.W  #1,D1
    BEQ.W   .case_adjust_1dd6

    SUBQ.W  #4,D1
    BEQ.W   .case_assert_ctrl_line

    SUBQ.W  #1,D1
    BEQ.W   .case_deassert_ctrl_line

    SUBQ.W  #8,D1
    BEQ.W   .case_transition_0

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_1

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_2

    SUBQ.W  #1,D1
    BEQ.W   .case_transition_3

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_all_on

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_all_off

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_on_highlight

    SUBQ.W  #1,D1
    BEQ.W   .case_copper_default

    SUBQ.W  #1,D1
    BEQ.W   .case_show_ciab_bit5

    SUBQ.W  #7,D1
    BEQ.W   .case_adjust_1dd7

    SUBQ.W  #3,D1
    BEQ.W   .case_increment_226a

    SUBI.W  #$20,D1
    BEQ.W   .case_toggle_226a

    BRA.W   .case_default_help

.case_toggle_1df0_low3:
    MOVEQ   #7,D0
    AND.L   _ED_DiagAvailMemMask,D0
    SUBQ.L  #7,D0
    BNE.S   .set_1df0_low3

    MOVEQ   #-8,D0
    AND.L   D0,_ED_DiagAvailMemMask
    BRA.W   .return

.set_1df0_low3:
    MOVEQ   #7,D0
    OR.L    D0,_ED_DiagAvailMemMask
    BRA.W   .return

.case_set_1df1_bit0:
    MOVEQ   #-8,D0
    AND.L   D0,_ED_DiagAvailMemMask
    BSET    #0,ED_DiagAvailMemPresetBits
    BRA.W   .return

.case_set_1df1_bit1:
    MOVEQ   #-8,D0
    AND.L   D0,_ED_DiagAvailMemMask
    BSET    #1,ED_DiagAvailMemPresetBits
    BRA.W   .return

.case_refresh_rastport_1:
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _GROUP_AK_JMPTBL_TLIBA3_DrawViewModeGuides(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.case_set_1df1_bit2:
    MOVEQ   #-8,D0
    AND.L   D0,_ED_DiagAvailMemMask
    BSET    #2,ED_DiagAvailMemPresetBits
    BRA.W   .return

.case_clear_error_counters:
    MOVEQ   #0,D0
    MOVE.W  D0,_Global_WORD_MAX_VALUE
    MOVE.W  D0,_CTRL_HDeltaMax
    MOVE.W  D0,_ESQIFF_LineErrorCount
    MOVE.W  D0,_DATACErrs
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVE.W  D0,_SCRIPT_CtrlCmdLengthErrorCount
    MOVE.W  D0,_SCRIPT_CtrlCmdChecksumErrorCount
    MOVE.W  D0,_SCRIPT_CtrlCmdCount
    BRA.W   .return

.case_adjust_1bc4:
    MOVE.B  _ED_DiagTextModeChar,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     _ED2_TAG_NRLS
    MOVE.L  D1,-(A7)
    JSR     _ED_FindNextCharInTable(PC)

    MOVE.B  D0,_ED_DiagTextModeChar
    JSR     _ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_adjust_1dd7:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    PEA     _ED2_STR_NYYLLZ
    MOVE.L  D0,-(A7)
    JSR     _ED_FindNextCharInTable(PC)

    MOVE.B  D0,_ED_DiagVinModeChar
    JSR     _ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_cycle_1dcd_digit:
    MOVE.B  _ED_DiagScrollSpeedChar,D0
    MOVE.L  D0,D1
    SUBQ.B  #1,D1
    MOVE.B  D1,_ED_DiagScrollSpeedChar
    MOVEQ   #51,D0
    CMP.B   D0,D1
    BCC.S   .after_cycle_1dcd

    MOVEQ   #54,D0
    MOVE.B  D0,_ED_DiagScrollSpeedChar

.after_cycle_1dcd:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagScrollSpeedChar,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,_ED_TextLimit
    MOVEQ   #40,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  D0,_ED_BlockOffset
    JSR     _ED_DrawDiagnosticModeText(PC)

    BRA.W   .return

.case_adjust_1dd6:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagGraphModeChar,D0
    PEA     _ED2_TAG_NYLRS
    MOVE.L  D0,-(A7)
    JSR     _ED_FindNextCharInTable(PC)

    MOVE.B  D0,_ED_DiagGraphModeChar
    JSR     _ED_DrawDiagnosticModeText(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.case_toggle_226a:
    MOVE.W  _ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BNE.S   .case_set_226a_one

    CLR.W   _ED_DiagnosticsViewMode
    BRA.W   .return

.case_set_226a_one:
    MOVE.W  #1,_ED_DiagnosticsViewMode
    BRA.W   .return

.case_increment_226a:
    MOVE.W  _ED_DiagnosticsViewMode,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ED_DiagnosticsViewMode
    BRA.W   .return

.case_transition_0:
    PEA     _ED2_STR_SILENCE
    PEA     360.W
    PEA     175.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    CLR.L   (A7)
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_transition_1:
    PEA     _ED2_STR_LEFT
    PEA     360.W
    PEA     175.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_2:
    PEA     _ED2_STR_RIGHT
    PEA     360.W
    PEA     175.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_transition_3:
    PEA     _ED2_STR_BACKGROUND
    PEA     360.W
    PEA     175.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     3.W
    JSR     _GROUP_AK_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    LEA     20(A7),A7
    BRA.W   .return

.case_copper_all_on:
    PEA     _ED2_STR_EXT_DOT_VIDEO_ONLY
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_AllOn(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_all_off:
    PEA     _ED2_STR_COMPUTER_ONLY
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OffDisableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_on_highlight:
    PEA     _ED2_STR_OVERLAY_EXT_DOT_VIDEO
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AM_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_copper_default:
    PEA     _ED2_STR_NEGATIVE_VIDEO
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AK_JMPTBL_ESQ_SetCopperEffect_Default(PC)

    LEA     16(A7),A7
    BRA.W   .return

.case_show_ciab_bit5:
    PEA     _ED2_STR_VIDEO_SWITCH
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    LEA     16(A7),A7
    TST.B   D0
    BNE.S   .show_ciab_bit5_set

    PEA     _ED2_STR_OPEN
    PEA     270.W
    PEA     235.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.show_ciab_bit5_set:
    PEA     _ED2_STR_CLOSED
    PEA     270.W
    PEA     235.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_assert_ctrl_line:
    PEA     _ED2_STR_START_TAPE_VIDEO
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AK_JMPTBL_SCRIPT_AssertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_deassert_ctrl_line:
    PEA     _ED2_STR_STOP
    PEA     270.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _GROUP_AK_JMPTBL_SCRIPT_DeassertCtrlLineNow(PC)

    LEA     16(A7),A7
    BRA.S   .return

.case_default_help:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    CLR.W   _ED_DiagnosticsScreenActive

.return:
    RTS

;!======