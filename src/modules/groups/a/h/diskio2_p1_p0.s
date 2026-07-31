    XDEF    _DISKIO2_ReceiveTransferBlocksToFile


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_ReceiveTransferBlocksToFile   (Receive data block and write to disk.)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +7: arg_2 (via 11(A5))
;   stack +10: arg_3 (via 14(A5))
;   stack +11: arg_4 (via 15(A5))
;   stack +12: arg_5 (via 16(A5))
;   stack +1036: arg_6 (via 1040(A5))
;   stack +1060: arg_7 (via 1064(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi, _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte, _DISKIO_WriteBytesToOutputHandleGuarded, _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay, _DISKIO_DrawTransferErrorMessageIfDiagnostics, _LVODeleteFile
; READS:
;   _DISKIO2_TransferBlockLength.._DISKIO2_TransferCrcErrorCount, _ESQIFF_ParseAttemptCount, _DISKIO2_TransferXorChecksumByte
; WRITES:
;   _DISKIO2_TransferBlockLength.._DISKIO2_TransferCrcErrorCount, _ESQIFF_ParseAttemptCount
; DESC:
;   Reads a variable-length data stream with checksum tracking and writes it out.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_ReceiveTransferBlocksToFile:
    LINK.W  A5,#-1040
    MOVEM.L D2-D7,-(A7)

    MOVE.B  11(A5),D7
    MOVEQ   #-1,D0
    MOVE.L  D0,-10(A5)
    CLR.L   -14(A5)
    CLR.B   -16(A5)
    LEA     _DISKIO2_TransferCrc32Table,A0
    LEA     -1040(A5),A1
    MOVE.W  #$ff,D0

.blockrx_init_crc_table_copy_loop:
    MOVE.L  (A0)+,(A1)+
    DBF     D0,.blockrx_init_crc_table_copy_loop

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D4
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_ESQIFF_ParseAttemptCount
    MOVE.B  _DISKIO2_TransferBlockSequence,D0
    CMP.B   D0,D4
    BNE.W   .blockrx_unexpected_sequence

    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,_DISKIO2_TransferXorChecksumByte
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_DISKIO2_TransferBlockLength
    TST.B   D0
    BEQ.W   .blockrx_handle_zero_length_block

    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,_DISKIO2_TransferXorChecksumByte
    MOVE.W  _DISKIO2_TransferBufferedByteCount,D5
    MOVEQ   #0,D6

    ; Stream in payload bytes and fold into checksum.
.blockrx_payload_byte_loop:
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  _DISKIO2_TransferBlockLength,D1
    CMP.L   D1,D0
    BEQ.S   .blockrx_after_payload

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.L  D0,D4
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D0
    EOR.B   D4,D0
    MOVE.B  D0,_DISKIO2_TransferXorChecksumByte
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    MOVE.L  -10(A5),D1
    EOR.L   D1,D0
    MOVEQ   #0,D2
    NOT.B   D2
    AND.L   D2,D0
    ASL.L   #2,D0
    LEA     -1040(A5),A0
    ADDA.L  D0,A0
    LSR.L   #8,D1
    MOVE.L  (A0),D0
    EOR.L   D1,D0
    MOVE.L  D5,D1
    ADDQ.W  #1,D5
    MOVEA.L _DISKIO2_TransferBlockBufferPtr,A0
    ADDA.W  D1,A0
    MOVE.B  D4,(A0)
    MOVE.L  D0,-10(A5)
    ADDQ.W  #1,D6
    BRA.S   .blockrx_payload_byte_loop

.blockrx_after_payload:
    TST.B   D7
    BEQ.S   .blockrx_verify_record_checksum

    CLR.L   -14(A5)
    MOVEQ   #0,D6

.blockrx_read_crc32_loop:
    MOVEQ   #4,D0
    CMP.W   D0,D6
    BGE.S   .blockrx_verify_crc32

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,_DISKIO2_TransferXorChecksumByte
    MOVE.L  -14(A5),D1
    ASL.L   #8,D1
    MOVEQ   #0,D2
    MOVE.B  D0,D2
    MOVEQ   #0,D3
    NOT.B   D3
    AND.L   D3,D2
    OR.L    D2,D1
    MOVE.B  D0,-15(A5)
    MOVE.L  D1,-14(A5)
    ADDQ.W  #1,D6
    BRA.S   .blockrx_read_crc32_loop

.blockrx_verify_crc32:
    MOVE.L  -10(A5),D0
    CMP.L   -14(A5),D0
    BEQ.S   .blockrx_verify_record_checksum

    MOVEQ   #1,D0
    MOVE.B  D0,-16(A5)

.blockrx_verify_record_checksum:
    TST.B   -16(A5)
    BNE.S   .blockrx_mark_crc_error

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.W   .blockrx_continue_transfer

    MOVE.W  D5,_DISKIO2_TransferBufferedByteCount
    CMPI.W  #$1000,D5
    BLT.S   .blockrx_advance_sequence

    MOVE.L  D5,D0
    MOVE.W  D0,_DISKIO2_TransferBufferedByteCount
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_TransferBlockBufferPtr,-(A7)
    JSR     _DISKIO_WriteBytesToOutputHandleGuarded(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .blockrx_flush_buffer_success

    MOVEQ   #2,D0
    BRA.W   .blockrx_return

.blockrx_flush_buffer_success:
    CLR.W   _DISKIO2_TransferBufferedByteCount

.blockrx_advance_sequence:
    MOVE.B  _DISKIO2_TransferBlockSequence,D0
    MOVE.L  D0,D1
    ADDQ.B  #1,D1
    MOVE.B  D1,_DISKIO2_TransferBlockSequence
    MOVEQ   #0,D0
    MOVE.B  D1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVE.B  D0,_DISKIO2_TransferBlockSequence
    MOVEQ   #0,D0
    MOVE.L  D0,_DISKIO2_TransferCrcErrorCount
    BRA.S   .blockrx_continue_transfer

.blockrx_mark_crc_error:
    CLR.B   -16(A5)
    ADDQ.L  #1,_DISKIO2_TransferCrcErrorCount
    BRA.S   .blockrx_continue_transfer

.blockrx_handle_zero_length_block:
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.S   .blockrx_checksum_mismatch_eof

    MOVE.W  _DISKIO2_TransferBufferedByteCount,D0
    BLE.S   .blockrx_complete_transfer

    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _DISKIO2_TransferBlockBufferPtr,-(A7)
    JSR     _DISKIO_WriteBytesToOutputHandleGuarded(PC)

    ADDQ.W  #8,A7
    ADDQ.L  #1,D0
    BNE.S   .blockrx_flush_tail_success

    MOVEQ   #3,D0
    BRA.S   .blockrx_return

.blockrx_flush_tail_success:
    CLR.W   _DISKIO2_TransferBufferedByteCount

.blockrx_complete_transfer:
    MOVEQ   #-1,D0
    BRA.S   .blockrx_return

.blockrx_checksum_mismatch_eof:
    MOVE.B  #$1,-16(A5)
    ADDQ.L  #1,_DISKIO2_TransferCrcErrorCount

.blockrx_continue_transfer:
    MOVEQ   #0,D0
    BRA.S   .blockrx_return

.blockrx_unexpected_sequence:
    MOVEQ   #0,D0
    MOVE.B  D4,D0
    ADDQ.L  #1,D0
    MOVEQ   #0,D1
    NOT.B   D1
    AND.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  _DISKIO2_TransferBlockSequence,D1
    CMP.L   D1,D0
    BNE.S   .blockrx_show_sequence_error_dialog

    MOVEQ   #0,D0
    BRA.S   .blockrx_return

.blockrx_show_sequence_error_dialog:
    LEA     _DISKIO2_TransferFilenameBuffer,A0
    LEA     _BRUSH_SnapshotHeader,A1   ; keep error dialog text in sync with disk state

.blockrx_copy_name_to_snapshot_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .blockrx_copy_name_to_snapshot_loop

    PEA     1.W
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    MOVEQ   #1,D0

.blockrx_return:
    MOVEM.L -1064(A5),D2-D7
    UNLK    A5
    RTS

;!======