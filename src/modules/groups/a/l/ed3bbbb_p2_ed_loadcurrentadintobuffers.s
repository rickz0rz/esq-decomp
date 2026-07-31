    XDEF    _ED_LoadCurrentAdIntoBuffers


;------------------------------------------------------------------------------
; FUNC: _ED_LoadCurrentAdIntoBuffers   (Load current ad into buffersuncertain)
; ARGS:
;   (none)
; RET:
;   (none)
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D7
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault, _GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte, _ED_RedrawAllRows, _ED_DrawCurrentColorIndicator,
;   _ED_RedrawCursorChar,
;   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE,
;   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _DISPLIB_DisplayTextAtPosition,
;   _ESQIFF_JMPTBL_MATH_Mulu32, _LVOSetAPen, _LVOSetBPen, _LVOSetDrMd, _LVORectFill
; READS:
;   _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER, _ED_BlockOffset, _ED_TextLimit
; WRITES:
;   _ED_EditCursorOffset, _ED_ViewportOffset, _ED_AdDisplayResetFlag, _Global_REF_BOOL_IS_LINE_OR_PAGE,
;   _Global_REF_BOOL_IS_TEXT_OR_CURSOR
; DESC:
;   Loads the current ad into edit buffers and refreshes the screen.
; NOTES:
;   Pads buffers to _ED_BlockOffset and redraws the header/status areas.
;   Uses a 44-byte local printf target (-44(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_LoadCurrentAdIntoBuffers:

.editingAdLabel = -44

    LINK.W  A5,#-48
    MOVEM.L D2-D3/D7,-(A7)
    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,D0
    SUBQ.L  #1,D0
    PEA     _ED_EditBufferLive
    PEA     _ED_EditBufferScratch
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_BuildEntryBuffersOrDefault(PC)

    LEA     12(A7),A7
    LEA     _ED_EditBufferScratch,A0
    MOVEA.L A0,A1

.find_string_end:
    TST.B   (A1)+
    BNE.S   .find_string_end

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D7
    MOVE.L  _ED_BlockOffset,D0
    CMP.L   D0,D7
    BGE.S   .after_pad

    ADDA.L  D7,A0
    SUB.L   D7,D0
    MOVEQ   #32,D1
    BRA.S   .pad_spaces_check

.pad_spaces_loop:
    MOVE.B  D1,(A0)+

.pad_spaces_check:
    SUBQ.L  #1,D0
    BCC.S   .pad_spaces_loop

    LEA     _ED_EditBufferLive,A0
    ADDA.L  D7,A0
    PEA     1.W
    PEA     2.W
    MOVE.L  A0,20(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(PC)

    ADDQ.W  #8,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  _ED_BlockOffset,D0
    SUB.L   D7,D0
    MOVEA.L 12(A7),A0
    BRA.S   .fill_attr_check

.fill_attr_loop:
    MOVE.B  D1,(A0)+

.fill_attr_check:
    SUBQ.L  #1,D0
    BCC.S   .fill_attr_loop

.after_pad:
    LEA     _ED_EditBufferScratch,A0
    ADDA.L  _ED_BlockOffset,A0
    CLR.B   (A0)
    MOVEQ   #1,D0
    MOVE.L  D0,_ED_AdDisplayResetFlag
    BSR.W   _ED_RedrawAllRows

    MOVEQ   #0,D0
    MOVE.L  D0,_ED_EditCursorOffset
    MOVE.L  D0,_ED_ViewportOffset
    MOVE.L  D0,_Global_REF_BOOL_IS_LINE_OR_PAGE
    MOVE.L  D0,-(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE

    MOVEQ   #1,D0
    MOVE.L  D0,_Global_REF_BOOL_IS_TEXT_OR_CURSOR
    MOVE.L  D0,(A7)
    BSR.W   _SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #8,D0
    SUB.L   _ED_TextLimit,D0
    MOVEQ   #30,D1
    JSR     _ESQIFF_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  #302,D1
    SUB.L   D0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #40,D0
    MOVE.L  #640,D2
    MOVE.L  #308,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  _ED_EditBufferLive,D0
    MOVE.L  D0,(A7)
    BSR.W   _ED_DrawCurrentColorIndicator

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    JSR     _LVOSetBPen(A6)

    MOVE.L  _Global_REF_LONG_CURRENT_EDITING_AD_NUMBER,(A7)
    PEA     _Global_STR_EDITING_AD_NUMBER_FORMATTED_2
    PEA     .editingAdLabel(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .editingAdLabel(A5)
    PEA     300.W
    PEA     190.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    ; Set drawing mode to 1
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    ; Set B pen to 2
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    BSR.W   _ED_RedrawCursorChar

    MOVEM.L -60(A5),D2-D3/D7
    UNLK    A5
    RTS

;!======