    XDEF    _PARSEINI_LoadWeatherStrings


;------------------------------------------------------------------------------
; FUNC: _PARSEINI_LoadWeatherStrings   (Routine at _PARSEINI_LoadWeatherStrings)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A2/A3/A7/D0
; CALLS:
;   _PARSEINI_JMPTBL_BRUSH_AllocBrushNode, _PARSEINI_JMPTBL_STRING_CompareNoCase
; READS:
;   _PARSEINI_BannerBrushResourceHead, _PARSEINI_TAG_FILENAME_WeatherString, _PARSEINI_TAG_WEATHER, _PARSEINI_WeatherBrushNodePtr, a
; WRITES:
;   _PARSEINI_BannerBrushResourceHead, _P_TYPE_WeatherBrushRefreshPendingFlag, _PARSEINI_WeatherBrushNodePtr
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
_PARSEINI_LoadWeatherStrings:
    MOVEM.L A2-A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEA.L 16(A7),A2
    TST.L   _PARSEINI_BannerBrushResourceHead
    BNE.S   .if_ne_1401

    CLR.L   _PARSEINI_WeatherBrushNodePtr

.if_ne_1401:
    PEA     _PARSEINI_TAG_FILENAME_WeatherString
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .if_ne_1402

    MOVE.L  _PARSEINI_WeatherBrushNodePtr,-(A7)
    MOVE.L  A2,-(A7)
    JSR     _PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #$a,190(A0)
    MOVE.L  D0,_PARSEINI_WeatherBrushNodePtr
    TST.L   _PARSEINI_BannerBrushResourceHead
    BNE.S   .return_1403

    MOVE.L  D0,_PARSEINI_BannerBrushResourceHead
    BRA.S   .return_1403

.if_ne_1402:
    MOVEQ   #0,D0
    TST.L   D0
    BEQ.S   .return_1403

    PEA     _PARSEINI_TAG_WEATHER
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_STRING_CompareNoCase(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BNE.S   .return_1403

    MOVEQ   #1,D0
    MOVE.L  D0,_P_TYPE_WeatherBrushRefreshPendingFlag
    MOVE.L  _PARSEINI_WeatherBrushNodePtr,-(A7)
    MOVE.L  A3,-(A7)
    JSR     _PARSEINI_JMPTBL_BRUSH_AllocBrushNode(PC)

    ADDQ.W  #8,A7
    MOVEA.L D0,A0
    MOVE.B  #10,190(A0)
    MOVE.L  D0,_PARSEINI_WeatherBrushNodePtr
    TST.L   _PARSEINI_BannerBrushResourceHead
    BNE.S   .return_1403

    MOVE.L  D0,_PARSEINI_BannerBrushResourceHead

.return_1403:
    MOVEM.L (A7)+,A2-A3
    RTS

;!======