    XDEF    _CLEANUP_DrawGridTimeBanner



;------------------------------------------------------------------------------
; FUNC: _CLEANUP_DrawGridTimeBanner   (DrawGridTimeBanneruncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1/A5-A6
; CALLS:
;   _ESQ_FormatTimeStamp, _LVOSetAPen, _LVOSetDrMd, _LVORectFill, _LVOTextLength,
;   _LVOMove, _LVOText, _GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat, _GROUP_AE_JMPTBL_WDISP_SPrintf,
;   _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort
; READS:
;   _CLOCK_CurrentDayOfWeekIndex, _Global_REF_RASTPORT_1, Global_REF_GRAPHICS_LIBRARY,
;   _Global_REF_STR_USE_24_HR_CLOCK, _Global_WORD_CURRENT_HOUR, _CLOCK_CurrentAmPmFlag,
;   _Global_WORD_CURRENT_MINUTE, _Global_WORD_CURRENT_SECOND,
;   _Global_STR_GRID_TIME_FORMAT_DUPLICATE, _Global_STR_12_44_44_SINGLE_SPACE,
;   _Global_STR_12_44_44_PM
; WRITES:
;   Stack buffers at -32(A5) and -23(A5)
; DESC:
;   Formats and renders the time banner into the main rastport, centered
;   based on measured text widths.
; NOTES:
;   - Draws an extra AM/PM suffix when using 12-hour format.
;------------------------------------------------------------------------------
_CLEANUP_DrawGridTimeBanner:
    LINK.W  A5,#-40
    MOVEM.L D2-D7,-(A7)
    MOVEQ   #0,D5
    PEA     _CLOCK_CurrentDayOfWeekIndex
    PEA     -32(A5)
    JSR     _ESQ_FormatTimeStamp(PC)

    ADDQ.W  #8,A7
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

    MOVE.B  -23(A5),D4
    CLR.B   -23(A5)
    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .measure_sample_width

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
    PEA     _Global_STR_GRID_TIME_FORMAT_DUPLICATE
    PEA     -32(A5)
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7

.measure_sample_width:
    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _Global_STR_12_44_44_SINGLE_SPACE,A0
    MOVEQ   #9,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D6

    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .no_ampm_suffix

    MOVEA.L _Global_REF_RASTPORT_1,A1
    LEA     _Global_STR_12_44_44_PM,A0
    MOVEQ   #11,D0
    JSR     _LVOTextLength(A6)

    MOVE.L  D0,D5

    BRA.S   .center_time_text

.no_ampm_suffix:
    MOVE.L  D6,D5

.center_time_text:
    MOVEQ   #108,D0
    ADD.L   D0,D0
    SUB.L   D5,D0
    TST.L   D0
    BPL.S   .center_time_x

    ADDQ.L  #1,D0

.center_time_x:
    ASR.L   #1,D0
    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D0
    MOVE.L  D0,24(A7)
    MOVEA.L A0,A1
    MOVE.L  D7,D0
    MOVE.L  24(A7),D1
    JSR     _LVOMove(A6)

    LEA     -32(A5),A0
    MOVEA.L A0,A1

.time_text_len_loop:
    TST.B   (A1)+
    BNE.S   .time_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

    MOVE.B  _Global_REF_STR_USE_24_HR_CLOCK,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BNE.S   .done

    MOVE.B  D4,-23(A5)
    MOVE.L  D7,D0
    ADD.L   D6,D0
    MOVEQ   #0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  62(A0),D1
    MOVEA.L A0,A1
    JSR     _LVOMove(A6)

    LEA     -23(A5),A0
    MOVEA.L A0,A1

.ampm_text_len_loop:
    TST.B   (A1)+
    BNE.S   .ampm_text_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,D0
    MOVEA.L _Global_REF_RASTPORT_1,A1
    JSR     _LVOText(A6)

.done:
    MOVE.L  D7,D0
    ADDI.L  #448,D0
    MOVEQ   #0,D1
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.W  58(A0),D1
    SUBQ.L  #2,D1
    PEA     192.W
    MOVE.L  D1,-(A7)
    MOVE.L  D5,-(A7)
    PEA     40.W
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-(A7)
    CLR.L   -(A7)
    MOVE.L  D7,-(A7)
    MOVE.L  4(A0),-(A7)
    JSR     _GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(PC)

    MOVEM.L -64(A5),D2-D7
    UNLK    A5
    RTS

;!======