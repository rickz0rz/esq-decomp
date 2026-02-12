;------------------------------------------------------------------------------
; SYM: kHexDigitTable_Maybe   (Hex digit lookup bytesuncertain)
; TYPE: array<u8>
; PURPOSE: Used by FORMAT_U32ToHexString to map nibbles to ASCII.
; NOTES: The table likely extends into the following words which are
;        disassembled as code; do not change without verifying layout.
;------------------------------------------------------------------------------
kHexDigitTable_Maybe:
    DC.W    $3031
    DC.W    $3233
    DC.W    $3435
    MOVE.W  57(A7,D3.L),D3
    BSR.S   PARSE_ReadSignedLong_ParseLoopEntry

    BLS.S   PARSE_ReadSignedLong_ParseDone+2

    BCS.S   PARSE_ReadSignedLong_NegateValue

;------------------------------------------------------------------------------
; FUNC: FORMAT_U32ToHexString   (Format an unsigned value as hex ASCII.)
; ARGS:
;   stack +4: A0 = destination buffer
;   stack +8: D0 = value
; RET:
;   D0: length of output string (bytes, excluding NUL)
; CLOBBERS:
;   D0-D1/A0-A1
; DESC:
;   Emits hex digits into a temp stack buffer, then reverses into A0.
;------------------------------------------------------------------------------
FORMAT_U32ToHexString:
    MOVE.L  8(A7),D0
    MOVEA.L 4(A7),A0
    LEA     4(A7),A1

.digit_loop:
    MOVE.W  D0,D1
    ANDI.W  #15,D1
    MOVE.B  kHexDigitTable_Maybe(PC,D1.W),(A1)+
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
; FUNC: PARSE_ReadSignedLong   (Parse signed decimal into output.)
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
;   Similar to PARSE_ReadSignedLong_NoBranch; exact differences are unclear.
;------------------------------------------------------------------------------
PARSE_ReadSignedLong:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   .lab_PARSE_ReadSignedLong_SkipSign

    CMPI.B  #$2d,(A0)
    BNE.S   PARSE_ReadSignedLong_ParseLoop

.lab_PARSE_ReadSignedLong_SkipSign:
    ADDQ.W  #1,A0

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_ParseLoop   (Routine at PARSE_ReadSignedLong_ParseLoop)
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
PARSE_ReadSignedLong_ParseLoop:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   PARSE_ReadSignedLong_ParseDone

    CMPI.B  #$9,D0
    BGT.S   PARSE_ReadSignedLong_ParseDone

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_ParseLoopEntry   (Routine at PARSE_ReadSignedLong_ParseLoopEntry)
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
PARSE_ReadSignedLong_ParseLoopEntry:
    BRA.S   PARSE_ReadSignedLong_ParseLoop

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_ParseDone   (Routine at PARSE_ReadSignedLong_ParseDone)
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
PARSE_ReadSignedLong_ParseDone:
    CMPI.B  #$2d,(A1)
    BNE.S   PARSE_ReadSignedLong_StoreResult

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_NegateValue   (Routine at PARSE_ReadSignedLong_NegateValue)
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
PARSE_ReadSignedLong_NegateValue:
    NEG.L   D1

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_StoreResult   (Routine at PARSE_ReadSignedLong_StoreResult)
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
PARSE_ReadSignedLong_StoreResult:
    MOVE.L  (A7)+,D2
    MOVE.L  A0,D0
    SUBQ.L  #1,D0
    MOVEA.L 8(A7),A0
    MOVE.L  D1,(A0)
    SUB.L   A1,D0
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: PARSE_ReadSignedLong_NoBranch   (Parse signed decimal into output.)
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
;   Similar to PARSE_ReadSignedLong; exact differences are unclear.
;------------------------------------------------------------------------------
PARSE_ReadSignedLong_NoBranch:
    MOVEA.L 4(A7),A0
    MOVEA.L A0,A1
    MOVEQ   #0,D1
    MOVEQ   #0,D0
    MOVE.L  D2,-(A7)
    CMPI.B  #$2b,(A0)
    BEQ.S   .lab_PARSE_ReadSignedLong_NoBranch_SkipSign

    CMPI.B  #$2d,(A0)
    BNE.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseLoop

