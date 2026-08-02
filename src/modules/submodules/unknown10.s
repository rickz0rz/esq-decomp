    XDEF    _FORMAT_U32ToHexString
    XDEF    _PARSE_ReadSignedLong
    XDEF    _PARSE_ReadSignedLong_NegateValue
    XDEF    _PARSE_ReadSignedLong_NoBranch
    XDEF    _PARSE_ReadSignedLong_ParseDone
    XDEF    _PARSE_ReadSignedLong_ParseLoop
    XDEF    _PARSE_ReadSignedLong_ParseLoopEntry
    XDEF    _PARSE_ReadSignedLong_StoreResult
    XDEF    _UNKNOWN10_PrintfPutcToBuffer
    XDEF    _WDISP_SPrintf


;------------------------------------------------------------------------------
; SYM: kHexDigitTable   (Hex digit lookup bytesuncertain)
; TYPE: array<u8>
; PURPOSE: Used by _FORMAT_U32ToHexString to map nibbles to ASCII.
;------------------------------------------------------------------------------
kHexDigitTable:
    DC.B    "0123456789abcdef"

;------------------------------------------------------------------------------
; FUNC: _FORMAT_U32ToHexString   (Format an unsigned value as hex ASCII.)
; ARGS:
;   stack +4: A0 = destination buffer
;   stack +8: D0 = value
; RET:
;   D0: length of output string (bytes, excluding NUL)
; CLOBBERS:
;   D0-D1/A0-A1
; DESC:
;   Emits hex digits into a temp stack buffer, then reverses into A0.
;   This is done by doing the following: Converts each byte to a hex code by copying
;   D0 to D1, then doing a logical and by 15 which only keeps the bottom 4 bits of the
;   byte. It then uses that (as a word) as a displacement against kHexDigitTable to get
;   the correct value. That value is used as an index, and the resultant char is copied
;   to A1's dest and A1 is incremented. The number is then left shifted by 4 bits, and
;   the digit conversion runs again. This happens in a loop while D0 doesn't equal zero.
;------------------------------------------------------------------------------
_FORMAT_U32ToHexString:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LEA     4(A7),A1

.digit_loop:
    MOVE.W  D0,D1
    ANDI.W  #15,D1
    MOVE.B  kHexDigitTable(PC,D1.W),(A1)+
    LSR.L   #4,D0
    BNE.S   .digit_loop

    MOVE.L  A1,D0
    MOVE.L  A7,D1
    ADDQ.L  #4,D1

.emit_loop:
    MOVE.B  -(A1),(A0)+
    CMP.L   A1,D1
    BNE.S   .emit_loop

    CLR.B   (A0)
    SUB.L   D1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong   (Parse signed decimal into output.)
; ARGS:
;   stack +4: A0 = input string
;   stack +8: A0' = output pointer (stores result)
; RET:
;   D0: number of chars consumed
; CLOBBERS:
;   D0-D2/A0-A1
; DESC:
;   Parses optional sign and decimal digits, stores the result.
; NOTES:
;   Similar to _PARSE_ReadSignedLong_NoBranch; exact differences are unclear.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #'+',(A0)
    BEQ.S   .lab_PARSE_ReadSignedLong_SkipSign

    CMPI.B  #'-',(A0)
    BNE.S   _PARSE_ReadSignedLong_ParseLoop

.lab_PARSE_ReadSignedLong_SkipSign:
    ADDQ.W  #1,A0

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_ParseLoop   (Routine at _PARSE_ReadSignedLong_ParseLoop)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D1/D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_ParseLoop:
    MOVE.B  (A0)+,D0

    ; Jump to _PARSE_ReadSignedLong_ParseDone if value is below 0
    SUBI.B  #'0',D0
    BLT.S   _PARSE_ReadSignedLong_ParseDone

    ; Jump to _PARSE_ReadSignedLong_ParseDone if value is above 9
    CMPI.B  #('9'-'0'),D0
    BGT.S   _PARSE_ReadSignedLong_ParseDone

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_ParseLoopEntry   (Routine at _PARSE_ReadSignedLong_ParseLoopEntry)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_ParseLoopEntry:
    BRA.S   _PARSE_ReadSignedLong_ParseLoop

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_ParseDone   (Routine at _PARSE_ReadSignedLong_ParseDone)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A1
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_ParseDone:
    CMPI.B  #'-',(A1)
    BNE.S   _PARSE_ReadSignedLong_StoreResult

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_NegateValue   (Routine at _PARSE_ReadSignedLong_NegateValue)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   D1
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_NegateValue:
    NEG.L   D1

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_StoreResult   (Routine at _PARSE_ReadSignedLong_StoreResult)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/D0/D2
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_StoreResult:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _PARSE_ReadSignedLong_NoBranch   (Parse signed decimal into output.)
; ARGS:
;   stack +4: A0 = input string
;   stack +8: A0' = output pointer (stores result)
; RET:
;   D0: number of chars consumed
; CLOBBERS:
;   D0-D2/A0-A1
; DESC:
;   Parses optional sign and decimal digits, stores the result.
; NOTES:
;   Similar to _PARSE_ReadSignedLong; exact differences are unclear.
;------------------------------------------------------------------------------
_PARSE_ReadSignedLong_NoBranch:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #'+',(A0)
    BEQ.S   .lab_PARSE_ReadSignedLong_NoBranch_SkipSign

    CMPI.B  #'-',(A0)
    BNE.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseLoop

