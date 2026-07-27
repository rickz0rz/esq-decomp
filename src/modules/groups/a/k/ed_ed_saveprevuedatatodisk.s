    XDEF    _ED_SavePrevueDataToDisk


;------------------------------------------------------------------------------
; FUNC: _ED_SavePrevueDataToDisk   (Save Prevue data to diskuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7/D7
; CALLS:
;   _ED_IsConfirmKey, _DISPLIB_DisplayTextAtPosition, _DISKIO2_WriteCurDayDataFile,
;   _ED_DrawESCMenuBottomHelp
; READS:
;   _Global_REF_RASTPORT_1
; WRITES:
;   (none)
; DESC:
;   Displays "Saving Prevue data to disk" and triggers the save routine.
; NOTES:
;   Skips display/trigger if _ED_IsConfirmKey reports busy (D0 nonzero).
;------------------------------------------------------------------------------
_ED_SavePrevueDataToDisk:
    MOVE.L  D7,-(A7)
    JSR     _ED_IsConfirmKey(PC)

    MOVE.L  D0,D7
    TST.B   D7
    BNE.S   .after_save_prevue_message

    PEA     _Global_STR_SAVING_PREVUE_DATA_TO_DISK
    PEA     120.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _DISKIO2_WriteCurDayDataFile(PC)

    LEA     16(A7),A7

.after_save_prevue_message:
    JSR     _ED_DrawESCMenuBottomHelp(PC)

    MOVE.L  (A7)+,D7
    RTS

;!======