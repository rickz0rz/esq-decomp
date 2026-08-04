    XDEF    _STREAM_BufferedGetc

;------------------------------------------------------------------------------
; FUNC: _STREAM_BufferedGetc   (Buffered read/getc handler)
; ARGS:
;   (none observed)
; RET:
;   D0: byte or -1 on error/EOF
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   _STREAM_BufferedPutcOrFlush, _BUFFER_EnsureAllocated, _DOS_ReadByIndex
; READS:
;   Struct_PreallocHandleNode__BufferCursor/ReadRemaining/BufferBase/BufferCapacity/OpenFlags/ModeFlags/StateFlags/HandleIndex
; WRITES:
;   Struct_PreallocHandleNode__BufferCursor/ReadRemaining/BufferBase/BufferCapacity/StateFlags
; DESC:
;   Ensures buffer is ready and returns next byte, refilling as needed.
; NOTES:
;   Handles 0x1A and 0x0D specially; uses SNE/NEG/EXT booleanization.
;   `ModeFlags bit7` enables translated read behavior (CR/LF folding path).
;   `StateFlags bits6/7` are a paired pre-read flush gate (provisional names).
;------------------------------------------------------------------------------
_STREAM_BufferedGetc:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    BTST    #Struct_PreallocHandleNode_ModeFlag_TextTranslate_Bit,Struct_PreallocHandleNode__ModeFlags(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVEQ   #Struct_PreallocHandleNode_OpenMask_FlushReject,D0
    AND.L   Struct_PreallocHandleNode__OpenFlags(A3),D0
    BEQ.S   .check_handle_flags

    CLR.L   Struct_PreallocHandleNode__ReadRemaining(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.check_handle_flags:
    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit7_PreReadFlushGateHi_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .maybe_flush_on_flags

    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit6_PreReadFlushGateLo_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .maybe_flush_on_flags

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     _STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7

.maybe_flush_on_flags:
    TST.L   Struct_PreallocHandleNode__BufferCapacity(A3)
    BNE.S   .consume_buffered

    CLR.L   Struct_PreallocHandleNode__ReadRemaining(A3)
    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .ensure_buffer

    MOVEQ   #1,D0
    MOVE.L  D0,Struct_PreallocHandleNode__BufferCapacity(A3)
    LEA     Struct_PreallocHandleNode__InlineByte(A3),A0
    MOVE.L  A0,Struct_PreallocHandleNode__BufferBase(A3)
    BRA.W   .fill_buffer

.ensure_buffer:
    MOVE.L  A3,-(A7)
    JSR     _BUFFER_EnsureAllocated(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .fill_buffer

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit5_IoError_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.consume_buffered:
    TST.B   D7
    BEQ.S   .fill_buffer

    ADDQ.L  #2,Struct_PreallocHandleNode__ReadRemaining(A3)
    MOVE.L  Struct_PreallocHandleNode__ReadRemaining(A3),D0
    TST.L   D0
    BGT.S   .fill_buffer

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVEQ   #0,D6
    MOVE.B  (A0),D6
    MOVE.L  D6,D0
    CMPI.L  #$1a,D0
    BEQ.S   .handle_ctrl_z

    CMPI.L  #$d,D0
    BNE.S   .return_char

    SUBQ.L  #1,Struct_PreallocHandleNode__ReadRemaining(A3)
    BLT.S   .retry_after_empty

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.W   .return

.retry_after_empty:
    MOVE.L  A3,-(A7)
    BSR.W   _STREAM_BufferedGetc

    ADDQ.W  #4,A7
    BRA.W   .return

.handle_ctrl_z:
    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit4_EofOrShort_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.return_char:
    MOVE.L  D6,D0
    BRA.W   .return

.fill_buffer:
    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BNE.S   .post_fill_flags

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit0_ReadRefillIssued_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    MOVE.L  Struct_PreallocHandleNode__BufferCapacity(A3),-(A7)
    MOVE.L  Struct_PreallocHandleNode__BufferBase(A3),-(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     _DOS_ReadByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BPL.S   .mark_error

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit5_IoError_Bit,Struct_PreallocHandleNode__StateFlags(A3)

.mark_error:
    TST.L   D5
    BNE.S   .mark_eof

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit4_EofOrShort_Bit,Struct_PreallocHandleNode__StateFlags(A3)

.mark_eof:
    TST.L   D5
    BLE.S   .post_fill_flags

    TST.B   D7
    BEQ.S   .set_remaining_neg

    MOVE.L  D5,D0
    NEG.L   D0
    MOVE.L  D0,Struct_PreallocHandleNode__ReadRemaining(A3)
    BRA.S   .set_buffer_ptr

.set_remaining_neg:
    MOVE.L  D5,Struct_PreallocHandleNode__ReadRemaining(A3)

.set_buffer_ptr:
    MOVEA.L Struct_PreallocHandleNode__BufferBase(A3),A0
    MOVE.L  A0,Struct_PreallocHandleNode__BufferCursor(A3)

.post_fill_flags:
    MOVEQ   #Struct_PreallocHandleNode_OpenMask_ReadReject,D0
    AND.L   Struct_PreallocHandleNode__OpenFlags(A3),D0
    BEQ.S   .read_next_byte

    TST.B   D7
    BEQ.S   .set_remaining_eof

    MOVEQ   #-1,D0
    MOVE.L  D0,Struct_PreallocHandleNode__ReadRemaining(A3)
    BRA.S   .return_eof

.set_remaining_eof:
    MOVEQ   #0,D0
    MOVE.L  D0,Struct_PreallocHandleNode__ReadRemaining(A3)

.return_eof:
    MOVEQ   #-1,D0
    BRA.S   .return

.read_next_byte:
    SUBQ.L  #1,Struct_PreallocHandleNode__ReadRemaining(A3)
    BLT.S   .recurse_for_next

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .return

.recurse_for_next:
    MOVE.L  A3,-(A7)
    BSR.W   _STREAM_BufferedGetc

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======