    XDEF    GENERATE_GRID_DATE_STRING
    XDEF    SCRIPT_ApplyPendingBannerTarget
    XDEF    SCRIPT_BeginBannerCharTransition
    XDEF    SCRIPT_CheckPathExists
    XDEF    SCRIPT_ClearSearchTextsAndChannels
    XDEF    SCRIPT_DispatchPlaybackCursorCommand
    XDEF    SCRIPT_HandleBrushCommand
    XDEF    SCRIPT_HandleSerialCtrlCmd
    XDEF    SCRIPT_InitCtrlContext
    XDEF    SCRIPT_LoadCtrlContextSnapshot
    XDEF    SCRIPT_PrimeBannerTransitionFromHexCode
    XDEF    SCRIPT_ProcessCtrlContextPlaybackTick
    XDEF    SCRIPT_ResetCtrlContext
    XDEF    SCRIPT_ResetCtrlContextAndClearStatusLine
    XDEF    SCRIPT_SaveCtrlContextSnapshot
    XDEF    SCRIPT_SelectPlaybackCursorFromSearchText
    XDEF    SCRIPT_SetCtrlContextMode
    XDEF    SCRIPT_SplitAndNormalizeSearchBuffer
    XDEF    SCRIPT_UpdateBannerCharTransition
    XDEF    SCRIPT_UpdateCtrlStateMachine
    XDEF    SCRIPT_UpdateRuntimeModeForPlaybackCursor
    XDEF    SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen
    XDEF    SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh
    XDEF    SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist
    XDEF    SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
    XDEF    SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom
    XDEF    SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
    XDEF    SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
    XDEF    SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState
    XDEF    SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
    XDEF    SCRIPT3_JMPTBL_MATH_DivS32
    XDEF    SCRIPT3_JMPTBL_MATH_Mulu32
    XDEF    SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt
    XDEF    SCRIPT3_JMPTBL_STRING_CompareN
    XDEF    SCRIPT3_JMPTBL_STRING_CopyPadNul


;!======