.lab_PARSE_ReadSignedLong_NoBranch_SkipSign:
    ADDQ.W  #1,A0

.lab_PARSE_ReadSignedLong_NoBranch_ParseLoop:
    MOVE.B  (A0)+,D0
    SUBI.B  #$30,D0
    BLT.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseDone

    CMPI.B  #$9,D0
    BGT.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseDone

    MOVE.L  D1,D2
    ASL.L   #2,D1
    ADD.L   D2,D1
    ADD.L   D1,D1
    ADD.L   D0,D1
    BRA.S   .lab_PARSE_ReadSignedLong_NoBranch_ParseLoop

.lab_PARSE_ReadSignedLong_NoBranch_ParseDone:
    CMPI.B  #$2d,(A1)
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
; FUNC: UNKNOWN10_PrintfPutcToBuffer   (PrintfPutcToBuffer)
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
UNKNOWN10_PrintfPutcToBuffer:
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
; FUNC: WDISP_SPrintf   (SPrintfToBuffer)
; ARGS:
;   stack +4: outBuf
;   stack +8: formatStr
;   stack +12+: varargs
; RET:
;   D0: bytes written (excluding terminator)
; CLOBBERS:
;   D0, A0, A2-A3
; CALLS:
;   WDISP_FormatWithCallback (core formatter), UNKNOWN10_PrintfPutcToBuffer
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
WDISP_SPrintf:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2

    CLR.L   Global_PrintfByteCount(A4)       ; Clear Global_PrintfByteCount(A4)
    MOVE.L  A3,Global_PrintfBufferPtr(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     UNKNOWN10_PrintfPutcToBuffer(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVEA.L Global_PrintfBufferPtr(A4),A0
    CLR.B   (A0)
    MOVE.L  Global_PrintfByteCount(A4),D0    ; Store Global_PrintfByteCount(A4) in D0

    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: HANDLE_OpenEntryWithFlags   (Allocate/open entry in handle table.)
; ARGS:
;   stack +10: arg_1 (via 14(A5))
;   stack +12: arg_2 (via 16(A5))
;   stack +14: arg_3 (via 18(A5))
;   stack +15: arg_4 (via 19(A5))
; RET:
;   D0: slot/index on success, -1 on failure
; CLOBBERS:
;   A0/A2/A3/A4/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   DOS_OpenWithErrorState, DOS_OpenNewFileIfMissing, DOS_DeleteAndRecreateFile, DOS_CloseWithSignalCheck
; READS:
;   Global_HandleTableCount(A4), Global_HandleTableBase(A4) (table), Global_HandleTableFlags(A4) (flags), Global_AppErrorCode(A4)
; WRITES:
;   Global_AppErrorCode(A4), Global_DosIoErr(A4), (A2), 4(A2)
; DESC:
;   Finds a free entry in the handle table, validates mode bits, and performs
;   setup/open work via helper calls; stores entry data on success.
; NOTES:
;   Uses SEQ/NEG/EXT booleanization in callers; sets error code in Global_AppErrorCode(A4).
;------------------------------------------------------------------------------
HANDLE_OpenEntryWithFlags:
    LINK.W  A5,#-26
    MOVEM.L D4-D7/A2-A3,-(A7)
    MOVEA.L 58(A7),A3
    MOVE.L  62(A7),D7

    CLR.B   -1(A5)
    CLR.L   Global_DosIoErr(A4)
    MOVE.L  Global_AppErrorCode(A4),-14(A5)
    MOVEQ   #3,D5

.find_free_slot:
    CMP.L   Global_HandleTableCount(A4),D5
    BGE.S   .have_slot_index

    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    TST.L   Struct_HandleEntry__Flags(A0,D0.L)
    BEQ.S   .have_slot_index

    ADDQ.L  #1,D5
    BRA.S   .find_free_slot

.have_slot_index:
    MOVE.L  Global_HandleTableCount(A4),D0
    CMP.L   D5,D0
    BNE.S   .init_slot

    ; Set 24 in the AppErrorCode and return -1
    MOVEQ   #24,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.init_slot:
    MOVE.L  D5,D0
    ASL.L   #3,D0
    LEA     Global_HandleTableBase(A4),A0
    ADDA.L  D0,A0
    MOVEA.L A0,A2
    TST.L   16(A5)
    BEQ.S   .set_errcode_default

    BTST    #2,19(A5)
    BEQ.S   .set_errcode_alt

.set_errcode_default:
    MOVE.L  #$3ec,-18(A5)
    BRA.S   .normalize_flags

.set_errcode_alt:
    MOVE.L  #$3ee,-18(A5)

.normalize_flags:
    MOVE.L  #$8000,D0
    AND.L   Global_HandleTableFlags(A4),D0
    EOR.L   D0,D7
    BTST    #3,D7
    BEQ.S   .normalize_access_bits

    MOVE.L  D7,D0
    ANDI.W  #$fffc,D0
    MOVE.L  D0,D7
    ORI.W   #2,D7

.normalize_access_bits:
    MOVE.L  D7,D0
    MOVEQ   #3,D1
    AND.L   D1,D0
    CMPI.L  #$2,D0
    BEQ.S   .access_ok

    CMPI.L  #$1,D0
    BEQ.S   .access_ok

    TST.L   D0
    BNE.S   .access_invalid

.access_ok:
    MOVE.L  D7,D6
    ADDQ.L  #1,D6
    BRA.S   .open_by_mode

.access_invalid:
    MOVEQ   #22,D0
    MOVE.L  D0,Global_AppErrorCode(A4)
    MOVEQ   #-1,D0
    BRA.W   .return

.open_by_mode:
    MOVE.L  D7,D0
    ANDI.L  #$300,D0
    BEQ.W   .simple_open

    BTST    #10,D7
    BEQ.S   .open_mode_bit10

    MOVE.B  #$1,-1(A5)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     DOS_OpenNewFileIfMissing(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    BRA.S   .post_open_adjust

.open_mode_bit10:
    BTST    #9,D7
    BNE.S   .open_mode_bit9

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     DOS_OpenWithErrorState(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4
    TST.L   D4
    BPL.S   .open_mode_bit9

    BSET    #9,D7

.open_mode_bit9:
    BTST    #9,D7
    BEQ.S   .post_open_adjust

    MOVE.B  #$1,-1(A5)
    MOVE.L  -14(A5),Global_AppErrorCode(A4)
    MOVE.L  -18(A5),-(A7)
    MOVE.L  A3,-(A7)
    JSR     DOS_DeleteAndRecreateFile(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.post_open_adjust:
    TST.B   -1(A5)
    BEQ.S   .check_ioerr

    MOVE.L  D7,D0
    MOVEQ   #120,D1
    ADD.L   D1,D1
    AND.L   D1,D0
    TST.L   D0
    BEQ.S   .check_ioerr

    TST.L   D4
    BMI.S   .check_ioerr

    MOVE.L  D4,-(A7)
    JSR     DOS_CloseWithSignalCheck(PC)

    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     DOS_OpenWithErrorState(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D4
    BRA.S   .check_ioerr

.simple_open:
    PEA     1005.W
    MOVE.L  A3,-(A7)
    JSR     DOS_OpenWithErrorState(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D4

.check_ioerr:
    TST.L   Global_DosIoErr(A4)
    BEQ.S   .store_entry

    MOVEQ   #-1,D0
    BRA.S   .return

.store_entry:
    MOVE.L  D6,(A2)
    MOVE.L  D4,4(A2)
    MOVE.L  D5,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ORI.B   #0,D0
    DC.W    $0000
    MOVEQ   #97,D0
