    XDEF    ESQIFF2_ReadRbfBytesToBuffer
    XDEF    ESQIFF2_ReadRbfBytesWithXor
    XDEF    ESQIFF2_ReadSerialBytesToBuffer_Return
    XDEF    ESQIFF2_ReadSerialBytesWithXor_Return


;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadRbfBytesToBuffer   (Read N serial bytes into buffer)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A0/A3/A7/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, _ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Reads a fixed byte count from serial input (with UI service wait) and writes
;   bytes sequentially into the destination buffer.
; NOTES:
;   Returns end pointer (one past last written byte) in D0.
;------------------------------------------------------------------------------
ESQIFF2_ReadRbfBytesToBuffer:
    LINK.W  A5,#-4
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 24(A7),A3
    MOVE.W  30(A7),D7
    MOVEQ   #0,D6

.loop_read_serial_byte_to_buffer:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesToBuffer_Return

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    MOVEA.L A3,A0
    ADDQ.L  #1,A3
    MOVE.L  A0,12(A7)
    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEA.L 12(A7),A0
    MOVE.B  D0,(A0)
    ADDQ.W  #1,D6
    BRA.S   .loop_read_serial_byte_to_buffer

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesToBuffer_Return   (Return tail for serial byte block reader)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns updated destination pointer in D0 and restores saved registers/frame.
; NOTES:
;   Shared return for loop-complete path.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesToBuffer_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadRbfBytesWithXor   (Read serial bytes and fold XOR checksum)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7/D6/D7
; CALLS:
;   _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte, _ESQFUNC_WaitForClockChangeAndServiceUi
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Reads N serial bytes into a destination buffer and XOR-accumulates them into
;   the caller-provided checksum byte pointer.
; NOTES:
;   Waits for clock/UI service between each byte read.
;------------------------------------------------------------------------------
ESQIFF2_ReadRbfBytesWithXor:
    MOVEM.L D6-D7/A2-A3,-(A7)
    MOVEA.L 20(A7),A3
    MOVE.W  26(A7),D7
    MOVEA.L 28(A7),A2
    MOVEQ   #0,D6

.loop_read_serial_byte_with_xor:
    CMP.W   D7,D6
    BGE.S   ESQIFF2_ReadSerialBytesWithXor_Return

    JSR     _ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _ESQPARS_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,(A3)
    ADDQ.L  #1,A3
    EOR.B   D0,(A2)
    ADDQ.W  #1,D6
    BRA.S   .loop_read_serial_byte_with_xor

;------------------------------------------------------------------------------
; FUNC: ESQIFF2_ReadSerialBytesWithXor_Return   (Return tail for serial+xor reader)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0/D6
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Returns end pointer in D0 and restores registers after XOR-fold read loop.
; NOTES:
;   Shared return for read-count completion.
;------------------------------------------------------------------------------
ESQIFF2_ReadSerialBytesWithXor_Return:
    MOVE.L  A3,D0
    MOVEM.L (A7)+,D6-D7/A2-A3
    RTS

;!======