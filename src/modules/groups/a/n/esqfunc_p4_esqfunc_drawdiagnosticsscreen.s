    XDEF    _ESQFUNC_DrawDiagnosticsScreen


;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_DrawDiagnosticsScreen   (DrawDiagnosticsScreenuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetFont, _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   _ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag, _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition,
;   _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   _ESQFUNC_VideoInsertionStateStrings, _SCRIPT_CtrlHandshakeStage, _ESQFUNC_STR_CLOSED_ENABLED/1EB9, _ESQFUNC_TAG_CLOSED/1EBB, _ESQFUNC_STR_CLOSED_ON_AIR/1EBD,
;   _Global_HANDLE_TOPAZ_FONT, Global_REF_GRAPHICS_LIBRARY, _WDISP_DisplayContextBase
; WRITES:
;   _ESQ_CopperStatusDigitsA/1E27/1E28/1E29/1E2A, _ESQ_CopperStatusDigitsB/1E56/1E57 (status fields),
;   _ESQ_CopperStatusDigitsA/1E27/1E28/1E29/1E2A (cleared/initialized), stack buffers
; DESC:
;   Builds and renders the ESC diagnostics screen, selecting status strings
;   based on multiple subsystem checks and a mode selector.
; NOTES:
;   Uses several helper probes (CIA bit/flag reads) to choose message text.
;   Reuses a 132-byte local printf buffer at -132(A5) for every row.
;   Most `%s` arguments in this routine come from fixed static literal tables
;   (status tags, mode names, TRUE/FALSE, AM/PM) rather than mutable buffers.
;------------------------------------------------------------------------------
; Printing of more diagnostic data
_ESQFUNC_DrawDiagnosticsScreen:
    LINK.W  A5,#-164
    MOVEM.L D2-D7,-(A7)

    LEA     _ESQFUNC_VideoInsertionStateStrings,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  #$fff,D0
    MOVE.W  D0,_ESQ_CopperStatusDigitsA_ColorRegistersA
    MOVE.W  D0,_ESQ_CopperStatusDigitsB_ColorRegistersA
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQ_CopperStatusDigitsA
    MOVE.W  D0,_ESQ_CopperStatusDigitsB
    MOVE.W  D0,_ESQ_CopperStatusDigitsA_ColorRegistersB
    MOVE.W  D0,_ESQ_CopperStatusDigitsB_TailColorWord
    MOVE.W  D0,_ESQ_CopperStatusDigitsA_ColorRegistersC
    MOVE.W  D0,_ESQ_CopperStatusDigitsA_TailColorWord

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    JSR     _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .status_a_false

    LEA     _ESQFUNC_STR_CLOSED_ENABLED,A0

    BRA.S   .status_a_selected

.status_a_false:
    LEA     _ESQFUNC_STR_OPEN_DISABLED,A0

.status_a_selected:
    MOVE.L  A0,24(A7)
    JSR     _ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag(PC)

    TST.B   D0
    BEQ.S   .status_b_false

    LEA     _ESQFUNC_TAG_CLOSED,A0
    BRA.S   .status_b_selected

.status_b_false:
    LEA     _ESQFUNC_TAG_OPEN,A0

.status_b_selected:
    MOVE.L  A0,28(A7)
    JSR     _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .status_c_false

    LEA     _ESQFUNC_STR_CLOSED_ON_AIR,A0
    BRA.S   .status_c_selected

.status_c_false:
    LEA     _ESQFUNC_STR_OPEN_OFF_AIR,A0

.status_c_selected:
    MOVE.W  _SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #2,D0
    BNE.S   .select_mode_two

    LEA     _ESQFUNC_STR_ON_AIR,A1
    BRA.S   .format_main_line

.select_mode_two:
    MOVE.W  _SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #1,D0
    BNE.S   .select_mode_one

    LEA     _ESQFUNC_STR_OFF_AIR,A1
    BRA.S   .format_main_line

.select_mode_one:
    LEA     _ESQFUNC_STR_NO_DETECT,A1

.format_main_line:
    ; `%s` args here are selected from static string literals above:
    ; CartSW, CartREL, VidSW, and on_air tags.
    ; Budget note for -132(A5): conservative max is 85 bytes incl NUL.
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  36(A7),-(A7)
    MOVE.L  36(A7),-(A7)
    PEA     _ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     92.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.W  _SCRIPT_RuntimeMode,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     -148(A5),A0
    ADDA.L  D0,A0
    MOVE.W  _ESQPARS2_ReadModeFlags,D0
    EXT.L   D0
    ; Entry-string source is from _ESQFUNC_VideoInsertionStateStrings (4 static labels).
    ; Budget note for -132(A5): conservative max is 62 bytes incl NUL
    ; (uses 8-digit worst-case for %04X-style hex expansion).
    MOVE.L  D0,(A7)
    MOVE.L  (A0),-(A7)
    PEA     _ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     110.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEQ   #0,D0
    ; Deferred action countdown/armed are populated in SCRIPT3/ED2 and then
    ; decremented in _TEXTDISP_TickDisplayState while armed.
    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    MOVEQ   #0,D1
    MOVE.W  _TEXTDISP_DeferredActionArmed,D1
    ; Layout-coupled _LOCAVAIL_PrimaryFilterState longs (+12 then +8).
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field0C,(A7)
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field08,-(A7)
    ; Filter class/step/mode are state-machine outputs from _LOCAVAIL_UpdateFilterStateMachine.
    MOVE.L  _LOCAVAIL_FilterClassId,-(A7)
    MOVE.L  _LOCAVAIL_FilterStep,-(A7)
    MOVE.L  _LOCAVAIL_FilterModeFlag,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 156 bytes incl NUL
    ; (%ld/%d treated as up to 11 chars each), so this row is top guard priority.
    PEA     _ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     92(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     128.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    ; Clock globals are normalized by _PARSEINI_NormalizeClockData.
    ; Month/day are 0-based table indexes; month is +1 only when writing RTC.
    MOVE.W  _CLOCK_CacheMonthIndex0,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CacheDayIndex0,D1
    EXT.L   D1
    MOVE.W  _CLOCK_CacheYear,D2
    EXT.L   D2
    MOVE.W  _CLOCK_CacheHour,D3
    EXT.L   D3
    MOVE.W  _CLOCK_CacheMinuteOrSecond,D4
    EXT.L   D4
    ; Seconds snapshot used by PARSEINI/SCRIPT clock-change detection paths.
    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D5
    EXT.L   D5
    ; AM/PM selector: 0 = AM, non-zero (typically -1) = PM.
    TST.W   _CLOCK_CacheAmPmFlag
    BEQ.S   .use_am_suffix

    LEA     _ESQFUNC_STR_PM,A0
    BRA.S   .format_clock_line

.use_am_suffix:
    LEA     _ESQFUNC_STR_AM,A0

.format_clock_line:
    ; LOCAVAIL cooldown timer: seeded in LOCAVAIL and adjusted/decremented in CLEANUP/APP2 ticks.
    MOVE.W  _LOCAVAIL_FilterCooldownTicks,D6
    EXT.L   D6
    MOVE.L  D6,-(A7)
    ; `%s` here is only "am"/"pm".
    MOVE.L  A0,-(A7)
    MOVE.L  D5,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 146 bytes incl NUL.
    PEA     _ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     146.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVE.L  #$20002,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,76(A7)
    MOVEQ   #4,D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,80(A7)
    MOVEQ   #2,D1
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,(A7)
    MOVE.L  80(A7),-(A7)
    MOVE.L  80(A7),-(A7)
    ; Budget note for -132(A5): conservative max is 56 bytes incl NUL.
    PEA     _ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     164.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    JSR     _ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    MOVE.W  _DATACErrs,D1
    EXT.L   D1
    MOVE.W  _ESQIFF_LineErrorCount,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  _Global_WORD_MAX_VALUE,D3
    MOVE.L  D7,(A7)
    MOVE.L  D3,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 109 bytes incl NUL.
    PEA     _ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     182.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEQ   #0,D0
    MOVE.W  _SCRIPT_CtrlCmdCount,D0
    MOVE.W  _SCRIPT_CtrlCmdChecksumErrorCount,D1
    EXT.L   D1
    MOVE.W  _SCRIPT_CtrlCmdLengthErrorCount,D2
    EXT.L   D2
    MOVEQ   #0,D3
    MOVE.W  _CTRL_HDeltaMax,D3
    MOVE.L  D0,72(A7)
    MOVE.L  D1,76(A7)
    MOVE.L  D2,80(A7)
    MOVE.L  D3,84(A7)
    JSR     _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 110 bytes incl NUL.
    PEA     _ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     200.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    LEA     12(A7),A7
    ; Monotonic diagnostics row counter (increments once per draw).
    ADDQ.L  #1,_ESQFUNC_DiagRowCounter
    MOVE.W  _Global_RefreshTickCounter,D0
    EXT.L   D0
    TST.W   _ESQDISP_PrimarySecondaryMirrorFlag
    BEQ.S   .set_false_text

    LEA     _Global_STR_TRUE_2,A0
    BRA.S   .format_tick_line

.set_false_text:
    LEA     _Global_STR_FALSE_2,A0

.format_tick_line:
    ; SCRIPT playback-side command counter (incremented in SCRIPT3 dispatch path).
    MOVE.W  _SCRIPT_PlaybackFallbackCounter,D1
    EXT.L   D1
    ; ED finite-state id (byte enum set across ED menu handlers).
    MOVE.B  _ED_MenuStateId,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    ; `%s` here is only _Global_STR_TRUE_2 / _Global_STR_FALSE_2.
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  _ESQFUNC_DiagRowCounter,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 142 bytes incl NUL,
    ; driven by four numeric fields plus "%s" TRUE/FALSE token.
    PEA     _ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     218.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_PREVUEC_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    MOVEM.L -188(A5),D2-D7
    UNLK    A5
    RTS

;!======