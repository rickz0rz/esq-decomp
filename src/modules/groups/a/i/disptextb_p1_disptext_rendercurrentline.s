    XDEF    _DISPTEXT_RenderCurrentLine

;------------------------------------------------------------------------------
; FUNC: _DISPTEXT_RenderCurrentLine   (Render one line of display text)
; ARGS:
;   stack +8: A3 = rastport
;   stack +12: D7 = x
;   stack +16: D6 = y
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A6/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _DISPTEXT_FinalizeLineTable, _LVOSetAPen, _LVOSetDrMd, _LVOMove, _LVOText, _GROUP_AI_JMPTBL_STR_FindCharPtr, _GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments
; READS:
;   _DISPTEXT_LinePtrTable/21D6/21D7/21D9/21DC/21B1/21B2/21D8
; WRITES:
;   _DISPTEXT_CurrentLineIndex, _DISPTEXT_ControlMarkerXOffsetPx
; DESC:
;   Draws the current line at the given position, honoring highlight markers.
; NOTES:
;   Uses 0x13/0x14 control markers when _DISPTEXT_ControlMarkersEnabledFlag set.
;------------------------------------------------------------------------------
_DISPTEXT_RenderCurrentLine:
    LINK.W  A5,#-12
    MOVEM.L D2-D7/A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVE.L  12(A5),D7
    MOVE.L  16(A5),D6
    BSR.W   _DISPTEXT_FinalizeLineTable

    MOVEQ   #0,D0
    MOVE.L  D0,_DISPTEXT_ControlMarkerXOffsetPx
    MOVE.L  _DISPTEXT_LineWidthPx,D1
    TST.L   D1
    BLE.W   .return

    MOVE.W  _DISPTEXT_CurrentLineIndex,D1
    MOVE.W  _DISPTEXT_TargetLineIndex,D2
    CMP.W   D2,D1
    BCC.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    LEA     _DISPTEXT_LinePtrTable,A0
    MOVEA.L A0,A1
    ADDA.L  D2,A1
    TST.L   (A1)
    BEQ.W   .return

    MOVEQ   #0,D2
    MOVE.W  D1,D2
    ASL.L   #2,D2
    ADDA.L  D2,A0
    MOVE.L  (A0),-6(A5)
    MOVEQ   #0,D3
    MOVE.W  D1,D3
    ADD.L   D3,D3
    LEA     _DISPTEXT_LineLengthTable,A0
    ADDA.L  D3,A0
    MOVEQ   #0,D4
    MOVE.W  (A0),D4
    TST.L   D4
    BLE.W   .return

    LEA     _DISPTEXT_LinePenTable,A0
    ADDA.L  D2,A0
    MOVEA.L A3,A1
    MOVE.L  (A0),D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L A3,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    MOVEA.L -6(A5),A0
    MOVE.B  0(A0,D4.L),D5
    CLR.B   0(A0,D4.L)
    TST.W   _DISPTEXT_ControlMarkersEnabledFlag
    BEQ.S   .draw_plain

    PEA     19.W
    MOVE.L  A0,-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    PEA     20.W
    MOVE.L  -6(A5),-(A7)
    JSR     _GROUP_AI_JMPTBL_STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .draw_plain

    MOVEQ   #0,D0
    MOVE.B  _DISPTEXT_InsetNibbleSecondary,D0
    MOVEQ   #0,D1
    MOVE.B  _DISPTEXT_InsetNibblePrimary,D1
    MOVE.L  -6(A5),-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _GROUP_AI_JMPTBL_TLIBA1_DrawTextWithInsetSegments(PC)

    LEA     24(A7),A7
    MOVEQ   #4,D0
    MOVE.L  D0,_DISPTEXT_ControlMarkerXOffsetPx
    BRA.S   .restore_char

.draw_plain:
    MOVEA.L A3,A1
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L A3,A1
    MOVE.L  D4,D0
    MOVEA.L -6(A5),A0
    JSR     _LVOText(A6)

.restore_char:
    MOVEA.L -6(A5),A0
    MOVE.B  D5,0(A0,D4.L)
    MOVE.W  _DISPTEXT_CurrentLineIndex,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_DISPTEXT_CurrentLineIndex

.return:
    MOVEM.L (A7)+,D2-D7/A3
    UNLK    A5
    RTS
