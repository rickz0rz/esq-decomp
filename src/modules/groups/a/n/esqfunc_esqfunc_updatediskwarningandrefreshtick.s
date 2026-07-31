    XDEF    _ESQFUNC_UpdateDiskWarningAndRefreshTick


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_UpdateDiskWarningAndRefreshTick   (UpdateDiskWarningAndRefreshTick)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A7/D0
; CALLS:
;   _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths, _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   _Global_REF_RASTPORT_2, _Global_STR_DISK_0_IS_WRITE_PROTECTED, _Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0, _WDISP_DisplayContextBase, _DISKIO_Drive0WriteProtectedCode, _DISKIO_DriveMediaStatusCodeTable, _Global_RefreshTickCounter
; WRITES:
;   _Global_RefreshTickCounter
; DESC:
;   Re-probes drive assignment state and updates the startup warning text path
;   plus _Global_RefreshTickCounter based on disk write-protect conditions.
; NOTES:
;   Draws one of two centered warning strings when protected/reinsert states are active.
;------------------------------------------------------------------------------
_ESQFUNC_UpdateDiskWarningAndRefreshTick:
    JSR     _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths(PC)

    TST.L   _DISKIO_Drive0WriteProtectedCode
    BNE.S   .lab_096B

    TST.L   _DISKIO_DriveMediaStatusCodeTable
    BNE.S   .lab_096A

    MOVE.W  _Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BNE.S   .lab_096C

    CLR.W   _Global_RefreshTickCounter
    BRA.S   .lab_096C

.lab_096A:
    MOVE.W  #(-1),_Global_RefreshTickCounter
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     90.W
    PEA     _Global_STR_DISK_0_IS_WRITE_PROTECTED
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    BRA.S   .lab_096C

.lab_096B:
    MOVE.W  #(-1),_Global_RefreshTickCounter
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     90.W
    PEA     _Global_STR_YOU_MUST_REINSERT_SYSTEM_DISK_INTO_DRIVE_0
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7

.lab_096C:
    RTS

;!======