    XDEF    _ESQ_FormatDiskErrorMessage


;------------------------------------------------------------------------------
; FUNC: _ESQ_FormatDiskErrorMessage   (FormatDiskErrorMessage)
; ARGS:
;   (none)
; RET:
;   D0: 0
; CLOBBERS:
;   D0-D7
; CALLS:
;   _DISKIO_QueryVolumeSoftErrorCount, _DISKIO_QueryDiskUsagePercentAndSetBufferSize, _GROUP_AE_JMPTBL_WDISP_SPrintf
; READS:
;   _COMMON_QueryDiskSoftErrorCountScratch, _COMMON_QueryDiskUsagePercentScratch, _Global_STR_DISK_ERRORS_FORMATTED,
;   _Global_STR_DISK_IS_FULL_FORMATTED, _DISKIO_ErrorMessageScratch
; WRITES:
;   _DISKIO_ErrorMessageScratch (formatted text buffer)
; DESC:
;   Builds a disk error message into _DISKIO_ErrorMessageScratch based on disk error counts.
; NOTES:
;   - Uses _DISKIO_QueryVolumeSoftErrorCount and _DISKIO_QueryDiskUsagePercentAndSetBufferSize helpers for error count retrieval.
;   - Destination _DISKIO_ErrorMessageScratch has 41 bytes total capacity.
;   - Current practical bounds:
;       "Disk Errors: %ld\\n" with 16-bit source <= 65535 => 19 chars + NUL
;       "Disk is %ld%% full" with percent source <= 100 => 17 chars + NUL
;   - Conservative signed-32 worst-case for either %ld path is 25 chars + NUL
;     (headroom 15 bytes, i.e. below a 16-byte comfort margin).
;------------------------------------------------------------------------------
_ESQ_FormatDiskErrorMessage:
    MOVEM.L D6-D7,-(A7)

    SetOffsetForStack   2

    PEA     _COMMON_QueryDiskSoftErrorCountScratch
    JSR     _DISKIO_QueryVolumeSoftErrorCount(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D6
    TST.L   D6
    BLE.S   .createDiskIsFullMessage

    MOVE.L  D6,-(A7)
    ; _DISKIO_ErrorMessageScratch is 41 bytes:
    ; - practical 16-bit count path (<=65535) uses 19 chars + NUL
    ; - signed-32 worst-case uses 25 chars + NUL
    PEA     _Global_STR_DISK_ERRORS_FORMATTED
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     .stackOffsetBytes+4(A7),A7
    BRA.S   .done

.createDiskIsFullMessage:
    PEA     _COMMON_QueryDiskUsagePercentScratch
    JSR     _DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    MOVE.L  D0,D7
    MOVE.L  D7,(A7)
    ; _DISKIO_ErrorMessageScratch is 41 bytes:
    ; - normal 0..100 percent path uses at most 17 chars + NUL
    ; - signed-32 worst-case uses 25 chars + NUL
    PEA     _Global_STR_DISK_IS_FULL_FORMATTED
    PEA     _DISKIO_ErrorMessageScratch
    JSR     _GROUP_AE_JMPTBL_WDISP_SPrintf(PC)

    LEA     .stackOffsetBytes+4(A7),A7

.done:
    MOVEQ   #0,D0
    MOVEM.L (A7)+,D6-D7
    RTS

;!======