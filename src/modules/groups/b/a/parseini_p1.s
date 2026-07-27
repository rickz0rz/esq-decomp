    XDEF    PARSEINI_LoadWeatherMessageStrings


;------------------------------------------------------------------------------
; FUNC: PARSEINI_LoadWeatherMessageStrings   (Routine at PARSEINI_LoadWeatherMessageStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   A2/A3/A7
; CALLS:
;   PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString, _PARSEINI_JMPTBL_STRING_CompareNoCase
; READS:
;   P_TYPE_WeatherCurrentMsgPtr, P_TYPE_WeatherForecastMsgPtr, P_TYPE_WeatherBottomLineMsgPtr, PARSEINI_STR_WEATHERCURRENT, PARSEINI_STR_WEATHERFORECAST, PARSEINI_STR_BOTTOMLINETAG
; WRITES:
;   P_TYPE_WeatherCurrentMsgPtr, P_TYPE_WeatherForecastMsgPtr, P_TYPE_WeatherBottomLineMsgPtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
PARSEINI_LoadWeatherMessageStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    PEA     PARSEINI_STR_WEATHERCURRENT
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1405

    MOVE.L  P_TYPE_WeatherCurrentMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,P_TYPE_WeatherCurrentMsgPtr
    BRA.S   .return_1407

.if_ne_1405:
    PEA     PARSEINI_STR_WEATHERFORECAST
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1406

    MOVE.L  P_TYPE_WeatherForecastMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,P_TYPE_WeatherForecastMsgPtr
    BRA.S   .return_1407

.if_ne_1406:
    PEA     PARSEINI_STR_BOTTOMLINETAG
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return_1407

    MOVE.L  P_TYPE_WeatherBottomLineMsgPtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     PARSEINI_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,P_TYPE_WeatherBottomLineMsgPtr

.return_1407:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======