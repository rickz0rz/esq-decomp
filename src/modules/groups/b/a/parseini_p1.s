    XDEF    _PARSEINI_LoadWeatherMessageStrings


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_LoadWeatherMessageStrings   (Routine at _PARSEINI_LoadWeatherMessageStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7
; CALLS:
;   _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, _PARSEINI_JMPTBL_STRING_CompareNoCase
; READS:
;   _P_TYPE_WeatherCurrentMsgPtr, _P_TYPE_WeatherForecastMsgPtr, _P_TYPE_WeatherBottomLineMsgPtr, _PARSEINI_STR_WEATHERCURRENT, _PARSEINI_STR_WEATHERFORECAST, _PARSEINI_STR_BOTTOMLINETAG
; WRITES:
;   _P_TYPE_WeatherCurrentMsgPtr, _P_TYPE_WeatherForecastMsgPtr, _P_TYPE_WeatherBottomLineMsgPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_LoadWeatherMessageStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    PEA     _PARSEINI_STR_WEATHERCURRENT
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1405

    MOVE.L  _P_TYPE_WeatherCurrentMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_P_TYPE_WeatherCurrentMsgPtr
    BRA.S   .return_1407

.if_ne_1405:
    PEA     _PARSEINI_STR_WEATHERFORECAST
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1406

    MOVE.L  _P_TYPE_WeatherForecastMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_P_TYPE_WeatherForecastMsgPtr
    BRA.S   .return_1407

.if_ne_1406:
    PEA     _PARSEINI_STR_BOTTOMLINETAG
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return_1407

    MOVE.L  _P_TYPE_WeatherBottomLineMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_P_TYPE_WeatherBottomLineMsgPtr

.return_1407:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======