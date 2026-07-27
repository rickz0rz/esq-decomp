    XDEF    ED_DrawAdNumberPrompt
    XDEF    _ED_DrawAreYouSurePrompt


;------------------------------------------------------------------------------
; FUNC: _ED_DrawAreYouSurePrompt   (Draw "Are you sure" promptuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   _ED_DrawHelpPanels, _DISPLIB_DisplayTextAtPosition,
;   _LVOSetAPen, _LVOSetDrMd
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws a confirmation prompt panel.
; NOTES:
;   Uses _ED_DrawHelpPanels to render the background.
;------------------------------------------------------------------------------
_ED_DrawAreYouSurePrompt:
    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ARE_YOU_SURE
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     20(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    RTS

;!======

; enter ad number prompt
;------------------------------------------------------------------------------
; FUNC: ED_DrawAdNumberPrompt   (Draw ad number promptuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _ED_DrawHelpPanels, _DISPLIB_DisplayTextAtPosition, _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth,
;   _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd
; READS:
;   _ED_MaxAdNumber, _Global_REF_RASTPORT_1
; WRITES:
;   _ED_EditCursorOffset, ED_AdNumberPromptStateBlock
; DESC:
;   Draws the "enter ad number" prompt and initializes the entry buffer.
; NOTES:
;   Initializes _ED_EditBufferScratch/_ED_EditBufferLive with spaces and default chars.
;------------------------------------------------------------------------------
ED_DrawAdNumberPrompt:
    LINK.W  A5,#-4
    MOVEM.L D2-D3/D7,-(A7)

    PEA     6.W
    BSR.W   _ED_DrawHelpPanels

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    PEA     Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN
    PEA     330.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     2.W
    MOVE.L  _ED_MaxAdNumber,-(A7)
    PEA     _ED_EditBufferScratch
    JSR     _GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(PC)

    PEA     _ED_EditBufferScratch
    PEA     330.W
    PEA     340.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_LEFT_PARENTHESIS_THEN
    PEA     330.W
    PEA     370.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2
    PEA     360.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7
    PEA     Global_STR_SINGLE_SPACE_4
    PEA     390.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVEQ   #68,D1
    MOVE.L  #640,D2
    MOVEQ   #98,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    PEA     Global_STR_AD_NUMBER_QUESTIONMARK
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #12,D0
    MOVE.L  D0,_ED_EditCursorOffset
    MOVEQ   #0,D7

.init_entry_loop:
    MOVEQ   #14,D0
    CMP.L   D0,D7
    BGE.S   .init_entry_done

    LEA     _ED_EditBufferScratch,A0
    ADDA.L  D7,A0
    MOVE.B  #$20,(A0)
    LEA     _ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.L  #1,D7
    BRA.S   .init_entry_loop

.init_entry_done:
    CLR.B   ED_AdNumberPromptStateBlock
    BSR.W   _ED_RedrawCursorChar

    MOVEM.L (A7)+,D2-D3/D7
    UNLK    A5
    RTS

;!======