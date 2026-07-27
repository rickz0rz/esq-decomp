    XDEF    _PARSEINI_WriteErrorLogEntry


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_WriteErrorLogEntry   (Write error log entryuncertain)
; ARGS:
;   (none)
; RET:
;   D0: -1 on failure, 0 on success
; CLOBBERS:
;   D0/D7
; CALLS:
;   _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer, _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes, _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush
; READS:
;   _NEWGRID2_ErrorLogEntryPtr, _FLIB_LogEntryByteCount, _CLOCK_FileEofMarkerCtrlZ
; WRITES:
;   Err log file on disk
; DESC:
;   Opens df0:err.log (MODE_NEWFILE), writes two entries via _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes and closes.
; NOTES:
;   Returns -1 when logging is disabled or open fails.
;------------------------------------------------------------------------------
_PARSEINI_WriteErrorLogEntry:
    MOVE.L  D7,-(A7)

    TST.L   _NEWGRID2_ErrorLogEntryPtr
    BNE.S   .logging_enabled

    MOVEQ   #-1,D0
    BRA.S   .return

.logging_enabled:
    PEA     MODE_NEWFILE.W
    PEA     _Global_STR_DF0_ERR_LOG
    JSR     _SCRIPT_JMPTBL_DISKIO_OpenFileWithBuffer(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,D7
    TST.L   D7
    BNE.S   .log_opened

    MOVEQ   #-1,D0
    BRA.S   .return

.log_opened:
    MOVE.W  _FLIB_LogEntryByteCount,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    MOVE.L  _NEWGRID2_ErrorLogEntryPtr,-(A7)
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    PEA     1.W
    PEA     _CLOCK_FileEofMarkerCtrlZ
    MOVE.L  D7,-(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_WriteBufferedBytes(PC)

    MOVE.L  D7,(A7)
    JSR     _SCRIPT_JMPTBL_DISKIO_CloseBufferedFileAndFlush(PC)

    LEA     24(A7),A7

.return:
    MOVE.L  (A7)+,D7
    RTS

;!======