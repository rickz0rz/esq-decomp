    XDEF    _DATETIME_FormatPairToStream

;------------------------------------------------------------------------------
; FUNC: _DATETIME_FormatPairToStream   (Dump time structs to streamuncertain)
; ARGS:
;   stack +8: D7 = stream/handle
;   stack +12: A3 = struct pair
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D6/D7
; CALLS:
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _GROUP_AI_JMPTBL_STRING_AppendAtNull, _GROUP_AG_JMPTBL_MATH_DivS32, _DISKIO_WriteBufferedBytes
; READS:
;   _DST_FMT_PCT_C_InTimePrefixChar.._DST_STR_NO_DST_DATA
; WRITES:
;   local buffer -87(A5)
; DESC:
;   Formats two optional time structs into text and writes to the stream.
; NOTES:
;   Uses local buffer with append helper.
;------------------------------------------------------------------------------
_DATETIME_FormatPairToStream:
    LINK.W  A5,#-140
    MOVEM.L D6-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    CLR.B   -87(A5)
    MOVE.L  A3,D0
    BEQ.W   .structs_missing

    MOVEA.L (A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   .first_missing

    PEA     4.W
    PEA     _DST_FMT_PCT_C_InTimePrefixChar
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     _DST_FMT_PCT_04D_PCT_03D_InTimeDateCode
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A0)
    BEQ.S   .no_am_pm_adjust

    MOVEQ   #12,D0
    BRA.S   .ampm_adjust_ready

.no_am_pm_adjust:
    MOVEQ   #0,D0

.ampm_adjust_ready:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DST_FMT_PCT_02D_COLON_PCT_02D_InTimeClock
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     24(A7),A7
    BRA.S   .after_first

.first_missing:
    PEA     _DST_STR_NO_IN_TIME
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.after_first:
    MOVEA.L 4(A3),A0
    MOVE.L  A0,-4(A5)
    MOVE.L  A0,D0
    BEQ.W   .second_missing

    PEA     19.W
    PEA     _DST_FMT_PCT_C_OutTimePrefixChar
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  6(A0),D0
    EXT.L   D0
    MOVE.W  16(A0),D1
    EXT.L   D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     _DST_FMT_PCT_04D_PCT_03D_OutTimeDateCode
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     40(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.W  8(A0),D0
    EXT.L   D0
    MOVEQ   #12,D1
    JSR     _GROUP_AG_JMPTBL_MATH_DivS32(PC)

    TST.W   18(A0)
    BEQ.S   .no_am_pm_adjust_2

    MOVEQ   #12,D0
    BRA.S   .ampm_adjust_ready_2

.no_am_pm_adjust_2:
    MOVEQ   #0,D0

.ampm_adjust_ready_2:
    ADD.L   D0,D1
    MOVE.L  D1,D6
    MOVE.L  D6,D0
    EXT.L   D0
    MOVE.W  10(A0),D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _DST_FMT_PCT_02D_COLON_PCT_02D_OutTimeClock
    PEA     -138(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -138(A5)
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     24(A7),A7
    BRA.S   .emit_buffer

.second_missing:
    PEA     _DST_STR_NO_OUT_TIME
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7
    BRA.S   .emit_buffer

.structs_missing:
    PEA     _DST_STR_NO_DST_DATA
    PEA     -87(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    ADDQ.W  #8,A7

.emit_buffer:
    LEA     -87(A5),A0
    MOVEA.L A0,A1

.count_buffer_len:
    TST.B   (A1)+
    BNE.S   .count_buffer_len

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _DISKIO_WriteBufferedBytes(PC)

    MOVEM.L -152(A5),D6-D7/A3
    UNLK    A5
    RTS

;!======