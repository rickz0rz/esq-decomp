    XDEF    _CLEANUP_DrawClockBanner


;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawClockBanner   (DrawClockBanner)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat, _GROUP_AE_JMPTBL_WDISP_SPrintf, _LVOSetAPen,
;   _LVORectFill, _LVOMove, _LVOText, _BEVEL_DrawBevelFrameWithTopRight, _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   _Global_UIBusyFlag, _Global_REF_STR_USE_24_HR_CLOCK, _Global_WORD_CURRENT_HOUR,
;   _CLOCK_CurrentAmPmFlag, _Global_WORD_CURRENT_MINUTE, _Global_WORD_CURRENT_SECOND,
;   _Global_STR_EXTRA_TIME_FORMAT, _Global_STR_GRID_TIME_FORMAT,
;   _NEWGRID_MainRastPortPtr, _NEWGRID_ColumnStartXPx, _Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -10(A5)
; DESC:
;   Formats the current time string and renders it into the top banner area.
; NOTES:
;   - Centers the rendered time based on the font metrics.
;------------------------------------------------------------------------------
; Render the top-of-screen clock/banner text.
_CLEANUP_DrawClockBanner:
    LINK.W  A5,#-12
    MOVEM.L D2-D3,-(A7)
    TST.W   _Global_UIBusyFlag
    BNE.W   .done

    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .format_grid_time

    MOVE.W  _Global_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CurrentAmPmFlag,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     _GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(PC)

    MOVE.W  _Global_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  _Global_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_EXTRA_TIME_FORMAT
    PEA     -10(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    BRA.S   .draw_banner

.format_grid_time:
    MOVE.W  _Global_WORD_CURRENT_HOUR,D0
    EXT.L   D0
    MOVE.W  _Global_WORD_CURRENT_MINUTE,D1
    EXT.L   D1
    MOVE.W  _Global_WORD_CURRENT_SECOND,D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_GRID_TIME_FORMAT
    PEA     -10(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7

.draw_banner:
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #7,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #35,D2
    MOVEQ   #33,D3
    JSR     _LVORectFill(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #7,D0
    JSR     _LVOSetAPen(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    ADD.L   D2,D0
    MOVE.L  D0,D2
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #36,D0
    MOVEQ   #0,D1
    JSR     _LVORectFill(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #35,D1
    ADD.L   D1,D0
    MOVE.L  D3,-(A7)
    MOVE.L  D0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEA.L 52(A1),A0
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    MOVEQ   #34,D1
    SUB.L   D0,D1
    TST.L   D1
    BPL.S   .center_text_y

    ADDQ.L  #1,D1

.center_text_y:
    ASR.L   #1,D1
    MOVEQ   #0,D0
    MOVE.W  26(A0),D0
    ADD.L   D0,D1
    SUBQ.L  #1,D1
    MOVEQ   #44,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOMove(A6)

    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    MOVEQ   #1,D0
    JSR     _LVOSetAPen(A6)

    LEA     -10(A5),A0

    MOVEA.L A0,A1

.measure_text_loop:
    TST.B   (A1)+
    BNE.S   .measure_text_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L _NEWGRID_MainRastPortPtr,A1
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVE.W  _NEWGRID_ColumnStartXPx,D0
    MOVEQ   #36,D1
    ADD.L   D1,D0
    PEA     192.W
    MOVEQ   #34,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  _NEWGRID_MainRastPortPtr,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVEA.L _NEWGRID_MainRastPortPtr,A0
    MOVE.L  4(A0),-(A7)
    JSR     _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

.done:
    MOVEM.L -20(A5),D2-D3
    UNLK    A5
    RTS

;!======