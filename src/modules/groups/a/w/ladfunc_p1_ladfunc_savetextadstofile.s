    XDEF    _LADFUNC_SaveTextAdsToFile


;------------------------------------------------------------------------------
; FUNC: _LADFUNC_SaveTextAdsToFile   (Save text ads to fileuncertain)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D4/D5/D6/D7
; CALLS:
;   _LADFUNC_ComposePackedPenByte, _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer,
;   _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField, _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes, _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush, _GROUP_AW_JMPTBL_WDISP_SPrintf
; READS:
;   _DISKIO_SaveOperationReadyFlag, _KYBD_PATH_DF0_LOCAL_ADS, _LADFUNC_FMT_AttrEscapePrefixCharHex, _LADFUNC_TextAdLineBreakBuffer, _LADFUNC_EntryPtrTable, _LADFUNC_SaveAdsFileHandle
; WRITES:
;   _DISKIO_SaveOperationReadyFlag, _LADFUNC_SaveAdsFileHandle
; DESC:
;   Encodes entry text/attribute data and writes it to a file.
; NOTES:
;   Emits attribute changes using _LADFUNC_FMT_AttrEscapePrefixCharHex and terminates entries with _LADFUNC_TextAdLineBreakBuffer.
;------------------------------------------------------------------------------
_LADFUNC_SaveTextAdsToFile:
    LINK.W  A5,#-36
    MOVEM.L D4-D7,-(A7)
    PEA     1.W
    PEA     2.W
    BSR.W   _LADFUNC_ComposePackedPenByte

    ADDQ.W  #8,A7
    MOVE.B  D0,-25(A5)
    TST.L   _DISKIO_SaveOperationReadyFlag
    BNE.S   .open_file

    MOVEQ   #0,D0
    BRA.W   .return

.open_file:
    CLR.L   _DISKIO_SaveOperationReadyFlag
    CLR.B   -15(A5)
    PEA     MODE_NEWFILE.W
    PEA     _KYBD_PATH_DF0_LOCAL_ADS
    JSR     _GROUP_AY_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_LADFUNC_SaveAdsFileHandle
    TST.L   D0
    BNE.S   .start_entry_loop

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag
    MOVEQ   #-1,D0
    BRA.W   .return

.start_entry_loop:
    MOVEQ   #0,D6

.entry_loop:
    MOVEQ   #46,D0
    CMP.W   D0,D6
    BGE.W   .close_file

    MOVE.L  D6,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _LADFUNC_EntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-4(A5)
    MOVEA.L -4(A5),A0
    MOVE.W  (A0),D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    MOVEA.L -4(A5),A0
    MOVE.W  2(A0),D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteDecimalField(PC)

    LEA     12(A7),A7
    MOVEA.L -4(A5),A0
    TST.L   6(A0)
    BNE.S   .use_entry_text

    LEA     -15(A5),A1
    MOVE.L  A1,-8(A5)
    BRA.S   .text_ptr_ready

.use_entry_text:
    MOVEA.L 6(A0),A0
    MOVE.L  A0,-8(A5)

.text_ptr_ready:
    MOVEA.L -8(A5),A0

.scan_text_end:
    TST.B   (A0)+
    BNE.S   .scan_text_end

    SUBQ.L  #1,A0
    SUBA.L  -8(A5),A0
    MOVE.L  A0,D7
    MOVEQ   #0,D4
    MOVE.L  D4,D5

.segment_loop:
    CMP.L   D7,D5
    BGE.W   .write_linebreak

    CMP.L   D4,D7
    BEQ.S   .flush_segment

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),D0
    MOVE.B  -25(A5),D1
    CMP.B   D1,D0
    BEQ.S   .next_char

.flush_segment:
    TST.L   D4
    BLE.S   .update_attr

    MOVEQ   #0,D0
    MOVE.B  -25(A5),D0
    MOVE.L  D0,-(A7)
    PEA     3.W
    PEA     _LADFUNC_FMT_AttrEscapePrefixCharHex
    PEA     -35(A5)
    JSR     _GROUP_AW_JMPTBL_WDISP_SPrintf(PC)

    LEA     -35(A5),A0
    MOVEA.L A0,A1

.fmt_len_loop:
    TST.B   (A1)+
    BNE.S   .fmt_len_loop

    SUBQ.L  #1,A1
    SUBA.L  A0,A1
    MOVE.L  A1,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVEA.L -8(A5),A0
    ADDA.L  D5,A0
    MOVE.L  D4,D0
    SUB.L   D5,D0
    MOVE.L  D0,(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     32(A7),A7
    MOVE.L  D4,D5

.update_attr:
    CMP.L   D7,D5
    BGE.S   .next_char

    MOVEA.L -4(A5),A1
    MOVEA.L 10(A1),A0
    ADDA.L  D4,A0
    MOVE.B  (A0),-25(A5)

.next_char:
    ADDQ.L  #1,D4
    BRA.W   .segment_loop

.write_linebreak:
    PEA     1.W
    PEA     _LADFUNC_TextAdLineBreakBuffer
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    LEA     12(A7),A7
    ADDQ.W  #1,D6
    BRA.W   .entry_loop

.close_file:
    MOVE.L  _LADFUNC_SaveAdsFileHandle,-(A7)
    JSR     _GROUP_AY_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    MOVEQ   #1,D0
    MOVE.L  D0,_DISKIO_SaveOperationReadyFlag

.return:
    MOVEM.L -52(A5),D4-D7
    UNLK    A5
    RTS

;!======