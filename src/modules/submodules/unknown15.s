    XDEF    STREAM_ReadLineWithLimit

;------------------------------------------------------------------------------
; FUNC: STREAM_ReadLineWithLimit   (Read a line into a buffer, NUL-terminate.)
; ARGS:
;   stack +28: A3 = destination buffer
;   stack +32: D7 = max length (including NUL)
;   stack +36: A2 = stream/buffer struct
; RET:
;   D0: 0 if no bytes read, else pointer to destination buffer
; CLOBBERS:
;   D0-D7/A0-A3
; CALLS:
;   STREAM_BufferedGetc (buffered getc/refill)
; READS:
;   A2+4 (read ptr), A2+8 (remaining count)
; WRITES:
;   A2+4, A2+8, destination buffer
; DESC:
;   Reads bytes up to newline or length-1, NUL-terminates the buffer.
; NOTES:
;   Treats byte value 10 as line terminator.
;------------------------------------------------------------------------------
STREAM_ReadLineWithLimit:
    MOVEM.L D4-D7/A2-A3,-(A7)

    MOVEA.L 28(A7),A3
    MOVE.L  32(A7),D7
    MOVEA.L 36(A7),A2

    MOVE.L  A3,D4
    SUBQ.L  #1,D7
    MOVE.L  D7,D6

.read_loop:
    TST.L   D6
    BMI.S   .done

    SUBQ.L  #1,8(A2)
    BLT.S   .refill_byte

    MOVEA.L 4(A2),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A2)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .have_byte

.refill_byte:
    MOVE.L  A2,-(A7)
    JSR     STREAM_BufferedGetc(PC)

    ADDQ.W  #4,A7

.have_byte:
    MOVE.L  D0,D5
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BEQ.S   .done

    SUBQ.L  #1,D6
    MOVE.L  D5,D0
    MOVE.B  D0,(A3)+
    MOVEQ   #10,D1
    CMP.L   D1,D5
    BNE.S   .read_loop

.done:
    CLR.B   (A3)
    CMP.L   D7,D6
    BNE.S   .return_ptr

    MOVEQ   #0,D0
    BRA.S   .return

.return_ptr:
    MOVEA.L D4,A0
    MOVE.L  A0,D0

.return:
    MOVEM.L (A7)+,D4-D7/A2-A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
