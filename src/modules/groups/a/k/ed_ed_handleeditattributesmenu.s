    XDEF    _ED_HandleEditAttributesMenu


;------------------------------------------------------------------------------
; FUNC: _ED_HandleEditAttributesMenu   (Handle edit attributes menuuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D4
; CALLS:
;   _ED_DrawCursorChar, _ED_RedrawCursorChar, ED_NextAdNumber, ED_PrevAdNumber, ED_DrawEditHelpText, _ED_DrawAdEditingScreen, _ED_LoadCurrentAdIntoBuffers,
;   _ED_DrawHelpPanels, _ED_UpdateAdNumberDisplay, _DISPLIB_DisplayTextAtPosition,
;   _GROUP_AG_JMPTBL_MATH_Mulu32, _GROUP_AG_JMPTBL_MATH_DivS32,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   _ED_LastKeyCode, _ED_EditCursorOffset, _ED_AdNumberInputDigitTens, _ED_AdNumberInputDigitOnes, _ED_MaxAdNumber, _ED_MenuStateId
; WRITES:
;   _ED_EditCursorOffset, _ED_EditBufferScratch, _ED_MenuStateId, _ED_SaveTextAdsOnExitFlag, _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
; DESC:
;   Handles edit-attributes input, updating the buffer and selected ad number.
; NOTES:
;   Accepts numeric keys and special menu codes (e.g., $8E).
;------------------------------------------------------------------------------
_ED_HandleEditAttributesMenu:
; Draw 'Edit Attributes' menu
    MOVEM.L D2-D4,-(A7)
    JSR     _ED_DrawCursorChar(PC)

    MOVEQ   #0,D0
    MOVE.B  _ED_LastKeyCode,D0
    SUBQ.W  #8,D0
    BEQ.S   .case_backspace

    SUBQ.W  #5,D0
    BEQ.S   .case_commit_ad_number

    SUBI.W  #$8e,D0
    BEQ.S   .case_nav_key

    BRA.W   .case_digit_input

.case_backspace:
    MOVE.L  _ED_EditCursorOffset,D0
    MOVEQ   #12,D1
    CMP.L   D1,D0
    BLE.S   .after_backspace

    SUBQ.L  #1,_ED_EditCursorOffset
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_EditCursorOffset,A0
    MOVE.B  #$20,(A0)

.after_backspace:
    JSR     _ED_DrawCursorChar(PC)

    BRA.W   .refresh_attribute_display

.case_nav_key:
    MOVE.L  _ED_StateRingIndex,D0
    LSL.L   #2,D0
    ADD.L   _ED_StateRingIndex,D0
    LEA     _ED_StateRingTable,A0
    ADDA.L  D0,A0
    MOVE.B  1(A0),D0
    MOVE.B  D0,_ED_LastMenuInputChar
    MOVEQ   #67,D1
    CMP.B   D1,D0
    BNE.S   .after_nav_key

    MOVEQ   #13,D1
    MOVE.L  D1,_ED_EditCursorOffset
    BRA.W   .refresh_attribute_display

.after_nav_key:
    MOVEQ   #68,D1
    CMP.B   D1,D0
    BNE.W   .refresh_attribute_display

    MOVEQ   #12,D0
    MOVE.L  D0,_ED_EditCursorOffset
    BRA.W   .refresh_attribute_display

.case_commit_ad_number:
    MOVE.B  _ED_AdNumberInputDigitTens,D0
    MOVEQ   #32,D1
    CMP.B   D1,D0
    BNE.S   .ad_second_blank

    MOVE.B  _ED_AdNumberInputDigitOnes,D2
    CMP.B   D1,D2
    BEQ.S   .ad_both_blank

    MOVEQ   #0,D3
    MOVE.B  D2,D3
    MOVEQ   #48,D4
    SUB.L   D4,D3
    MOVE.L  D3,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_both_blank:
    MOVEQ   #1,D3
    MOVE.L  D3,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_second_blank:
    MOVE.B  _ED_AdNumberInputDigitOnes,D2
    CMP.B   D1,D2
    BNE.S   .ad_two_digits

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D3
    SUB.L   D3,D1
    MOVE.L  D1,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER
    BRA.S   .ad_number_ready

.ad_two_digits:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #48,D0
    SUB.L   D0,D1
    MOVEQ   #10,D0
    JSR     _GROUP_AG_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  D2,D1
    ADD.L   D1,D0
    MOVEQ   #48,D1
    SUB.L   D1,D0
    MOVE.L  D0,_Global_REF_LONG_CURRENT_EDITING_AD_NUMBER

.ad_number_ready:
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    CMP.L   _ED_MaxAdNumber,D0
    BLE.S   .ad_number_in_range

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _ED2_STR_NUMBER_TOO_BIG
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_in_range:
    TST.L   D0
    BNE.S   .ad_number_mode2

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #4,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _ED2_STR_NUMBER_TOO_SMALL
    PEA     150.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    BRA.W   .return

.ad_number_mode2:
    MOVE.B  _ED_MenuStateId,D0
    SUBQ.B  #2,D0
    BNE.S   .ad_number_other_mode

    MOVE.B  #$4,_ED_MenuStateId
    JSR     _ED_DrawAdEditingScreen(PC)

    JSR     _ED_LoadCurrentAdIntoBuffers(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_ED_SaveTextAdsOnExitFlag
    BRA.W   .return

.ad_number_other_mode:
    MOVE.B  #$5,_ED_MenuStateId
    PEA     6.W
    JSR     _ED_DrawHelpPanels(PC)

    JSR     _ED_UpdateAdNumberDisplay(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     _ED2_STR_PUSH_ESC_TO_EXIT_ATTRIBUTE_EDIT_DOT
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _ED2_STR_PUSH_RETURN_TO_ENTER_SELECTION
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _ED2_STR_PUSH_ANY_KEY_TO_SELECT
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     52(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    BRA.S   .return

.case_digit_input:
    MOVE.B  _ED_LastKeyCode,D0
    MOVEQ   #48,D1
    CMP.B   D1,D0
    BCS.S   .refresh_attribute_display

    MOVEQ   #57,D1
    CMP.B   D1,D0
    BHI.S   .refresh_attribute_display

    JSR     _ED_DrawCursorChar(PC)

    LEA     _ED_EditBufferScratch,A0
    MOVE.L  _ED_EditCursorOffset,D0
    ADDA.L  D0,A0
    MOVE.B  _ED_LastKeyCode,(A0)
    CMPI.L  #$d,_ED_EditCursorOffset
    BGE.S   .refresh_attribute_display

    JSR     _ED_DrawCursorChar(PC)

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_EditCursorOffset,A0
    ADDQ.L  #1,_ED_EditCursorOffset
    MOVE.B  _ED_LastKeyCode,(A0)

.refresh_attribute_display:
    JSR     _ED_RedrawCursorChar(PC)

.return:
    MOVEM.L (A7)+,D2-D4
    RTS

;!======