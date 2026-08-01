    XDEF    _ED_DrawCurrentColorIndicator


;------------------------------------------------------------------------------
; FUNC: _ED_DrawCurrentColorIndicator   (Draw current color indicatoruncertain)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +37: arg_2 (via 41(A5))
;   stack +56: arg_3 (via 60(A5))
; RET:
;   (none)
; CLOBBERS:
;   A1/A6/A7/D0/D1/D2/D3/D6/D7
; CALLS:
;   _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble, _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _DISPLIB_DisplayTextAtPosition, _LVOSetAPen, _LVOSetBPen, _LVORectFill
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Draws the current color swatch and formatted label.
; NOTES:
;   Local color-label buffer is 41 bytes (-41(A5)..-1(A5)).
;------------------------------------------------------------------------------
_ED_DrawCurrentColorIndicator:

.colorLabel = -41

    LINK.W  A5,#-44
    MOVEM.L D2-D3/D6-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractHighNibble(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #102,D0
    ADD.L   D0,D0
    MOVEQ   #125,D1
    ADD.L   D1,D1
    MOVE.L  #474,D2
    MOVE.L  #275,D3
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    JSR     _GROUP_AL_JMPTBL_LADFUNC_ExtractLowNibble(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOSetBPen(A6)

    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,(A7)
    PEA     _Global_STR_CURRENT_COLOR_FORMATTED
    PEA     .colorLabel(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .colorLabel(A5)
    PEA     272.W
    PEA     205.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #2,D0
    JSR     _LVOSetBPen(A6)

    MOVEM.L -60(A5),D2-D3/D6-D7
    UNLK    A5
    RTS

;!======