;------------------------------------------------------------------------------
; FUNC: GENERATE_GRID_DATE_STRING   (GenerateGridDateStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   D0-D1/A0-A1/A3
; CALLS:
;   PARSEINI_JMPTBL_WDISP_SPrintf
; READS:
;   CLOCK_CurrentDayOfWeekIndex/2275/2276/2277, Global_JMPTBL_DAYS_OF_WEEK, Global_JMPTBL_MONTHS
; WRITES:
;   outBuffer
; DESC:
;   Formats the current grid date string into outBuffer.
; NOTES:
;   Uses Global_STR_GRID_DATE_FORMAT_STRING as the template.
;------------------------------------------------------------------------------
GENERATE_GRID_DATE_STRING:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    MOVE.W  CLOCK_CurrentDayOfWeekIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_DAYS_OF_WEEK,A0
    ADDA.L  D0,A0
    MOVE.W  CLOCK_CurrentMonthIndex,D0
    EXT.L   D0
    ASL.L   #2,D0
    LEA     Global_JMPTBL_MONTHS,A1
    ADDA.L  D0,A1
    MOVE.W  CLOCK_CurrentDayOfMonth,D0
    EXT.L   D0
    MOVE.W  CLOCK_CurrentYearValue,D1
    EXT.L   D1
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    MOVE.L  (A1),-(A7)
    MOVE.L  (A0),-(A7)
    PEA     Global_STR_GRID_DATE_FORMAT_STRING
    MOVE.L  A3,-(A7)
    JSR     PARSEINI_JMPTBL_WDISP_SPrintf(PC)

    LEA     24(A7),A7
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CopyWeatherUpdateForString   (CopyWeatherUpdateForStringuncertain)
; ARGS:
;   stack +8: outBuffer (char *)
; RET:
;   (none)
; CLOBBERS:
;   A0-A1/A3
; CALLS:
;   (none)
; READS:
;   Global_STR_WEATHER_UPDATE_FOR
; WRITES:
;   outBuffer
; DESC:
;   Copies the "Weather Update For" string into outBuffer.
; NOTES:
;   Previously unlabeled; appears unused in current build.
;------------------------------------------------------------------------------
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3

    LEA     Global_STR_WEATHER_UPDATE_FOR,A0
    MOVEA.L A3,A1

.copy_loop:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .copy_loop

    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_CheckPathExists   (CheckPathExistsuncertain)
; ARGS:
;   stack +8: path (char *)
; RET:
;   D0: 1 if lock/unlock succeeds, 0 otherwise
; CLOBBERS:
;   D0-D2/D6-D7/A3
; CALLS:
;   _LVOLock, _LVOUnLock
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Attempts a DOS lock on path and returns whether it succeeds.
; NOTES:
;   Uses lock mode -2 (shared read).
;------------------------------------------------------------------------------
SCRIPT_CheckPathExists:
    MOVEM.L D2/D6-D7/A3,-(A7)
    MOVEA.L 20(A7),A3

    MOVEQ   #0,D7
    MOVEQ   #0,D6
    MOVE.L  A3,D1
    MOVEQ   #-2,D2
    MOVEA.L Global_REF_DOS_LIBRARY_2,A6
    JSR     _LVOLock(A6)

    MOVE.L  D0,D7
    TST.L   D7
    BEQ.S   .return

    MOVE.L  D7,D1
    JSR     _LVOUnLock(A6)

    MOVEQ   #1,D6

.return:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D2/D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateBannerCharTransition   (UpdateBannerCharTransitionuncertain)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D7/A4
; CALLS:
;   SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar, SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset
; READS:
;   DATA_SCRIPT_BSS_WORD_2120/SCRIPT_BannerTransitionActive/DATA_SCRIPT_BSS_WORD_212A, DATA_WDISP_BSS_WORD_2352/2353/2354
; WRITES:
;   SCRIPT_BannerTransitionActive/DATA_SCRIPT_BSS_WORD_212A, banner character (via SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset)
; DESC:
;   Advances an in-progress banner character transition toward its target.
; NOTES:
;   Disables the transition when the target is reached.
;------------------------------------------------------------------------------
SCRIPT_UpdateBannerCharTransition:
    MOVEM.L D2-D7/A4,-(A7)

    LEA     Global_REF_LONG_FILE_SCRATCH,A4
    TST.W   SCRIPT_BannerTransitionActive
    BEQ.W   .done

    JSR     SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D6
    MOVEQ   #0,D0
    MOVE.B  DATA_WDISP_BSS_WORD_2352,D0
    MOVE.L  D6,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .advance_step

    MOVEQ   #0,D1
    MOVE.W  D1,SCRIPT_BannerTransitionActive
    MOVE.W  D1,DATA_SCRIPT_BSS_WORD_212A
    BRA.W   .done

.advance_step:
    MOVE.W  DATA_WDISP_BSS_WORD_2353,D5
    MOVE.W  DATA_SCRIPT_BSS_WORD_2120,D1
    MOVEQ   #0,D2
    CMP.W   D2,D1
    BLS.S   .calc_candidate

    ADDQ.W  #1,DATA_SCRIPT_BSS_WORD_212A
    MOVE.W  DATA_SCRIPT_BSS_WORD_212A,D3
    CMP.W   D1,D3
    BLT.S   .calc_candidate

    MOVE.W  DATA_WDISP_BSS_WORD_2354,D3
    ADD.W   D3,D5
    MOVE.W  D2,DATA_SCRIPT_BSS_WORD_212A

.calc_candidate:
    MOVE.L  D5,D7
    ADD.W   D6,D7
    MOVE.W  DATA_WDISP_BSS_WORD_2354,D3
    TST.W   D3
    BPL.S   .check_positive_step

    MOVE.L  D7,D4
    EXT.L   D4
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    CMP.L   D1,D4
    BLT.S   .snap_to_target

.check_positive_step:
    TST.W   D3
    BLE.S   .check_zero_step

    MOVE.L  D7,D1
    EXT.L   D1
    MOVEQ   #0,D3
    MOVE.B  D0,D3
    CMP.L   D3,D1
    BGT.S   .snap_to_target

.check_zero_step:
    TST.W   DATA_WDISP_BSS_WORD_2353
    BNE.S   .apply_step

    TST.W   DATA_SCRIPT_BSS_WORD_2120
    BNE.S   .apply_step

.snap_to_target:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  D6,D0
    EXT.L   D0
    SUB.L   D0,D1
    MOVE.L  D1,D5

.apply_step:
    MOVE.L  D5,D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset(PC)

    ADDQ.W  #4,A7

.done:
    MOVEM.L (A7)+,D2-D7/A4
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_BeginBannerCharTransition   (Configure and start banner-char transition)
; ARGS:
;   stack +6: arg_1 (via 10(A5))
;   stack +8: arg_2 (via 12(A5))
;   stack +10: arg_3 (via 14(A5))
; RET:
;   D0: 1 if a transition was started, 0 otherwise
; CLOBBERS:
;   D0-D7
; CALLS:
;   GCOMMAND_GetBannerChar, SCRIPT3_JMPTBL_MATH_DivS32, SCRIPT3_JMPTBL_MATH_Mulu32
; READS:
;   CONFIG_LRBN_FlagChar/CONFIG_MSN_FlagChar, Global_WORD_SELECT_CODE_IS_RAVESC, SCRIPT_BannerTransitionActive
; WRITES:
;   DATA_WDISP_BSS_WORD_2352/2353/2354, DATA_SCRIPT_BSS_WORD_2120, SCRIPT_BannerTransitionActive, DATA_SCRIPT_BSS_WORD_211F
; DESC:
;   Prepares parameters for a banner-char transition toward a target value.
; NOTES:
;   Clamps target to 130..226 and rate to 0..$1D4C. Uses current banner char
;   from GCOMMAND_GetBannerChar; returns 0 if already at target or busy.
;------------------------------------------------------------------------------
SCRIPT_BeginBannerCharTransition:
    LINK.W  A5,#-12
    MOVEM.L D2/D4-D7,-(A7)

    MOVE.W  10(A5),D7
    MOVE.W  14(A5),D6

    MOVEQ   #0,D5
    MOVE.B  CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.W   .return

    CMPI.W  #130,D7
    BGE.S   .begin_banner_clamp_high_check

    MOVE.W  #130,D7
    BRA.S   .begin_banner_after_target_clamp

.begin_banner_clamp_high_check:
    CMPI.W  #226,D7
    BLE.S   .begin_banner_after_target_clamp

    MOVE.W  #226,D7

.begin_banner_after_target_clamp:
    MOVEQ   #0,D0
    CMP.W   D0,D6
    BCC.S   .begin_banner_clamp_rate_high_check

    MOVE.L  D0,D6
    BRA.S   .begin_banner_after_rate_clamp

.begin_banner_clamp_rate_high_check:
    CMPI.W  #$1d4c,D6
    BLS.S   .begin_banner_after_rate_clamp

    MOVE.W  #$1d4c,D6

.begin_banner_after_rate_clamp:
    JSR     SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.W  D0,-12(A5)
    TST.W   SCRIPT_BannerTransitionActive
    BNE.W   .return

    CMP.W   D7,D0
    BEQ.W   .return

    MOVE.L  D7,D1
    MOVE.L  D7,D2
    EXT.L   D2
    EXT.L   D0
    SUB.L   D0,D2
    MOVE.L  D2,D4
    MOVE.B  D1,DATA_WDISP_BSS_WORD_2352
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .config_msn_flag_not_m

.selectCodeIsNotRAVSEC:
    TST.L   D4
    BPL.S   .begin_banner_default_rate_if_forward

    MOVE.L  #7500,D0
    BRA.S   .begin_banner_after_rate_override

.begin_banner_default_rate_if_forward:
    MOVEQ   #0,D0

.begin_banner_after_rate_override:
    MOVE.L  D0,D6

.config_msn_flag_not_m:
    MOVE.L  D6,D0
    MULU    #60,D0
    MOVE.L  #1000,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.L  D0,-10(A5)
    BGT.S   .begin_banner_compute_step

    MOVE.L  D4,D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_2353
    BRA.S   .begin_banner_activate

.begin_banner_compute_step:
    TST.L   D4
    BPL.S   .begin_banner_direction_positive

    MOVEQ   #-1,D1
    BRA.S   .begin_banner_direction_selected

.begin_banner_direction_positive:
    MOVEQ   #1,D1

.begin_banner_direction_selected:
    MOVE.W  D1,DATA_WDISP_BSS_WORD_2354
    TST.L   D4
    BPL.S   .begin_banner_abs_delta_positive

    MOVE.L  D4,D2
    NEG.L   D2
    BRA.S   .begin_banner_abs_delta_ready

.begin_banner_abs_delta_positive:
    MOVE.L  D4,D2

.begin_banner_abs_delta_ready:
    MOVE.L  D2,D4
    MOVE.L  D4,D0
    MOVE.L  -10(A5),D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,DATA_WDISP_BSS_WORD_2353
    EXT.L   D0
    MOVE.L  -10(A5),D1
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    SUB.L   D0,D4
    BLE.S   .begin_banner_no_remainder

    MOVE.L  -10(A5),D0
    MOVE.L  D4,D1
    JSR     SCRIPT3_JMPTBL_MATH_DivS32(PC)

    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_2120
    BRA.S   .begin_banner_finalize_step_sign

.begin_banner_no_remainder:
    CLR.W   DATA_SCRIPT_BSS_WORD_2120

.begin_banner_finalize_step_sign:
    MOVE.W  DATA_WDISP_BSS_WORD_2353,D0
    MULS    DATA_WDISP_BSS_WORD_2354,D0
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2353

.begin_banner_activate:
    MOVE.L  D6,D0
    MOVEQ   #1,D5
    MOVE.W  D5,SCRIPT_BannerTransitionActive
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_211F

.return:
    MOVE.L  D5,D0
    MOVEM.L (A7)+,D2/D4-D7
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_PrimeBannerTransitionFromHexCode   (PrimeBannerTransitionFromHexCode)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D2/D3/D7
; CALLS:
;   SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar
; READS:
;   Global_REF_WORD_HEX_CODE_8E (target banner char)
; WRITES:
;   DATA_SCRIPT_BSS_WORD_2120, SCRIPT_BannerTransitionActive, DATA_WDISP_BSS_WORD_2352, DATA_WDISP_BSS_WORD_2353, DATA_WDISP_BSS_WORD_2354
; DESC:
;   Initializes transition-step globals to move the current banner character
;   directly toward Global_REF_WORD_HEX_CODE_8E.
; NOTES:
;   DATA_SCRIPT_BSS_WORD_2120 is reset to 0; transition is enabled only when
;   current and target characters differ.
;------------------------------------------------------------------------------
SCRIPT_PrimeBannerTransitionFromHexCode:
    MOVEM.L D2-D3/D7,-(A7)

    JSR     SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_BannerTransitionActive
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D1
    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVE.L  D7,D3
    EXT.L   D3
    SUB.L   D3,D2
    MOVE.B  D1,DATA_WDISP_BSS_WORD_2352
    MOVE.W  D2,DATA_WDISP_BSS_WORD_2353
    BGE.S   .step_positive_or_zero

    MOVEQ   #-1,D1
    BRA.S   .store_step_sign

.step_positive_or_zero:
    MOVEQ   #1,D1

.store_step_sign:
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_2120
    MOVE.W  D1,DATA_WDISP_BSS_WORD_2354
    TST.W   D2
    BEQ.S   .set_transition_inactive

    MOVE.W  #1,SCRIPT_BannerTransitionActive
    BRA.S   .return

.set_transition_inactive:
    MOVE.W  D0,SCRIPT_BannerTransitionActive

.return:
    MOVEM.L (A7)+,D2-D3/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_InitCtrlContext   (InitCtrlContext)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   SCRIPT_SetCtrlContextMode
; READS:
;   SCRIPT_CTRL_CONTEXT (control context base)
; WRITES:
;   SCRIPT_CTRL_CONTEXT (initializes context)
; DESC:
;   Initializes the script CTRL/control context block with a mode flag of 1.
; NOTES:
;   Wrapper around SCRIPT_SetCtrlContextMode which fully clears/initializes the context struct.
;------------------------------------------------------------------------------
SCRIPT_InitCtrlContext:
    PEA     1.W
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_SetCtrlContextMode

    ADDQ.W  #8,A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_HandleSerialCtrlCmd   (HandleSerialCtrlCmd)
; ARGS:
;   (none)
; RET:
;   D0: none (status handled via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte, PARSEINI_CheckCtrlHChange, SCRIPT_HandleBrushCommand, SCRIPT_ApplyPendingBannerTarget,
;   WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, TEXTDISP_SetRastForMode, SCRIPT_ProcessCtrlContextPlaybackTick, SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, TEXTDISP_ResetSelectionAndRefresh
; READS:
;   Global_WORD_SELECT_CODE_IS_RAVESC, CONFIG_MSN_FlagChar, DATA_ESQ_BSS_WORD_1DF3, DATA_ESQDISP_BSS_LONG_1E84, DATA_SCRIPT_BSS_WORD_212B
;   Global_REF_CLOCKDATA_STRUCT, Global_WORD_CLOCK_SECONDS
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   SCRIPT_RuntimeMode/2347/2348/2349/234A, SCRIPT_CTRL_CMD_BUFFER
; WRITES:
;   Global_RefreshTickCounter, DATA_SCRIPT_BSS_WORD_212B, Global_WORD_CLOCK_SECONDS,
;   SCRIPT_CTRL_READ_INDEX, SCRIPT_CTRL_CHECKSUM, SCRIPT_CTRL_STATE,
;   SCRIPT_CTRL_CMD_BUFFER, DATA_WDISP_BSS_WORD_2347/2348/2349
; DESC:
;   Polls the CTRL input buffer and advances a small state machine to parse
;   serial control commands; dispatches actions via a jump table.
; NOTES:
;   The jump table is a compiler switch/jumptable on the input byte (0..21).
;   SCRIPT_CTRL_STATE acts as a parser state: 0=idle, 1/2/3=substates uncertain.
;------------------------------------------------------------------------------
SCRIPT_HandleSerialCtrlCmd:
    MOVEM.L D6-D7,-(A7)

    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_gate_refresh_disabled

.selectCodeIsNotRAVSEC:
    MOVE.W  #(-1),Global_RefreshTickCounter
    BRA.S   .ctrl_cmd_handle_status_timeout

.ctrl_cmd_gate_refresh_disabled:
    TST.W   DATA_ESQ_BSS_WORD_1DF3
    BEQ.S   .ctrl_cmd_check_display_state

    MOVEQ   #0,D0
    MOVE.W  D0,Global_RefreshTickCounter
    BRA.W   .return

.ctrl_cmd_check_display_state:
    MOVEQ   #1,D0
    CMP.L   DATA_ESQDISP_BSS_LONG_1E84,D0
    BEQ.W   .return

.ctrl_cmd_handle_status_timeout:
    TST.W   DATA_SCRIPT_BSS_WORD_212B
    BEQ.S   .ctrl_cmd_poll_input

    MOVE.W  Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  Global_WORD_CLOCK_SECONDS,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_cmd_poll_input

    ADDQ.W  #1,Global_WORD_CLOCK_SECONDS
    CMPI.W  #3,Global_WORD_CLOCK_SECONDS
    BLT.S   .ctrl_cmd_poll_input

    CLR.W   DATA_SCRIPT_BSS_WORD_212B
    CLR.L   -(A7)
    PEA     32.W
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.ctrl_cmd_poll_input:
    JSR     PARSEINI_CheckCtrlHChange(PC)

    MOVE.L  D0,D6
    TST.W   Global_UIBusyFlag
    BNE.W   .return

    TST.W   D6
    BEQ.W   .return

    MOVE.W  Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BEQ.S   .ctrl_cmd_parse_state_dispatch

    CLR.W   Global_RefreshTickCounter

.ctrl_cmd_parse_state_dispatch:
    JSR     SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    MOVE.L  D0,D7
    MOVE.W  SCRIPT_CTRL_STATE,D0
    TST.W   D0
    BEQ.S   .ctrl_cmd_state_idle

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state_collect_body

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state_expect_checksum

    SUBQ.W  #1,D0
    BEQ.W   .ctrl_cmd_state3_clear

    BRA.W   .ctrl_cmd_state_invalid_reset

.ctrl_cmd_state_idle:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    SUBQ.W  #1,D0
    BLT.W   .finish_29ABA

    CMPI.W  #22,D0
    BGE.W   .finish_29ABA

    ADD.W   D0,D0
    MOVE.W  .ctrl_cmd_jmptbl(PC,D0.W),D0
    JMP     .ctrl_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.ctrl_cmd_jmptbl:
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_enter_state3-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_start_packet-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_finish_dispatch-.ctrl_cmd_jmptbl-2
    DC.W    .ctrl_cmd_case_gated_by_select_code-.ctrl_cmd_jmptbl-2

.ctrl_cmd_case_enter_state3:
    MOVE.W  #3,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA    

.ctrl_cmd_case_gated_by_select_code:
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.W   .return

.ctrl_cmd_case_start_packet:
    MOVEQ   #1,D0
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  SCRIPT_CTRL_READ_INDEX,A0
    MOVE.B  D7,(A0)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.W  D1,SCRIPT_CTRL_CHECKSUM
    MOVE.W  DATA_WDISP_BSS_WORD_2347,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_2347
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA

.ctrl_cmd_state_collect_body:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,SCRIPT_CTRL_READ_INDEX
    LEA     SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  D1,A0
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_state_collect_update_checksum

    MOVE.W  #2,SCRIPT_CTRL_STATE

.ctrl_cmd_state_collect_update_checksum:
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    EOR.L   D1,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    BRA.W   .finish_29ABA

.ctrl_cmd_state_expect_checksum:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  SCRIPT_CTRL_CHECKSUM,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .ctrl_cmd_checksum_mismatch

    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .ctrl_cmd_checksum_ok_normal_mode

    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Pass packet length into SCRIPT_HandleBrushCommand; command bytes live in
    ; SCRIPT_CTRL_CMD_BUFFER (200-byte storage in data/wdisp.s).
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    BSR.W   SCRIPT_ApplyPendingBannerTarget

    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   (A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    LEA     12(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_ok_normal_mode:
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    BEQ.S   .ctrl_cmd_dispatch_brush_now

    SUBQ.W  #1,D0
    BNE.S   .ctrl_cmd_defer_dispatch

.ctrl_cmd_dispatch_brush_now:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Same packet-length/path as above (SCRIPT_CTRL_CMD_BUFFER + read index).
    MOVE.L  D0,-(A7)
    PEA     SCRIPT_CTRL_CMD_BUFFER
    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_HandleBrushCommand

    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_ProcessCtrlContextPlaybackTick

    LEA     16(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_defer_dispatch:
    MOVE.W  DATA_SCRIPT_BSS_WORD_211B,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_211B
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_mismatch:
    PEA     1.W
    PEA     32.W
    JSR     SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVE.W  Global_REF_CLOCKDATA_STRUCT,Global_WORD_CLOCK_SECONDS
    MOVEQ   #1,D0
    MOVE.W  DATA_WDISP_BSS_WORD_2348,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_2348
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_212B

.ctrl_cmd_reset_parser:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state3_clear:
    CLR.W   SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state_invalid_reset:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,SCRIPT_CTRL_STATE

.ctrl_cmd_finish_dispatch:
.finish_29ABA:
    MOVE.W  SCRIPT_CTRL_READ_INDEX,D0
    CMPI.W  #198,D0
    BLE.S   .return

    MOVE.W  DATA_WDISP_BSS_WORD_2349,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATA_WDISP_BSS_WORD_2349
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,SCRIPT_CTRL_READ_INDEX
    MOVE.W  SCRIPT_RuntimeMode,D1
    MOVE.W  D0,SCRIPT_CTRL_STATE
    TST.W   D1
    BNE.S   .return

    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======

; Dispatch helper for brush-control script commands (handles primary/secondary selection requests).
;------------------------------------------------------------------------------
; FUNC: SCRIPT_HandleBrushCommand   (Parse CTRL brush command payload)
; ARGS:
;   stack +4: arg_1 (via 8(A5))
;   stack +6: arg_2 (via 10(A5))
;   stack +7: arg_3 (via 11(A5))
;   stack +8: arg_4 (via 12(A5))
;   stack +9: arg_5 (via 13(A5))
;   stack +10: arg_6 (via 14(A5))
;   stack +11: arg_7 (via 15(A5))
;   stack +12: arg_8 (via 16(A5))
;   stack +13: arg_9 (via 17(A5))
;   stack +14: arg_10 (via 18(A5))
;   stack +16: arg_11 (via 20(A5))
;   stack +24: arg_12 (via 28(A5))
;   stack +28: arg_13 (via 32(A5))
; RET:
;   D0: result/status
; CLOBBERS:
;   A0/A1/A2/A3/A5/A7/D0/D1/D2/D3/D4/D5/D6/D7
; CALLS:
;   P_TYPE_GetSubtypeIfType20, P_TYPE_ConsumePrimaryTypeIfPresent, SCRIPT_SelectPlaybackCursorFromSearchText, SCRIPT_SplitAndNormalizeSearchBuffer, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist, SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState, SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry, SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit, SCRIPT3_JMPTBL_MATH_Mulu32, SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt, SCRIPT3_JMPTBL_STRING_CompareN, SCRIPT3_JMPTBL_STRING_CopyPadNul, SCRIPT_ReadCiaBBit5Mask, TEXTDISP_FindEntryIndexByWildcard, TEXTDISP_HandleScriptCommand, TEXTDISP_UpdateChannelRangeFlags, UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   BRUSH_SelectedNode, CONFIG_LRBN_FlagChar, CONFIG_MSN_FlagChar, DATA_CTASKS_STR_1_1BC9, DATA_ESQ_STR_N_1DCE, ED_DiagGraphModeChar, ED_DiagVinModeChar, ESQIFF_BrushIniListHead, ESQIFF_GAdsBrushListCount, Global_WORD_SELECT_CODE_IS_RAVESC, LOCAVAIL_FilterModeFlag, LOCAVAIL_FilterStep, LOCAVAIL_PrimaryFilterState, DATA_SCRIPT_BSS_WORD_211D, SCRIPT_CommandTextPtr, DATA_SCRIPT_TAG_00_212C, DATA_SCRIPT_TAG_00_212D, DATA_SCRIPT_TAG_11_212E, DATA_SCRIPT_TAG_11_212F, DATA_WDISP_BSS_LONG_2357, DATA_WDISP_BSS_WORD_2365, SCRIPT_RuntimeMode, SCRIPT_PlaybackCursor, SCRIPT_PrimarySearchFirstFlag, TEXTDISP_CurrentMatchIndex, CLEANUP_AlignedStatusMatchIndex, WDISP_CharClassTable, WDISP_HighlightActive
; WRITES:
;   BRUSH_ScriptPrimarySelection, BRUSH_ScriptSecondarySelection, DATA_COMMON_STR_VALUE_1B05, DATA_SCRIPT_BSS_WORD_211D, SCRIPT_PendingBannerTargetChar, DATA_SCRIPT_BSS_WORD_211F, DATA_SCRIPT_STR_X_2126, DATA_SCRIPT_BSS_BYTE_2127, DATA_SCRIPT_BSS_WORD_2128, SCRIPT_CommandTextPtr, SCRIPT_RuntimeMode, TEXTDISP_PrimaryChannelCode, TEXTDISP_SecondaryChannelCode, DATA_WDISP_BSS_WORD_234F, SCRIPT_PlaybackCursor, SCRIPT_PrimarySearchFirstFlag, DATA_WDISP_BSS_LONG_2357, TEXTDISP_CurrentMatchIndex
; DESC:
;   Parses one CTRL packet payload via a 22-way switch/jumptable and updates
;   brush selection, playback cursor/runtime mode, channel filters, search text,
;   and pending banner-target state before optional script-command dispatch.
; NOTES:
;   Saves and restores control-context snapshots around command handling.
;------------------------------------------------------------------------------
SCRIPT_HandleBrushCommand:
    LINK.W  A5,#-36
    MOVEM.L D2-D7/A2-A3,-(A7)

    MOVEA.L 8(A5),A3
    MOVEA.L 12(A5),A2
    MOVE.L  16(A5),D7

    MOVEQ   #1,D6
    MOVEQ   #1,D0
    MOVE.L  D0,-8(A5)
    MOVE.W  SCRIPT_RuntimeMode,D5
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_LoadCtrlContextSnapshot

    ADDQ.W  #4,A7
    CLR.L   SCRIPT_PlaybackCursor
    CLR.B   0(A2,D7.L)
    MOVEQ   #0,D0
    MOVE.B  (A2),D0
    SUBQ.W  #1,D0
    BLT.W   .brush_cmd_finalize

    CMPI.W  #22,D0
    BGE.W   .brush_cmd_finalize

    ADD.W   D0,D0
    MOVE.W  .brush_cmd_jmptbl(PC,D0.W),D0
    JMP     .brush_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.brush_cmd_jmptbl:
    DC.W    .brush_cmd_case_dispatch_subcommand-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_select_primary_secondary-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_toggle_primary_search_order-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_channel_codes-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_cursor_15-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_apply_rtc_yyyymmddhhmm-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_select_playback_mode-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_string_value-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_set_cursor_14-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_split_search_buffer-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_type20_subtype-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_noop-.brush_cmd_jmptbl-2
    DC.W    .brush_cmd_case_filter_or_runtime_mode-.brush_cmd_jmptbl-2

.brush_cmd_case_select_primary_secondary:
    MOVEQ   #0,D0
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     DATA_SCRIPT_TAG_00_212C
    MOVE.L  D0,-20(A5)
    MOVE.L  D0,-16(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_primary00

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptPrimarySelection    ; default primary selection to current brush
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.brush_cmd_after_tag_primary00:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     DATA_SCRIPT_TAG_00_212D
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_secondary00

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection  ; same for secondary fallback
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.brush_cmd_after_tag_secondary00:
    LEA     3(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     DATA_SCRIPT_TAG_11_212E
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_primary11

    TST.L   -16(A5)
    BNE.S   .brush_cmd_after_tag_primary11

    CLR.L   BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)

.brush_cmd_after_tag_primary11:
    LEA     1(A2),A0
    PEA     2.W
    MOVE.L  A0,-(A7)
    PEA     DATA_SCRIPT_TAG_11_212F
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_after_tag_secondary11

    TST.L   -20(A5)
    BNE.S   .brush_cmd_after_tag_secondary11

    CLR.L   BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)

.brush_cmd_after_tag_secondary11:
    TST.L   -16(A5)
    BEQ.S   .brush_cmd_scan_selection_list

    TST.L   -20(A5)
    BNE.W   .brush_cmd_finalize

.brush_cmd_scan_selection_list:
    MOVE.L  ESQIFF_BrushIniListHead,-12(A5)

.brush_cmd_scan_nodes_loop:
    ; Scan available brushes to pick the first entries matching the requested names.
    TST.L   -12(A5)
    BEQ.W   .brush_cmd_scan_complete

    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     3(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_check_secondary_tag_loop

    TST.L   -16(A5)
    BNE.S   .brush_cmd_check_secondary_tag_loop

    MOVE.L  -12(A5),BRUSH_ScriptPrimarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-16(A5)
    BEQ.S   .brush_cmd_check_secondary_tag_loop

    TST.L   -20(A5)
    BNE.S   .brush_cmd_scan_complete

.brush_cmd_check_secondary_tag_loop:
    MOVEA.L -12(A5),A0
    ADDA.W  #$21,A0
    LEA     1(A2),A1
    PEA     2.W
    MOVE.L  A1,-(A7)
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_STRING_CompareN(PC)

    LEA     12(A7),A7
    TST.L   D0
    BNE.S   .brush_cmd_advance_node

    TST.L   -20(A5)
    BNE.S   .brush_cmd_advance_node

    MOVE.L  -12(A5),BRUSH_ScriptSecondarySelection
    MOVEQ   #1,D0
    MOVE.L  D0,-20(A5)
    TST.L   -16(A5)
    BEQ.S   .brush_cmd_advance_node

    TST.L   D0
    BNE.S   .brush_cmd_scan_complete

.brush_cmd_advance_node:
    MOVEA.L -12(A5),A0
    MOVE.L  368(A0),-12(A5)
    BRA.W   .brush_cmd_scan_nodes_loop

.brush_cmd_scan_complete:
    TST.L   -16(A5)
    BNE.S   .brush_cmd_ensure_primary_default

    MOVEA.L BRUSH_SelectedNode,A0
    MOVE.L  A0,BRUSH_ScriptPrimarySelection

.brush_cmd_ensure_primary_default:
    TST.L   -20(A5)
    BNE.W   .brush_cmd_finalize

    MOVE.L  BRUSH_SelectedNode,BRUSH_ScriptSecondarySelection
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_type20_subtype:
    MOVE.L  A2,-(A7)
    JSR     P_TYPE_GetSubtypeIfType20(PC)

    ADDQ.W  #4,A7
    MOVE.B  D0,DATA_SCRIPT_BSS_WORD_211D
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_channel_codes:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    MOVE.W  D0,TEXTDISP_PrimaryChannelCode
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    MOVE.W  D0,TEXTDISP_SecondaryChannelCode
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_toggle_primary_search_order:
    MOVE.B  1(A2),D0
    MOVEQ   #76,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_toggle_primary_search_if_r

    MOVE.W  #1,SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_toggle_primary_search_if_r:
    MOVEQ   #82,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_toggle_primary_search_auto

    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_toggle_primary_search_auto:
    TST.W   SCRIPT_PrimarySearchFirstFlag
    BEQ.S   .brush_cmd_toggle_pick_secondary_first

    MOVEQ   #0,D0
    BRA.S   .brush_cmd_toggle_store_flag

.brush_cmd_toggle_pick_secondary_first:
    MOVEQ   #1,D0

.brush_cmd_toggle_store_flag:
    MOVE.W  D0,SCRIPT_PrimarySearchFirstFlag
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_apply_rtc_yyyymmddhhmm:
    MOVE.B  DATA_CTASKS_STR_1_1BC9,D0
    MOVEQ   #49,D1
    CMP.B   D1,D0
    BNE.W   .brush_cmd_finalize

    MOVEA.L A2,A0

.brush_cmd_find_cmd_terminator:
    TST.B   (A0)+
    BNE.S   .brush_cmd_find_cmd_terminator

    SUBQ.L  #1,A0
    SUBA.L  A2,A0
    CMPA.W  #12,A0
    BNE.W   .brush_cmd_finalize

    LEA     4(A2),A0
    PEA     4.W
    MOVE.L  A0,-(A7)
    PEA     -28(A5)
    JSR     SCRIPT3_JMPTBL_STRING_CopyPadNul(PC)

    PEA     -28(A5)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    LEA     16(A7),A7
    MOVEQ   #-48,D1
    ADD.B   1(A2),D1
    MOVE.B  D1,-18(A5)
    MOVEQ   #-48,D2
    ADD.B   2(A2),D2
    MOVE.B  D2,-17(A5)
    MOVEQ   #-48,D3
    ADD.B   3(A2),D3
    MOVE.B  D3,-16(A5)
    MOVE.L  D0,-32(A5)
    SUBI.L  #1900,D0
    MOVE.B  D0,-15(A5)
    MOVEQ   #-48,D0
    ADD.B   8(A2),D0
    MOVE.B  D0,-14(A5)
    MOVEQ   #-48,D0
    ADD.B   9(A2),D0
    MOVE.B  D0,-13(A5)
    MOVEQ   #-48,D0
    ADD.B   10(A2),D0
    MOVE.B  D0,-12(A5)
    MOVEQ   #-48,D3
    ADD.B   11(A2),D3
    MOVE.B  D3,-11(A5)
    CLR.B   -10(A5)
    MOVEQ   #7,D3
    CMP.B   D3,D1
    BGE.W   .brush_cmd_finalize

    MOVEQ   #12,D1
    CMP.B   D1,D2
    BGE.W   .brush_cmd_finalize

    MOVEQ   #60,D1
    CMP.B   D1,D0
    BGE.W   .brush_cmd_finalize

    PEA     -18(A5)
    JSR     SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist(PC)

    ADDQ.W  #4,A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_playback_mode:
    MOVE.L  LOCAVAIL_FilterStep,D0
    MOVEQ   #1,D1
    CMP.L   D1,D0
    BEQ.S   .brush_cmd_playback_cursor_mode2

    SUBQ.L  #2,D0
    BNE.S   .brush_cmd_filter_mode_dispatch

.brush_cmd_playback_cursor_mode2:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_mode_dispatch:
    CMP.L   LOCAVAIL_FilterModeFlag,D1
    BEQ.S   .brush_cmd_try_consume_primary_type

    MOVE.B  ED_DiagGraphModeChar,D0
    MOVEQ   #78,D1
    CMP.B   D1,D0
    BEQ.S   .brush_cmd_filter_highlight_gate

    TST.L   ESQIFF_GAdsBrushListCount
    BNE.S   .brush_cmd_set_playback_cursor_4

.brush_cmd_filter_highlight_gate:
    TST.W   WDISP_HighlightActive
    BNE.S   .brush_cmd_set_playback_cursor_4

.brush_cmd_try_consume_primary_type:
    PEA     DATA_SCRIPT_BSS_WORD_211D
    JSR     P_TYPE_ConsumePrimaryTypeIfPresent(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .brush_cmd_filter_cmd_dispatch

    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_cmd_dispatch:
    MOVEQ   #49,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_filter_cmd_case3

    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_filter_cmd_case3:
    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.W   .brush_cmd_finalize

    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_set_playback_cursor_4:
    MOVEQ   #4,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    CLR.W   DATA_WDISP_BSS_LONG_2357
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_dispatch_subcommand:
    PEA     DATA_SCRIPT_BSS_WORD_211D
    JSR     P_TYPE_ConsumePrimaryTypeIfPresent(PC)

    ADDQ.W  #4,A7
    TST.L   D0
    BEQ.S   .brush_cmd_dispatch_by_subcode

    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_dispatch_by_subcode:
    MOVEQ   #0,D0
    MOVE.B  1(A2),D0
    SUBI.W  #$31,D0
    BEQ.W   .brush_cmd_case_select_cursor_from_primary_search

    SUBQ.W  #2,D0
    BEQ.W   .brush_cmd_case_reset_match_and_pick_cursor

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_find_wildcard_then_set_cursor

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_pending_banner_hex

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_find_wildcard_then_set_cursor

    SUBQ.W  #1,D0
    BEQ.S   .brush_cmd_case_channel_range_gate

    SUBQ.W  #1,D0
    BEQ.W   .brush_cmd_case_select_cursor_from_secondary_search

    SUBI.W  #12,D0
    BEQ.W   .brush_cmd_case_reset_match_cursor_1

    SUBQ.W  #2,D0
    BEQ.S   .brush_cmd_case_set_cursor_9_and_banner_text

    SUBI.W  #17,D0
    BEQ.S   .brush_cmd_case_set_cursor_8_and_byte

    SUBQ.W  #1,D0
    BNE.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_9_and_banner_text:
    MOVEQ   #9,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    MOVE.B  1(A2),DATA_SCRIPT_BSS_BYTE_2127
    MOVE.B  2(A2),DATA_SCRIPT_BSS_WORD_2128
    LEA     3(A2),A0                        ; payload tail inside SCRIPT_CTRL_CMD_BUFFER packet
    ; Source is NUL-terminated by caller at packet end (0(A2,D7)=0).
    MOVE.L  SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  A0,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,SCRIPT_CommandTextPtr
    CLR.L   -8(A5)
    MOVE.W  #(-2),SCRIPT_PendingBannerTargetChar
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_8_and_byte:
    MOVEQ   #8,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    MOVE.B  2(A2),DATA_SCRIPT_STR_X_2126
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_channel_range_gate:
    TST.W   DATA_WDISP_BSS_LONG_2357
    BNE.S   .brush_cmd_case_channel_range_read_digit

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_channel_range_read_digit:
    MOVE.W  DATA_WDISP_BSS_WORD_2365,D0
    SUBQ.W  #1,D0
    BNE.S   .brush_cmd_case_channel_offset_secondary

    MOVEQ   #2,D0
    BRA.S   .brush_cmd_case_channel_offset_selected

.brush_cmd_case_channel_offset_secondary:
    MOVEQ   #3,D0

.brush_cmd_case_channel_offset_selected:
    MOVEQ   #0,D1
    MOVE.B  0(A2,D0.L),D1
    MOVE.W  D1,DATA_WDISP_BSS_WORD_234F
    MOVEQ   #48,D0
    CMP.W   D0,D1
    BNE.S   .brush_cmd_case_require_match_index

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_require_match_index:
    MOVE.W  TEXTDISP_CurrentMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_resolve_match_index

    MOVE.W  CLEANUP_AlignedStatusMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_resolve_match_index

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_resolve_match_index:
    MOVE.W  TEXTDISP_CurrentMatchIndex,D0
    ADDQ.W  #1,D0
    BNE.S   .brush_cmd_case_apply_channel_range

    MOVE.W  CLEANUP_AlignedStatusMatchIndex,TEXTDISP_CurrentMatchIndex

.brush_cmd_case_apply_channel_range:
    JSR     TEXTDISP_UpdateChannelRangeFlags(PC)

    MOVEQ   #5,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_pending_banner_hex:
    MOVE.B  CONFIG_LRBN_FlagChar,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BEQ.S   .brush_cmd_case_parse_pending_banner_hex

    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_parse_pending_banner_hex:
    MOVEQ   #0,D0
    MOVE.B  2(A2),D0
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #7,(A1)
    BEQ.W   .brush_cmd_case_pending_banner_invalid

    MOVEQ   #0,D1
    MOVE.B  3(A2),D1
    ADDA.L  D1,A0
    BTST    #7,(A0)
    BEQ.W   .brush_cmd_case_pending_banner_invalid

    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ASL.L   #4,D1
    MOVE.B  3(A2),D0
    EXT.W   D0
    EXT.L   D0
    MOVE.L  D0,(A7)
    MOVE.L  D1,36(A7)
    JSR     SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(PC)

    ADDQ.W  #4,A7
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVE.L  32(A7),D0
    ADD.L   D1,D0
    MOVEQ   #0,D1
    MOVE.B  4(A2),D1
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BTST    #2,(A1)
    BEQ.S   .brush_cmd_case_default_banner_speed

    MOVEQ   #0,D0
    MOVE.B  5(A2),D0
    ADDA.L  D0,A0
    BTST    #2,(A0)
    BEQ.S   .brush_cmd_case_default_banner_speed

    MOVEQ   #0,D2
    MOVE.B  D1,D2
    MOVEQ   #48,D1
    SUB.L   D1,D2
    MOVE.L  D2,D0
    MOVE.L  #1000,D1
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    MOVEQ   #0,D1
    MOVE.B  5(A2),D1
    MOVEQ   #48,D2
    SUB.L   D2,D1
    MOVE.L  D0,32(A7)
    MOVEQ   #100,D0
    JSR     SCRIPT3_JMPTBL_MATH_Mulu32(PC)

    MOVE.L  32(A7),D1
    ADD.L   D0,D1
    MOVE.W  D1,DATA_SCRIPT_BSS_WORD_211F
    BRA.S   .brush_cmd_case_after_banner_speed

.brush_cmd_case_default_banner_speed:
    MOVE.W  #1000,DATA_SCRIPT_BSS_WORD_211F

.brush_cmd_case_after_banner_speed:
    TST.B   6(A2)
    BNE.S   .checkIfSelectCodeIsRAVESC

    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #2,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.checkIfSelectCodeIsRAVESC:
    TST.W   Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsRAVESC

    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BEQ.S   .selectCodeIsRAVESC

    LEA     6(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BEQ.S   .selectCodeIsNotRAVESC

.selectCodeIsRAVESC:
    MOVEQ   #3,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.selectCodeIsNotRAVESC:
    MOVEQ   #-1,D0
    MOVEQ   #1,D1
    MOVE.L  D1,SCRIPT_PlaybackCursor
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_pending_banner_invalid:
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_reset_match_and_pick_cursor:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVE.B  DATA_ESQ_STR_N_1DCE,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .brush_cmd_case_set_cursor_2

    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_2:
    MOVEQ   #2,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_reset_match_cursor_1:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_find_wildcard_then_set_cursor:
    LEA     2(A2),A0
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_FindEntryIndexByWildcard(PC)

    ADDQ.W  #4,A7
    TST.W   D0
    BNE.S   .brush_cmd_case_wildcard_found_cursor_3

    MOVEQ   #0,D6
    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_wildcard_found_cursor_3:
    MOVEQ   #3,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_cursor_from_primary_search:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    CLR.L   -(A7)
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_select_cursor_from_secondary_search:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    PEA     1.W
    BSR.W   SCRIPT_SelectPlaybackCursorFromSearchText

    LEA     12(A7),A7
    MOVE.L  D0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_string_value:
    LEA     1(A2),A0
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(PC)

    ADDQ.W  #4,A7
    MOVEQ   #63,D1
    SUB.L   D0,D1
    MOVE.B  D1,DATA_COMMON_STR_VALUE_1B05
    MOVEQ   #63,D0
    CMP.B   D0,D1

    BGT.S   .brush_cmd_case_clamp_common_str_value

    TST.B   D1
    BPL.S   .brush_cmd_case_set_cursor_13

.brush_cmd_case_clamp_common_str_value:
    MOVE.B  D0,DATA_COMMON_STR_VALUE_1B05

.brush_cmd_case_set_cursor_13:
    MOVEQ   #13,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_14:
    MOVEQ   #14,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_set_cursor_15:
    MOVEQ   #15,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_or_runtime_mode:
    MOVEQ   #57,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_filter_update_entry

    PEA     1.W
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState(PC)

    LEA     2(A2),A0
    PEA     LOCAVAIL_PrimaryFilterState
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry(PC)

    LEA     12(A7),A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_update_entry:
    MOVEQ   #1,D0
    CMP.L   LOCAVAIL_FilterModeFlag,D0
    BNE.S   .brush_cmd_case_filter_mode_checks

    MOVEQ   #56,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_filter_mode_checks

    CLR.L   -(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState(PC)

    ADDQ.W  #4,A7
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_filter_mode_checks:
    MOVEQ   #1,D0
    CMP.L   LOCAVAIL_FilterModeFlag,D0
    BNE.S   .brush_cmd_case_diag_char_mode_checks

    MOVEQ   #0,D6
    BRA.W   .brush_cmd_finalize

.brush_cmd_case_diag_char_mode_checks:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagVinModeChar,D0
    LEA     WDISP_CharClassTable,A0
    MOVEA.L A0,A1
    ADDA.L  D0,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_diag_char_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .brush_cmd_case_diag_char_normalized

.brush_cmd_case_diag_char_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_diag_char_normalized:
    MOVEQ   #89,D2
    CMP.L   D2,D1
    BNE.S   .brush_cmd_case_check_l2

    MOVE.B  1(A2),D1
    MOVEQ   #48,D3
    CMP.B   D3,D1
    BEQ.S   .brush_cmd_case_set_runtime_mode_3

.brush_cmd_case_check_l2:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_check_l2_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D3
    SUB.L   D3,D1
    BRA.S   .brush_cmd_case_check_l2_normalized

.brush_cmd_case_check_l2_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_l2_normalized:
    MOVEQ   #76,D3
    CMP.L   D3,D1
    BNE.S   .brush_cmd_case_check_y1

    MOVE.B  1(A2),D1
    MOVEQ   #50,D4
    CMP.B   D4,D1
    BNE.S   .brush_cmd_case_check_y1

.brush_cmd_case_set_runtime_mode_3:
    MOVE.W  #3,SCRIPT_RuntimeMode
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_check_y1:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEA.L A0,A1
    ADDA.L  D1,A1
    BTST    #1,(A1)
    BEQ.S   .brush_cmd_case_check_y1_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D4
    SUB.L   D4,D1
    BRA.S   .brush_cmd_case_check_y1_normalized

.brush_cmd_case_check_y1_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_y1_normalized:
    CMP.L   D2,D1
    BNE.S   .brush_cmd_case_check_l3

    MOVE.B  1(A2),D1
    MOVEQ   #49,D2
    CMP.B   D2,D1
    BEQ.S   .brush_cmd_case_try_cursor_10

.brush_cmd_case_check_l3:
    MOVEQ   #0,D1
    MOVE.B  D0,D1
    ADDA.L  D1,A0
    BTST    #1,(A0)
    BEQ.S   .brush_cmd_case_check_l3_keep

    MOVEQ   #0,D1
    MOVE.B  D0,D1
    MOVEQ   #32,D2
    SUB.L   D2,D1
    BRA.S   .brush_cmd_case_check_l3_normalized

.brush_cmd_case_check_l3_keep:
    MOVEQ   #0,D1
    MOVE.B  D0,D1

.brush_cmd_case_check_l3_normalized:
    CMP.L   D3,D1
    BNE.S   .brush_cmd_case_fail

    MOVEQ   #51,D0
    CMP.B   1(A2),D0
    BNE.S   .brush_cmd_case_fail

.brush_cmd_case_try_cursor_10:
    JSR     SCRIPT_ReadCiaBBit5Mask(PC)

    TST.B   D0
    BEQ.S   .brush_cmd_case_fail

    MOVEQ   #10,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_fail:
    MOVEQ   #0,D6
    BRA.S   .brush_cmd_finalize

.brush_cmd_case_split_search_buffer:
    MOVE.L  D7,-(A7)
    MOVE.L  A2,-(A7)
    BSR.W   SCRIPT_SplitAndNormalizeSearchBuffer

    ADDQ.W  #8,A7

.brush_cmd_case_noop:
.brush_cmd_finalize:
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_SaveCtrlContextSnapshot

    ADDQ.W  #4,A7
    TST.L   -8(A5)
    BEQ.S   .return

    TST.L   SCRIPT_PlaybackCursor
    BEQ.S   .return

    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7

.return:
    MOVE.W  D5,SCRIPT_RuntimeMode
    MOVE.L  D6,D0

    MOVEM.L (A7)+,D2-D7/A2-A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SelectPlaybackCursorFromSearchText   (Resolve cursor from split search windows)
; ARGS:
;   stack +8: matchCountOrIndex (long) ??
;   stack +12: parseBuffer (char *)
; RET:
;   D0: 1 when a primary or secondary lookup matched, else 0
; CLOBBERS:
;   A0/A1/A3/A7/D0/D5/D6/D7
; CALLS:
;   TEXTDISP_SelectGroupAndEntry
; READS:
;   TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText, TEXTDISP_PrimaryChannelCode, TEXTDISP_SecondaryChannelCode, SCRIPT_PrimarySearchFirstFlag
; WRITES:
;   DATA_WDISP_BSS_LONG_2350, SCRIPT_PlaybackCursor, DATA_WDISP_BSS_LONG_2357
; DESC:
;   Splits the incoming parse buffer into primary/secondary lookup windows and
;   tries entry selection in preferred order based on SCRIPT_PrimarySearchFirstFlag.
; NOTES:
;   Sets SCRIPT_PlaybackCursor to 6/7 on successful primary/secondary matches,
;   otherwise forces cursor 1 and clears DATA_WDISP_BSS_LONG_2357.
;------------------------------------------------------------------------------
SCRIPT_SelectPlaybackCursorFromSearchText:
    LINK.W  A5,#-4
    MOVEM.L D5-D7/A3,-(A7)
    MOVE.L  8(A5),D7
    MOVEA.L 12(A5),A3
    MOVEQ   #1,D6
    MOVE.L  D7,DATA_WDISP_BSS_LONG_2350
    MOVE.W  #1,DATA_WDISP_BSS_LONG_2357
    MOVEQ   #3,D5

.loop_1546:
    MOVEQ   #18,D0
    CMP.B   0(A3,D5.W),D0
    BEQ.S   .branch_1547

    MOVEQ   #30,D0
    CMP.W   D0,D5
    BGE.S   .branch_1547

    ADDQ.W  #1,D5
    BRA.S   .loop_1546

.branch_1547:
    CLR.B   0(A3,D5.W)
    TST.W   SCRIPT_PrimarySearchFirstFlag
    BNE.S   .if_ne_1548

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1548

    MOVEQ   #7,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1548:
    LEA     2(A3),A0
    MOVE.W  TEXTDISP_PrimaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     TEXTDISP_PrimarySearchText
    MOVE.L  A0,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .if_ne_1549

    MOVEQ   #6,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.if_ne_1549:
    TST.W   SCRIPT_PrimarySearchFirstFlag
    BEQ.S   .branch_154A

    MOVE.L  D5,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    MOVE.W  TEXTDISP_SecondaryChannelCode,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     TEXTDISP_SecondarySearchText
    MOVE.L  A1,-(A7)
    JSR     TEXTDISP_SelectGroupAndEntry(PC)

    LEA     12(A7),A7
    SUBQ.W  #1,D0
    BNE.S   .branch_154A

    MOVEQ   #7,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor
    BRA.S   .skip_154B

.branch_154A:
    MOVEQ   #0,D6
    CLR.W   DATA_WDISP_BSS_LONG_2357
    MOVEQ   #1,D0
    MOVE.L  D0,SCRIPT_PlaybackCursor

.skip_154B:
    MOVE.L  D6,D0
    MOVEM.L (A7)+,D5-D7/A3
    UNLK    A5
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ProcessCtrlContextPlaybackTick   (ProcessCtrlContextPlaybackTick)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1/D2
; CALLS:
;   SCRIPT_ApplyPendingBannerTarget, SCRIPT_UpdateRuntimeModeForPlaybackCursor, SCRIPT_DispatchPlaybackCursorCommand, SCRIPT_LoadCtrlContextSnapshot, SCRIPT_SaveCtrlContextSnapshot, SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine
; READS:
;   CONFIG_MSN_FlagChar, DATA_SCRIPT_BSS_WORD_211A, DATA_SCRIPT_BSS_LONG_2125, LOCAVAIL_PrimaryFilterState, SCRIPT_RuntimeMode, SCRIPT_PlaybackCursor, TEXTDISP_CurrentMatchIndex
; WRITES:
;   DATA_SCRIPT_BSS_WORD_211A, DATA_SCRIPT_BSS_LONG_2125, SCRIPT_RuntimeMode, SCRIPT_PlaybackCursor, DATA_WDISP_BSS_WORD_236E
; DESC:
;   Loads context state, applies mode/cursor gating, runs playback-command
;   dispatch, then saves the updated state back into the context snapshot.
; NOTES:
;   Playback cursor dispatch is only attempted for cursor values 1..15.
;------------------------------------------------------------------------------
SCRIPT_ProcessCtrlContextPlaybackTick:
    MOVEM.L D2/A3,-(A7)
    MOVEA.L 12(A7),A3
    PEA     LOCAVAIL_PrimaryFilterState
    MOVE.L  A3,-(A7)
    JSR     SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine(PC)

    MOVE.L  A3,(A7)
    BSR.W   SCRIPT_LoadCtrlContextSnapshot

    ADDQ.W  #8,A7
    TST.L   DATA_SCRIPT_BSS_LONG_2125
    BEQ.S   .playback_tick_apply_pending_mode_change

    MOVEQ   #3,D0
    MOVE.W  D0,SCRIPT_RuntimeMode
    MOVEQ   #0,D0
    MOVE.L  D0,DATA_SCRIPT_BSS_LONG_2125

.playback_tick_apply_pending_mode_change:
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .playback_tick_gate_cursor_for_m_mode

    MOVE.L  SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #10,D1
    CMP.L   D1,D0
    BGE.S   .playback_tick_gate_cursor_for_m_mode

    MOVEQ   #2,D2
    MOVE.L  D2,SCRIPT_PlaybackCursor

.playback_tick_gate_cursor_for_m_mode:
    MOVE.W  SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .playback_tick_maybe_dispatch_cursor

    TST.W   DATA_SCRIPT_BSS_WORD_211A
    BEQ.S   .playback_tick_clear_runtime_latch

    MOVE.L  SCRIPT_PlaybackCursor,D0
    MOVEQ   #10,D1
    CMP.L   D1,D0
    BLE.S   .playback_tick_clear_runtime_latch

.playback_tick_maybe_dispatch_cursor:
    MOVE.L  SCRIPT_PlaybackCursor,D0
    TST.L   D0
    BLE.S   .return

    MOVEQ   #15,D1
    CMP.L   D1,D0
    BGT.S   .return

    BSR.W   SCRIPT_UpdateRuntimeModeForPlaybackCursor

    TST.W   D0
    BNE.S   .return

    MOVEQ   #1,D0
    CMP.L   SCRIPT_PlaybackCursor,D0
    BEQ.S   .playback_tick_dispatch_cursor

    BSR.W   SCRIPT_ApplyPendingBannerTarget

.playback_tick_dispatch_cursor:
    PEA     SCRIPT_PlaybackCursor
    BSR.W   SCRIPT_DispatchPlaybackCursorCommand

    ADDQ.W  #4,A7
    BRA.S   .return

.playback_tick_clear_runtime_latch:
    CLR.W   DATA_SCRIPT_BSS_WORD_211A

.return:
    MOVE.W  TEXTDISP_CurrentMatchIndex,DATA_WDISP_BSS_WORD_236E
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_SaveCtrlContextSnapshot

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D2/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ClearSearchTextsAndChannels   (ClearSearchTextsAndChannels)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0
; CALLS:
;   (none)
; READS:
;   (none observed)
; WRITES:
;   TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText, TEXTDISP_PrimaryChannelCode, TEXTDISP_SecondaryChannelCode
; DESC:
;   Clears both search strings and both channel-code selectors.
;------------------------------------------------------------------------------
SCRIPT_ClearSearchTextsAndChannels:
    MOVEQ   #0,D0
    MOVE.B  D0,TEXTDISP_SecondarySearchText
    MOVE.B  D0,TEXTDISP_PrimarySearchText
    MOVEQ   #0,D0
    MOVE.W  D0,TEXTDISP_SecondaryChannelCode
    MOVE.W  D0,TEXTDISP_PrimaryChannelCode
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SplitAndNormalizeSearchBuffer   (SplitAndNormalizeSearchBuffer)
; ARGS:
;   stack +16: parseBuffer (char *)
;   stack +20: parseLen (long)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D6/D7
; CALLS:
;   SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText, c8
; WRITES:
;   TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText
; DESC:
;   Splits raw search text around delimiter 18 and copies primary/secondary
;   portions into dedicated buffers.
; NOTES:
;   Calls SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters with max length 128 for non-empty strings.
;------------------------------------------------------------------------------
SCRIPT_SplitAndNormalizeSearchBuffer:
    MOVEM.L D6-D7/A3,-(A7)
    MOVEA.L 16(A7),A3
    MOVE.L  20(A7),D7
    MOVEQ   #18,D0
    CMP.B   1(A3),D0
    BNE.S   .split_search_check_trailing_delimiter

    LEA     2(A3),A0
    LEA     TEXTDISP_SecondarySearchText,A1

.split_search_copy_secondary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_secondary_only

    MOVEQ   #0,D0
    MOVE.B  D0,TEXTDISP_PrimarySearchText
    BRA.S   .split_search_filter_primary

.split_search_check_trailing_delimiter:
    CMP.B   -1(A3,D7.L),D0
    BNE.S   .split_search_find_mid_delimiter

    CLR.B   -1(A3,D7.L)
    LEA     1(A3),A0
    LEA     TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_only:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_only

    CLR.B   TEXTDISP_SecondarySearchText
    BRA.S   .split_search_filter_primary

.split_search_find_mid_delimiter:
    MOVEQ   #1,D6

.split_search_find_mid_delimiter_loop:
    MOVEQ   #18,D0
    CMP.B   0(A3,D6.W),D0
    BEQ.S   .split_search_split_at_delimiter

    CMPI.W  #$c8,D6
    BGE.S   .split_search_split_at_delimiter

    ADDQ.W  #1,D6
    BRA.S   .split_search_find_mid_delimiter_loop

.split_search_split_at_delimiter:
    CLR.B   0(A3,D6.W)
    MOVE.L  D6,D0
    EXT.L   D0
    MOVEA.L A3,A0
    ADDA.L  D0,A0
    LEA     1(A0),A1
    LEA     TEXTDISP_SecondarySearchText,A0

.split_search_copy_secondary_part:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .split_search_copy_secondary_part

    LEA     1(A3),A0
    LEA     TEXTDISP_PrimarySearchText,A1

.split_search_copy_primary_part:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .split_search_copy_primary_part

.split_search_filter_primary:
    LEA     TEXTDISP_PrimarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .split_search_filter_secondary

    TST.B   TEXTDISP_PrimarySearchText
    BEQ.S   .split_search_filter_secondary

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.split_search_filter_secondary:
    LEA     TEXTDISP_SecondarySearchText,A0
    MOVE.L  A0,D0
    BEQ.S   .return

    TST.B   TEXTDISP_SecondarySearchText
    BEQ.S   .return

    PEA     128.W
    MOVE.L  A0,-(A7)
    JSR     SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters(PC)

    ADDQ.W  #8,A7

.return:
    MOVEM.L (A7)+,D6-D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ApplyPendingBannerTarget   (ApplyPendingBannerTarget)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0/D1/D2/D7
; CALLS:
;   SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar, SCRIPT_BeginBannerCharTransition
; READS:
;   Global_REF_WORD_HEX_CODE_8E, SCRIPT_PendingBannerTargetChar, DATA_SCRIPT_BSS_WORD_211F, DATA_SCRIPT_BSS_WORD_2122
; WRITES:
;   ESQPARS2_ReadModeFlags, SCRIPT_PendingBannerTargetChar, DATA_SCRIPT_BSS_WORD_2122
; DESC:
;   Applies any pending banner target request and kicks a transition if needed.
; NOTES:
;   A pending value of -2 is normalized to -1 (no deferred target).
;------------------------------------------------------------------------------
SCRIPT_ApplyPendingBannerTarget:
    MOVEM.L D2/D7,-(A7)
    JSR     SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar(PC)

    MOVE.L  D0,D7
    MOVEQ   #-2,D0
    CMP.W   SCRIPT_PendingBannerTargetChar,D0
    BNE.S   .check_specific_pending_target

    MOVEQ   #-1,D0
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.check_specific_pending_target:
    MOVE.W  SCRIPT_PendingBannerTargetChar,D0
    MOVEQ   #-1,D1
    CMP.W   D1,D0
    BEQ.S   .compare_against_default_target

    EXT.L   D0
    MOVE.W  DATA_SCRIPT_BSS_WORD_211F,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar
    BRA.S   .maybe_clear_readmode_flags

.compare_against_default_target:
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    CMP.W   D0,D7
    BEQ.S   .maybe_clear_readmode_flags

    EXT.L   D0
    MOVE.W  DATA_SCRIPT_BSS_WORD_211F,D1
    MOVEQ   #0,D2
    MOVE.W  D1,D2
    MOVE.L  D2,-(A7)
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7
    MOVE.W  #(-1),SCRIPT_PendingBannerTargetChar

.maybe_clear_readmode_flags:
    TST.W   DATA_SCRIPT_BSS_WORD_2122
    BEQ.S   .return

    MOVEQ   #0,D0
    MOVE.W  D0,ESQPARS2_ReadModeFlags
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_2122

.return:
    MOVEM.L (A7)+,D2/D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateRuntimeModeForPlaybackCursor   (UpdateRuntimeModeForPlaybackCursor)
; ARGS:
;   (none)
; RET:
;   D0: 1 when a mode-change path was consumed, else 0
; CLOBBERS:
;   A7/D0/D1/D7
; CALLS:
;   SCRIPT_UpdateSerialShadowFromCtrlByte, SCRIPT_ClearSearchTextsAndChannels, SCRIPT_BeginBannerCharTransition, SCRIPT_DeassertCtrlLineNow, TEXTDISP_SetRastForMode, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   Global_REF_WORD_HEX_CODE_8E, DATA_CTASKS_STR_N_1BB3, DATA_CTASKS_STR_N_1BC6, CONFIG_MSN_FlagChar, SCRIPT_RuntimeMode
; WRITES:
;   DATA_SCRIPT_BSS_WORD_2119, DATA_SCRIPT_BSS_WORD_211A, SCRIPT_RuntimeMode, TEXTDISP_CurrentMatchIndex
; DESC:
;   Handles runtime-mode transitions around playback cursor commands and
;   updates the serial shadow byte according to current mode/flags.
; NOTES:
;   Returns 1 when it handled the mode transition and caller should stop.
;------------------------------------------------------------------------------
SCRIPT_UpdateRuntimeModeForPlaybackCursor:
    MOVE.L  D7,-(A7)

    MOVE.W  SCRIPT_RuntimeMode,D0
    SUBQ.W  #1,D0
    BNE.W   .runtime_mode_else_paths

    MOVE.B  DATA_CTASKS_STR_N_1BB3,D0
    MOVEQ   #89,D1
    CMP.B   D1,D0
    BNE.S   .runtime_mode_enter_mode2

    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    ADDI.W  #28,D0
    EXT.L   D0
    PEA     1000.W
    MOVE.L  D0,-(A7)
    BSR.W   SCRIPT_BeginBannerCharTransition

    ADDQ.W  #8,A7

.runtime_mode_enter_mode2:
    CLR.W   DATA_SCRIPT_BSS_WORD_2119
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVE.W  #2,SCRIPT_RuntimeMode
    MOVE.W  #1,DATA_SCRIPT_BSS_WORD_211A
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BEQ.S   .runtime_mode_pick_shadow_byte

    MOVEQ   #83,D1
    CMP.B   D1,D0
    BNE.S   .runtime_mode_shadow_default

.runtime_mode_pick_shadow_byte:
    MOVE.B  DATA_CTASKS_STR_N_1BC6,D0
    EXT.W   D0
    SUBI.W  #$42,D0
    BEQ.S   .runtime_mode_shadow_case_3

    SUBI.W  #10,D0
    BEQ.S   .runtime_mode_shadow_case_1

    SUBQ.W  #2,D0
    BEQ.S   .runtime_mode_shadow_case_0

    SUBQ.W  #4,D0
    BEQ.S   .runtime_mode_shadow_case_2

    BRA.S   .runtime_mode_shadow_case_0

.runtime_mode_shadow_case_1:
    MOVEQ   #1,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_2:
    MOVEQ   #2,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_3:
    MOVEQ   #3,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_case_0:
    MOVEQ   #0,D7
    BRA.S   .runtime_mode_apply_shadow_and_clear_search

.runtime_mode_shadow_default:
    MOVEQ   #0,D7

.runtime_mode_apply_shadow_and_clear_search:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.L  D0,-(A7)
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    BSR.W   SCRIPT_ClearSearchTextsAndChannels

    ADDQ.W  #4,A7
    MOVEQ   #1,D0
    BRA.S   .runtime_mode_return

.runtime_mode_else_paths:
    MOVE.W  SCRIPT_RuntimeMode,D0
    SUBQ.W  #3,D0
    BNE.S   .runtime_mode_clear_to_zero

    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_211A

.runtime_mode_clear_to_zero:
    MOVEQ   #0,D0
    MOVE.W  D0,SCRIPT_RuntimeMode

.runtime_mode_return:
    MOVE.L  (A7)+,D7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_UpdateCtrlStateMachine   (Update ctrl-line runtime state machine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   D0-D1
; CALLS:
;   SCRIPT_DeassertCtrlLineNow, TEXTDISP_ResetSelectionAndRefresh, UNKNOWN7_FindCharWrapper, SCRIPT_ReadCiaBBit3Flag
; READS:
;   SCRIPT_RuntimeMode, DATA_SCRIPT_BSS_WORD_2118, DATA_SCRIPT_BSS_WORD_2119, ED_DiagVinModeChar, Global_UIBusyFlag
; WRITES:
;   SCRIPT_RuntimeMode, DATA_SCRIPT_BSS_WORD_2118, DATA_SCRIPT_BSS_WORD_2119
; DESC:
;   Advances a small control state machine and triggers follow-up actions when
;   counters hit thresholds.
; NOTES:
;   Uses ED_DiagVinModeChar via UNKNOWN7_FindCharWrapper to probe a control flag string.
;------------------------------------------------------------------------------
SCRIPT_UpdateCtrlStateMachine:
    BSR.W   .refresh_ctrl_state

    MOVE.W  SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .reset_state

    MOVE.W  DATA_SCRIPT_BSS_WORD_2118,D0
    SUBQ.W  #1,D0
    BNE.S   .check_state_two

    MOVE.W  DATA_SCRIPT_BSS_WORD_2119,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,DATA_SCRIPT_BSS_WORD_2119
    MOVEQ   #3,D0
    CMP.W   D0,D1
    BLT.S   .return_status

    CLR.W   DATA_SCRIPT_BSS_WORD_2119
    MOVE.W  D0,SCRIPT_RuntimeMode
    JSR     SCRIPT_DeassertCtrlLineNow(PC)

    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.S   .return_status

.check_state_two:
    MOVE.W  DATA_SCRIPT_BSS_WORD_2118,D0
    SUBQ.W  #2,D0
    BNE.S   .check_banner_active

    MOVEQ   #0,D0
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_2119
    BRA.S   .return_status

.check_banner_active:
    TST.W   Global_UIBusyFlag
    BEQ.S   .return_status

    MOVE.W  #3,SCRIPT_RuntimeMode
    BRA.S   .return_status

.reset_state:
    CLR.W   DATA_SCRIPT_BSS_WORD_2119

.return_status:
    RTS

;!======

.refresh_ctrl_state:
    MOVEQ   #0,D0
    MOVE.B  ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     DATA_SCRIPT_STR_YL_2130
    JSR     UNKNOWN7_FindCharWrapper(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_state

    JSR     SCRIPT_ReadCiaBBit3Flag(PC)

    TST.B   D0
    BEQ.S   .set_state_one

    MOVE.W  #2,DATA_SCRIPT_BSS_WORD_2118
    BRA.S   .refresh_done

.set_state_one:
    MOVE.W  #1,DATA_SCRIPT_BSS_WORD_2118
    BRA.S   .refresh_done

.clear_state:
    CLR.W   DATA_SCRIPT_BSS_WORD_2118

.refresh_done:
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_DispatchPlaybackCursorCommand   (DispatchPlaybackCursorCommand)
; ARGS:
;   stack +8: playbackCursorPtr (long *)
; RET:
;   D0: none
; CLOBBERS:
;   A3/A7/D0/D1
; CALLS:
;   SCRIPT_UpdateSerialShadowFromCtrlByte, SCRIPT_ClearSearchTextsAndChannels, TEXTDISP_ResetSelectionAndRefresh, WDISP_HandleWeatherStatusCommand, SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen, SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom, SCRIPT_AssertCtrlLineNow, TEXTDISP_HandleScriptCommand, TEXTDISP_SetRastForMode, WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight
; READS:
;   Global_REF_WORD_HEX_CODE_8E, CONFIG_MSN_FlagChar, TEXTDISP_DeferredActionCountdown, DATA_SCRIPT_BSS_WORD_211C, DATA_SCRIPT_STR_X_2126, DATA_SCRIPT_BSS_BYTE_2127, DATA_SCRIPT_BSS_WORD_2128, SCRIPT_CommandTextPtr, DATA_WDISP_BSS_WORD_234F, DATA_WDISP_BSS_LONG_2350, DATA_WDISP_BSS_WORD_2365
; WRITES:
;   TEXTDISP_DeferredActionCountdown, TEXTDISP_DeferredActionArmed, ESQPARS2_ReadModeFlags, DATA_SCRIPT_BSS_WORD_211C, SCRIPT_PendingBannerTargetChar, DATA_SCRIPT_BSS_WORD_211F, DATA_SCRIPT_BSS_WORD_2122, SCRIPT_RuntimeMode, TEXTDISP_CurrentMatchIndex
; DESC:
;   Dispatches command behavior from *playbackCursorPtr using a compiler
;   switch/jumptable and clears the command slot afterward.
; NOTES:
;   Valid dispatch range is cursor values 1..15.
;------------------------------------------------------------------------------
SCRIPT_DispatchPlaybackCursorCommand:
    MOVE.L  A3,-(A7)
    MOVEA.L 8(A7),A3
    MOVE.L  (A3),D0
    SUBQ.L  #1,D0
    BLT.W   .playback_cmd_case_default_increment

    CMPI.L  #$f,D0
    BGE.W   .playback_cmd_case_default_increment

    ADD.W   D0,D0
    MOVE.W  .playback_cmd_jmptbl(PC,D0.W),D0
    JMP     .playback_cmd_jmptbl+2(PC,D0.W)

; switch/jumptable
.playback_cmd_jmptbl:
    DC.W    .playback_cmd_case_reset_selection-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_and_shadow-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_no_defer-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_enter_mode2_defer-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_current-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_primary-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_render_aligned_secondary-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_weather_status-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_textdisp_command-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_assert_ctrl_mode1-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_highlight_and_banner_plus28-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_banner_current-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_custom_copper_effect-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_set_read_mode_on-.playback_cmd_jmptbl-2
    DC.W    .playback_cmd_case_set_read_mode_off-.playback_cmd_jmptbl-2

.playback_cmd_case_set_read_mode_on:
    MOVE.W  #1,DATA_SCRIPT_BSS_WORD_2122
    MOVE.W  #256,ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_set_read_mode_off:
    MOVEQ   #0,D0
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_2122
    MOVE.W  D0,ESQPARS2_ReadModeFlags
    BRA.W   .return

.playback_cmd_case_highlight_and_banner_plus28:
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    ADDI.W  #28,D0
    MOVE.W  #1000,DATA_SCRIPT_BSS_WORD_211F
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_banner_current:
    MOVE.W  Global_REF_WORD_HEX_CODE_8E,D0
    MOVE.W  #1000,DATA_SCRIPT_BSS_WORD_211F
    MOVE.W  D0,SCRIPT_PendingBannerTargetChar
    BRA.W   .return

.playback_cmd_case_custom_copper_effect:
    JSR     SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom(PC)

    BRA.W   .return

.playback_cmd_case_reset_selection:
    JSR     TEXTDISP_ResetSelectionAndRefresh(PC)

    BRA.W   .return

.playback_cmd_case_enter_mode2_and_shadow:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    ADDQ.W  #4,A7
    MOVE.B  CONFIG_MSN_FlagChar,D0
    MOVEQ   #77,D1
    CMP.B   D1,D0
    BNE.S   .playback_cmd_case_shadow_fallback

    PEA     3.W
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.playback_cmd_case_shadow_fallback:
    PEA     1.W
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    BRA.W   .return

.playback_cmd_case_enter_mode2_no_defer:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    JSR     WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   -(A7)
    JSR     TEXTDISP_SetRastForMode(PC)

    PEA     1.W
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #8,A7
    BRA.W   .return

.playback_cmd_case_enter_mode2_defer
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVE.W  TEXTDISP_DeferredActionCountdown,D0
    BNE.W   .return

    PEA     3.W
    JSR     SCRIPT_UpdateSerialShadowFromCtrlByte(PC)

    ADDQ.W  #4,A7
    MOVE.W  #3,TEXTDISP_DeferredActionCountdown
    MOVE.W  #1,TEXTDISP_DeferredActionArmed
    BRA.W   .return

.playback_cmd_case_render_aligned_current:
    MOVE.W  DATA_WDISP_BSS_WORD_2365,D0
    EXT.L   D0
    MOVE.W  DATA_WDISP_BSS_WORD_234F,D1
    EXT.L   D1
    CLR.L   -(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_primary:
    MOVE.L  DATA_WDISP_BSS_LONG_2350,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    PEA     1.W
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.W   .return

.playback_cmd_case_render_aligned_secondary:
    MOVE.L  DATA_WDISP_BSS_LONG_2350,D0
    EXT.L   D0
    MOVE.L  D0,-(A7)
    PEA     53.W
    CLR.L   -(A7)
    JSR     SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen(PC)

    LEA     12(A7),A7
    BRA.S   .return

.playback_cmd_case_weather_status:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  DATA_SCRIPT_STR_X_2126,D0
    MOVE.L  D0,-(A7)
    JSR     WDISP_HandleWeatherStatusCommand(PC)

    ADDQ.W  #4,A7
    BRA.S   .return

.playback_cmd_case_textdisp_command:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVEQ   #0,D0
    MOVE.B  DATA_SCRIPT_BSS_BYTE_2127,D0
    MOVEQ   #0,D1
    MOVE.B  DATA_SCRIPT_BSS_WORD_2128,D1
    MOVE.L  SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  D1,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    LEA     12(A7),A7
    BRA.S   .return

.playback_cmd_case_assert_ctrl_mode1:
    JSR     SCRIPT_AssertCtrlLineNow(PC)

    MOVE.W  #1,SCRIPT_RuntimeMode
    BRA.S   .return

.playback_cmd_case_default_increment:
    MOVE.W  #(-1),TEXTDISP_CurrentMatchIndex
    MOVE.W  DATA_SCRIPT_BSS_WORD_211C,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,DATA_SCRIPT_BSS_WORD_211C

.return:
    BSR.W   SCRIPT_ClearSearchTextsAndChannels

    CLR.L   (A3)
    MOVEA.L (A7)+,A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SetCtrlContextMode   (Set ctrl context mode + reset snapshot)
; ARGS:
;   (none observed)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D7/A3
; CALLS:
;   SCRIPT_ResetCtrlContext
; READS:
;   (none)
; WRITES:
;   A3+0, A3+2, and full context via SCRIPT_ResetCtrlContext
; DESC:
;   Stores a mode flag into the CTRL context header and reinitializes it.
; NOTES:
;   Calls SCRIPT_ResetCtrlContext to clear and reset the rest of the structure.
;------------------------------------------------------------------------------
SCRIPT_SetCtrlContextMode:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.W  18(A7),D7
    MOVE.W  D7,(A3)
    MOVE.W  #1,2(A3)
    MOVE.L  A3,-(A7)
    BSR.W   SCRIPT_ResetCtrlContext

    ADDQ.W  #4,A7
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ResetCtrlContext   (Reset ctrl context snapshot fields)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   D0/D1/D7/A3
; CALLS:
;   UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   (none observed)
; WRITES:
;   A3 fields: +26/+226 strings, +426 flag, +436..+439, +440 handle, and
;   clears ranges at +428..+431 and +0x1B0..+0x1B3 (4 bytes each).
; DESC:
;   Clears and initializes the CTRL context structure and refreshes a resource.
; NOTES:
;   The loop runs 4 iterations (D7 = 0..3), clearing two 4-byte subranges.
;------------------------------------------------------------------------------
SCRIPT_ResetCtrlContext:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVEQ   #0,D0
    MOVE.B  D0,436(A3)
    MOVE.B  #120,437(A3)
    MOVE.B  D0,438(A3)
    MOVE.B  D0,439(A3)
    MOVE.L  440(A3),-(A7)
    CLR.L   -(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVEQ   #0,D0
    MOVE.B  D0,226(A3)
    MOVE.B  D0,26(A3)
    MOVEQ   #0,D0
    MOVE.W  D0,6(A3)
    MOVE.W  D0,4(A3)
    MOVE.W  D0,10(A3)
    MOVE.W  D0,12(A3)
    MOVE.W  D0,14(A3)
    MOVEQ   #0,D1
    MOVE.L  D1,16(A3)
    MOVE.L  D1,20(A3)
    MOVE.W  D0,24(A3)
    MOVE.W  #1,426(A3)
    MOVE.L  D1,D7

.ctrl_context_reset_clear_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    MOVEQ   #0,D0
    MOVE.L  D7,D1
    ADDI.L  #428,D1
    MOVE.B  D0,0(A3,D1.L)
    MOVE.L  D7,D1
    ADDI.L  #$1b0,D1
    MOVE.B  D0,0(A3,D1.L)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_reset_clear_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_LoadCtrlContextSnapshot   (LoadCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   SCRIPT_CommandTextPtr, SCRIPT_RuntimeMode, TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText, DATA_WDISP_BSS_BYTE_2372, DATA_WDISP_BSS_BYTE_2376
; WRITES:
;   DATA_SCRIPT_BSS_WORD_211D, DATA_SCRIPT_STR_X_2126, DATA_SCRIPT_BSS_BYTE_2127, DATA_SCRIPT_BSS_WORD_2128, SCRIPT_CommandTextPtr, TEXTDISP_ActiveGroupId, SCRIPT_RuntimeMode, TEXTDISP_PrimaryChannelCode, TEXTDISP_SecondaryChannelCode, DATA_WDISP_BSS_WORD_234F, DATA_WDISP_BSS_LONG_2350, SCRIPT_PlaybackCursor, SCRIPT_PrimarySearchFirstFlag, DATA_WDISP_BSS_LONG_2357, TEXTDISP_CurrentMatchIndex, DATA_WDISP_BSS_WORD_2365
; DESC:
;   Loads saved CTRL context fields into live script/text-display globals.
; NOTES:
;   Copies two NUL-terminated text buffers from context offsets +26 and +226.
;------------------------------------------------------------------------------
SCRIPT_LoadCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  436(A3),DATA_SCRIPT_BSS_WORD_211D
    MOVE.B  437(A3),DATA_SCRIPT_STR_X_2126
    MOVE.B  438(A3),DATA_SCRIPT_BSS_BYTE_2127
    MOVE.B  439(A3),DATA_SCRIPT_BSS_WORD_2128
    MOVE.L  SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  440(A3),-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,SCRIPT_CommandTextPtr
    MOVE.W  2(A3),SCRIPT_PrimarySearchFirstFlag
    MOVE.W  4(A3),TEXTDISP_PrimaryChannelCode
    MOVE.W  6(A3),TEXTDISP_SecondaryChannelCode
    LEA     26(A3),A0
    LEA     TEXTDISP_PrimarySearchText,A1

.ctrl_context_load_copy_primary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_primary_search

    LEA     226(A3),A0
    LEA     TEXTDISP_SecondarySearchText,A1

.ctrl_context_load_copy_secondary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_secondary_search

    MOVE.W  8(A3),TEXTDISP_CurrentMatchIndex
    MOVE.W  10(A3),DATA_WDISP_BSS_LONG_2357
    MOVE.W  12(A3),DATA_WDISP_BSS_WORD_2365
    MOVE.W  14(A3),DATA_WDISP_BSS_WORD_234F
    MOVE.L  16(A3),DATA_WDISP_BSS_LONG_2350
    MOVE.L  20(A3),SCRIPT_PlaybackCursor
    MOVE.W  SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .ctrl_context_load_runtime_gate

    MOVE.W  24(A3),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_context_load_apply_saved_mode

.ctrl_context_load_runtime_gate:
    MOVE.W  SCRIPT_RuntimeMode,D0
    BNE.S   .ctrl_context_load_copy_active_group

    MOVE.W  24(A3),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   .ctrl_context_load_copy_active_group

.ctrl_context_load_apply_saved_mode:
    MOVE.W  D0,SCRIPT_RuntimeMode

.ctrl_context_load_copy_active_group:
    MOVE.W  426(A3),TEXTDISP_ActiveGroupId
    MOVEQ   #0,D7

.ctrl_context_load_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     DATA_WDISP_BSS_BYTE_2372,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  0(A3,D0.L),(A0)
    LEA     DATA_WDISP_BSS_BYTE_2376,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  0(A3,D0.L),(A0)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_load_copy_shadow_bytes_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_SaveCtrlContextSnapshot   (SaveCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D7
; CALLS:
;   UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   DATA_SCRIPT_BSS_WORD_211D, DATA_SCRIPT_STR_X_2126, DATA_SCRIPT_BSS_BYTE_2127, DATA_SCRIPT_BSS_WORD_2128, SCRIPT_CommandTextPtr, TEXTDISP_ActiveGroupId, SCRIPT_RuntimeMode, TEXTDISP_PrimarySearchText, TEXTDISP_SecondarySearchText, TEXTDISP_PrimaryChannelCode, TEXTDISP_SecondaryChannelCode, DATA_WDISP_BSS_WORD_234F, DATA_WDISP_BSS_LONG_2350, SCRIPT_PlaybackCursor, SCRIPT_PrimarySearchFirstFlag, DATA_WDISP_BSS_LONG_2357, TEXTDISP_CurrentMatchIndex, DATA_WDISP_BSS_WORD_2365, DATA_WDISP_BSS_BYTE_2372, DATA_WDISP_BSS_BYTE_2376
; WRITES:
;   Context fields at A3+2/+4/+6/+8/+10/+12/+14/+16/+20/+24/+26/+226/+426/+436..+440 and A3+0x1AC..0x1B3
; DESC:
;   Saves live script/text-display globals back into the CTRL context block.
;------------------------------------------------------------------------------
SCRIPT_SaveCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  DATA_SCRIPT_BSS_WORD_211D,436(A3)
    MOVE.B  DATA_SCRIPT_STR_X_2126,437(A3)
    MOVE.B  DATA_SCRIPT_BSS_BYTE_2127,438(A3)
    MOVE.B  DATA_SCRIPT_BSS_WORD_2128,439(A3)
    MOVE.L  440(A3),-(A7)
    MOVE.L  SCRIPT_CommandTextPtr,-(A7)
    JSR     UNKNOWN_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVE.W  SCRIPT_PrimarySearchFirstFlag,2(A3)
    MOVE.W  TEXTDISP_PrimaryChannelCode,4(A3)
    MOVE.W  TEXTDISP_SecondaryChannelCode,6(A3)
    LEA     26(A3),A0
    LEA     TEXTDISP_PrimarySearchText,A1

.ctrl_context_save_copy_primary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_primary_search

    LEA     226(A3),A0
    LEA     TEXTDISP_SecondarySearchText,A1

.ctrl_context_save_copy_secondary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_secondary_search

    MOVE.W  TEXTDISP_CurrentMatchIndex,8(A3)
    MOVE.W  DATA_WDISP_BSS_LONG_2357,10(A3)
    MOVE.W  DATA_WDISP_BSS_WORD_2365,12(A3)
    MOVE.W  DATA_WDISP_BSS_WORD_234F,14(A3)
    MOVE.L  DATA_WDISP_BSS_LONG_2350,16(A3)
    MOVE.L  SCRIPT_PlaybackCursor,20(A3)
    MOVE.W  SCRIPT_RuntimeMode,24(A3)
    MOVE.W  TEXTDISP_ActiveGroupId,426(A3)
    MOVEQ   #0,D7

.ctrl_context_save_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     DATA_WDISP_BSS_BYTE_2372,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  (A0),0(A3,D0.L)
    LEA     DATA_WDISP_BSS_BYTE_2376,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1b0,D0
    MOVE.B  (A0),0(A3,D0.L)
    ADDQ.L  #1,D7
    BRA.S   .ctrl_context_save_copy_shadow_bytes_loop

.return:
    MOVEM.L (A7)+,D7/A3
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT_ResetCtrlContextAndClearStatusLine   (ResetCtrlContextAndClearStatusLine)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   A7/D0
; CALLS:
;   SCRIPT_ResetCtrlContext, TEXTDISP_HandleScriptCommand
; READS:
;   SCRIPT_CTRL_CONTEXT
; WRITES:
;   SCRIPT_CTRL_CONTEXT (via SCRIPT_ResetCtrlContext)
; DESC:
;   Clears the status line via TEXTDISP_HandleScriptCommand and reinitializes
;   SCRIPT_CTRL_CONTEXT.
;------------------------------------------------------------------------------
SCRIPT_ResetCtrlContextAndClearStatusLine:
    CLR.L   -(A7)
    MOVEQ   #0,D0
    NOT.B   D0
    MOVE.L  D0,-(A7)
    MOVE.L  D0,-(A7)
    JSR     TEXTDISP_HandleScriptCommand(PC)

    PEA     SCRIPT_CTRL_CONTEXT
    BSR.W   SCRIPT_ResetCtrlContext

    LEA     16(A7),A7
    RTS

;!======

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine   (Routine at SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   LOCAVAIL_UpdateFilterStateMachine
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_UpdateFilterStateMachine:
    JMP     LOCAVAIL_UpdateFilterStateMachine

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_DivS32   (Routine at SCRIPT3_JMPTBL_MATH_DivS32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_DivS32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_MATH_DivS32:
    JMP     MATH_DivS32

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQSHARED_ApplyProgramTitleTextFilters
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQSHARED_ApplyProgramTitleTextFilters.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQSHARED_ApplyProgramTitleTextFilters:
    JMP     ESQSHARED_ApplyProgramTitleTextFilters

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_STRING_CompareN   (Routine at SCRIPT3_JMPTBL_STRING_CompareN)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   STRING_CompareN
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_STRING_CompareN:
    JMP     STRING_CompareN

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQDISP_UpdateStatusMaskAndRefresh
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQDISP_UpdateStatusMaskAndRefresh.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh:
    JMP     ESQDISP_UpdateStatusMaskAndRefresh

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar   (JumpStub_GCOMMAND_GetBannerChar)
; ARGS:
;   (none)
; RET:
;   D0: banner char (see GCOMMAND_GetBannerChar)
; CLOBBERS:
;   (none)
; CALLS:
;   GCOMMAND_GetBannerChar
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_GetBannerChar.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_GCOMMAND_GetBannerChar:
    JMP     GCOMMAND_GetBannerChar

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit   (JumpStub_LADFUNC_ParseHexDigit)
; ARGS:
;   (none)
; RET:
;   D0: parsed digit (see LADFUNC_ParseHexDigit)
; CLOBBERS:
;   (none)
; CALLS:
;   LADFUNC_ParseHexDigit
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LADFUNC_ParseHexDigit.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit:
    JMP     LADFUNC_ParseHexDigit

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   ESQPARS_ApplyRtcBytesAndPersist
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQPARS_ApplyRtcBytesAndPersist.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQPARS_ApplyRtcBytesAndPersist:
    JMP     ESQPARS_ApplyRtcBytesAndPersist

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt   (JumpStub_PARSE_ReadSignedLongSkipClass3_Alt)
; ARGS:
;   (none)
; RET:
;   D0: parsed value (see PARSE_ReadSignedLongSkipClass3_Alt)
; CLOBBERS:
;   (none)
; CALLS:
;   PARSE_ReadSignedLongSkipClass3_Alt
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to PARSE_ReadSignedLongSkipClass3_Alt.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt:
    JMP     PARSE_ReadSignedLongSkipClass3_Alt

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset   (JumpStub_GCOMMAND_AdjustBannerCopperOffset)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   GCOMMAND_AdjustBannerCopperOffset
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to GCOMMAND_AdjustBannerCopperOffset.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_GCOMMAND_AdjustBannerCopperOffset:
    JMP     GCOMMAND_AdjustBannerCopperOffset

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom   (JumpStub_ESQ_SetCopperEffect_Custom)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   ESQ_SetCopperEffect_Custom
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to ESQ_SetCopperEffect_Custom.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_ESQ_SetCopperEffect_Custom:
    JMP     ESQ_SetCopperEffect_Custom

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen   (JumpStub_CLEANUP_RenderAlignedStatusScreen)
; ARGS:
;   (none)
; RET:
;   D0: none
; CLOBBERS:
;   (none)
; CALLS:
;   CLEANUP_RenderAlignedStatusScreen
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to CLEANUP_RenderAlignedStatusScreen.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_CLEANUP_RenderAlignedStatusScreen:
    JMP     CLEANUP_RenderAlignedStatusScreen

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_ComputeFilterOffsetForEntry
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_ComputeFilterOffsetForEntry.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_ComputeFilterOffsetForEntry:
    JMP     LOCAVAIL_ComputeFilterOffsetForEntry

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_MATH_Mulu32   (Routine at SCRIPT3_JMPTBL_MATH_Mulu32)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   MATH_Mulu32
; READS:
;   (none observed)
; WRITES:
;   (none observed)
; DESC:
;   Entry-point routine; static scan captures calls and symbol accesses.
; NOTES:
;   Auto-refined from instruction scan; verify semantics during deeper analysis.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_MATH_Mulu32:
    JMP     MATH_Mulu32

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState   (JumpStub)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   LOCAVAIL_SetFilterModeAndResetState
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to LOCAVAIL_SetFilterModeAndResetState.
; NOTES:
;   Requires deeper reverse-engineering.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_LOCAVAIL_SetFilterModeAndResetState:
    JMP     LOCAVAIL_SetFilterModeAndResetState

;------------------------------------------------------------------------------
; FUNC: SCRIPT3_JMPTBL_STRING_CopyPadNul   (JumpStub_STRING_CopyPadNul)
; ARGS:
;   (none)
; RET:
;   D0: none observed
; CLOBBERS:
;   (none)
; CALLS:
;   STRING_CopyPadNul
; READS:
;   (none)
; WRITES:
;   (none)
; DESC:
;   Jump stub to STRING_CopyPadNul.
;------------------------------------------------------------------------------
SCRIPT3_JMPTBL_STRING_CopyPadNul:
    JMP     STRING_CopyPadNul
