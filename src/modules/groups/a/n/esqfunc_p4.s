    XDEF    ESQFUNC_DrawDiagnosticsScreen
    XDEF    ESQFUNC_DrawMemoryStatusScreen
    XDEF    ESQFUNC_SelectAndApplyBrushForCurrentEntry
    XDEF    ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner
    XDEF    ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts
    XDEF    _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths
    XDEF    ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange
    XDEF    ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex
    XDEF    _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt
    XDEF    _ESQFUNC_JMPTBL_ESQ_PollCtrlInput
    XDEF    _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters
    XDEF    _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState
    XDEF    ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup
    XDEF    ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup
    XDEF    ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues
    XDEF    _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange
    XDEF    ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData
    XDEF    ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
    XDEF    ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList
    XDEF    ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList
    XDEF    ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag
    XDEF    ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd
    XDEF    ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag
    XDEF    _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask
    XDEF    ESQFUNC_JMPTBL_STRING_CopyPadNul
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode
    XDEF    ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState
    XDEF    _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines


;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawMemoryStatusScreen   (DrawMemoryStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOAvailMem, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues,
;   ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   _ED_DiagnosticsScreenActive, _ED_DiagnosticsViewMode, _ED_DiagAvailMemMask, _ESQIFF_ParseAttemptCount, _DATACErrs, _ESQIFF_LineErrorCount,
;   _SCRIPT_CtrlCmdCount/2348/2349, ESQ_SerialRbfErrorCount, _Global_WORD_H_VALUE, _Global_WORD_T_VALUE,
;   _Global_WORD_MAX_VALUE, _CTRL_H, _CTRL_HPreviousSample, _CTRL_HDeltaMax, _TEXTDISP_PrimaryGroupCode/_TEXTDISP_SecondaryGroupCode,
;   _TEXTDISP_PrimaryGroupHeaderCode/_TEXTDISP_SecondaryGroupHeaderCode, _TEXTDISP_PrimaryGroupPresentFlag/_TEXTDISP_SecondaryGroupPresentFlag, CLOCK_CacheDayIndex0/223B/2244/223D,
;   _CLOCK_CurrentDayOfMonth/2275/227E/2277, _DST_PrimaryCountdown/227B/225C, CLOCK_CacheHour,
;   _Global_WORD_CURRENT_HOUR, _CLOCK_HalfHourSlotIndex
; WRITES:
;   _ED_DiagnosticsScreenActive (early return gate), temporary text buffer on stack
; DESC:
;   Draws the ESC diagnostics memory/status screen with data/CTRL counts,
;   available memory totals, and various clock/calendar diagnostics.
; NOTES:
;   Uses _ED_DiagAvailMemMask bitmask to select which memory types to show.
;   Reuses a 72-byte local printf buffer at -72(A5) for all text lines.
;------------------------------------------------------------------------------
; draw the screen showing available memory
ESQFUNC_DrawMemoryStatusScreen:
    LINK.W  A5,#-80
    MOVEM.L D2-D7,-(A7)

    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  4(A0),-76(A5)
    MOVE.L  #_Global_REF_696_400_BITMAP,4(A0)
    TST.W   _ED_DiagnosticsScreenActive
    BEQ.W   .return

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetAPen(A6)

    MOVEA.L _Global_REF_RASTPORT_1,A1
    MOVEQ   #1,D0
    JSR     _LVOSetDrMd(A6)

    MOVE.W  _ED_DiagnosticsViewMode,D0
    BNE.W   .draw_calendar_section

    MOVEQ   #0,D0
    MOVE.W  _ESQIFF_ParseAttemptCount,D0
    MOVE.W  _DATACErrs,D1
    EXT.L   D1
    MOVE.W  _ESQIFF_LineErrorCount,D2
    EXT.L   D2

    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DATA_CMDS_CERRS_LERRS
    ; Shared 72-byte line buffer for all diagnostics rows in this function.
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     112.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.W  _SCRIPT_CtrlCmdCount,D0
    MOVE.W  _SCRIPT_CtrlCmdChecksumErrorCount,D1
    EXT.L   D1
    MOVE.W  _SCRIPT_CtrlCmdLengthErrorCount,D2
    EXT.L   D2

    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CTRL_CMDS_CERRS_LERRS
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     68(A7),A7
    MOVEQ   #7,D0
    AND.L   _ED_DiagAvailMemMask,D0
    SUBQ.L  #7,D0
    BNE.S   .check_chip_only

    MOVE.L  #$20002,D1          ; Attributes: 0x20000 = Largest
    MOVEA.L AbsExecBase,A6      ; so 0x20002 = Largest | Chip
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7

    MOVEQ   #4,D1               ; Attributes: 0x4 = Fast
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6

    MOVEQ   #2,D1               ; Attributes: 0x2 = Chip
    SWAP    D1
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5

    MOVE.L  D5,-(A7)
    MOVE.L  D6,-(A7)
    MOVE.L  D7,-(A7)
    PEA     Global_STR_L_CHIP_FAST_MAX
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     20(A7),A7
    BRA.W   .draw_memory_section

.check_chip_only:
    MOVEQ   #1,D0
    AND.L   _ED_DiagAvailMemMask,D0
    SUBQ.L  #1,D0
    BNE.S   .check_fast_only

    MOVEQ   #2,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D7
    MOVE.L  D7,-(A7)
    PEA     Global_STR_CHIP_PLACEHOLDER
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_fast_only:
    MOVEQ   #2,D0
    AND.L   _ED_DiagAvailMemMask,D0
    SUBQ.L  #2,D0
    BNE.S   .check_max_only

    MOVEQ   #4,D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D6
    MOVE.L  D6,-(A7)
    PEA     Global_STR_FAST_PLACEHOLDER
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.check_max_only:
    MOVEQ   #4,D0
    AND.L   _ED_DiagAvailMemMask,D0
    SUBQ.L  #4,D0
    BNE.S   .show_disabled

    MOVEQ   #2,D1
    SWAP    D1
    MOVEA.L AbsExecBase,A6
    JSR     _LVOAvailMem(A6)

    MOVE.L  D0,D5
    MOVE.L  D5,-(A7)
    PEA     Global_STR_MAX_PLACEHOLDER
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.show_disabled:
    PEA     Global_STR_MEMORY_TYPES_DISABLED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    ADDQ.W  #8,A7

.draw_memory_section:
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.W  ESQ_SerialRbfErrorCount,D0
    MOVE.L  D0,(A7)
    PEA     Global_STR_DATA_OVERRUNS_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    JSR     ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  _Global_WORD_H_VALUE,D0
    MOVEQ   #0,D1
    MOVE.W  _Global_WORD_T_VALUE,D1
    MOVEQ   #0,D2
    MOVE.W  _Global_WORD_MAX_VALUE,D2
    MOVE.L  D2,(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_DATA_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    JSR     ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,D4
    MOVEQ   #0,D0
    MOVE.W  _CTRL_H,D0
    MOVEQ   #0,D1
    MOVE.W  _CTRL_HPreviousSample,D1
    MOVEQ   #0,D2
    MOVE.W  _CTRL_HDeltaMax,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D4,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CTRL_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     40(A7),A7

.draw_calendar_section:
    MOVE.W  _ED_DiagnosticsViewMode,D0
    SUBQ.W  #1,D0
    BNE.W   .return

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupCode,D0
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_SecondaryGroupCode,D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_JULIAN_DAY_NEXT_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)                                 ; Text address to display
    PEA     112.W                                   ; X position
    PEA     40.W                                    ; Y position
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)               ; Rastport
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupHeaderCode,D0
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_SecondaryGroupHeaderCode,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_JDAY1_JDAY2_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     142.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVEQ   #0,D0
    MOVE.B  _TEXTDISP_PrimaryGroupPresentFlag,D0
    MOVEQ   #0,D1
    MOVE.B  _TEXTDISP_SecondaryGroupPresentFlag,D1
    MOVE.L  D1,(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_CURCLU_NXTCLU_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  CLOCK_CacheDayIndex0,D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheMonthIndex0,D1
    EXT.L   D1
    MOVE.W  ESQFUNC_CListLinePointer,D2
    EXT.L   D2
    MOVE.W  CLOCK_CacheYear,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  _CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CurrentMonthIndex,D1
    EXT.L   D1
    MOVE.W  CLOCK_CurrentLeapYearFlag,D2
    EXT.L   D2
    MOVE.W  _CLOCK_CurrentYearValue,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  _DST_PrimaryCountdown,D0
    EXT.L   D0
    MOVE.W  _DST_SecondaryCountdown,D1
    EXT.L   D1
    MOVE.W  _WDISP_BannerCharPhaseShift,D2
    EXT.L   D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_DST_B_DST_PSHIFT_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  CLOCK_CacheHour,D0
    EXT.L   D0
    MOVE.W  _Global_WORD_CURRENT_HOUR,D1
    EXT.L   D1
    MOVEQ   #0,D2
    MOVE.W  _CLOCK_HalfHourSlotIndex,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     Global_STR_C_HOUR_B_HOUR_CS_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     292.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     80(A7),A7

.return:
    MOVEA.L _Global_REF_RASTPORT_1,A0
    MOVE.L  -76(A5),4(A0)

    MOVEM.L (A7)+,D2-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_DrawDiagnosticsScreen   (DrawDiagnosticsScreenuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetFont, _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask,
;   ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag, ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag,
;   _GROUP_AM_JMPTBL_WDISP_SPrintf, _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition,
;   ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   ESQFUNC_VideoInsertionStateStrings, SCRIPT_CtrlHandshakeStage, ESQFUNC_STR_CLOSED_ENABLED/1EB9, ESQFUNC_TAG_CLOSED/1EBB, ESQFUNC_STR_CLOSED_ON_AIR/1EBD,
;   _Global_HANDLE_TOPAZ_FONT, Global_REF_GRAPHICS_LIBRARY, _WDISP_DisplayContextBase
; WRITES:
;   _ESQ_CopperStatusDigitsA/1E27/1E28/1E29/1E2A, ESQ_CopperStatusDigitsB/1E56/1E57 (status fields),
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
ESQFUNC_DrawDiagnosticsScreen:
    LINK.W  A5,#-164
    MOVEM.L D2-D7,-(A7)

    LEA     ESQFUNC_VideoInsertionStateStrings,A0
    LEA     -148(A5),A1
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.L  (A0)+,(A1)+
    MOVE.W  #$fff,D0
    MOVE.W  D0,ESQ_CopperStatusDigitsA_ColorRegistersA
    MOVE.W  D0,ESQ_CopperStatusDigitsB_ColorRegistersA
    MOVEQ   #0,D0
    MOVE.W  D0,_ESQ_CopperStatusDigitsA
    MOVE.W  D0,ESQ_CopperStatusDigitsB
    MOVE.W  D0,ESQ_CopperStatusDigitsA_ColorRegistersB
    MOVE.W  D0,ESQ_CopperStatusDigitsB_TailColorWord
    MOVE.W  D0,ESQ_CopperStatusDigitsA_ColorRegistersC
    MOVE.W  D0,ESQ_CopperStatusDigitsA_TailColorWord

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEA.L _Global_HANDLE_TOPAZ_FONT,A0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetFont(A6)

    JSR     _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .status_a_false

    LEA     ESQFUNC_STR_CLOSED_ENABLED,A0

    BRA.S   .status_a_selected

.status_a_false:
    LEA     ESQFUNC_STR_OPEN_DISABLED,A0

.status_a_selected:
    MOVE.L  A0,24(A7)
    JSR     ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag(PC)

    TST.B   D0
    BEQ.S   .status_b_false

    LEA     ESQFUNC_TAG_CLOSED,A0
    BRA.S   .status_b_selected

.status_b_false:
    LEA     ESQFUNC_TAG_OPEN,A0

.status_b_selected:
    MOVE.L  A0,28(A7)
    JSR     ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .status_c_false

    LEA     ESQFUNC_STR_CLOSED_ON_AIR,A0
    BRA.S   .status_c_selected

.status_c_false:
    LEA     ESQFUNC_STR_OPEN_OFF_AIR,A0

.status_c_selected:
    MOVE.W  SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #2,D0
    BNE.S   .select_mode_two

    LEA     ESQFUNC_STR_ON_AIR,A1
    BRA.S   .format_main_line

.select_mode_two:
    MOVE.W  SCRIPT_CtrlHandshakeStage,D0
    SUBQ.W  #1,D0
    BNE.S   .select_mode_one

    LEA     ESQFUNC_STR_OFF_AIR,A1
    BRA.S   .format_main_line

.select_mode_one:
    LEA     ESQFUNC_STR_NO_DETECT,A1

.format_main_line:
    ; `%s` args here are selected from static string literals above:
    ; CartSW, CartREL, VidSW, and on_air tags.
    ; Budget note for -132(A5): conservative max is 85 bytes incl NUL.
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    MOVE.L  36(A7),-(A7)
    MOVE.L  36(A7),-(A7)
    PEA     ESQFUNC_FMT_CARTSW_COLON_PCT_S_CARTREL_COLON_PCT
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
    ; Entry-string source is from ESQFUNC_VideoInsertionStateStrings (4 static labels).
    ; Budget note for -132(A5): conservative max is 62 bytes incl NUL
    ; (uses 8-digit worst-case for %04X-style hex expansion).
    MOVE.L  D0,(A7)
    MOVE.L  (A0),-(A7)
    PEA     ESQFUNC_FMT_INSERTIME_PCT_S_WINIT_0X_PCT_04X
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
    ; decremented in TEXTDISP_TickDisplayState while armed.
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    MOVEQ   #0,D1
    MOVE.W  TEXTDISP_DeferredActionArmed,D1
    ; Layout-coupled _LOCAVAIL_PrimaryFilterState longs (+12 then +8).
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field0C,(A7)
    MOVE.L  LOCAVAIL_PrimaryFilterState_Field08,-(A7)
    ; Filter class/step/mode are state-machine outputs from LOCAVAIL_UpdateFilterStateMachine.
    MOVE.L  _LOCAVAIL_FilterClassId,-(A7)
    MOVE.L  _LOCAVAIL_FilterStep,-(A7)
    MOVE.L  _LOCAVAIL_FilterModeFlag,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 156 bytes incl NUL
    ; (%ld/%d treated as up to 11 chars each), so this row is top guard priority.
    PEA     ESQFUNC_FMT_LOCAL_MODE_PCT_LD_LOCAL_UPDATE_PCT_L
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
    ; Clock globals are normalized by PARSEINI_NormalizeClockData.
    ; Month/day are 0-based table indexes; month is +1 only when writing RTC.
    MOVE.W  CLOCK_CacheMonthIndex0,D0
    EXT.L   D0
    MOVE.W  CLOCK_CacheDayIndex0,D1
    EXT.L   D1
    MOVE.W  CLOCK_CacheYear,D2
    EXT.L   D2
    MOVE.W  CLOCK_CacheHour,D3
    EXT.L   D3
    MOVE.W  CLOCK_CacheMinuteOrSecond,D4
    EXT.L   D4
    ; Seconds snapshot used by PARSEINI/SCRIPT clock-change detection paths.
    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D5
    EXT.L   D5
    ; AM/PM selector: 0 = AM, non-zero (typically -1) = PM.
    TST.W   CLOCK_CacheAmPmFlag
    BEQ.S   .use_am_suffix

    LEA     ESQFUNC_STR_PM,A0
    BRA.S   .format_clock_line

.use_am_suffix:
    LEA     ESQFUNC_STR_AM,A0

.format_clock_line:
    ; LOCAVAIL cooldown timer: seeded in LOCAVAIL and adjusted/decremented in CLEANUP/APP2 ticks.
    MOVE.W  LOCAVAIL_FilterCooldownTicks,D6
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
    PEA     ESQFUNC_FMT_CTIME_PCT_02D_SLASH_PCT_02D_SLASH_PC
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
    PEA     ESQFUNC_FMT_L_CHIP_COLON_PCT_07LD_FAST_COLON_PCT
    PEA     -132(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     68(A7),A7
    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    PEA     164.W
    PEA     -132(A5)
    MOVE.L  A0,-(A7)
    JSR     _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(PC)

    JSR     ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

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
    PEA     ESQFUNC_FMT_DATA_COLON_CMD_CNT_COLON_PCT_08LD_CR
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
    JSR     ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

    MOVE.L  D0,(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    MOVE.L  84(A7),-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 110 bytes incl NUL.
    PEA     ESQFUNC_FMT_CTRL_COLON_CMD_CNT_COLON_PCT_08LD_CR
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
    ADDQ.L  #1,ESQFUNC_DiagRowCounter
    MOVE.W  _Global_RefreshTickCounter,D0
    EXT.L   D0
    TST.W   ESQDISP_PrimarySecondaryMirrorFlag
    BEQ.S   .set_false_text

    LEA     Global_STR_TRUE_2,A0
    BRA.S   .format_tick_line

.set_false_text:
    LEA     Global_STR_FALSE_2,A0

.format_tick_line:
    ; SCRIPT playback-side command counter (incremented in SCRIPT3 dispatch path).
    MOVE.W  SCRIPT_PlaybackFallbackCounter,D1
    EXT.L   D1
    ; ED finite-state id (byte enum set across ED menu handlers).
    MOVE.B  _ED_MenuStateId,D2
    EXT.W   D2
    EXT.L   D2
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    ; `%s` here is only Global_STR_TRUE_2 / Global_STR_FALSE_2.
    MOVE.L  A0,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  ESQFUNC_DiagRowCounter,-(A7)
    ; Budget note for -132(A5): full signed-32 worst-case is 142 bytes incl NUL,
    ; driven by four numeric fields plus "%s" TRUE/FALSE token.
    PEA     ESQFUNC_FMT_PCT_05LD_COLON_PEP_COLON_PCT_LD_REUS
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

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_SetRastForMode
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode:
    JMP     TEXTDISP_SetRastForMode

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _P_TYPE_PromoteSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_P_TYPE_PromoteSecondaryList:
    JMP     _P_TYPE_PromoteSecondaryList

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _DISKIO_ProbeDrivesAndAssignPaths
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_DISKIO_ProbeDrivesAndAssignPaths:
    JMP     _DISKIO_ProbeDrivesAndAssignPaths

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax:
    JMP     _PARSEINI_UpdateCtrlHDeltaMax

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_ClampBannerCharRange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_ClampBannerCharRange:
    JMP     _ESQ_ClampBannerCharRange

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ReadHandshakeBit3Flag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag:
    JMP     _SCRIPT_ReadHandshakeBit3Flag

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TLIBA3_DrawCenteredWrappedTextLines
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines:
    JMP     TLIBA3_DrawCenteredWrappedTextLines

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_GetCtrlLineFlag
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_GetCtrlLineFlag:
    JMP     _SCRIPT_GetCtrlLineFlag

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_SyncSecondaryFilterForCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LOCAVAIL_SyncSecondaryFilterForCurrentGroup:
    JMP     _LOCAVAIL_SyncSecondaryFilterForCurrentGroup

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _TEXTDISP_ResetSelectionAndRefresh
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_ResetSelectionAndRefresh:
    JMP     _TEXTDISP_ResetSelectionAndRefresh

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_MonitorClockChange
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange:
    JMP     PARSEINI_MonitorClockChange

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_ParseHexDigit
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     _LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_ProcessAlerts
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts:
    ; Update on-screen alerts and pending timers (cleanup module owns the UI state).
    JMP     CLEANUP_ProcessAlerts

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_GetHalfHourSlotIndex
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_ESQ_GetHalfHourSlotIndex:
    JMP     _ESQ_GetHalfHourSlotIndex

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   CLEANUP_DrawClockBanner
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_CLEANUP_DrawClockBanner:
    JMP     CLEANUP_DrawClockBanner

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _PARSEINI_ComputeHTCMaxValues
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues:
    JMP     _PARSEINI_ComputeHTCMaxValues

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LADFUNC_UpdateHighlightState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState:
    JMP     _LADFUNC_UpdateHighlightState

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _P_TYPE_EnsureSecondaryList
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_P_TYPE_EnsureSecondaryList:
    JMP     _P_TYPE_EnsureSecondaryList

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _SCRIPT_ReadHandshakeBit5Mask
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit5Mask:
    JMP     _SCRIPT_ReadHandshakeBit5Mask

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   PARSEINI_NormalizeClockData
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_PARSEINI_NormalizeClockData:
    JMP     PARSEINI_NormalizeClockData

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_TickGlobalCounters   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   ESQ_TickGlobalCounters
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_TickGlobalCounters:
    JMP     ESQ_TickGlobalCounters

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   SCRIPT_HandleSerialCtrlCmd
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_SCRIPT_HandleSerialCtrlCmd:
    JMP     SCRIPT_HandleSerialCtrlCmd

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_HandleSerialRbfInterrupt
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_HandleSerialRbfInterrupt:
    JMP     _ESQ_HandleSerialRbfInterrupt

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   TEXTDISP_TickDisplayState
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState:
    JMP     TEXTDISP_TickDisplayState

;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_JMPTBL_ESQ_PollCtrlInput   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQ_PollCtrlInput
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
_ESQFUNC_JMPTBL_ESQ_PollCtrlInput:
    JMP     _ESQ_PollCtrlInput

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _LOCAVAIL_RebuildFilterStateFromCurrentGroup
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_LOCAVAIL_RebuildFilterStateFromCurrentGroup:
    JMP     _LOCAVAIL_RebuildFilterStateFromCurrentGroup

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_JMPTBL_STRING_CopyPadNul   (Jump-table forwarder)
; ARGS:
;   (none observed)
; RET:
;   D0: result/status
; CLOBBERS:
;   D0
; CALLS:
;   _STRING_CopyPadNul
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Thin jump-table forwarder; execution immediately transfers to CALLS target.
; NOTES:
;   No local logic; argument/return behavior matches forwarded routine.
;------------------------------------------------------------------------------
ESQFUNC_JMPTBL_STRING_CopyPadNul:
    JMP     _STRING_CopyPadNul

;!======

    MOVEQ   #97,D0

;!======

;------------------------------------------------------------------------------
; FUNC: ESQFUNC_SelectAndApplyBrushForCurrentEntry   (Select and blit brush for current entry context)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +16: arg_3 (via 20(A5))
;   stack +20: arg_4 (via 24(A5))
;   stack +28: arg_5 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A5/A6/A7/D0/D1/D2/D4/D5/D6/D7
; CALLS:
;   ESQIFF_JMPTBL_BRUSH_SelectBrushSlot, ESQIFF_JMPTBL_STRING_CompareN, _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex, _ESQSHARED_JMPTBL_ESQ_WildcardMatch, _ESQIFF_RestoreBasePaletteTriples, _LVOSetRast
; READS:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, _BRUSH_SelectedNode, Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_2, __ESQFUNC_BasePaletteRgbTriples, _ESQFUNC_FallbackType3BrushNode, _ESQIFF_BrushIniListHead, ESQFUNC_TAG_00, ESQFUNC_TAG_11, _TEXTDISP_ActiveGroupId, _WDISP_DisplayContextBase, _TEXTDISP_PrimaryEntryPtrTable, _TEXTDISP_SecondaryEntryPtrTable, _WDISP_PaletteTriplesRBase, _TEXTDISP_CurrentMatchIndex, e8
; WRITES:
;   (none observed)
; DESC:
;   Chooses a brush from script selection or brush.ini metadata for the current
;   entry, clears target rastports, blits the brush, and applies palette-copy rules.
; NOTES:
;   Entry tag bytes at `entry+0x2B` steer tag/wildcard lookup paths.
;------------------------------------------------------------------------------
ESQFUNC_SelectAndApplyBrushForCurrentEntry:
    LINK.W  A5,#-32
    MOVEM.L D2/D4-D7,-(A7)
    MOVE.W  10(A5),D7
    MOVE.L  _ESQIFF_BrushIniListHead,-4(A5)
    MOVEQ   #0,D5
    TST.W   D7
    BNE.S   .load_secondary_script_selection

    MOVE.L  BRUSH_ScriptPrimarySelection,-24(A5) ; prefer script-selected brush if present
    BRA.S   .resolve_selection_source

.load_secondary_script_selection:
    MOVEA.L BRUSH_ScriptSecondarySelection,A0 ; fall back to secondary slot when requested
    MOVE.L  A0,-24(A5)

.resolve_selection_source:
    TST.L   -24(A5)
    BNE.W   .use_script_selected_brush

    MOVE.W  _TEXTDISP_ActiveGroupId,D0
    SUBQ.W  #1,D0
    BNE.S   .load_secondary_current_entry_ptr

    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_PrimaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)
    BRA.S   .compare_entry_tag_00

.load_secondary_current_entry_ptr:
    MOVE.W  _TEXTDISP_CurrentMatchIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     _TEXTDISP_SecondaryEntryPtrTable,A0
    ADDA.L  D0,A0
    MOVE.L  (A0),-8(A5)

.compare_entry_tag_00:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     ESQFUNC_TAG_00
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .compare_entry_tag_11

    MOVE.L  _BRUSH_SelectedNode,-4(A5)
    MOVEQ   #1,D5
    BRA.W   .ensure_fallback_selected_brush

.compare_entry_tag_11:
    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    PEA     2.W
    PEA     ESQFUNC_TAG_11
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .scan_brush_nodes_by_2char_tag

.scan_brush_nodes_by_wildcard_chain:
    TST.L   -4(A5)
    BEQ.S   .fallback_to_type3_or_selected

    TST.L   D5
    BNE.S   .fallback_to_type3_or_selected

    MOVEA.L -4(A5),A0
    MOVE.L  364(A0),-20(A5)

.loop_match_wildcard_list:
    TST.L   -20(A5)
    BEQ.S   .advance_brush_node_chain

    TST.L   D5
    BNE.S   .advance_brush_node_chain

    MOVEA.L -8(A5),A0
    ADDA.W  #12,A0
    MOVE.L  -20(A5),-(A7)
    MOVE.L  A0,-(A7)
    JSR     _ESQSHARED_JMPTBL_ESQ_WildcardMatch(PC)

    ADDQ.W  #8,A7
    TST.B   D0
    BNE.S   .advance_wildcard_node

    MOVEQ   #1,D5

.advance_wildcard_node:
    MOVEA.L -20(A5),A0
    MOVE.L  8(A0),-20(A5)
    BRA.S   .loop_match_wildcard_list

.advance_brush_node_chain:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_wildcard_chain

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_wildcard_chain

.fallback_to_type3_or_selected:
    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    BTST    #4,27(A0)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   _ESQFUNC_FallbackType3BrushNode
    BEQ.S   .ensure_fallback_selected_brush

    MOVEQ   #1,D5
    MOVE.L  _ESQFUNC_FallbackType3BrushNode,-4(A5)
    BRA.S   .ensure_fallback_selected_brush

.scan_brush_nodes_by_2char_tag:
    TST.L   -4(A5)
    BEQ.S   .ensure_fallback_selected_brush

    TST.L   D5
    BNE.S   .ensure_fallback_selected_brush

    MOVEA.L -8(A5),A0
    ADDA.W  #$2b,A0
    MOVEA.L -4(A5),A1
    ADDA.W  #$21,A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     ESQIFF_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .advance_tag_match_node

    MOVEQ   #1,D5

.advance_tag_match_node:
    TST.L   D5
    BNE.S   .scan_brush_nodes_by_2char_tag

    MOVEA.L -4(A5),A0
    MOVE.L  368(A0),-4(A5)
    BRA.S   .scan_brush_nodes_by_2char_tag

.use_script_selected_brush:
    MOVEQ   #1,D5
    MOVE.L  -24(A5),-4(A5)

.ensure_fallback_selected_brush:
    TST.L   D5
    BNE.S   .clear_rastports_before_brush_blit

    MOVE.L  _BRUSH_SelectedNode,-4(A5)

.clear_rastports_before_brush_blit:
    MOVEA.L Global_REF_RASTPORT_2,A1
    MOVEQ   #31,D0
    MOVEA.L Global_REF_GRAPHICS_LIBRARY,A6
    JSR     _LVOSetRast(A6)

    MOVEA.L _WDISP_DisplayContextBase,A0
    ADDA.W  #(Offset_RastPort2_FromDisplayContextBase+2),A0
    MOVEA.L A0,A1
    MOVEQ   #31,D0
    JSR     _LVOSetRast(A6)

    TST.L   -4(A5)
    BEQ.S   .maybe_copy_brush_palette_segment

    TST.L   _BRUSH_SelectedNode
    BNE.S   .blit_selected_brush_to_rast

    TST.L   D5
    BEQ.S   .maybe_copy_brush_palette_segment

.blit_selected_brush_to_rast:
    MOVEQ   #0,D0
    MOVEA.L _WDISP_DisplayContextBase,A0
    MOVE.W  2(A0),D0
    SUBQ.L  #1,D0
    MOVEQ   #0,D1
    MOVE.W  4(A0),D1
    SUBQ.L  #1,D1
    MOVEQ   #0,D2
    MOVE.L  D2,-(A7)
    MOVE.L  Global_REF_RASTPORT_2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  -4(A5),-(A7)
    JSR     ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(PC)

    LEA     28(A7),A7

.maybe_copy_brush_palette_segment:
    TST.L   -4(A5)
    BEQ.W   .restore_base_palette_when_no_brush

    MOVEA.L -4(A5),A0
    TST.L   328(A0)
    BEQ.S   .prepare_plane_mask_bounds

    MOVE.L  328(A0),D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .prepare_plane_mask_bounds

    SUBQ.L  #3,D0
    BNE.S   .apply_brush_palette_mode_postprocess

.prepare_plane_mask_bounds:
    PEA     5.W
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVE.L  D1,D4
    MOVEQ   #0,D0
    MOVEA.L -4(A5),A0
    MOVE.B  184(A0),D0
    MOVE.L  D0,(A7)
    JSR     _ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(PC)

    ADDQ.W  #4,A7
    MOVE.L  D0,D1
    LSL.L   #2,D1
    SUB.L   D0,D1
    MOVEQ   #0,D6
    MOVE.L  D1,-32(A5)

.loop_copy_palette_bytes_from_brush:
    CMP.L   -32(A5),D6
    BGE.S   .apply_brush_palette_mode_postprocess

    CMP.L   D4,D6
    BGE.S   .apply_brush_palette_mode_postprocess

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    MOVEA.L -4(A5),A1
    MOVE.L  D6,D0
    ADDI.L  #$e8,D0
    MOVE.B  0(A1,D0.L),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_copy_palette_bytes_from_brush

.apply_brush_palette_mode_postprocess:
    MOVEQ   #1,D0
    MOVEA.L -4(A5),A0
    CMP.L   328(A0),D0
    BNE.S   .check_palette_mode_three

    BSR.W   _ESQIFF_RestoreBasePaletteTriples

    BRA.S   .return

.check_palette_mode_three:
    MOVEQ   #3,D0
    CMP.L   328(A0),D0
    BNE.S   .return

    MOVEQ   #0,D6

.loop_restore_first_12_palette_bytes:
    MOVEQ   #12,D0
    CMP.L   D0,D6
    BGE.S   .return

    LEA     _WDISP_PaletteTriplesRBase,A0
    ADDA.L  D6,A0
    LEA     __ESQFUNC_BasePaletteRgbTriples,A1
    ADDA.L  D6,A1
    MOVE.B  (A1),(A0)
    ADDQ.L  #1,D6
    BRA.S   .loop_restore_first_12_palette_bytes

.restore_base_palette_when_no_brush:
    BSR.W   _ESQIFF_RestoreBasePaletteTriples

.return:
    MOVEQ   #1,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======