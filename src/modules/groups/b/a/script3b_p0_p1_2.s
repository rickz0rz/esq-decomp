
    XDEF    _SCRIPT_RefreshCtrlState

_SCRIPT_RefreshCtrlState:
    MOVEQ   #0,D0
    MOVE.B  _ED_DiagVinModeChar,D0
    MOVE.L  D0,-(A7)
    PEA     _SCRIPT_Tag_YL
    ; strchr-style membership test against "YL" mode-gate chars.
    JSR     _STR_FindCharPtr(PC)

    ADDQ.W  #8,A7
    TST.L   D0
    BEQ.S   .clear_state

    JSR     _SCRIPT_ReadHandshakeBit3Flag(PC)

    TST.B   D0
    BEQ.S   .set_state_one

    MOVE.W  #2,_SCRIPT_CtrlHandshakeStage
    BRA.S   .refresh_done

.set_state_one:
    MOVE.W  #1,_SCRIPT_CtrlHandshakeStage
    BRA.S   .refresh_done

.clear_state:
    CLR.W   _SCRIPT_CtrlHandshakeStage

.refresh_done:
    RTS

;!======