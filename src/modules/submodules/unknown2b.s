    XDEF    STREAM_BufferedGetc
    XDEF    STREAM_BufferedPutcOrFlush
    XDEF    STREAM_BufferedWriteString
    XDEF    GRAPHICS_AllocRaster
    XDEF    GRAPHICS_FreeRaster
    XDEF    DOS_MovepWordReadCallback
    XDEF    DOS_OpenFileWithMode
    XDEF    ESQ_MainEntryNoOpHook
    XDEF    ESQ_MainExitNoOpHook

;!======
;------------------------------------------------------------------------------
; FUNC: GRAPHICS_AllocRaster   (AllocRaster wrapper)
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
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Allocates a raster via graphics.library.
; NOTES:
;   Thin wrapper used by brush/display setup code.
;------------------------------------------------------------------------------
GRAPHICS_AllocRaster:
    LINK.W  A5,#-4
    MOVEM.L D6-D7,-(A7)
    MOVE.L  16(A5),D7   ; Width
    MOVE.L  20(A5),D6   ; Height

    MOVE.L  D7,D0       ; Width
    MOVE.L  D6,D1       ; Height
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOAllocRaster(A6)

    MOVEM.L (A7)+,D6-D7
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: GRAPHICS_FreeRaster   (FreeRaster wrapper)
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
;   Global_REF_GRAPHICS_LIBRARY
; WRITES:
;   (none observed)
; DESC:
;   Frees a raster via graphics.library.
; NOTES:
;   Thin wrapper paired with GRAPHICS_AllocRaster.
;------------------------------------------------------------------------------
GRAPHICS_FreeRaster:
    LINK.W  A5,#0
    MOVEM.L D6-D7/A3,-(A7)

    MOVEA.L 16(A5),A3
    MOVE.L  20(A5),D7
    MOVE.L  24(A5),D6

    MOVEA.L A3,A0
    MOVE.L  D7,D0
    MOVE.L  D6,D1
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOFreeRaster(A6)

    MOVEM.L (A7)+,D6-D7/A3
    UNLK    A5
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: DOS_OpenFileWithMode   (DOS Open wrapper)
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
;   Global_REF_DOS_LIBRARY_2
; WRITES:
;   (none observed)
; DESC:
;   Opens a file via dos.library using the provided access mode.
; NOTES:
;   Direct pass-through to dos.library Open(name, mode).
;------------------------------------------------------------------------------
DOS_OpenFileWithMode:
    MOVEM.L D2/D6-D7/A3,-(A7)

    SetOffsetForStack 4

    MOVEA.L .stackOffsetBytes+4(A7),A3
    MOVE.L  .stackOffsetBytes+8(A7),D7

    MOVE.L  A3,D1
    MOVE.L  D7,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOOpen(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: ESQ_MainEntryNoOpHook   (Main pre-run no-op hook)
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
;   Reserved pre-run hook; currently no-op.
; NOTES:
;   Called immediately before ESQ_ParseCommandLineAndRun.
;------------------------------------------------------------------------------
ESQ_MainEntryNoOpHook:
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: ESQ_MainExitNoOpHook   (Main shutdown no-op hook)
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
;   Reserved shutdown hook; currently no-op.
; NOTES:
;   Called after cleanup and dos.library close.
;------------------------------------------------------------------------------
ESQ_MainExitNoOpHook:
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
;   Global_PreallocHandleNode1_WriteRemaining(A4), Global_PreallocHandleNode1_BufferCursor(A4)
; WRITES:
;   Global_PreallocHandleNode1_WriteRemaining(A4),
;   Global_PreallocHandleNode1_BufferCursor(A4),
;   Global_PreallocHandleNode1(A4)
; DESC:
;   Writes a NUL-terminated string into a buffer, flushing via STREAM_BufferedPutcOrFlush on overflow.
; NOTES:
;   Uses a byte-at-a-time loop until NUL.
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
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D1
    BRA.S   .write_loop

.done:
    PEA     Global_PreallocHandleNode1(A4)
    PEA     -1.W
    JSR     STREAM_BufferedPutcOrFlush(PC)

    ADDQ.W  #8,A7
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======
;------------------------------------------------------------------------------
; FUNC: STREAM_BufferedPutcOrFlush   (Buffered putc/flush handler)
; ARGS:
;   stack +12: D7 = byte to write, or -1 to flush
;   stack +16: A3 = prealloc/dynamic handle node
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A3/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   BUFFER_EnsureAllocated, DOS_WriteByIndex, DOS_SeekByIndex, DOS_ReadByIndex, STREAM_BufferedGetc
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
STREAM_BufferedPutcOrFlush:
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
    JSR     BUFFER_EnsureAllocated(PC)

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
    BSR.W   STREAM_BufferedPutcOrFlush

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
    PEA     DOS_MovepWordReadCallback(PC)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     DOS_WriteByIndex(PC)

    LEA     12(A7),A7
    MOVE.L  D0,D5
    BRA.S   .after_direct_write

.direct_write_one:
    MOVEQ   #1,D1
    MOVE.L  D1,-(A7)
    PEA     -1(A5)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    MOVE.L  D1,-16(A5)
    JSR     DOS_WriteByIndex(PC)

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
    BSR.W   STREAM_BufferedPutcOrFlush

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
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
    JSR     DOS_SeekByIndex(PC)

    PEA     1.W
    PEA     -3(A5)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
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
    MOVE.L  Struct_PreallocHandleNode__BufferBase(A3),-(A7)
    MOVE.L  Struct_PreallocHandleNode__HandleIndex(A3),-(A7)
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
    BSR.W   STREAM_BufferedPutcOrFlush

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
; FUNC: DOS_MovepWordReadCallback   (Callback: MOVEP.W 0(A2)->D6)
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
;   Used by translated newline path so DOS_WriteByIndex can fetch a 2-byte word.
;   Followed by padding word.
;------------------------------------------------------------------------------
DOS_MovepWordReadCallback:
    MOVEP.W 0(A2),D6
    DC.W    $0000

;!======
;------------------------------------------------------------------------------
; FUNC: STREAM_BufferedGetc   (Buffered read/getc handler)
; ARGS:
;   (none observed)
; RET:
;   D0: byte or -1 on error/EOF
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   STREAM_BufferedPutcOrFlush, BUFFER_EnsureAllocated, DOS_ReadByIndex
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
STREAM_BufferedGetc:
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
    JSR     STREAM_BufferedPutcOrFlush(PC)

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
    JSR     BUFFER_EnsureAllocated(PC)

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
    BSR.W   STREAM_BufferedGetc

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
    JSR     DOS_ReadByIndex(PC)

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
    BSR.W   STREAM_BufferedGetc

    ADDQ.W  #4,A7

.return:
    MOVEM.L (A7)+,D5-D7/A3
    RTS

;!======

    ; Alignment
    ALIGN_WORD
