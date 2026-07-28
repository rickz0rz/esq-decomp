    XDEF    _ESQFUNC_DrawMemoryStatusScreen



;------------------------------------------------------------------------------
; FUNC: _ESQFUNC_DrawMemoryStatusScreen   (DrawMemoryStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _LVOSetAPen, _LVOSetDrMd, _LVOAvailMem, _GROUP_AM_JMPTBL_WDISP_SPrintf,
;   _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition, _ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues,
;   _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax
; READS:
;   _ED_DiagnosticsScreenActive, _ED_DiagnosticsViewMode, _ED_DiagAvailMemMask, _ESQIFF_ParseAttemptCount, _DATACErrs, _ESQIFF_LineErrorCount,
;   _SCRIPT_CtrlCmdCount/2348/2349, _ESQ_SerialRbfErrorCount, _Global_WORD_H_VALUE, _Global_WORD_T_VALUE,
;   _Global_WORD_MAX_VALUE, _CTRL_H, _CTRL_HPreviousSample, _CTRL_HDeltaMax, _TEXTDISP_PrimaryGroupCode/_TEXTDISP_SecondaryGroupCode,
;   _TEXTDISP_PrimaryGroupHeaderCode/_TEXTDISP_SecondaryGroupHeaderCode, _TEXTDISP_PrimaryGroupPresentFlag/_TEXTDISP_SecondaryGroupPresentFlag, _CLOCK_CacheDayIndex0/223B/2244/223D,
;   _CLOCK_CurrentDayOfMonth/2275/227E/2277, _DST_PrimaryCountdown/227B/225C, _CLOCK_CacheHour,
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
_ESQFUNC_DrawMemoryStatusScreen:
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
    PEA     _Global_STR_DATA_CMDS_CERRS_LERRS
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
    PEA     _Global_STR_CTRL_CMDS_CERRS_LERRS
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
    PEA     _Global_STR_L_CHIP_FAST_MAX
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
    PEA     _Global_STR_CHIP_PLACEHOLDER
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
    PEA     _Global_STR_FAST_PLACEHOLDER
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
    PEA     _Global_STR_MAX_PLACEHOLDER
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     12(A7),A7
    BRA.S   .draw_memory_section

.show_disabled:
    PEA     _Global_STR_MEMORY_TYPES_DISABLED
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
    MOVE.W  _ESQ_SerialRbfErrorCount,D0
    MOVE.L  D0,(A7)
    PEA     _Global_STR_DATA_OVERRUNS_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     202.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    JSR     _ESQFUNC_JMPTBL_PARSEINI_ComputeHTCMaxValues(PC)

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
    PEA     _Global_STR_DATA_H_T_C_MAX_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     232.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    LEA     76(A7),A7
    JSR     _ESQFUNC_JMPTBL_PARSEINI_UpdateCtrlHDeltaMax(PC)

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
    PEA     _Global_STR_CTRL_H_T_C_MAX_FORMATTED
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
    PEA     _Global_STR_JULIAN_DAY_NEXT_FORMATTED
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
    PEA     _Global_STR_JDAY1_JDAY2_FORMATTED
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
    PEA     _Global_STR_CURCLU_NXTCLU_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    LEA     72(A7),A7
    PEA     -72(A5)
    PEA     172.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  _CLOCK_CacheDayIndex0,D0
    EXT.L   D0
    MOVE.W  _CLOCK_CacheMonthIndex0,D1
    EXT.L   D1
    MOVE.W  _ESQFUNC_CListLinePointer,D2
    EXT.L   D2
    MOVE.W  _CLOCK_CacheYear,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_C_DATE_C_MONTH_LP_YR_FORMATTED
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
    MOVE.W  _CLOCK_CurrentLeapYearFlag,D2
    EXT.L   D2
    MOVE.W  _CLOCK_CurrentYearValue,D3
    EXT.L   D3
    MOVE.L  D3,(A7)
    MOVE.L  D2,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_B_DATE_B_MONTH_LP_YR_FORMATTED
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
    PEA     _Global_STR_C_DST_B_DST_PSHIFT_FORMATTED
    PEA     -72(A5)
    JSR     _GROUP_AM_JMPTBL_WDISP_SPrintf(PC)

    PEA     -72(A5)
    PEA     262.W
    PEA     40.W
    MOVE.L  _Global_REF_RASTPORT_1,-(A7)
    JSR     _ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(PC)

    MOVE.W  _CLOCK_CacheHour,D0
    EXT.L   D0
    MOVE.W  _Global_WORD_CURRENT_HOUR,D1
    EXT.L   D1
    MOVEQ   #0,D2
    MOVE.W  _CLOCK_HalfHourSlotIndex,D2
    MOVE.L  D2,(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    PEA     _Global_STR_C_HOUR_B_HOUR_CS_FORMATTED
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