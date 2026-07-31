    XDEF    _SCRIPT_HandleSerialCtrlCmd



;------------------------------------------------------------------------------
; FUNC: _SCRIPT_HandleSerialCtrlCmd   (HandleSerialCtrlCmd)
; ARGS:
;   (none)
; RET:
;   D0: none (status handled via globals)
; CLOBBERS:
;   D0-D7/A0-A1
; CALLS:
;   _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte, _PARSEINI_CheckCtrlHChange, _SCRIPT_HandleBrushCommand, _SCRIPT_ApplyPendingBannerTarget,
;   _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight, _TEXTDISP_SetRastForMode, _SCRIPT_ProcessCtrlContextPlaybackTick, _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh, _TEXTDISP_ResetSelectionAndRefresh
; READS:
;   _Global_WORD_SELECT_CODE_IS_RAVESC, _CONFIG_MSN_FlagChar, _SCRIPT_StatusRefreshHoldFlag, _ESQDISP_DisplayActiveFlag, _SCRIPT_StatusMaskRefreshPending
;   _Global_REF_CLOCKDATA_STRUCT, _Global_WORD_CLOCK_SECONDS
;   _SCRIPT_CTRL_READ_INDEX, _SCRIPT_CTRL_CHECKSUM, _SCRIPT_CTRL_STATE,
;   _SCRIPT_RuntimeMode/2347/2348/2349/234A, _SCRIPT_CTRL_CMD_BUFFER
; WRITES:
;   _Global_RefreshTickCounter, _SCRIPT_StatusMaskRefreshPending, _Global_WORD_CLOCK_SECONDS,
;   _SCRIPT_CTRL_READ_INDEX, _SCRIPT_CTRL_CHECKSUM, _SCRIPT_CTRL_STATE,
;   _SCRIPT_CTRL_CMD_BUFFER, _SCRIPT_CtrlCmdCount/2348/2349
; DESC:
;   Polls the CTRL input buffer and advances a small state machine to parse
;   serial control commands; dispatches actions via a jump table.
; NOTES:
;   The jump table is a compiler switch/jumptable on the input byte (0..21).
;   _SCRIPT_CTRL_STATE acts as a parser state: 0=idle, 1/2/3=substates uncertain.
;------------------------------------------------------------------------------
_SCRIPT_HandleSerialCtrlCmd:
    MOVEM.L D6-D7,-(A7)

    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.S   .selectCodeIsNotRAVSEC

    MOVE.B  _CONFIG_MSN_FlagChar,D0
    MOVEQ   #'M',D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_gate_refresh_disabled

.selectCodeIsNotRAVSEC:
    MOVE.W  #(-1),_Global_RefreshTickCounter
    BRA.S   .ctrl_cmd_handle_status_timeout

.ctrl_cmd_gate_refresh_disabled:
    TST.W   _SCRIPT_StatusRefreshHoldFlag
    BEQ.S   .ctrl_cmd_check_display_state

    MOVEQ   #0,D0
    MOVE.W  D0,_Global_RefreshTickCounter
    BRA.W   .return

.ctrl_cmd_check_display_state:
    MOVEQ   #1,D0
    CMP.L   _ESQDISP_DisplayActiveFlag,D0
    BEQ.W   .return

.ctrl_cmd_handle_status_timeout:
    TST.W   _SCRIPT_StatusMaskRefreshPending
    BEQ.S   .ctrl_cmd_poll_input

    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,D0
    MOVE.W  _Global_WORD_CLOCK_SECONDS,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_cmd_poll_input

    ADDQ.W  #1,_Global_WORD_CLOCK_SECONDS
    CMPI.W  #3,_Global_WORD_CLOCK_SECONDS
    BLT.S   .ctrl_cmd_poll_input

    CLR.W   _SCRIPT_StatusMaskRefreshPending
    CLR.L   -(A7)
    PEA     32.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7

.ctrl_cmd_poll_input:
    JSR     _PARSEINI_CheckCtrlHChange(PC)

    MOVE.L  D0,D6
    TST.W   _Global_UIBusyFlag
    BNE.W   .return

    TST.W   D6
    BEQ.W   .return

    MOVE.W  _Global_RefreshTickCounter,D0
    ADDQ.W  #1,D0
    BEQ.S   .ctrl_cmd_parse_state_dispatch

    CLR.W   _Global_RefreshTickCounter

.ctrl_cmd_parse_state_dispatch:
    JSR     _SCRIPT_ESQ_CaptureCtrlBit4StreamBufferByte(PC)

    MOVE.L  D0,D7
    MOVE.W  _SCRIPT_CTRL_STATE,D0
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
    MOVE.W  #3,_SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA    

.ctrl_cmd_case_gated_by_select_code:
    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BNE.W   .return

.ctrl_cmd_case_start_packet:
    MOVEQ   #1,D0
    LEA     _SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  _SCRIPT_CTRL_READ_INDEX,A0
    MOVE.B  D7,(A0)
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    MOVE.W  D1,_SCRIPT_CTRL_CHECKSUM
    MOVE.W  _SCRIPT_CtrlCmdCount,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlCmdCount
    MOVE.W  D0,_SCRIPT_CTRL_STATE
    BRA.W   .finish_29ABA

