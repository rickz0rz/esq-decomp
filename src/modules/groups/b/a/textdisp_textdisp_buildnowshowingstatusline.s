    XDEF    _TEXTDISP_BuildNowShowingStatusLine


;------------------------------------------------------------------------------
; FUNC: _TEXTDISP_BuildNowShowingStatusLine   (Build aligned "Now Showing" line)
; ARGS:
;   stack +10: mode (word, 1/2)
;   stack +14: groupIndex (word)
;   stack +18: entryIndex (word)
; RET:
;   none
; CLOBBERS:
;   D0-D3/A0-A1
; CALLS:
;   _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode, _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode, _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow,
;   _TEXTDISP_FormatEntryTimeForIndex, _STR_SkipClass3Chars, _STRING_AppendAtNull, _TEXTDISP_FindControlToken,
;   _TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine, _SCRIPT_SetupHighlightEffect
; READS:
;   _TEXTDISP_PrimaryChannelCode, _CLOCK_CurrentDayOfWeekIndex, _TEXTDISP_BannerFallbackIsSpecialFlag/_TEXTDISP_BannerCharSelected/_TEXTDISP_BannerSelectedIsSpecialFlag, _P_TYPE_WeatherBottomLineMsgPtr
; WRITES:
;   _TEXTDISP_PrimaryChannelCode
; DESC:
;   Builds an aligned status string for the current channel/entry (\"Now Showing\"),
;   then hands it to the aligned status line renderer; falls back to external text.
; NOTES:
;   Uses stack buffers for string assembly:
;   - -137(A5): final aligned-line payload
;   - -188(A5): temporary formatter scratch (51-byte non-overlap window before -137)
;------------------------------------------------------------------------------
_TEXTDISP_BuildNowShowingStatusLine:
    LINK.W  A5,#-216
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6
    MOVE.W  18(A5),D5
    CLR.L   -196(A5)
    MOVEQ   #1,D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-216(A5)
    TST.W   D7
    BNE.S   .after_table_kind

    MOVEQ   #2,D0

.after_table_kind:
    MOVE.L  D0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryAuxPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D1
    EXT.L   D1
    MOVEM.L D0,-4(A5)
    TST.W   D7
    BEQ.S   .use_kind_2

    MOVEQ   #1,D2
    BRA.S   .dispatch_kind

.use_kind_2:
    MOVEQ   #2,D2

.dispatch_kind:
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    JSR     _TLIBA1_JMPTBL_ESQDISP_GetEntryPointerByMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    TST.L   D0
    BEQ.W   .append_external_line

    TST.L   -4(A5)
    BEQ.W   .append_external_line

    MOVE.W  _TEXTDISP_PrimaryChannelCode,D1
    BNE.S   .ensure_default_channel

    MOVEQ   #48,D2
    MOVE.W  D2,_TEXTDISP_PrimaryChannelCode

.ensure_default_channel:
    CLR.B   -137(A5)
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D1
    MOVEQ   #48,D2
    CMP.W   D2,D1
    BLT.S   .check_channel_range_alt

    MOVEQ   #67,D2
    CMP.W   D2,D1
    BLE.S   .check_channel_enabled

.check_channel_range_alt:
    MOVEQ   #72,D2
    CMP.W   D2,D1
    BLT.S   .channel_not_enabled

    MOVEQ   #77,D2
    CMP.W   D2,D1
    BGT.S   .channel_not_enabled

.check_channel_enabled:
    EXT.L   D1
    LEA     _Global_STR_TEXTDISP_C_3,A0
    ADDA.L  D1,A0
    MOVE.W  _CLOCK_CurrentDayOfWeekIndex,D1
    EXT.L   D1
    MOVEQ   #1,D2
    ASL.L   D1,D2
    MOVEQ   #0,D1
    MOVE.B  (A0),D1
    AND.L   D2,D1
    TST.L   D1
    BEQ.S   .channel_not_enabled

    MOVEQ   #1,D2
    BRA.S   .store_channel_enabled

.channel_not_enabled:
    MOVEQ   #0,D2

.store_channel_enabled:
    MOVE.L  D2,-212(A5)
    BEQ.W   .fallback_channel_line

    TST.W   D5
    BLE.W   .fallback_channel_line

    MOVEQ   #49,D1
    CMP.W   D1,D5
    BGE.W   .fallback_channel_line

    MOVE.L  D5,D1
    EXT.L   D1
    MOVE.L  _CONFIG_TimeWindowMinutes,-(A7)
    PEA     1440.W
    MOVE.L  D1,-(A7)
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    JSR     _TLIBA1_JMPTBL_COI_TestEntryWithinTimeWindow(PC)

    LEA     20(A7),A7
    TST.L   D0
    BEQ.W   .fallback_channel_line

    MOVE.B  _TEXTDISP_BannerCharSelected,D0
    MOVEQ   #100,D1
    CMP.B   D1,D0
    BEQ.S   .use_channel_digit

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_BannerSelectedIsSpecialFlag,D0
    BRA.S   .store_channel_char

.use_channel_digit:
    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_BannerFallbackIsSpecialFlag,D0

.store_channel_char:
    MOVE.L  D0,-200(A5)
    SUBQ.L  #1,D0
    BNE.S   .build_entry_title

    LEA     _Global_STR_ALIGNED_NOW_SHOWING,A0
    LEA     -188(A5),A1

.copy_now_showing:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_now_showing

    LEA     -188(A5),A0
    MOVE.L  A0,-192(A5)
    BRA.S   .append_center_prefix

.build_entry_title:
    MOVE.L  D5,D0
    EXT.L   D0
    MOVE.L  -4(A5),-(A7)
    MOVE.L  D0,-(A7)
    PEA     -188(A5)
    JSR     _TEXTDISP_FormatEntryTimeForIndex(PC)

    PEA     -188(A5)
    JSR     _STR_SkipClass3Chars(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-192(A5)

.append_center_prefix:
    LEA     _SCRIPT_AlignedPrefixEmptyA,A0
    LEA     -137(A5),A1

.copy_center_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_center_prefix

    MOVE.L  -192(A5),-(A7)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    MOVE.L  D5,D0
    EXT.L   D0
    ASL.L   #2,D0
    MOVEA.L -4(A5),A0
    MOVE.L  56(A0,D0.L),(A7)
    JSR     _TEXTDISP_FindControlToken(PC)

    ADDQ.W  #8,A7
    CLR.L   -216(A5)
    MOVE.L  D0,-196(A5)
    BRA.S   .build_program_title

.fallback_channel_line:
    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    MOVEQ   #48,D1
    CMP.W   D1,D0
    BLE.S   .check_channel_range_primary

    MOVEQ   #67,D1
    CMP.W   D1,D0
    BLE.S   .append_channel_name

.check_channel_range_primary:
    MOVEQ   #72,D1
    CMP.W   D1,D0
    BLT.S   .build_program_title

    MOVEQ   #77,D1
    CMP.W   D1,D0
    BGT.S   .build_program_title

.append_channel_name:
    LEA     _SCRIPT_AlignedPrefixEmptyB,A0
    LEA     -137(A5),A1

.copy_channel_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_channel_prefix

    MOVE.W  _TEXTDISP_PrimaryChannelCode,D0
    MOVE.L  D0,D1
    EXT.L   D1
    ASL.L   #2,D1
    ; Layout-coupled table anchor: legacy code indexes longword pointers from
    ; _SCRIPT_StrChannelLabel_TuesdaysFridays + 2.
    LEA     (_SCRIPT_StrChannelLabel_TuesdaysFridays+2),A0
    ADDA.L  D1,A0
    MOVE.L  (A0),-(A7)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    PEA     _TEXTDISP_PrimarySearchText
    JSR     _TEXTDISP_FindControlToken(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D1
    MOVE.L  D0,-196(A5)
    MOVE.L  D1,-216(A5)

.build_program_title:
    TST.L   -216(A5)
    BNE.W   .render_output

    MOVEQ   #0,D0
    MOVE.L  D0,-204(A5)
    MOVE.L  D0,-208(A5)

.copy_program_loop:
    MOVEA.L -8(A5),A0
    MOVE.L  -204(A5),D0
    TST.B   1(A0,D0.L)
    BEQ.S   .finalize_program_title

    MOVEQ   #32,D1
    CMP.B   1(A0,D0.L),D1
    BEQ.S   .skip_program_space

    LEA     -188(A5),A1
    ADDA.L  -208(A5),A1
    ADDQ.L  #1,-208(A5)
    MOVE.B  1(A0,D0.L),(A1)

.skip_program_space:
    ADDQ.L  #1,-204(A5)
    BRA.S   .copy_program_loop

.finalize_program_title:
    LEA     -188(A5),A0
    ADDA.L  -208(A5),A0
    MOVEQ   #0,D0
    MOVE.B  D0,(A0)
    MOVE.B  -188(A5),D1
    TST.B   D1
    BEQ.S   .append_time_suffix

    MOVE.B  -137(A5),D1
    TST.B   D1
    BEQ.S   .append_channel_label

    PEA     _SCRIPT_SpacerTripleA
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_channel_label:
    PEA     _SCRIPT_AlignedChannelAbbrevPrefix
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    LEA     16(A7),A7

.append_time_suffix:
    TST.L   -196(A5)
    BEQ.S   .emit_aligned_line

    MOVE.B  -137(A5),D0
    TST.B   D0
    BEQ.S   .append_time_prefix

    PEA     _SCRIPT_SpacerTripleB
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.append_time_prefix:
    MOVEQ   #0,D0
    MOVEA.L -196(A5),A0
    MOVE.B  (A0),D0
    MOVE.L  D0,-(A7)
    PEA     _SCRIPT_AlignedCharFormat
    ; Format here is "%c" (+ alignment token), so -188(A5) remains short.
    PEA     -188(A5)
    JSR     _WDISP_SPrintf(PC)

    PEA     -188(A5)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    LEA     20(A7),A7

.emit_aligned_line:
    MOVE.L  D7,D0
    EXT.L   D0
    MOVE.L  D6,D1
    EXT.L   D1
    MOVE.L  D5,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.L  D3,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     -137(A5)
    JSR     _TEXTDISP_JMPTBL_CLEANUP_BuildAlignedStatusLine(PC)

    LEA     24(A7),A7
    BRA.S   .render_output

.append_external_line:
    TST.L   _P_TYPE_WeatherBottomLineMsgPtr
    BEQ.S   .clear_output

    MOVEA.L _P_TYPE_WeatherBottomLineMsgPtr,A0
    TST.B   (A0)
    BEQ.S   .clear_output

    LEA     _SCRIPT_AlignedPrefixEmptyC,A0
    LEA     -137(A5),A1

.copy_external_prefix:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_external_prefix

    MOVE.L  _P_TYPE_WeatherBottomLineMsgPtr,-(A7)
    PEA     -137(A5)
    JSR     _STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .render_output

.clear_output:
    CLR.B   -137(A5)

.render_output:
    PEA     -137(A5)
    BSR.W   _SCRIPT_SetupHighlightEffect

    MOVEM.L -236(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======