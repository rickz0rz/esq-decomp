    XDEF    _FORMAT_RawDoFmtWithScratchBuffer
    XDEF    _UNKNOWN2A_Stub0

;!======
;------------------------------------------------------------------------------
; FUNC: uncertain   (Dead code: _FORMAT_FormatToBuffer2/PARALLEL_RawDoFmtStackArgs wrapperuncertain)
; ARGS:
;   stack +8: uncertain (arg for _FORMAT_FormatToBuffer2)
;   stack +12: uncertain (arg for _FORMAT_FormatToBuffer2)
; RET:
;   D0: status/result from formatter callback path
; CLOBBERS:
;   D0/A0 uncertain
; CALLS:
;   _FORMAT_FormatToBuffer2, PARALLEL_RawDoFmtStackArgs
; READS:
;   _FORMAT_ScratchBuffer
; WRITES:
;   _FORMAT_ScratchBuffer
; DESC:
;   Dead code wrapper that formats/updates _FORMAT_ScratchBuffer and then calls
;   PARALLEL_RawDoFmtStackArgs.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-4

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     _FORMAT_ScratchBuffer
    MOVE.L  A0,-4(A5)
    JSR     _FORMAT_FormatToBuffer2(PC)

    PEA     _FORMAT_ScratchBuffer
    JSR     PARALLEL_RawDoFmtStackArgs(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: _FORMAT_RawDoFmtWithScratchBuffer   (_FORMAT_FormatToBuffer2/RawDoFmt wrapper)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +8: arg_2 (via 12(A5))
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A5/A7
; CALLS:
;   _FORMAT_FormatToBuffer2, PARALLEL_RawDoFmtStackArgs
; READS:
;   _FORMAT_ScratchBuffer
; WRITES:
;   _FORMAT_ScratchBuffer
; DESC:
;   Wrapper that formats/updates _FORMAT_ScratchBuffer and then calls PARALLEL_RawDoFmtStackArgs.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_FORMAT_RawDoFmtWithScratchBuffer:
    LINK.W  A5,#-4
    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     _FORMAT_ScratchBuffer
    MOVE.L  A0,-4(A5)
    JSR     _FORMAT_FormatToBuffer2(PC)

    PEA     _FORMAT_ScratchBuffer
    JSR     PARALLEL_RawDoFmtStackArgs(PC)

    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: uncertain   (Dead code: open log file and write LAB_2381uncertain)
; ARGS:
;   stack +8: uncertain (arg for _FORMAT_FormatToBuffer2)
;   stack +12: uncertain (arg for _FORMAT_FormatToBuffer2)
; RET:
;   D0: status/result from debug-log wrapper path
; CLOBBERS:
;   D0/A0 uncertain
; CALLS:
;   _HANDLE_OpenWithMode, _FORMAT_FormatToBuffer2, _FORMAT_FormatToCallbackBuffer, _UNKNOWN36_FinalizeRequest
; READS:
;   _Global_STR_A_PLUS, _Global_STR_DF1_DEBUG_LOG, _FORMAT_ScratchBuffer
; WRITES:
;   _FORMAT_ScratchBuffer
; DESC:
;   Dead code that opens a debug log, formats _FORMAT_ScratchBuffer, writes it, and closes.
; NOTES:
;   Entry label not present in source.
;------------------------------------------------------------------------------
    ; Dead code.
    LINK.W  A5,#-8

    PEA     _Global_STR_A_PLUS
    PEA     _Global_STR_DF1_DEBUG_LOG
    JSR     _HANDLE_OpenWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,-8(A5)
    BEQ.S   .no_log

    LEA     12(A5),A0
    MOVE.L  A0,-(A7)
    MOVE.L  8(A5),-(A7)
    PEA     _FORMAT_ScratchBuffer
    MOVE.L  A0,-4(A5)
    JSR     _FORMAT_FormatToBuffer2(PC)

    PEA     _FORMAT_ScratchBuffer
    MOVE.L  -8(A5),-(A7)
    JSR     _FORMAT_FormatToCallbackBuffer(PC)

    MOVE.L  -8(A5),(A7)
    JSR     _UNKNOWN36_FinalizeRequest(PC)

    LEA     20(A7),A7

.no_log:
    UNLK    A5
    RTS

;!======

;!======
;------------------------------------------------------------------------------
; FUNC: _UNKNOWN2A_Stub0   (Stub)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   none
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Empty stub.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_UNKNOWN2A_Stub0:
    RTS