.ctrl_cmd_state_collect_body:
    MOVE.W  _SCRIPT_CTRL_READ_INDEX,D0
    MOVE.L  D0,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CTRL_READ_INDEX
    LEA     _SCRIPT_CTRL_CMD_BUFFER,A0
    ADDA.W  D1,A0
    MOVE.L  D7,D0
    MOVE.B  D0,(A0)
    MOVEQ   #13,D1
    CMP.B   D1,D0
    BNE.S   .ctrl_cmd_state_collect_update_checksum

    MOVE.W  #2,_SCRIPT_CTRL_STATE

.ctrl_cmd_state_collect_update_checksum:
    MOVE.W  _SCRIPT_CTRL_CHECKSUM,D0
    EXT.L   D0
    MOVEQ   #0,D1
    MOVE.B  D7,D1
    EOR.L   D1,D0
    MOVE.W  D0,_SCRIPT_CTRL_CHECKSUM
    BRA.W   .finish_29ABA

.ctrl_cmd_state_expect_checksum:
    MOVEQ   #0,D0
    MOVE.B  D7,D0
    MOVE.W  _SCRIPT_CTRL_CHECKSUM,D1
    EXT.L   D1
    CMP.L   D1,D0
    BNE.S   .ctrl_cmd_checksum_mismatch

    TST.W   _Global_WORD_SELECT_CODE_IS_RAVESC
    BEQ.S   .ctrl_cmd_checksum_ok_normal_mode

    MOVE.W  _SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Pass packet length into _SCRIPT_HandleBrushCommand; command bytes live in
    ; _SCRIPT_CTRL_CMD_BUFFER (200-byte storage in data/wdisp.s).
    MOVE.L  D0,-(A7)
    PEA     _SCRIPT_CTRL_CMD_BUFFER
    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_HandleBrushCommand

    BSR.W   _SCRIPT_ApplyPendingBannerTarget

    JSR     _WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(PC)

    CLR.L   (A7)
    JSR     _TEXTDISP_SetRastForMode(PC)

    LEA     12(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_ok_normal_mode:
    MOVE.W  _TEXTDISP_DeferredActionCountdown,D0
    BEQ.S   .ctrl_cmd_dispatch_brush_now

    SUBQ.W  #1,D0
    BNE.S   .ctrl_cmd_defer_dispatch

.ctrl_cmd_dispatch_brush_now:
    MOVE.W  _SCRIPT_CTRL_READ_INDEX,D0
    EXT.L   D0
    ; Same packet-length/path as above (_SCRIPT_CTRL_CMD_BUFFER + read index).
    MOVE.L  D0,-(A7)
    PEA     _SCRIPT_CTRL_CMD_BUFFER
    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_HandleBrushCommand

    PEA     _SCRIPT_CTRL_CONTEXT
    BSR.W   _SCRIPT_ProcessCtrlContextPlaybackTick

    LEA     16(A7),A7
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_defer_dispatch:
    MOVE.W  _SCRIPT_CtrlCmdDeferCounter,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_SCRIPT_CtrlCmdDeferCounter
    BRA.S   .ctrl_cmd_reset_parser

.ctrl_cmd_checksum_mismatch:
    PEA     1.W
    PEA     32.W
    JSR     _SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(PC)

    ADDQ.W  #8,A7
    MOVE.W  _Global_REF_CLOCKDATA_STRUCT,_Global_WORD_CLOCK_SECONDS
    MOVEQ   #1,D0
    MOVE.W  _SCRIPT_CtrlCmdChecksumErrorCount,D1
    ADDQ.W  #1,D1
    MOVE.W  D1,_SCRIPT_CtrlCmdChecksumErrorCount
    MOVE.W  D0,_SCRIPT_StatusMaskRefreshPending

.ctrl_cmd_reset_parser:
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,_SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,_SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state3_clear:
    CLR.W   _SCRIPT_CTRL_STATE
    BRA.S   .finish_29ABA

.ctrl_cmd_state_invalid_reset:
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,_SCRIPT_CTRL_READ_INDEX
    MOVE.W  D0,_SCRIPT_CTRL_STATE

.ctrl_cmd_finish_dispatch:
.finish_29ABA:
    MOVE.W  _SCRIPT_CTRL_READ_INDEX,D0
    CMPI.W  #198,D0
    BLE.S   .return

    MOVE.W  _SCRIPT_CtrlCmdLengthErrorCount,D0
    ADDQ.W  #1,D0
    MOVE.W  D0,_SCRIPT_CtrlCmdLengthErrorCount
    MOVEQ   #0,D0
    MOVE.W  D0,_SCRIPT_CTRL_CHECKSUM
    MOVE.W  D0,_SCRIPT_CTRL_READ_INDEX
    MOVE.W  _SCRIPT_RuntimeMode,D1
    MOVE.W  D0,_SCRIPT_CTRL_STATE
    TST.W   D1
    BNE.S   .return

    JSR     _TEXTDISP_ResetSelectionAndRefresh(PC)

.return:
    MOVEM.L (A7)+,D6-D7
    RTS

;!======