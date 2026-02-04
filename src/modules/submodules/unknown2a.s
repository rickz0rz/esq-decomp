;!======
;------------------------------------------------------------------------------
; FUNC: ??   (Dead code: FORMAT_FormatToBuffer2/PARALLEL_RawDoFmtStackArgs wrapper??)
; ARGS:
;   stack +8: ?? (arg for FORMAT_FormatToBuffer2)
;   stack +12: ?? (arg for FORMAT_FormatToBuffer2)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   FORMAT_FormatToBuffer2, PARALLEL_RawDoFmtStackArgs
; READS:
;   LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Dead code wrapper that formats/updates LAB_2381 and then calls
;   PARALLEL_RawDoFmtStackArgs.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-4

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     FORMAT_FormatToBuffer2(PC)

    PEA     LAB_2381
    JSR     PARALLEL_RawDoFmtStackArgs(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: FORMAT_RawDoFmtWithScratchBuffer   (FORMAT_FormatToBuffer2/RawDoFmt wrapper)
; ARGS:
;   stack +8: ?? (arg for FORMAT_FormatToBuffer2)
;   stack +12: ?? (arg for FORMAT_FormatToBuffer2)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   FORMAT_FormatToBuffer2, PARALLEL_RawDoFmtStackArgs
; READS:
;   LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Wrapper that formats/updates LAB_2381 and then calls PARALLEL_RawDoFmtStackArgs.
; NOTES:
;   ??
;------------------------------------------------------------------------------
FORMAT_RawDoFmtWithScratchBuffer:
    LINK.W  A5,#-4
    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     FORMAT_FormatToBuffer2(PC)

    PEA     LAB_2381
    JSR     PARALLEL_RawDoFmtStackArgs(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: ??   (Dead code: open log file and write LAB_2381??)
; ARGS:
;   stack +8: ?? (arg for FORMAT_FormatToBuffer2)
;   stack +12: ?? (arg for FORMAT_FormatToBuffer2)
; RET:
;   D0: ??
; CLOBBERS:
;   D0/A0 ??
; CALLS:
;   HANDLE_OpenWithMode, FORMAT_FormatToBuffer2, FORMAT_FormatToCallbackBuffer, UNKNOWN36_FinalizeRequest
; READS:
;   GLOB_STR_A_PLUS, GLOB_STR_DF1_DEBUG_LOG, LAB_2381
; WRITES:
;   LAB_2381
; DESC:
;   Dead code that opens a debug log, formats LAB_2381, writes it, and closes.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-8

    PEA     GLOB_STR_A_PLUS
    PEA     GLOB_STR_DF1_DEBUG_LOG
    JSR     HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .no_log

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     LAB_2381
    MOVE.L  A0,-4(A5)
    JSR     FORMAT_FormatToBuffer2(PC)

    PEA     LAB_2381
    MOVE.L  -8(A5),-(A7)
    JSR     FORMAT_FormatToCallbackBuffer(PC)

    MOVE.L  -8(A5),(A7)
    JSR     UNKNOWN36_FinalizeRequest(PC)

    LEA     20(A7),A7

.no_log:
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2A_Stub0   (Stub)
; ARGS:
;   ??
; RET:
;   ??
; CLOBBERS:
;   ??
; CALLS:
;   none
; READS:
;   ??
; WRITES:
;   ??
; DESC:
;   Empty stub.
; NOTES:
;   ??
;------------------------------------------------------------------------------
UNKNOWN2A_Stub0:
    RTS
