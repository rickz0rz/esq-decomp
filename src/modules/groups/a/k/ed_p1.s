    XDEF    _ED_HandleEditAttributesInput


;------------------------------------------------------------------------------
; FUNC: _ED_HandleEditAttributesInput   (Handle edit attributes inputuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A7/D0/D1
; CALLS:
;   _ED_DrawESCMenuBottomHelp, _ED_IncrementAdNumber, _ED_DecrementAdNumber, _ESQDISP_TestWordIsZeroBooleanize, _ED_ApplyActiveFlagToAdData,
;   _ED_UpdateActiveInactiveIndicator
; READS:
;   _ED_LastKeyCode, _ED_AdActiveFlag, _ED_StateRingIndex, _ED_StateRingTable
; WRITES:
;   _ED_AdActiveFlag, _ED_SaveTextAdsOnExitFlag, _ED_AdDisplayResetFlag
; DESC:
;   Processes edit-attribute key codes and commits changes to state variables.
; NOTES:
;   Recognizes key code $80 with modifier bytes to trigger _ED_IncrementAdNumber/_ED_DecrementAdNumber.
;------------------------------------------------------------------------------
_ED_HandleEditAttributesInput:
    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBI.W  #13,D0
    BEQ.S   .case_show_help

    SUBI.W  #14,D0
    BEQ.S   .case_show_help

    SUBI.W  #$80,D0
    BNE.S   .case_adjust_21ea

    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    MOVEQ   #32,D1
    CMP.B   1(A1),D1
    BNE.S   .return

    ADDA.L  D0,A0
    MOVEQ   #64,D0
    CMP.B   2(A0),D0
    BNE.S   .case_special_65

    JSR     _ED_IncrementAdNumber(PC)

    BRA.S   .return

.case_special_65:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVEQ   #65,D0
    CMP.B   2(A0),D0
    BNE.S   .return

    JSR     _ED_DecrementAdNumber(PC)

    BRA.S   .return

.case_show_help:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_ED_SaveTextAdsOnExitFlag
    JSR     _ED_ApplyActiveFlagToAdData(PC)

    BRA.S   .return

.case_adjust_21ea:
    MOVE.L  _ED_AdActiveFlag,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     _ESQDISP_TestWordIsZeroBooleanize(PC)

    ADDQ.W  #4,A7
    EXT.L   D0
    MOVE.L  D0,_ED_AdActiveFlag
    MOVEQ   #1,D0
    MOVE.L  D0,_ED_AdDisplayResetFlag

.return:
    JSR     _ED_UpdateActiveInactiveIndicator(PC)

    RTS
