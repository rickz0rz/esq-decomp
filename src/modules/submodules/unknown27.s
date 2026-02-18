    XDEF    FORMAT_Buffer2WriteChar
    XDEF    FORMAT_FormatToBuffer2
    XDEF    FORMAT_ParseFormatSpec

;------------------------------------------------------------------------------
; FUNC: FORMAT_Buffer2WriteChar   (Append a byte to format buffer #2.)
; ARGS:
;   stack +8: D7 = byte to append
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D7/A0
; READS:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
; WRITES:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
;------------------------------------------------------------------------------
FORMAT_Buffer2WriteChar:
    MOVE.L  D7,-(A7)

    MOVE.L  8(A7),D7
    ADDQ.L  #1,Global_FormatByteCount2(A4)
    MOVE.L  D7,D0
    MOVEA.L Global_FormatBufferPtr2(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,Global_FormatBufferPtr2(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: FORMAT_FormatToBuffer2   (Format string into buffer #2.)
; ARGS:
;   stack +16: A3 = output buffer
;   stack +20: A2 = format string
;   stack +24: varargs pointer
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0/A0-A3
; CALLS:
;   WDISP_FormatWithCallback, FORMAT_Buffer2WriteChar
; WRITES:
;   Global_FormatBufferPtr2, Global_FormatByteCount2
;------------------------------------------------------------------------------
FORMAT_FormatToBuffer2:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)

    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   Global_FormatByteCount2(A4)
    MOVE.L  A3,Global_FormatBufferPtr2(A4)
    MOVE.L  16(A5),-(A7)
    MOVE.L  A2,-(A7)
    PEA     FORMAT_Buffer2WriteChar(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVEA.L Global_FormatBufferPtr2(A4),A0
    CLR.B   (A0)
    MOVE.L  Global_FormatByteCount2(A4),D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

; More core printf logic
;------------------------------------------------------------------------------
; FUNC: FORMAT_ParseFormatSpec   (Core printf format parser.)
; ARGS:
;   stack +92: A3 = format string pointer
;   stack +96: A2 = varargs pointer
; RET:
;   D0: pointer into format string after spec (or 0 on failure)
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   PARSE_ReadSignedLong_NoBranch, FORMAT_U32ToHexString, FORMAT_U32ToDecimalString, FORMAT_U32ToOctalString, etc.
; DESC:
;   Parses flags/width/precision/length and emits formatted output via callback.
; NOTES:
;   Large routine; refine labels as needed when deeper analysis is done.
;------------------------------------------------------------------------------
FORMAT_ParseFormatSpec:
    LINK.W  A5,#-60
    MOVEM.L D2/D5-D7/A2-A3,-(A7)
    MOVEA.L 92(A7),A3
    MOVEA.L 96(A7),A2

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVEQ   #0,D5
    MOVEQ   #0,D0
    MOVE.B  #$20,-5(A5)
    MOVEQ   #0,D1
    MOVE.L  D1,-10(A5)
    MOVEQ   #-1,D2
    MOVE.L  D2,-14(A5)
    LEA     -48(A5),A0
    MOVE.B  D0,-15(A5)
    MOVE.B  D0,-4(A5)
    MOVE.L  D1,-28(A5)
    MOVE.L  D1,-24(A5)
    MOVE.L  A0,-52(A5)

.parse_flags:
    TST.B   (A3)
    BEQ.S   .check_zero_pad

    MOVEQ   #0,D0
    MOVE.B  (A3),D0
    SUBI.W  #' ',D0
    BEQ.S   .flag_space

    SUBQ.W  #3,D0
    BEQ.S   .flag_alt

    SUBQ.W  #8,D0
    BEQ.S   .flag_plus

    SUBQ.W  #2,D0
    BNE.S   .check_zero_pad

    MOVEQ   #1,D7
    BRA.S   .advance_flag

.flag_plus:
    MOVEQ   #1,D6
    BRA.S   .advance_flag

.flag_space:
    MOVEQ   #1,D5
    BRA.S   .advance_flag

.flag_alt:
    MOVE.B  #$1,-4(A5)

.advance_flag:
    ADDQ.L  #1,A3
    BRA.S   .parse_flags

.check_zero_pad:
    MOVE.B  (A3),D0
    MOVEQ   #'0',D1
    CMP.B   D1,D0
    BNE.S   .parse_width

    ADDQ.L  #1,A3
    MOVE.B  D1,-5(A5)

.parse_width:
    MOVEQ   #'*',D0
    CMP.B   (A3),D0
    BNE.S   .parse_width_from_str

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),-10(A5)
    ADDQ.L  #1,A3
    BRA.S   .parse_precision

.parse_width_from_str:
    PEA     -10(A5)
    MOVE.L  A3,-(A7)
    JSR     PARSE_ReadSignedLong_NoBranch(PC)

    ADDQ.W  #8,A7
    ADDA.L  D0,A3

.parse_precision:
    MOVE.B  (A3),D0
    MOVEQ   #'.',D1
    CMP.B   D1,D0
    BNE.S   .parse_length

    ADDQ.L  #1,A3
    MOVEQ   #'*',D0
    CMP.B   (A3),D0
    BNE.S   .parse_precision_from_str

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),-14(A5)
    ADDQ.L  #1,A3
    BRA.S   .parse_length

.parse_precision_from_str:
    PEA     -14(A5)
    MOVE.L  A3,-(A7)
    JSR     PARSE_ReadSignedLong_NoBranch(PC)

    ADDQ.W  #8,A7
    ADDA.L  D0,A3

.parse_length:
    MOVE.B  (A3),D0
    MOVEQ   #'l',D1
    CMP.B   D1,D0
    BNE.S   .length_h

    MOVE.B  #$1,-15(A5)
    ADDQ.L  #1,A3
    BRA.S   .dispatch_conv

.length_h:
    MOVEQ   #104,D1
    CMP.B   D1,D0

    BNE.S   .dispatch_conv

    ADDQ.L  #1,A3

.dispatch_conv:
    MOVE.B  (A3)+,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-16(A5)
    SUBI.W  #$58,D1
    BEQ.W   .conv_hex_long

    SUBI.W  #11,D1
    BEQ.W   .conv_char

    SUBQ.W  #1,D1
    BEQ.S   .conv_signed

    SUBI.W  #11,D1
    BEQ.W   .conv_octal

    SUBQ.W  #1,D1
    BEQ.W   .conv_hex

    SUBQ.W  #3,D1
    BEQ.W   .conv_string

    SUBQ.W  #2,D1
    BEQ.W   .conv_unsigned

    SUBQ.W  #3,D1
    BEQ.W   .conv_hex_long

    BRA.W   .conv_invalid

.conv_signed:
    TST.B   -15(A5)
    BEQ.S   .conv_signed_long

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .conv_signed_done

.conv_signed_long:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.conv_signed_done:
    MOVE.L  D0,-20(A5)
    BGE.S   .conv_signed_setsign

    MOVEQ   #1,D1
    NEG.L   -20(A5)
    MOVE.L  D1,-24(A5)

.conv_signed_setsign:
    TST.L   -24(A5)
    BEQ.S   .choose_prefix

    MOVEQ   #'-',D0
    BRA.S   .prefix_ready

.choose_prefix:
    TST.B   D6
    BEQ.S   .prefix_plus_or_space

    MOVEQ   #'+',D0
    BRA.S   .prefix_ready

.prefix_plus_or_space:
    MOVEQ   #32,D0

.prefix_ready:
    MOVE.B  D0,-48(A5)
    MOVEQ   #0,D0
    MOVE.B  D6,D0
    MOVE.L  -24(A5),D1
    OR.L    D0,D1
    MOVEQ   #0,D0
    MOVE.B  D5,D0
    OR.L    D0,D1
    BEQ.S   .format_decimal

    ADDQ.L  #1,-52(A5)
    ADDQ.L  #1,-28(A5)

.format_decimal:
    MOVE.L  -20(A5),-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     FORMAT_U32ToDecimalString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)

.apply_precision:
    MOVE.L  -14(A5),D0
    TST.L   D0
    BPL.S   .precision_normalize

    MOVEQ   #1,D1
    MOVE.L  D1,-14(A5)

.precision_normalize:
    MOVE.L  -56(A5),D0
    MOVE.L  -14(A5),D1
    SUB.L   D0,D1
    MOVEM.L D1,-60(A5)
    BLE.S   .emit_decimal_and_reset

    MOVEA.L -52(A5),A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.L  D0,-(A7)
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     MEM_Move(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  -60(A5),D1
    MOVEA.L -52(A5),A0
    BRA.S   .pad_zero_next

.pad_zero_loop:
    MOVE.B  D0,(A0)+

.pad_zero_next:
    SUBQ.L  #1,D1
    BCC.S   .pad_zero_loop

    MOVE.L  -14(A5),D0
    MOVE.L  D0,-56(A5)

.emit_decimal_and_reset:
    ADD.L   D0,-28(A5)
    LEA     -48(A5),A0
    MOVE.L  A0,-52(A5)
    TST.B   D7
    BEQ.W   .emit_field

    MOVE.B  #' ',-5(A5)
    BRA.W   .emit_field

.conv_unsigned:
    TST.B   -15(A5)
    BEQ.S   .conv_unsigned_long

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .conv_unsigned_done

.conv_unsigned_long:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.conv_unsigned_done:
    MOVE.L  D0,-20(A5)
    BRA.W   .format_decimal

.conv_octal:
    TST.B   -15(A5)
    BEQ.S   .conv_octal_long

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .conv_octal_done

.conv_octal_long:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.conv_octal_done:
    MOVE.L  D0,-20(A5)
    TST.B   -4(A5)
    BEQ.S   .octal_alt_prefix

    MOVEA.L -52(A5),A0
    MOVE.B  #$30,(A0)+
    MOVEQ   #1,D1
    MOVE.L  D1,-28(A5)
    MOVE.L  A0,-52(A5)

.octal_alt_prefix:
    MOVE.L  D0,-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     FORMAT_U32ToOctalString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)
    BRA.W   .apply_precision

.conv_hex:
    MOVE.B  #'0',-5(A5)
    MOVE.L  -14(A5),D0
    TST.L   D0
    BPL.S   .conv_hex_long

    MOVEQ   #8,D0
    MOVE.L  D0,-14(A5)

.conv_hex_long:
    TST.B   -15(A5)
    BEQ.S   .conv_hex_done

    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    BRA.S   .conv_hex_value

.conv_hex_done:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0

.conv_hex_value:
    MOVE.L  D0,-20(A5)
    TST.B   -4(A5)
    BEQ.S   .hex_alt_prefix

    MOVEA.L -52(A5),A0
    MOVE.B  #'0',(A0)+
    MOVE.B  #'x',(A0)+
    MOVEQ   #2,D1
    MOVE.L  D1,-28(A5)
    MOVE.L  A0,-52(A5)

.hex_alt_prefix:
    MOVE.L  D0,-(A7)
    MOVE.L  -52(A5),-(A7)
    JSR     FORMAT_U32ToHexString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-56(A5)
    MOVEQ   #'X',D0
    CMP.B   -16(A5),D0
    BNE.W   .apply_precision

    PEA     -48(A5)
    JSR     STRING_ToUpperInPlace(PC)

    ADDQ.W  #4,A7
    BRA.W   .apply_precision

.conv_string:
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVEA.L (A0),A1
    MOVE.L  A1,-52(A5)
    BNE.S   .string_default

    LEA     .loc(PC),A0
    MOVE.L  A0,-52(A5)

.string_default:
    MOVEA.L -52(A5),A0

.string_len:
    TST.B   (A0)+
    BNE.S   .string_len

    SUBQ.L  #1,A0
    SUBA.L  -52(A5),A0
    MOVE.L  A0,-28(A5)
    MOVE.L  -14(A5),D0
    TST.L   D0
    BMI.S   .emit_field

    CMPA.L  D0,A0
    BLE.S   .emit_field

    MOVE.L  D0,-28(A5)
    BRA.S   .emit_field

.conv_char:
    MOVEQ   #1,D0
    MOVE.L  D0,-28(A5)
    MOVEA.L (A2),A0
    ADDQ.L  #4,(A2)
    MOVE.L  (A0),D0
    MOVE.B  D0,-48(A5)
    CLR.B   -47(A5)
    BRA.S   .emit_field

.conv_invalid:
    MOVEQ   #0,D0
    BRA.W   .return

.emit_field:
    MOVE.L  -28(A5),D0
    MOVE.L  -10(A5),D1
    CMP.L   D0,D1
    BGE.S   .width_ok

    MOVEQ   #0,D2
    MOVE.L  D2,-10(A5)
    BRA.S   .emit_with_pad

.width_ok:
    SUB.L   D0,-10(A5)

.emit_with_pad:
    TST.B   D7
    BEQ.S   .emit_pad_before

.emit_field_bytes:
    SUBQ.L  #1,-28(A5)
    BLT.S   .emit_pad_after

    MOVEQ   #0,D0
    MOVEA.L -52(A5),A0
    MOVE.B  (A0)+,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-52(A5)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .emit_field_bytes

.emit_pad_after:
    SUBQ.L  #1,-10(A5)
    BLT.S   .done

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .emit_pad_after

.emit_pad_before:
    SUBQ.L  #1,-10(A5)
    BLT.S   .emit_field_after

    MOVEQ   #0,D0
    MOVE.B  -5(A5),D0
    MOVE.L  D0,-(A7)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .emit_pad_before

.emit_field_after:
    SUBQ.L  #1,-28(A5)
    BLT.S   .done

    MOVEQ   #0,D0
    MOVEA.L -52(A5),A0
    MOVE.B  (A0)+,D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-52(A5)
    MOVEA.L 16(A5),A0
    JSR     (A0)

    ADDQ.W  #4,A7
    BRA.S   .emit_field_after

.done:
    MOVE.L  A3,D0

.return:
    MOVEM.L (A7)+,D2/D5-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; SYM: .loc   (Default "%s" fallback string)
; TYPE: string (NUL)
; PURPOSE: Used when %s argument is null.
;------------------------------------------------------------------------------
.loc:
    DC.W    $0000
