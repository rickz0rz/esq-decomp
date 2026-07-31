    XDEF    _TLIBA1_FormatClockFormatEntry


;------------------------------------------------------------------------------
; FUNC: _TLIBA1_FormatClockFormatEntry   (Compose TLFORMAT metadata + values into output text)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +16: arg_4 (via 20(A5))
;   stack +20: arg_5 (via 24(A5))
;   stack +24: arg_6 (via 28(A5))
;   stack +30: arg_7 (via 34(A5))
;   stack +528: arg_8 (via 532(A5))
;   stack +534: arg_9 (via 538(A5))
;   stack +538: arg_10 (via 542(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D5/D6/D7
; CALLS:
;   _FORMAT_RawDoFmtWithScratchBuffer, _STRING_AppendAtNull, _WDISP_SPrintf
; READS:
;   _TEXTDISP_FormatEntryFallbackTable, _TLIBA1_FormatFallbackBuffer, _TLIBA1_FormatFallbackFieldPtr0, _TLIBA1_FormatFallbackFieldPtr1, _TLIBA1_FormatFallbackFieldPtr2, _TLIBA1_FormatFallbackFieldPtr3, _TLIBA1_FMT_PCT_C_PCT_S, _TLIBA1_FMT_STRUCT_TLFORMAT_0X_PCT_X, _TLIBA1_STR_TLFormatStructOpenBraceLine, _TLIBA1_FMT_TLF_COLOR_PCT_D, _TLIBA1_FMT_TLF_OFFSET_PCT_D, _TLIBA1_FMT_TLF_FONTSEL_PCT_D, _TLIBA1_FMT_TLF_ALIGN_PCT_D, _TLIBA1_FMT_TLF_PREGAP_PCT_D, _TLIBA1_STR_TLFormatStructCloseBraceLine, _WDISP_CharClassTable, copy_loop
; WRITES:
;   (none observed)
; DESC:
;   Builds a formatted output string by combining template fragments and current
;   TLFORMAT/value fields, appending each fragment into destination buffer.
; NOTES:
;   Falls back to module default field strings when optional pointers are null.
;------------------------------------------------------------------------------
_TLIBA1_FormatClockFormatEntry:
    LINK.W  A5,#-544
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.W  34(A5),D7
    LEA     _TLIBA1_FormatFallbackBuffer,A0
    LEA     -532(A5),A1
    MOVE.W  #$1ff,D0
; This is weird, it's purposefully one byte back
; so that it can start the loop as if it's doing a
; do/while loop.
.copy_loop:
    MOVE.B  (A0)+,(A1)+
    DBF     D0,.copy_loop
    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B3

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B4

.if_eq_17B3:
    MOVEQ   #65,D0

.skip_17B4:
    LEA     _WDISP_CharClassTable,A0
    ADDA.L  D0,A0
    BTST    #1,(A0)
    BEQ.S   .if_eq_17B7

    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B5

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B6

.if_eq_17B5:
    MOVEQ   #65,D0

.skip_17B6:
    MOVEQ   #32,D1
    SUB.L   D1,D0
    BRA.S   .skip_17B9

.if_eq_17B7:
    MOVE.L  A2,D0
    BEQ.S   .if_eq_17B8

    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    BRA.S   .skip_17B9

.if_eq_17B8:
    MOVEQ   #65,D0

.skip_17B9:
    MOVE.L  D0,D6
    MOVE.L  D6,D0
    SUBI.B  #$41,D0
    MOVE.L  D0,D5
    ADDQ.B  #1,D5
    TST.W   D7
    BNE.S   .branch_17BA

    MOVEQ   #0,D0
    CMP.B   D0,D5
    BCS.S   .branch_17BA

    MOVEQ   #2,D1
    CMP.B   D1,D5
    BCC.S   .branch_17BA

    MOVEQ   #0,D1
    MOVE.B  D5,D1
    MOVE.L  D1,D2
    EXT.L   D2
    ASL.L   #2,D2
    LEA     _TEXTDISP_FormatEntryFallbackTable,A0
    ADDA.L  D2,A0
    MOVE.L  (A0),-4(A5)
    BRA.S   .skip_17BB

.branch_17BA:
    MOVE.L  _TEXTDISP_FormatEntryFallbackTable,-4(A5)

.skip_17BB:
    TST.L   28(A5)
    BEQ.S   .if_eq_17BC

    MOVEA.L 28(A5),A0
    BRA.S   .skip_17BD

.if_eq_17BC:
    LEA     _TLIBA1_FormatFallbackFieldPtr0,A0

.skip_17BD:
    MOVE.L  A0,-20(A5)
    TST.L   16(A5)
    BEQ.S   .if_eq_17BE

    MOVEA.L 16(A5),A0
    BRA.S   .skip_17BF

.if_eq_17BE:
    LEA     _TLIBA1_FormatFallbackFieldPtr1,A0

.skip_17BF:
    MOVE.L  A0,-16(A5)
    TST.L   24(A5)
    BEQ.S   .if_eq_17C0

    MOVEA.L 24(A5),A0
    BRA.S   .skip_17C1

.if_eq_17C0:
    LEA     _TLIBA1_FormatFallbackFieldPtr2,A0

.skip_17C1:
    MOVE.L  A0,-12(A5)
    TST.L   20(A5)
    BEQ.S   .if_eq_17C2

    MOVEA.L 20(A5),A0
    BRA.S   .skip_17C3

.if_eq_17C2:
    LEA     _TLIBA1_FormatFallbackFieldPtr3,A0

.skip_17C3:
    MOVE.L  A0,-8(A5)
    CLR.B   (A3)
    CLR.L   -538(A5)

.loop_17C4:
    MOVE.L  -538(A5),D0
    MOVEQ   #4,D1
    CMP.L   D1,D0
    BGE.S   .return_17C8

    ASL.L   #2,D0
    MOVEA.L -20(A5,D0.L),A0

.if_ne_17C5:
    TST.B   (A0)+
    BNE.S   .if_ne_17C5

    SUBQ.L  #1,A0
    SUBA.L  -20(A5,D0.L),A0
    MOVE.L  A0,-542(A5)
    BLE.S   .branch_17C7

    MOVE.L  A0,D0
    CMPI.L  #$200,D0
    BGE.S   .branch_17C7

    MOVEA.L A3,A0

.if_ne_17C6:
    TST.B   (A0)+
    BNE.S   .if_ne_17C6

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D1
    ADD.L   D1,D0
    CMPI.L  #$200,D0
    BGE.S   .branch_17C7

    CLR.B   -532(A5)
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.L  -538(A5),D1
    MOVE.B  0(A0,D1.L),D0
    ASL.L   #2,D1
    MOVE.L  -20(A5,D1.L),-(A7)
    MOVE.L  D0,-(A7)
    PEA     _TLIBA1_FMT_PCT_C_PCT_S
    PEA     -532(A5)
    JSR     _WDISP_SPrintf(PC)

    PEA     -532(A5)
    MOVE.L  A3,-(A7)
    JSR     _STRING_AppendAtNull(PC)

    LEA     24(A7),A7

.branch_17C7:
    ADDQ.L  #1,-538(A5)
    BRA.S   .loop_17C4

.return_17C8:
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======