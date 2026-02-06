;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_AllocRaster   (AllocRaster wrapper)
; ARGS:
;   stack +16: D7 = width
;   stack +20: D6 = height
; RET:
;   D0: raster pointer (or 0)
; CLOBBERS:
;   A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOAllocRaster
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Allocates a raster via graphics.library.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
UNKNOWN2B_AllocRaster:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  16(A5),D7   ; Width
    MOVE.L  20(A5),D6   ; Height

    MOVE.L  D7,D0       ; Width
    MOVE.L  D6,D1       ; Height
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOAllocRaster(A6)

    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_FreeRaster   (FreeRaster wrapper)
; ARGS:
;   stack +16: A3 = raster pointer
;   stack +20: D7 = width
;   stack +24: D6 = height
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A3/A6/A7/D0/D1/D6/D7
; CALLS:
;   _LVOFreeRaster
; READS:
;   GLOB_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Frees a raster via graphics.library.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
UNKNOWN2B_FreeRaster:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7
    MOVE.L  24(A5),D6

    MOVEA.L A3,A0
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L GLOB_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOFreeRaster(A6)

    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_OpenFileWithAccessMode   (Open wrapper)
; ARGS:
;   stack +8: A3 = filename pointer
;   stack +12: D7 = access mode
; RET:
;   D0: file handle (or 0)
; CLOBBERS:
;   A3/A6/A7/D0/D1/D2/D6/D7
; CALLS:
;   _LVOOpen
; READS:
;   GLOB_REF_DOS_LIBRARY_2
; WRITES:
;   (none observed)
; DESC:
;   Opens a file via dos.library using the provided access mode.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
UNKNOWN2B_OpenFileWithAccessMode:
    MOVEM.L D2/D6-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7

    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L GLOB_REF_DOS_LIBRARY_2,A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_Stub0   (Stub)
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
UNKNOWN2B_Stub0:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: UNKNOWN2B_Stub1   (Stub)
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
UNKNOWN2B_Stub1:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STREAM_BufferedWriteString   (Buffered write of stringuncertain)
; ARGS:
;   stack +8: A3 = string pointer
; RET:
;   D0: string length
; CLOBBERS:
;   A0/A1/A3/A4/A7/D0/D1/D6/D7
; CALLS:
;   STREAM_BufferedPutcOrFlush
; READS:
;   Global_A4_1074_Counter(A4), Global_A4_1082_Ptr(A4)
; WRITES:
;   Global_A4_1074_Counter(A4), Global_A4_1082_Ptr(A4), Global_A4_1086_Buffer(A4)
; DESC:
;   Writes a NUL-terminated string into a buffer, flushing via STREAM_BufferedPutcOrFlush on overflow.
; NOTES:
;   Uses DBF-style loop over bytes until NUL.
;------------------------------------------------------------------------------
STREAM_BufferedWriteString:
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

    SUBQ.L  #1,Global_A4_1074_Counter(A4)
    BLT.S   .flush_and_retry

    MOVEA.L Global_A4_1082_Ptr(A4),A0
    LEA     1(A0),A1
    MOVE.L  A1,Global_A4_1082_Ptr(A4)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    BRA.S   .write_loop

.flush_and_retry:
    MOVE.L  D7,D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    PEA     Global_A4_1086_Buffer(A4)
    MOVE.L  D1,-(A7)
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1
    BRA.S   .write_loop

