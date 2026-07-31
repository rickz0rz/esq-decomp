    XDEF    _LADFUNC_LoadTextAdsFromFile


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_LoadTextAdsFromFile   (Load text ads from fileuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   _LADFUNC_ComposePackedPenByte, _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer, _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer, _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer, _LADFUNC_ParseHexDigit,
;   _LADFUNC_SetPackedPenHighNibble, _LADFUNC_SetPackedPenLowNibble, _NEWGRID_JMPTBL_MEMORY_AllocateMemory,
;   _NEWGRID_JMPTBL_MEMORY_DeallocateMemory, _LADFUNC_ResetEntryTextBuffers
; READS:
;   _Global_REF_LONG_FILE_SCRATCH, _Global_PTR_WORK_BUFFER, _LADFUNC_EntryPtrTable
; WRITES:
;   (none observed)
; DESC:
;   Reads encoded entry data and rebuilds per-entry text and attribute buffers.
; NOTES:
;   Control code 3 carries hex nibbles that update the attribute byte.
;------------------------------------------------------------------------------
_LADFUNC_LoadTextAdsFromFile:
    LINK.W  A5,#-40
    MOVEM.L D2/D4-D7,-(A7)

    PEA     1.W
    PEA     2.W
    BSR.W   _LADFUNC_ComposePackedPenByte

    PEA     _KYBD_PATH_DF0_LOCAL_ADS
    MOVE.B  D0,-29(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_LoadFileToWorkBuffer(PC)

    LEA     12(A7),A7
    ADDQ.L  #1,D0
    BNE.S   .file_opened

    MOVEQ   #-1,D0
    BRA.W   .return

.file_opened:
    MOVE.L  _Global_REF_LONG_FILE_SCRATCH,D6
    MOVE.L  _Global_PTR_WORK_BUFFER,-12(A5)
    BSR.W   _LADFUNC_ResetEntryTextBuffers

    MOVEQ   #0,D7

.entry_loop:
    MOVEQ   #46,D0
    CMP.L   D0,D7
    BGE.W   .free_file_buffer

    MOVE.L  D7,D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,(A0)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ParseLongFromWorkBuffer(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  D0,2(A0)
    JSR     _GROUP_AY_JMPTBL_DISKIO_ConsumeCStringFromWorkBuffer(PC)

    MOVEA.L D0,A0

.scan_encoded_end:
    TST.B   (A0)+
    BNE.S   .scan_encoded_end

    SUBQ.L  #1,A0
    SUBA.L  D0,A0
    MOVE.L  A0,D4
    MOVE.L  D0,-34(A5)
    MOVE.L  D0,-8(A5)

.measure_text_len:
    TST.L   D4
    BLE.S   .alloc_or_free

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.S   .alloc_or_free

    MOVEQ   #3,D0
    CMP.B   (A0),D0
    BNE.S   .advance_len_ptr

    SUBQ.L  #3,D4
    ADDQ.L  #2,-34(A5)

.advance_len_ptr:
    ADDQ.L  #1,-34(A5)
    BRA.S   .measure_text_len

.alloc_or_free:
    TST.L   D4
    BLE.W   .free_existing_buffers

    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D0,-(A7)
    PEA     591.W
    PEA     _Global_STR_LADFUNC_C_9
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,6(A0)
    TST.L   D0
    BNE.S   .alloc_attr_buffer

    MOVEQ   #-1,D0
    BRA.W   .return

.alloc_attr_buffer:
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    MOVE.L  D4,-(A7)
    PEA     600.W
    PEA     _Global_STR_LADFUNC_C_10
    JSR     _NEWGRID_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    MOVE.L  D0,10(A0)
    BNE.S   .decode_loop

    MOVEQ   #-1,D0
    BRA.W   .return

.decode_loop:
    MOVEQ   #0,D5
    MOVE.L  -8(A5),-34(A5)

.decode_loop_next:
    CMP.L   D4,D5
    BGE.W   .finish_entry

    MOVEA.L -34(A5),A0
    TST.B   (A0)
    BEQ.W   .finish_entry

    MOVE.B  (A0),D0
    MOVEQ   #3,D1
    CMP.B   D1,D0
    BNE.S   .emit_char

    ADDQ.L  #1,-34(A5)
    MOVEA.L -34(A5),A0
    MOVE.B  (A0)+,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  A0,-34(A5)
    BSR.W   _LADFUNC_ParseHexDigit

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #0,D0
    MOVE.B  -29(A5),D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,-(A7)
    BSR.W   _LADFUNC_SetPackedPenHighNibble

    MOVE.L  -34(A5),-34(A5)
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L -34(A5),A0
    MOVE.B  (A0),D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.B  D0,-29(A5)
    MOVE.L  D1,28(A7)
    BSR.W   _LADFUNC_ParseHexDigit

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,(A7)
    MOVE.L  28(A7),-(A7)
    BSR.W   _LADFUNC_SetPackedPenLowNibble

    LEA     12(A7),A7
    MOVE.B  D0,-29(A5)
    BRA.S   .advance_decode_ptr

.emit_char:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    ADDA.L  D5,A0
    MOVE.B  D0,(A0)
    MOVEA.L 10(A1),A0
    ADDA.L  D5,A0
    ADDQ.L  #1,D5
    MOVE.B  -29(A5),(A0)

.advance_decode_ptr:
    ADDQ.L  #1,-34(A5)
    BRA.W   .decode_loop_next

.finish_entry:
    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0
    MOVEA.L A0,A1
    ADDA.L  D5,A1
    CLR.B   (A1)
    BRA.S   .next_entry

.free_existing_buffers:
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BEQ.S   .next_entry

    MOVEA.L -4(A5),A1
    MOVEA.L 6(A1),A0

.scan_existing_len:
    TST.B   (A0)+
    BNE.S   .scan_existing_len

    SUBQ.L  #1,A0
    SUBA.L  6(A1),A0
    MOVE.L  A0,D4
    MOVE.L  D4,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  6(A1),-(A7)
    PEA     638.W
    PEA     _Global_STR_LADFUNC_C_11
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    SUBA.L  A0,A0
    MOVEA.L -4(A5),A1
    MOVE.L  A0,6(A1)
    TST.L   10(A1)
    BEQ.S   .next_entry

    MOVE.L  D4,-(A7)
    MOVE.L  10(A1),-(A7)
    PEA     642.W
    PEA     _Global_STR_LADFUNC_C_12
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    MOVEA.L -4(A5),A0
    CLR.L   10(A0)

.next_entry:
    ADDQ.L  #1,D7
    BRA.W   .entry_loop

.free_file_buffer:
    MOVE.L  D6,D0
    ADDQ.L  #1,D0
    MOVE.L  D0,-(A7)
    MOVE.L  -12(A5),-(A7)
    PEA     653.W
    PEA     _Global_STR_LADFUNC_C_13
    JSR     _NEWGRID_JMPTBL_MEMORY_DeallocateMemory(PC)

    MOVEQ   #0,D0

.return:
    MOVEM.L -60(A5),D2/D4-D7

    UNLK    A5
    RTS

;!======