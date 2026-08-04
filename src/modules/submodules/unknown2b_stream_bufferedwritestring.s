    XDEF    _STREAM_BufferedWriteString

;------------------------------------------------------------------------------
; FUNC: _STREAM_BufferedWriteString   (Buffered write of stringuncertain)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: string length
; CLOBBERS:
;   A0/A1/A3/A4/A7/D0/D1/D6/D7
; CALLS:
;   _STREAM_BufferedPutcOrFlush
; READS:
;   Global_PreallocHandleNode1_WriteRemaining(A4), Global_PreallocHandleNode1_BufferCursor(A4)
; WRITES:
;   Global_PreallocHandleNode1_WriteRemaining(A4),
;   Global_PreallocHandleNode1_BufferCursor(A4),
;   Global_PreallocHandleNode1(A4)
; DESC:
;   Writes a NUL-terminated string into a buffer, flushing via _STREAM_BufferedPutcOrFlush on overflow.
; NOTES:
;   Uses a byte-at-a-time loop until NUL.
;------------------------------------------------------------------------------
_STREAM_BufferedWriteString:
    MOVEM.L D6-D7/A3,-(A7)

    SetOffsetForStack 3

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVEA.L A3,A0

.incrementAddressForStringLength:
    TST.B   (A0)+
    BNE.S   .incrementAddressForStringLength

    SUBQ.L  #1,A0
    SUBA.L  A3,A0
    MOVE.L  A0,D6   ; String length

.write_loop:
    MOVEQ   #0,D7
    MOVE.B  (A3)+,D7
    TST.L   D7
    BEQ.S   .done

    SUBQ.L  #1,Global_PreallocHandleNode1_WriteRemaining(A4)
    BLT.S   .flush_and_retry

    MOVEA.L Global_PreallocHandleNode1_BufferCursor(A4),A0
    LEA     1(A0),A1
    MOVE.L  A1,Global_PreallocHandleNode1_BufferCursor(A4)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .write_loop

.flush_and_retry:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     Global_PreallocHandleNode1(A4)
    MOVE.L  D1,-(A7)
    JSR     _STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1
    BRA.S   .write_loop

.done:
    PEA     Global_PreallocHandleNode1(A4)
    PEA     -1.W
    JSR     _STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======