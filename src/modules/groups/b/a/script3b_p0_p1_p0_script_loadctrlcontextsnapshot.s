    XDEF    _SCRIPT_LoadCtrlContextSnapshot


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_LoadCtrlContextSnapshot   (LoadCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D1/D7
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _SCRIPT_CommandTextPtr, _SCRIPT_RuntimeMode, _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_BannerFallbackEntryIndex, _TEXTDISP_BannerSelectedEntryIndex
; WRITES:
;   _SCRIPT_Type20SubtypeCache, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _TEXTDISP_ActiveGroupId, _SCRIPT_RuntimeMode, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ChannelSourceMode
; DESC:
;   Loads saved CTRL context fields into live script/text-display globals.
; NOTES:
;   Copies two NUL-terminated text buffers from context offsets +26 and +226.
;------------------------------------------------------------------------------
_SCRIPT_LoadCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3
    MOVE.B  436(A3),_SCRIPT_Type20SubtypeCache
    MOVE.B  437(A3),_SCRIPT_PendingWeatherCommandChar
    MOVE.B  438(A3),_SCRIPT_PendingTextdispCmdChar
    MOVE.B  439(A3),_SCRIPT_PendingTextdispCmdArg
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    MOVE.L  440(A3),-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,_SCRIPT_CommandTextPtr
    MOVE.W  2(A3),_SCRIPT_PrimarySearchFirstFlag
    MOVE.W  4(A3),_TEXTDISP_PrimaryChannelCode
    MOVE.W  6(A3),_TEXTDISP_SecondaryChannelCode
    LEA     26(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.ctrl_context_load_copy_primary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_primary_search

    LEA     226(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.ctrl_context_load_copy_secondary_search:
    MOVE.B  (A0)+,(A1)+
    BNE.S   .ctrl_context_load_copy_secondary_search

    MOVE.W  8(A3),_TEXTDISP_CurrentMatchIndex
    MOVE.W  10(A3),_SCRIPT_ChannelRangeArmedFlag
    MOVE.W  12(A3),_TEXTDISP_ChannelSourceMode
    MOVE.W  14(A3),_SCRIPT_ChannelRangeDigitChar
    MOVE.L  16(A3),_SCRIPT_SearchMatchCountOrIndex
    MOVE.L  20(A3),_SCRIPT_PlaybackCursor
    MOVE.W  _SCRIPT_RuntimeMode,D0
    SUBQ.W  #2,D0
    BNE.S   .ctrl_context_load_runtime_gate

    MOVE.W  24(A3),D0
    MOVEQ   #3,D1
    CMP.W   D1,D0
    BEQ.S   .ctrl_context_load_apply_saved_mode

.ctrl_context_load_runtime_gate:
    MOVE.W  _SCRIPT_RuntimeMode,D0
    BNE.S   .ctrl_context_load_copy_active_group

    MOVE.W  24(A3),D0
    MOVEQ   #1,D1
    CMP.W   D1,D0
    BNE.S   .ctrl_context_load_copy_active_group

.ctrl_context_load_apply_saved_mode:
    MOVE.W  D0,_SCRIPT_RuntimeMode

.ctrl_context_load_copy_active_group:
    MOVE.W  426(A3),_TEXTDISP_ActiveGroupId
    MOVEQ   #0,D7

.ctrl_context_load_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _TEXTDISP_BannerFallbackEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  0(A3,D0.L),(A0)
    LEA     _TEXTDISP_BannerSelectedEntryIndex,A0
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