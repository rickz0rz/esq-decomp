;------------------------------------------------------------------------------
; FUNC: FORMAT_CallbackWriteChar   (Callback writer for formatter.)
; ARGS:
;   stack +12: D7 = byte to write
; RET:
;   D1: ?? (result from STREAM_BufferedPutcOrFlush when overflow)
; CLOBBERS:
;   D0-D1/D7/A0-A2
; CALLS:
;   STREAM_BufferedPutcOrFlush (overflow handler)
; READS:
;   Global_FormatCallbackBufferPtr, Global_FormatCallbackByteCount
; WRITES:
;   Global_FormatCallbackByteCount, buffer fields
; DESC:
;   Writes a byte into a callback buffer, or falls back to STREAM_BufferedPutcOrFlush if full.
;------------------------------------------------------------------------------
FORMAT_CallbackWriteChar:
    MOVEM.L D7/A2,-(A7)
    MOVE.L  12(A7),D7
    ADDQ.L  #1,Global_FormatCallbackByteCount(A4)
    MOVEA.L Global_FormatCallbackBufferPtr(A4),A0
    SUBQ.L  #1,12(A0)
    BLT.S   .buffer_full

    MOVEA.L 4(A0),A1
    LEA     1(A1),A2
    MOVE.L  A2,4(A0)
    MOVE.L  D7,D0
    MOVE.B  D0,(A1)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .return

.buffer_full:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A0,-(A7)
    MOVE.L  D1,-(A7)
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.return:
    MOVEM.L (A7)+,D7/A2
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: FORMAT_FormatToCallbackBuffer   (Format string via callback buffer.)
; ARGS:
;   stack +16: A3 = callback buffer struct
;   stack +20: A2 = format string
;   stack +24: varargs ptr
; RET:
;   D0: byte count written
; CLOBBERS:
;   D0-D1/A0-A3
; CALLS:
;   WDISP_FormatWithCallback, STREAM_BufferedPutcOrFlush
; READS:
;   Global_FormatCallbackBufferPtr, Global_FormatCallbackByteCount
; WRITES:
;   Global_FormatCallbackBufferPtr, Global_FormatCallbackByteCount
; DESC:
;   Formats into a callback buffer, then flushes with STREAM_BufferedPutcOrFlush (-1 terminator).
;------------------------------------------------------------------------------
FORMAT_FormatToCallbackBuffer:
    LINK.W  A5,#0
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVEA.L 20(A7),A2
    CLR.L   Global_FormatCallbackByteCount(A4)
    MOVE.L  A3,Global_FormatCallbackBufferPtr(A4)
    PEA     16(A5)
    MOVE.L  A2,-(A7)
    PEA     FORMAT_CallbackWriteChar(PC)
    JSR     WDISP_FormatWithCallback(PC)

    MOVE.L  A3,(A7)
    PEA     -1.W
    JSR     STREAM_BufferedPutcOrFlush(PC)

    MOVE.L  Global_FormatCallbackByteCount(A4),D0
    MOVEM.L -8(A5),A2-A3
    UNLK    A5
    RTS

;!======

    ; Alignment
    ALIGN_WORD
