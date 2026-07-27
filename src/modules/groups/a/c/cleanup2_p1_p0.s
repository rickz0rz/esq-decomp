    XDEF    CLEANUP_DrawBannerSpacerSegment
    XDEF    CLEANUP_DrawDateBannerSegment
    XDEF    CLEANUP_DrawDateTimeBannerRow
    XDEF    CLEANUP_DrawTimeBannerSegment
    XDEF    RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY


;------------------------------------------------------------------------------
; FUNC: RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY   (Routine at RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A1/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort, _GROUP_AE_JMPTBL_WDISP_SPrintf, _LVOMove, _LVORectFill, _LVOSetAPen, _LVOSetDrMd, _LVOText, _LVOTextLength
; READS:
;   _Global_JMPTBL_SHORT_DAYS_OF_WEEK, _Global_JMPTBL_SHORT_MONTHS, _Global_REF_696_400_BITMAP, Global_REF_GRAPHICS_LIBRARY, _Global_REF_RASTPORT_1, Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED, _CLOCK_CurrentDayOfWeekIndex, _CLOCK_CurrentMonthIndex, _CLOCK_CurrentDayOfMonth, fff7
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY:
;------------------------------------------------------------------------------
; FUNC: RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY   (RenderShortMonthShortDowDay)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   _GROUP_AE_JMPTBL_WDISP_SPrintf, _LVOSetAPen, _LVOSetDrMd, _LVORectFill,
;   _LVOTextLength, _LVOMove, _LVOText, _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   _CLOCK_CurrentDayOfWeekIndex, _CLOCK_CurrentMonthIndex, _CLOCK_CurrentDayOfMonth, _Global_JMPTBL_SHORT_DAYS_OF_WEEK,
;   _Global_JMPTBL_SHORT_MONTHS, Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED,
;   _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   Stack buffer at -32(A5)
; DESC:
;   Formats and renders "Mon Jan 1" style text in the banner area.
; NOTES:
;   - Centers the string based on measured text width.
;------------------------------------------------------------------------------
    LINK.W  A5,#-36
    MOVEM.L D2-D3/D5-D7,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)

    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _Global_JMPTBL_SHORT_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0

    MOVE.W  _CLOCK_CurrentMonthIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _Global_JMPTBL_SHORT_MONTHS,A1
    ADDA.L  D0,A1

    MOVE.W  _CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0

    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED
    PEA     -32(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetDrMd(A6)

    MOVEQ   #0,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #1,D0
    MOVEA.L A0,A1
    MOVE.L  D0,D3
    MOVEQ   #0,D0
    MOVE.L  D0,D1
    MOVEQ   #40,D2
    NOT.B   D2
    JSR     _LVORectFill(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #3,D0
    JSR     _LVOSetAPen(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.date_text_len_loop:
    TST.B   (A1)+
    BNE.S   .date_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D6
    MOVE.L  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_date_text_x

    ADDQ.L  #1,D0

.center_date_text_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,20(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  20(A7),D1
    JSR     _LVOMove(A6)

    MOVE.L  D6,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     -32(A5),A0
    JSR     _LVOText(A6)

    MOVEQ   #0,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D0
    SUBQ.L  #2,D0
    PEA     192.W
    MOVE.L  D0,-(A7)
    PEA     208.W
    PEA     40.W
    PEA     44.W
    MOVE.L  A0,-(A7)
    MOVEQ   #0,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

    MOVEM.L -56(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateBannerSegment   (DrawDateBannerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY,
;   _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the left banner segment containing the short date (day/month).
; NOTES:
;   - Temporarily swaps the rastport bitmap to _Global_REF_696_400_BITMAP.
;------------------------------------------------------------------------------
CLEANUP_DrawDateBannerSegment:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

.rastPortBitmap = -4

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  Struct_RastPort__BitMap(A0),.rastPortBitmap(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,Struct_RastPort__BitMap(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  Struct_RastPort__Flags(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,Struct_RastPort__Flags(A0)
    MOVEA.L A0,A1
    MOVEQ   #40,D0
    MOVEQ   #34,D1
    MOVEQ   #0,D2
    NOT.B   D2
    MOVEQ   #67,D3
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY

    PEA     67.W
    PEA     255.W
    PEA     34.W
    CLR.L   -(A7)
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  .rastPortBitmap(A5),Struct_RastPort__BitMap(A0)

    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawBannerSpacerSegment   (DrawBannerSpacerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears/draws the middle banner segment (no text).
;------------------------------------------------------------------------------
CLEANUP_DrawBannerSpacerSegment:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #256,D0
    MOVEQ   #34,D1
    MOVE.L  #447,D2
    MOVEQ   #67,D3
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    PEA     34.W
    PEA     256.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawTimeBannerSegment   (DrawTimeBannerSegmentuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, _CLEANUP_DrawGridTimeBanner, _BEVEL_DrawBevelFrameWithTopRight
; READS:
;   _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Draws the right banner segment containing the time string.
;------------------------------------------------------------------------------
CLEANUP_DrawTimeBannerSegment:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVE.L  #448,D0
    MOVEQ   #34,D1
    MOVE.L  #663,D2
    MOVEQ   #67,D3
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   _CLEANUP_DrawGridTimeBanner

    PEA     67.W
    PEA     695.W
    PEA     34.W
    PEA     448.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _BEVEL_DrawBevelFrameWithTopRight(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)
    MOVEM.L -12(A5),D2-D3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: CLEANUP_DrawDateTimeBannerRow   (DrawDateTimeBannerRowuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D3/A0-A1/A5-A6
; CALLS:
;   _LVOSetAPen, _LVORectFill, CLEANUP_DrawDateBannerSegment,
;   CLEANUP_DrawBannerSpacerSegment, CLEANUP_DrawTimeBannerSegment
; READS:
;   _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY, _Global_REF_696_400_BITMAP
; WRITES:
;   RastPort BitMap (temporary swap)
; DESC:
;   Clears the banner row and draws left date, middle spacer, and right time.
;------------------------------------------------------------------------------
CLEANUP_DrawDateTimeBannerRow:
    LINK.W  A5,#-4
    MOVEM.L D2-D3,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-4(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #7,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  32(A0),D0
    ANDI.W  #$fff7,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  D0,32(A0)
    MOVEA.L A0,A1
    MOVEQ   #0,D0
    MOVEQ   #34,D1
    MOVE.L  #695,D2
    MOVEQ   #67,D3
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVORectFill(A6)

    BSR.W   CLEANUP_DrawDateBannerSegment

    BSR.W   CLEANUP_DrawBannerSpacerSegment

    BSR.W   CLEANUP_DrawTimeBannerSegment

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -4(A5),4(A0)

    MOVEM.L (A7)+,D2-D3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
