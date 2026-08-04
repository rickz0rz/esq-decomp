    XDEF    _STREAM_BufferedGetc
    XDEF    _STREAM_BufferedPutcOrFlush
    XDEF    DOS_STR_CRLF

;------------------------------------------------------------------------------
; FUNC: _STREAM_BufferedPutcOrFlush   (Buffered putc/flush handler)
; ARGS:
;   stack +12: D7 = byte to write, or -1 to flush
;   stack +16: A3 = prealloc/dynamic handle node
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _BUFFER_EnsureAllocated, _DOS_WriteByIndex, _DOS_SeekByIndex, _DOS_ReadByIndex, _STREAM_BufferedGetc
; READS:
;   Struct_PreallocHandleNode__BufferCursor/WriteRemaining/BufferBase/BufferCapacity/OpenFlags/ModeFlags/StateFlags/HandleIndex,
;   Global_DosIoErr(A4)
; WRITES:
;   Struct_PreallocHandleNode__BufferCursor/ReadRemaining/WriteRemaining/StateFlags,
;   Global_DosIoErr(A4)
; DESC:
;   Writes one byte or flushes pending bytes for a handle node, handling
;   buffered, unbuffered, and translated-CR/LF modes.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT. Uses 0x1A/0x0D handling.
;   `ModeFlags bit7` toggles translated CR/LF mode; `ModeFlags bit6` gates
;   pre-write backward scan around Ctrl-Z.
;------------------------------------------------------------------------------
_STREAM_BufferedPutcOrFlush:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)

    SetOffsetForStackAfterLink 20,6

    MOVE.L  .stackOffsetBytes+4(A7),D7
    MOVEA.L .stackOffsetBytes+8(A7),A3
    MOVE.L  D7,D4
    MOVEQ   #Struct_PreallocHandleNode_OpenMask_WriteReject,D0
    AND.L   Struct_PreallocHandleNode__OpenFlags(A3),D0
    BEQ.S   .check_buffer_state

    MOVEQ   #-1,D0
    BRA.W   .return

