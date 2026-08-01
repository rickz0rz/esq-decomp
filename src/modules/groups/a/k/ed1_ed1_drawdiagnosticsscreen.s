    XDEF    _ED1_DrawDiagnosticsScreen


;------------------------------------------------------------------------------
; FUNC: _ED1_DrawDiagnosticsScreen   (Render diagnostic mode screen)
; ARGS:
;   (none)
; RET:
;   D0: result/status
; CLOBBERS:
;   A1/A6/A7/D0
; CALLS:
;   _ED_DrawBottomHelpBarBackground, _DISPLIB_DisplayTextAtPosition, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _DISKIO_QueryDiskUsagePercentAndSetBufferSize, _DISKIO_QueryVolumeSoftErrorCount, _ED_DrawDiagnosticModeText, _LVOSetAPen
; READS:
;   _Global_REF_BAUD_RATE, _ED2_DiagnosticDiskUsagePercent, _ED2_DiagnosticDiskSoftErrorCount, _WDISP_WeatherStatusLabelBuffer
; WRITES:
;   _ED_MenuStateId, _ED_DiagnosticsScreenActive
; DESC:
;   Draws diagnostic-mode text blocks and prompts on the ESC menu screen.
; NOTES:
;   Local printf buffer is 41 bytes (-41(A5)..-1(A5) and reused across two
;   _WDISP_SPrintf calls.
;------------------------------------------------------------------------------
_ED1_DrawDiagnosticsScreen:

.printfResult   = -41

    LINK.W  A5,#-48

    MOVE.B  #$7,_ED_MenuStateId
    MOVE.W  #1,_ED_DiagnosticsScreenActive

    JSR     _ED_DrawBottomHelpBarBackground(PC)

    PEA     _ESQ_SelectCodeBuffer
    PEA     360.W
    PEA     90.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _WDISP_WeatherStatusLabelBuffer    ; Weather/status label token buffer used by diagnostics format path.
    PEA     360.W
    PEA     210.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVE.L  _Global_REF_BAUD_RATE,(A7)
    PEA     _Global_STR_BAUD_RATE_DIAGNOSTIC_MODE
    PEA     .printfResult(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     .printfResult(A5)
    PEA     360.W
    PEA     410.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    PEA     _ED2_DiagnosticDiskUsagePercent
    JSR     _DISKIO_QueryDiskUsagePercentAndSetBufferSize(PC)

    PEA     _ED2_DiagnosticDiskSoftErrorCount
    MOVE.L  D0,64(A7)
    JSR     _DISKIO_QueryVolumeSoftErrorCount(PC)

    MOVE.L  D0,(A7)
    MOVE.L  64(A7),-(A7)
    PEA     _Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS
    PEA     .printfResult(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     76(A7),A7
    PEA     .printfResult(A5)
    PEA     88.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    JSR     _ED_DrawDiagnosticModeText(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #6,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    PEA     _Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2
    PEA     390.W
    PEA     175.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _DISPLIB_DisplayTextAtPosition(PC)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L _Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    UNLK    A5
    RTS

;!======