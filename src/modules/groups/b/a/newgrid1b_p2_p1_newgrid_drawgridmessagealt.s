    XDEF    _NEWGRID_DrawGridMessageAlt


;------------------------------------------------------------------------------
; FUNC: _NEWGRID_DrawGridMessageAlt   (Draw alternate grid message)
; ARGS:
;   stack +8: A3 = rastport
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A3/A6
; CALLS:
;   _NEWGRID_DrawGridFrame, _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight, _LVOSetAPen, _LVOSetDrMd,
;   _LVOTextLength, _LVOMove, _LVOText, _NEWGRID_ValidateSelectionCode
; READS:
;   _GCOMMAND_PpvMessageTextPen, _GCOMMAND_PpvMessageFramePen, _GCOMMAND_PPVPeriodTemplatePtr, _NEWGRID_ColumnStartXPx, _NEWGRID_ColumnWidthPx
; DESC:
;   Centers a fixed message string inside the grid frame.
; NOTES:
;   Reads message text directly from _GCOMMAND_PPVPeriodTemplatePtr.
;   This routine currently assumes that pointer is non-NULL.
;------------------------------------------------------------------------------
_NEWGRID_DrawGridMessageAlt:
    LINK.W  A5,#-12
    MOVEM.L D2/D7/A3,-(A7)
    MOVEA.L 32(A7),A3
    PEA     33.W
    MOVE.L  _GCOMMAND_PpvMessageFramePen,D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    PEA     7.W
    MOVE.L  A3,-(A7)
    JSR     _NEWGRID_DrawGridFrame(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    PEA     33.W
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     33.W
    PEA     695.W
    CLR.L   -(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    JSR     _NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(PC)

    LEA     60(A7),A7
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  _GCOMMAND_PpvMessageTextPen,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    JSR     _LVOSetDrMd(A6)

    ; Source message pointer: expected to be valid/NUL-terminated.
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0

.scan_message_end:
    TST.B   (A0)+
    BNE.S   .scan_message_end

    SUBQ.L  #1,A0
    SUBA.L  _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVE.L  A0,D7

.fit_message_width:
    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    MOVEQ   #12,D2
    SUB.L   D2,D1
    CMP.L   D1,D0
    BLE.S   .layout_text

    SUBQ.L  #1,D7
    BRA.S   .fit_message_width

.layout_text:
    LEA     60(A3),A0
    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVE.W  _NEWGRID_ColumnWidthPx,D1
    MULU    #3,D1
    LEA     60(A3),A1
    MOVE.L  D0,16(A7)
    MOVE.L  D1,20(A7)
    MOVE.L  A0,12(A7)
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  20(A7),D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_x

    ADDQ.L  #1,D1

.center_x:
    ASR.L   #1,D1
    MOVE.L  16(A7),D0
    ADD.L   D1,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    MOVEA.L 112(A3),A0
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    MOVEQ   #34,D2
    SUB.L   D1,D2
    TST.L   D2
    BPL.S   .center_y

    ADDQ.L  #1,D2

.center_y:
    ASR.L   #1,D2
    MOVEQ   #0,D1
    MOVE.W  26(A0),D1
    ADD.L   D1,D2
    SUBQ.L  #1,D2
    MOVE.L  D2,D1
    MOVEA.L 12(A7),A1
    JSR     _LVOMove(A6)

    LEA     60(A3),A0
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVEA.L _GCOMMAND_PPVPeriodTemplatePtr,A0
    JSR     _LVOText(A6)

    MOVEQ   #17,D0
    MOVE.W  D0,52(A3)
    MOVEQ   #0,D1
    MOVE.W  D0,D1
    MOVE.L  D1,32(A3)
    PEA     68.W
    MOVE.L  A3,-(A7)
    BSR.W   _NEWGRID_ValidateSelectionCode

    MOVEM.L -24(A5),D2/D7/A3
    UNLK    A5
    RTS

;!======