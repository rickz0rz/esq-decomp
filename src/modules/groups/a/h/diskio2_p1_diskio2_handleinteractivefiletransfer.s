    XDEF    _DISKIO2_HandleInteractiveFileTransfer



;------------------------------------------------------------------------------
; FUNC: _DISKIO2_HandleInteractiveFileTransfer   (Interactive file receive/save workflow.)
; ARGS:
;   stack +7: arg_1 (via 11(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +12: arg_3 (via 16(A5))
;   stack +13: arg_4 (via 17(A5))
;   stack +14: arg_5 (via 18(A5))
;   stack +54: arg_6 (via 58(A5))
;   stack +60: arg_7 (via 64(A5))
;   stack +64: arg_8 (via 68(A5))
;   stack +68: arg_9 (via 72(A5))
;   stack +72: arg_10 (via 76(A5))
;   stack +152: arg_11 (via 156(A5))
;   stack +176: arg_12 (via 180(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D3/D5/D6/D7
; CALLS:
;   _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi, _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte, _DISPLIB_DisplayTextAtPosition, _GROUP_AG_JMPTBL_STRING_CopyPadNul,
;   _LVOLock/_LVOUnLock/_LVOOpen/_LVOClose/_LVORead/_LVOWrite/_LVODeleteFile,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay, _GROUP_AH_JMPTBL_ESQSHARED_InitEntryDefaults, _GROUP_AH_JMPTBL_STR_FindAnyCharPtr, _DISKIO2_ReceiveTransferBlocksToFile
; READS:
;   _DISKIO2_TransferFilenameBuffer.._DISKIO_SavedReadModeFlags, _ED_DiagnosticsScreenActive, _DISKIO2_TransferXorChecksumByte, _CTASKS_EXT_GRF
; WRITES:
;   _DISKIO2_TransferFilenameBuffer.._DISKIO2_TransferCrcErrorCount, _DISKIO2_InteractiveTransferArmedFlag/21CB, _ESQPARS2_ReadModeFlags
; DESC:
;   Reads a filename and payload, validates/locks the target, and writes the data.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_HandleInteractiveFileTransfer:
    LINK.W  A5,#-160
    MOVEM.L D2-D3/D5-D7,-(A7)
    MOVE.B  11(A5),D7
    PEA     1.W
    PEA     4.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVEQ   #1,D5
    CLR.B   -17(A5)
    TST.B   D7
    BEQ.S   .xfer_set_checksum_default

    MOVE.B  #$c2,_DISKIO2_TransferXorChecksumByte
    BRA.S   .xfer_wait_before_filename

.xfer_set_checksum_default:
    MOVE.B  #$b7,_DISKIO2_TransferXorChecksumByte

.xfer_wait_before_filename:
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    ; Read filename into _DISKIO2_TransferFilenameBuffer with checksum.
.xfer_read_filename_loop:
    CMPI.B  #$1f,-17(A5)
    BCC.S   .xfer_finalize_filename

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .xfer_finalize_filename

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     _DISKIO2_TransferFilenameBuffer,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,_DISKIO2_TransferXorChecksumByte
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    BRA.S   .xfer_read_filename_loop

.xfer_finalize_filename:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     _DISKIO2_TransferFilenameBuffer,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .xfer_prepare_target_paths

    PEA     _CTASKS_EXT_GRF
    PEA     _DISKIO2_TransferFilenameExtPtr
    JSR     _GROUP_AH_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .xfer_prepare_target_paths

    MOVEQ   #0,D5
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_prepare_target_paths

    PEA     _Global_STR_SPECIAL_NGAD
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7

.xfer_prepare_target_paths:
    LEA     _DISKIO2_TransferFilenameBuffer,A0
    LEA     -58(A5),A1

.xfer_copy_filename_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .xfer_copy_filename_loop

    PEA     4.W
    PEA     _Global_STR_RAM
    PEA     -58(A5)
    JSR     _GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_optional_size_guard

    PEA     _Global_STR_FILENAME
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _DISKIO2_TransferFilenameBuffer
    PEA     180.W
    PEA     205.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.xfer_optional_size_guard:
    PEA     4.W
    PEA     _DISKIO2_TransferFilenameBuffer
    PEA     -68(A5)
    JSR     _GROUP_AG_JMPTBL_STRING_CopyPadNul(PC)

    LEA     12(A7),A7
    MOVEQ   #0,D0
    MOVE.B  D0,-64(A5)
    TST.B   D7
    BEQ.W   .xfer_verify_name_checksum_and_open

    MOVE.B  D0,-17(A5)
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    ; Read secondary token into _DISKIO2_TransferSizeTokenBuffer with checksum.
.xfer_read_secondary_token_loop:
    CMPI.B  #$8,-17(A5)
    BCC.S   .xfer_finalize_secondary_token

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    TST.B   D0
    BEQ.S   .xfer_finalize_secondary_token

    MOVE.B  -17(A5),D1
    ADDQ.B  #1,-17(A5)
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    LEA     _DISKIO2_TransferSizeTokenBuffer,A0
    ADDA.W  D2,A0
    MOVE.B  D0,(A0)
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    EOR.B   D0,D1
    MOVE.B  D1,_DISKIO2_TransferXorChecksumByte
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    BRA.S   .xfer_read_secondary_token_loop

.xfer_finalize_secondary_token:
    MOVEQ   #0,D0
    MOVE.B  -17(A5),D0
    LEA     _DISKIO2_TransferSizeTokenBuffer,A0
    ADDA.W  D0,A0
    CLR.B   (A0)
    LEA     -68(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,-76(A5)
    TST.L   D0
    BEQ.S   .xfer_parse_requested_size

    MOVE.L  #(MEMF_CLEAR),-(A7)
    PEA     Struct_InfoData_Size.W
    PEA     1312.W
    PEA     _Global_STR_DISKIO2_C_24
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,-72(A5)
    TST.L   D0
    BEQ.S   .xfer_unlock_target_dir

    MOVE.L  D0,D2
    MOVE.L  -76(A5),D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOInfo(A6)

    TST.L   D0
    BEQ.S   .xfer_have_volume_info

    MOVE.L  #$6de,D0
    MOVEA.L D2,A0
    SUB.L   16(A0),D0
    ASL.L   #8,D0
    ADD.L   D0,D0
    SUBI.L  #$1000,D0
    MOVE.L  D0,-12(A5)

.xfer_have_volume_info:
    PEA     Struct_InfoData_Size.W
    MOVE.L  D2,-(A7)
    PEA     1318.W
    PEA     _Global_STR_DISKIO2_C_25
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7

.xfer_unlock_target_dir:
    MOVE.L  -76(A5),D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOUnLock(A6)

.xfer_parse_requested_size:
    PEA     _DISKIO2_TransferSizeTokenBuffer
    JSR     _GROUP_AH_JMPTBL_PARSE_ReadSignedLongSkipClass3(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,-16(A5)
    CMP.L   -12(A5),D0
    BLE.S   .xfer_verify_name_checksum_and_open

    LEA     _DISKIO2_TransferFilenameBuffer,A0
    LEA     _BRUSH_SnapshotHeader,A1   ; refresh saved UI header with on-disk metadata

.xfer_copy_name_to_snapshot_header:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .xfer_copy_name_to_snapshot_header

    PEA     2.W
    JSR     _GROUP_AH_JMPTBL_ESQIFF2_ShowAttentionOverlay(PC)

    MOVEQ   #0,D0
    MOVE.L  D0,_DISKIO2_InteractiveTransferArmedFlag
    MOVE.L  D0,(A7)
    PEA     4.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVEQ   #-2,D0
    BRA.W   .xfer_return

.xfer_verify_name_checksum_and_open:
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,_ESQIFF_RecordChecksumByte
    MOVE.B  _DISKIO2_TransferXorChecksumByte,D1
    CMP.B   D1,D0
    BNE.W   .xfer_clear_overlay_and_maybe_report_disk

    MOVEQ   #1,D0
    CMP.L   D0,D5
    BNE.W   .xfer_clear_overlay_and_maybe_report_disk

    PEA     (MODE_NEWFILE).W
    PEA     -58(A5)
    JSR     _GROUP_AG_JMPTBL_DOS_OpenFileWithMode(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_DISKIO_WriteFileHandle
    TST.L   D0
    BNE.S   .xfer_setup_transfer_state

    PEA     5.W
    JSR     _DISKIO_DrawTransferErrorMessageIfDiagnostics(PC)

    CLR.L   (A7)
    PEA     4.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    MOVEQ   #-1,D0
    BRA.W   .xfer_return

.xfer_setup_transfer_state:
    MOVE.W  _ESQPARS2_ReadModeFlags,_DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    CLR.L   _DISKIO2_TransferCrcErrorCount
    CLR.B   _DISKIO2_TransferBlockSequence
    MOVE.L  #(MEMF_PUBLIC+MEMF_CLEAR),-(A7)
    PEA     4352.W
    PEA     1389.W
    PEA     _Global_STR_DISKIO2_C_26
    JSR     _GROUP_AG_JMPTBL_MEMORY_AllocateMemory(PC)

    LEA     16(A7),A7
    MOVE.L  D0,_DISKIO2_TransferBlockBufferPtr
    MOVE.W  _DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags
    CLR.W   _DISKIO2_TransferBufferedByteCount

.xfer_wait_for_sync_markers:
    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    CMP.B   -18(A5),D0
    BNE.S   .xfer_wait_for_sync_markers

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #85,D0
    ADD.L   D0,D0
    CMP.L   D0,D1
    BNE.S   .xfer_wait_for_sync_markers

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    MOVEQ   #72,D1
    CMP.B   D1,D0
    BEQ.S   .xfer_handle_data_marker

    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .xfer_handle_delete_marker

.xfer_handle_data_marker:
    MOVEQ   #61,D1
    CMP.B   D1,D0
    BNE.S   .xfer_set_checksum_h_mode

    MOVE.B  #$c2,_DISKIO2_TransferXorChecksumByte
    BRA.S   .xfer_dispatch_receive_blocks

.xfer_set_checksum_h_mode:
    MOVE.B  #$b7,_DISKIO2_TransferXorChecksumByte

.xfer_dispatch_receive_blocks:
    CMP.B   D1,D0
    SEQ     D0
    NEG.B   D0
    EXT.W   D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D1,-(A7)
    BSR.W   _DISKIO2_ReceiveTransferBlocksToFile

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BEQ.S   .xfer_wait_for_sync_markers

    BRA.S   .xfer_teardown_transfer_state

.xfer_handle_delete_marker:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #68,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVE.B  D0,-18(A5)
    BNE.W   .xfer_wait_for_sync_markers

    JSR     _GROUP_AH_JMPTBL_ESQFUNC_WaitForClockChangeAndServiceUi(PC)

    JSR     _GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.B  D0,-18(A5)
    MOVEQ   #0,D0
    NOT.B   D0
    CMP.L   D0,D1
    BNE.W   .xfer_wait_for_sync_markers

    MOVEQ   #4,D6

.xfer_teardown_transfer_state:
    MOVE.W  _ESQPARS2_ReadModeFlags,_DISKIO_SavedReadModeFlags
    MOVE.W  #$100,_ESQPARS2_ReadModeFlags
    MOVE.L  _DISKIO_WriteFileHandle,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOClose(A6)

    PEA     4352.W
    MOVE.L  _DISKIO2_TransferBlockBufferPtr,-(A7)
    PEA     1499.W
    PEA     _Global_STR_DISKIO2_C_27
    JSR     _GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(PC)

    LEA     16(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_post_transfer_status

    PEA     _DISKIO2_STR_DiagTransferStatusClearLine210
    PEA     210.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _DISKIO2_STR_DiagTransferStatusClearLine240
    PEA     240.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     32(A7),A7

.xfer_post_transfer_status:
    MOVEQ   #-1,D0
    CMP.L   D0,D6

    BNE.W   .xfer_handle_transfer_error

    LEA     _DISKIO2_TransferFilenameBuffer,A0
    MOVE.L  A0,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

    JSR     _DISKIO_ForceUiRefreshIfIdle(PC)

    LEA     _Global_STR_COPY_NIL,A0
    LEA     -156(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    PEA     -58(A5)
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     _DISKIO2_STR_ShellCommandArgSeparator
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    PEA     _DISKIO2_TransferFilenameBuffer
    PEA     -156(A5)
    JSR     _GROUP_AI_JMPTBL_STRING_AppendAtNull(PC)

    LEA     -156(A5),A0
    MOVE.L  A0,D1
    MOVEQ   #0,D2
    MOVE.L  D2,D3
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOExecute(A6)

    LEA     -58(A5),A0
    MOVE.L  A0,D1
    JSR     _LVODeleteFile(A6)

    JSR     _DISKIO_ResetCtrlInputStateIfIdle(PC)

    LEA     24(A7),A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_restore_read_mode

    PEA     _Global_STR_STORED
    PEA     180.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     16(A7),A7
    BRA.S   .xfer_restore_read_mode

.xfer_handle_transfer_error:
    MOVE.L  D6,-(A7)
    JSR     _DISKIO_DrawTransferErrorMessageIfDiagnostics(PC)

    ADDQ.W  #4,A7
    LEA     -58(A5),A0
    MOVE.L  A0,D1
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVODeleteFile(A6)

.xfer_restore_read_mode:
    MOVE.W  _DISKIO_SavedReadModeFlags,_ESQPARS2_ReadModeFlags

.xfer_clear_overlay_and_maybe_report_disk:
    MOVEQ   #0,D0
    MOVE.L  D0,_DISKIO2_InteractiveTransferArmedFlag
    MOVE.L  D0,-(A7)
    PEA     4.W
    JSR     _GROUP_AH_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.S   .xfer_return

    PEA     _DISKIO2_DiagnosticsDiskUsagePercentBuffer
    JSR     _DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    PEA     _DISKIO2_DiagnosticsSoftErrorCountBuffer
    MOVE.L  D0,28(A7)
    JSR     _DISKIO_QueryVolumeSoftErrorCount(PC)

    MOVE.L  D0,(A7)
    MOVE.L  28(A7),-(A7)
    PEA     _Global_STR_DISK_0_IS_FULL_WITH_ERRORS_FORMATTED
    PEA     -58(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -58(A5)
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    LEA     36(A7),A7

.xfer_return:
    MOVEM.L -180(A5),D2-D3/D5-D7
    UNLK    A5
    RTS

;!======