.check_buffer_state:
    BTST    #Struct_PreallocHandleNode_ModeFlag_TextTranslate_Bit,Struct_PreallocHandleNode__ModeFlags(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    TST.L   Struct_PreallocHandleNode__BufferCapacity(A3)
    BNE.W   .direct_or_unbuffered

    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BNE.S   .direct_or_unbuffered

    MOVEQ   #0,D0
    MOVE.L  D0,Struct_PreallocHandleNode__WriteRemaining(A3)
    MOVEQ   #-1,D1
    CMP.L   D1,D7
    BEQ.W   .return

    MOVE.L  A3,-(A7)
    JSR     _BUFFER_EnsureAllocated(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .buffer_ready

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit5_IoError_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.buffer_ready:
    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    TST.B   D6
    BEQ.S   .set_count_positive

    MOVE.L  Struct_PreallocHandleNode__BufferCapacity(A3),D0
    MOVE.L  D0,D1
    NEG.L   D1
    MOVE.L  D1,Struct_PreallocHandleNode__WriteRemaining(A3)
    BRA.S   .store_to_buffer

.set_count_positive:
    MOVE.L  Struct_PreallocHandleNode__BufferCapacity(A3),D0
    MOVE.L  D0,Struct_PreallocHandleNode__WriteRemaining(A3)

.store_to_buffer:
    SUBQ.L  #1,Struct_PreallocHandleNode__WriteRemaining(A3)
    BLT.S   .flush_and_retry

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .return_byte

.flush_and_retry:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.return_byte:
    MOVE.L  D1,D0
    BRA.W   .return

.direct_or_unbuffered:
    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .buffered_path

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BNE.S   .direct_write_byte

    MOVEQ   #0,D0
    BRA.W   .return

.direct_write_byte:
    MOVE.L  D7,D0
    MOVE.B  D0,-1(A5)
    TST.B   D6
    BEQ.S   .direct_write_one

    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .direct_write_one

    MOVEQ   #2,D1
    MOVE.L  D1,-(A7)
    PEA     DOS_STR_CRLF(PC)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     _DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .after_direct_write

.direct_write_one:
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     _DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

.after_direct_write:
    MOVEQ   #-1,D7
    BRA.W   .post_write_status

.buffered_path:
    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit1_WritePending_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    TST.B   D6
    BEQ.S   .flush_buffer

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .flush_buffer

    ADDQ.L  #2,Struct_PreallocHandleNode__WriteRemaining(A3)
    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .store_char

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVE.B  #$d,(A0)
    MOVE.L  Struct_PreallocHandleNode__WriteRemaining(A3),D1
    TST.L   D1
    BMI.S   .after_cr_flush

    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   _STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7

.after_cr_flush:
    ADDQ.L  #1,Struct_PreallocHandleNode__WriteRemaining(A3)

.store_char:
    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVE.L  Struct_PreallocHandleNode__WriteRemaining(A3),D1
    TST.L   D1
    BMI.W   .return

    MOVEQ   #-1,D7

.flush_buffer:
    MOVE.L  Struct_PreallocHandleNode__BufferCursor(A3),D0
    SUB.L   Struct_PreallocHandleNode__BufferBase(A3),D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .no_pending_write

    BTST    #Struct_PreallocHandleNode_ModeFlag_PreWriteScan_Bit,Struct_PreallocHandleNode__ModeFlags(A3)
    BEQ.S   .write_buffer

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     _DOS_SeekByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    TST.B   D6
    BEQ.S   .write_buffer

.linefeed_loop:
    SUBQ.L  #1,-20(A5)
    BLT.S   .write_buffer

    CLR.L   -(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     _DOS_SeekByIndex(PC)

    PEA     1.W
    PEA     -3(A5)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     _DOS_ReadByIndex(PC)

    LEA     24(A7),A7
    TST.L   Global_DosIoErr(A4)
    BNE.S   .write_buffer

    MOVE.B  -3(A5),D0
    MOVEQ   #26,D1
    CMP.B   D1,D0
    BEQ.S   .linefeed_loop

.write_buffer:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  Struct_PreallocHandleNode__BufferBase(A3),-(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     _DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .post_write_status

.no_pending_write:
    MOVEQ   #0,D5

.post_write_status:
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .check_short_write

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit5_IoError_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BRA.S   .set_buffer_counters

.check_short_write:
    CMP.L   -16(A5),D5
    BEQ.S   .set_buffer_counters

    BSET    #Struct_PreallocHandleNode_OpenFlagsLowBit4_EofOrShort_Bit,Struct_PreallocHandleNode__StateFlags(A3)

.set_buffer_counters:
    TST.B   D6
    BEQ.S   .set_count_linebuffered

    MOVE.L  Struct_PreallocHandleNode__BufferCapacity(A3),D1
    MOVE.L  D1,D2
    NEG.L   D2
    MOVE.L  D2,Struct_PreallocHandleNode__WriteRemaining(A3)
    BRA.S   .reset_buffer_ptr

.set_count_linebuffered:
    BTST    #Struct_PreallocHandleNode_OpenFlagsLowBit2_Unbuffered_Bit,Struct_PreallocHandleNode__StateFlags(A3)
    BEQ.S   .set_count_normal

    MOVEQ   #0,D1
    MOVE.L  D1,Struct_PreallocHandleNode__WriteRemaining(A3)
    BRA.S   .reset_buffer_ptr

.set_count_normal:
    MOVE.L  Struct_PreallocHandleNode__BufferCapacity(A3),D1
    MOVE.L  D1,Struct_PreallocHandleNode__WriteRemaining(A3)

.reset_buffer_ptr:
    MOVEA.L Struct_PreallocHandleNode__BufferBase(A3),A0
    MOVE.L  A0,Struct_PreallocHandleNode__BufferCursor(A3)
    CMP.L   D0,D7
    BEQ.S   .final_checks

    SUBQ.L  #1,Struct_PreallocHandleNode__WriteRemaining(A3)
    BLT.S   .retry_after_full

    MOVEA.L Struct_PreallocHandleNode__BufferCursor(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,Struct_PreallocHandleNode__BufferCursor(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .final_checks

.retry_after_full:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  A3,-(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.final_checks:
    MOVEQ   #Struct_PreallocHandleNode_OpenMask_FlushReject,D0
    AND.L   Struct_PreallocHandleNode__OpenFlags(A3),D0
    BEQ.S   .check_flags_return

    MOVEQ   #-1,D0
    BRA.S   .return

.check_flags_return:
    MOVEQ   #-1,D0
    CMP.L   D0,D4
    BNE.S   .return_value

    MOVEQ   #0,D0
    BRA.S   .return

.return_value:
    MOVE.L  D4,D0

.return:
    MOVEM.L (A7)+,D2/D4-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; DATA: DOS_STR_CRLF   (the two bytes CR LF, plus alignment)
;
; THIS IS NOT CODE AND IT IS NOT A CALLBACK. The disassembly named it
; DOS_MovepWordReadCallback and rendered its first word as `MOVEP.W 0(A2),D6`,
; but MOVEP.W (d16,A2),D6 encodes as $0D0A -- which is CR LF. It is the
; line-ending constant the text-translate path writes.
;
; Its ONE use proves it. _STREAM_BufferedPutcOrFlush reaches it by ADDRESS, not
; by call, and hands it to DOS_WriteByIndex with a length of 2:
;
;     MOVEQ   #2,D1
;     MOVE.L  D1,-(A7)                ; length = 2
;     PEA     DOS_STR_CRLF(PC)        ; buffer
;     MOVE.L  ...HandleIndex(A3),-(A7)
;     JSR     _DOS_WriteByIndex(PC)
;
; A callback would be reached with JSR and would not be passed a length.
;
; The bytes are unchanged: DC.B 13,10 is $0D0A, and the two zero words that
; follow are the same padding the MOVEP displacement word and the trailing
; DC.W accounted for. Both gates stay green across this relabelling.
;------------------------------------------------------------------------------
DOS_STR_CRLF:
    DC.B    13,10
    DC.W    $0000
    DC.W    $0000

;!======
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

    ; Alignment
    ALIGN_WORD
