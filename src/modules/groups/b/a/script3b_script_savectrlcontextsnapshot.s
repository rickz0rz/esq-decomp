    XDEF    _SCRIPT_SaveCtrlContextSnapshot


;------------------------------------------------------------------------------
; FUNC: _SCRIPT_SaveCtrlContextSnapshot   (SaveCtrlContextSnapshot)
; ARGS:
;   stack +12: ctxPtr (A3)
; RET:
;   D0: none
; CLOBBERS:
;   A0/A1/A3/A7/D0/D7
; CALLS:
;   _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString
; READS:
;   _SCRIPT_Type20SubtypeCache, _SCRIPT_PendingWeatherCommandChar, _SCRIPT_PendingTextdispCmdChar, _SCRIPT_PendingTextdispCmdArg, _SCRIPT_CommandTextPtr, _TEXTDISP_ActiveGroupId, _SCRIPT_RuntimeMode, _TEXTDISP_PrimarySearchText, _TEXTDISP_SecondarySearchText, _TEXTDISP_PrimaryChannelCode, _TEXTDISP_SecondaryChannelCode, _SCRIPT_ChannelRangeDigitChar, _SCRIPT_SearchMatchCountOrIndex, _SCRIPT_PlaybackCursor, _SCRIPT_PrimarySearchFirstFlag, _SCRIPT_ChannelRangeArmedFlag, _TEXTDISP_CurrentMatchIndex, _TEXTDISP_ChannelSourceMode, _TEXTDISP_BannerFallbackEntryIndex, _TEXTDISP_BannerSelectedEntryIndex
; WRITES:
;   Context fields at A3+2/+4/+6/+8/+10/+12/+14/+16/+20/+24/+26/+226/+426/+436..+440 and A3+0x1AC..0x1B3
; DESC:
;   Saves live script/text-display globals back into the CTRL context block.
;------------------------------------------------------------------------------
_SCRIPT_SaveCtrlContextSnapshot:
    MOVEM.L D7/A3,-(A7)
    MOVEA.L 12(A7),A3

    MOVE.B  _SCRIPT_Type20SubtypeCache,436(A3)
    MOVE.B  _SCRIPT_PendingWeatherCommandChar,437(A3)
    MOVE.B  _SCRIPT_PendingTextdispCmdChar,438(A3)
    MOVE.B  _SCRIPT_PendingTextdispCmdArg,439(A3)
    MOVE.L  440(A3),-(A7)
    MOVE.L  _SCRIPT_CommandTextPtr,-(A7)
    JSR     _ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(PC)

    ADDQ.W  #8,A7
    MOVE.L  D0,440(A3)
    MOVE.W  _SCRIPT_PrimarySearchFirstFlag,2(A3)
    MOVE.W  _TEXTDISP_PrimaryChannelCode,4(A3)
    MOVE.W  _TEXTDISP_SecondaryChannelCode,6(A3)
    LEA     26(A3),A0
    LEA     _TEXTDISP_PrimarySearchText,A1

.ctrl_context_save_copy_primary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_primary_search

    LEA     226(A3),A0
    LEA     _TEXTDISP_SecondarySearchText,A1

.ctrl_context_save_copy_secondary_search:
    MOVE.B  (A1)+,(A0)+
    BNE.S   .ctrl_context_save_copy_secondary_search

    MOVE.W  _TEXTDISP_CurrentMatchIndex,8(A3)
    MOVE.W  _SCRIPT_ChannelRangeArmedFlag,10(A3)
    MOVE.W  _TEXTDISP_ChannelSourceMode,12(A3)
    MOVE.W  _SCRIPT_ChannelRangeDigitChar,14(A3)
    MOVE.L  _SCRIPT_SearchMatchCountOrIndex,16(A3)
    MOVE.L  _SCRIPT_PlaybackCursor,20(A3)
    MOVE.W  _SCRIPT_RuntimeMode,24(A3)
    MOVE.W  _TEXTDISP_ActiveGroupId,426(A3)
    MOVEQ   #0,D7

.ctrl_context_save_copy_shadow_bytes_loop:
    MOVEQ   #4,D0
    CMP.L   D0,D7
    BGE.S   .return

    LEA     _TEXTDISP_BannerFallbackEntryIndex,A0
    ADDA.L  D7,A0
    MOVE.L  D7,D0
    ADDI.L  #$1ac,D0
    MOVE.B  (A0),0(A3,D0.L)
    LEA     _TEXTDISP_BannerSelectedEntryIndex,A0
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