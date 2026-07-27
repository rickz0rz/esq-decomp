    XDEF    _DISKIO2_ParseIniFileFromDisk


;------------------------------------------------------------------------------
; FUNC: _DISKIO2_ParseIniFileFromDisk   (Parse INI file from disk.)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A7
; CALLS:
;   _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers, _PARSEINI_ParseIniBufferAndDispatch
; READS:
;   _CTASKS_PATH_QTABLE_INI
; WRITES:
;   (none observed)
; DESC:
;   Invokes the INI parser for the _CTASKS_PATH_QTABLE_INI file.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
_DISKIO2_ParseIniFileFromDisk:
    JSR     _GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(PC)

    PEA     _CTASKS_PATH_QTABLE_INI
    JSR     _GROUP_AK_JMPTBL_PARSEINI_ParseIniBufferAndDispatch(PC)

    ADDQ.W  #4,A7
    RTS

;!======