.done:
    PEA     Global_A4_1086_Buffer(A4)
    PEA     -1.W
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STREAM_BufferedPutcOrFlush   (Buffered putc/flush handleruncertain)
; ARGS:
;   stack +12: arg_1 (via 16(A5))
;   stack +16: arg_2 (via 20(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   BUFFER_EnsureAllocated, DOS_WriteByIndex, DOS_SeekByIndex, DOS_ReadByIndex, STREAM_BufferedGetc
; READS:
;   A3+4/8/12/16/20/24/26/27/28, Global_HandleTableFlags(A4), Global_DosIoErr(A4)
; WRITES:
;   A3+4/8/12/27, Global_DosIoErr(A4)
; DESC:
;   Handles buffered output, flushing or writing directly based on flags and mode.
; NOTES:
;   Booleanize pattern: SNE/NEG/EXT. Uses 0x1A/0x0D handling.
;------------------------------------------------------------------------------
STREAM_BufferedPutcOrFlush:
    LINK.W  A5,#-20
    MOVEM.L D2/D4-D7/A3,-(A7)

    SetOffsetForStackAfterLink 20,6

    MOVE.L  .stackOffsetBytes+4(A7),D7
    MOVEA.L .stackOffsetBytes+8(A7),A3
    MOVE.L  D7,D4
    MOVEQ   #49,D0
    AND.L   24(A3),D0
    BEQ.S   .check_buffer_state

    MOVEQ   #-1,D0
    BRA.W   .return

.check_buffer_state:
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D6
    TST.L   20(A3)
    BNE.W   .direct_or_unbuffered

    BTST    #2,27(A3)
    BNE.S   .direct_or_unbuffered

    MOVEQ   #0,D0
    MOVE.L  D0,12(A3)
    MOVEQ   #-1,D1
    CMP.L   D1,D7
    BEQ.W   .return

    MOVE.L  A3,-(A7)
    JSR     BUFFER_EnsureAllocated(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .buffer_ready

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.buffer_ready:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .set_count_positive

    MOVE.L  20(A3),D0
    MOVE.L  D0,D1
    NEG.L   D1
    MOVE.L  D1,12(A3)
    BRA.S   .store_to_buffer

.set_count_positive:
    MOVE.L  20(A3),D0
    MOVE.L  D0,12(A3)

.store_to_buffer:
    SUBQ.L  #1,12(A3)
    BLT.S   .flush_and_retry

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
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
    BSR.W   STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.return_byte:
    MOVE.L  D1,D0
    BRA.W   .return

.direct_or_unbuffered:
    BTST    #2,27(A3)
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
    PEA     UNKNOWN2B_MovepReadCallback(PC)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .after_direct_write

.direct_write_one:
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  28(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5

.after_direct_write:
    MOVEQ   #-1,D7
    BRA.W   .post_write_status

.buffered_path:
    BSET    #1,27(A3)
    TST.B   D6
    BEQ.S   .flush_buffer

    MOVEQ   #-1,D0
    CMP.L   D0,D7
    BEQ.S   .flush_buffer

    ADDQ.L  #2,12(A3)
    MOVEQ   #10,D1
    CMP.L   D1,D7
    BNE.S   .store_char

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.B  #$d,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.S   .after_cr_flush

    MOVE.L  A3,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7

.after_cr_flush:
    ADDQ.L  #1,12(A3)

.store_char:
    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVE.L  12(A3),D1
    TST.L   D1
    BMI.W   .return

    MOVEQ   #-1,D7

.flush_buffer:
    MOVE.L  4(A3),D0
    SUB.L   16(A3),D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .no_pending_write

    BTST    #6,26(A3)
    BEQ.S   .write_buffer

    PEA     2.W
    CLR.L   -(A7)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_SeekByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,-20(A5)
    TST.B   D6
    BEQ.S   .write_buffer

.linefeed_loop:
    SUBQ.L  #1,-20(A5)
    BLT.S   .write_buffer

    CLR.L   -(A7)
    MOVE.L  -20(A5),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_SeekByIndex(PC)

    PEA     1.W
    PEA     -3(A5)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_ReadByIndex(PC)

    LEA     24(A7),A7
    TST.L   Global_DosIoErr(A4)
    BNE.S   .write_buffer

    MOVE.B  -3(A5),D0
    MOVEQ   #26,D1
    CMP.B   D1,D0
    BEQ.S   .linefeed_loop

.write_buffer:
    MOVE.L  -16(A5),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .post_write_status

.no_pending_write:
    MOVEQ   #0,D5

.post_write_status:
    MOVEQ   #-1,D0
    CMP.L   D0,D5
    BNE.S   .check_short_write

    BSET    #5,27(A3)
    BRA.S   .set_buffer_counters

.check_short_write:
    CMP.L   -16(A5),D5
    BEQ.S   .set_buffer_counters

    BSET    #4,27(A3)

.set_buffer_counters:
    TST.B   D6
    BEQ.S   .set_count_linebuffered

    MOVE.L  20(A3),D1
    MOVE.L  D1,D2
    NEG.L   D2
    MOVE.L  D2,12(A3)
    BRA.S   .reset_buffer_ptr

.set_count_linebuffered:
    BTST    #2,27(A3)
    BEQ.S   .set_count_normal

    MOVEQ   #0,D1
    MOVE.L  D1,12(A3)
    BRA.S   .reset_buffer_ptr

.set_count_normal:
    MOVE.L  20(A3),D1
    MOVE.L  D1,12(A3)

.reset_buffer_ptr:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)
    CMP.L   D0,D7
    BEQ.S   .final_checks

    SUBQ.L  #1,12(A3)
    BLT.S   .retry_after_full

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
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
    BSR.W   STREAM_BufferedPutcOrFlush

    ADDQ.W  #8,A7
    MOVE.L  D0,D1

.final_checks:
    MOVEQ   #48,D0
    AND.L   24(A3),D0
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
; FUNC: UNKNOWN2B_MovepReadCallback   (Callback: MOVEP.W 0(A2)->D6)
; ARGS:
;   A2 = source pointeruncertain
; RET:
;   D6: word loaded via MOVEP
; CLOBBERS:
;   D6
; CALLS:
;   none
; READS:
;   (A2)
; WRITES:
;   D6
; DESC:
;   Tiny helper used as a callback to read a word via MOVEP.
; NOTES:
;   Followed by padding word.
;------------------------------------------------------------------------------
UNKNOWN2B_MovepReadCallback:
    MOVEP.W 0(A2),D6
    DC.W    $0000

;!======
;------------------------------------------------------------------------------
; FUNC: STREAM_BufferedGetc   (Buffered read/getc handleruncertain)
; ARGS:
;   (none observed)
; RET:
;   D0: byte or -1 on error/EOF
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   STREAM_BufferedPutcOrFlush, BUFFER_EnsureAllocated, DOS_ReadByIndex
; READS:
;   A3+4/8/16/20/24/26/27/28
; WRITES:
;   A3+4/8/20/27
; DESC:
;   Ensures buffer is ready and returns next byte, refilling as needed.
; NOTES:
;   Handles 0x1A and 0x0D specially; uses SNE/NEG/EXT booleanization.
;------------------------------------------------------------------------------
STREAM_BufferedGetc:
    MOVEM.L D5-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    BTST    #7,26(A3)
    SNE     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,D7
    MOVEQ   #48,D0
    AND.L   24(A3),D0
    BEQ.S   .check_handle_flags

    CLR.L   8(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.check_handle_flags:
    BTST    #7,27(A3)
    BEQ.S   .maybe_flush_on_flags

    BTST    #6,27(A3)
    BEQ.S   .maybe_flush_on_flags

    MOVE.L  A3,-(A7)
    PEA     -1.W
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7

.maybe_flush_on_flags:
    TST.L   20(A3)
    BNE.S   .consume_buffered

    CLR.L   8(A3)
    BTST    #2,27(A3)
    BEQ.S   .ensure_buffer

    MOVEQ   #1,D0
    MOVE.L  D0,20(A3)
    LEA     32(A3),A0
    MOVE.L  A0,16(A3)
    BRA.W   .fill_buffer

.ensure_buffer:
    MOVE.L  A3,-(A7)
    JSR     BUFFER_EnsureAllocated(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .fill_buffer

    BSET    #5,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.consume_buffered:
    TST.B   D7
    BEQ.S   .fill_buffer

    ADDQ.L  #2,8(A3)
    MOVE.L  8(A3),D0
    TST.L   D0
    BGT.S   .fill_buffer

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D6
    MOVE.B  (A0),D6
    MOVE.L  D6,D0
    CMPI.L  #$1a,D0
    BEQ.S   .handle_ctrl_z

    CMPI.L  #$d,D0
    BNE.S   .return_char

    SUBQ.L  #1,8(A3)
    BLT.S   .retry_after_empty

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.W   .return

.retry_after_empty:
    MOVE.L  A3,-(A7)
    BSR.W   STREAM_BufferedGetc

    ADDQ.W  #4,A7
    BRA.W   .return

.handle_ctrl_z:
    BSET    #4,27(A3)
    MOVEQ   #-1,D0
    BRA.W   .return

.return_char:
    MOVE.L  D6,D0
    BRA.W   .return

.fill_buffer:
    BTST    #1,27(A3)
    BNE.S   .post_fill_flags

    BSET    #0,27(A3)
    MOVE.L  20(A3),-(A7)
    MOVE.L  16(A3),-(A7)
    MOVE.L  28(A3),-(A7)
    JSR     DOS_ReadByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    TST.L   D5
    BPL.S   .mark_error

    BSET    #5,27(A3)

.mark_error:
    TST.L   D5
    BNE.S   .mark_eof

    BSET    #4,27(A3)

.mark_eof:
    TST.L   D5
    BLE.S   .post_fill_flags

    TST.B   D7
    BEQ.S   .set_remaining_neg

    MOVE.L  D5,D0
    NEG.L   D0
    MOVE.L  D0,8(A3)
    BRA.S   .set_buffer_ptr

.set_remaining_neg:
    MOVE.L  D5,8(A3)

.set_buffer_ptr:
    MOVEA.L 16(A3),A0
    MOVE.L  A0,4(A3)

.post_fill_flags:
    MOVEQ   #50,D0
    AND.L   24(A3),D0
    BEQ.S   .read_next_byte

    TST.B   D7
    BEQ.S   .set_remaining_eof

    MOVEQ   #-1,D0
    MOVE.L  D0,8(A3)
    BRA.S   .return_eof

.set_remaining_eof:
    MOVEQ   #0,D0
    MOVE.L  D0,8(A3)

.return_eof:
    MOVEQ   #-1,D0
    BRA.S   .return

.read_next_byte:
    SUBQ.L  #1,8(A3)
    BLT.S   .recurse_for_next

    MOVEA.L 4(A3),A0
    LEA     1(A0),A1
    MOVE.L  A1,4(A3)
    MOVEQ   #0,D0
    MOVE.B  (A0),D0
    BRA.S   .return

.recurse_for_next:
    MOVE.L  A3,-(A7)
    BSR.W   STREAM_BufferedGetc

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