.lab_PARSE_ReadSignedLong_NoBranch_SkipSign:
    ADDQ.W  #1,A0

.lab_PARSE_ReadSignedLong_NoBranch_ParseLoop:
    MOVE.B  (A0)+,D0

    ; Jump to done if the value is below '0'
    SUBI.B  #'0',D0
    BLT.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseDone

    ; Jump to done if the value is above '9'
    CMPI.B  #('9'-'0'),D0
    BGT.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseDone

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1
    BRA.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseLoop

.lab_PARSE_ReadSignedLong_NoBranch_ParseDone:
    CMPI.B  #'-',(A1)
    BNE.S   .lab_PARSE_ReadSignedLong_NoBranch_StoreResult

    NEG.L   D1

.lab_PARSE_ReadSignedLong_NoBranch_StoreResult:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _UNKNOWN10_PrintfPutcToBuffer   (PrintfPutcToBuffer)
; ARGS:
;   D0.b: character to append
; RET:
;   (none)
; CLOBBERS:
;   D0, D7
; CALLS:
;   (none)
; READS:
;   Global_PrintfBufferPtr(A4), Global_PrintfByteCount(A4)
; WRITES:
;   Global_PrintfBufferPtr(A4), Global_PrintfByteCount(A4), [buffer]
; DESC:
;   Appends one byte to the current printf output buffer and advances the cursor.
; NOTES:
;   Uses A4-relative globals for the buffer pointer and byte count.
;------------------------------------------------------------------------------
_UNKNOWN10_PrintfPutcToBuffer:
    MOVE.L  D7,-(A7)
    MOVE.L  8(A7),D7

    ADDQ.L  #1,Global_PrintfByteCount(A4)
    MOVE.L  D7,D0
    MOVEA.L Global_PrintfBufferPtr(A4),A0
    MOVE.B  D0,(A0)+
    MOVE.L  A0,Global_PrintfBufferPtr(A4)

    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: _WDISP_SPrintf   (SPrintfToBuffer)
; ARGS:
;   stack +4: outBuf
;   stack +8: formatStr
;   stack +12+: varargs
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0, A0, A2-A3
; CALLS:
;   _WDISP_FormatWithCallback (core formatter), _UNKNOWN10_PrintfPutcToBuffer
; READS:
;   (none)
; WRITES:
;   outBuf, Global_PrintfBufferPtr(A4), Global_PrintfByteCount(A4)
; DESC:
;   Formats into the provided buffer using the local printf core and returns length.
; NOTES:
;   Zero-terminates the output.
;   No local NULL guard is applied to `formatStr`; callers must pass a valid
;   NUL-terminated format pointer.
;   No destination-capacity argument is present; callers must ensure `outBuf`
;   is large enough for worst-case formatted output.
;------------------------------------------------------------------------------
_WDISP_SPrintf:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2

    CLR.L   Global_PrintfByteCount(A4)       ; Clear Global_PrintfByteCount(A4)
    MOVE.L  A3,Global_PrintfBufferPtr(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     _UNKNOWN10_PrintfPutcToBuffer(PC)
    JSR     _WDISP_FormatWithCallback(PC)

    MOVEA.L Global_PrintfBufferPtr(A4),A0
    CLR.B   (A0)
    MOVE.L  Global_PrintfByteCount(A4),D0    ; Store Global_PrintfByteCount(A4) in D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======