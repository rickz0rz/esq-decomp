    XDEF    _ED_SaveEverythingToDisk


;------------------------------------------------------------------------------
; FUNC: _ED_SaveEverythingToDisk   (Save everything to diskuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   _ED_IsConfirmKey, _DISPLIB_DisplayTextAtPosition, _DISKIO2_RunDiskSyncWorkflow,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving EVERYTHING to disk" and triggers a save operation.
; NOTES:
;   Skips display/trigger if _ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
_ED_SaveEverythingToDisk:
; Print 'Saving "EVERYTHING" to disk'
    MOVE.L  D7,-(A7)
    JSR     _ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_everything_message

    PEA     _Global_STR_SAVING_EVERYTHING_TO_DISK
    PEA     90.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     1.W
    JSR     _DISKIO2_RunDiskSyncWorkflow(PC)

    LEA     20(A7),A7

.after_save_everything_message:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======