    XDEF    _ESQDISP_ProcessGridMessagesIfIdle


;------------------------------------------------------------------------------
; FUNC: _ESQDISP_ProcessGridMessagesIfIdle   (Pump grid messages when UI is idle)
; ARGS:
;   (none observed)
; RET:
;   D0: none observed
; CLOBBERS:
;   none observed
; CALLS:
;   _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages
; READS:
;   _ESQDISP_GridMessagePumpBlockFlag, _NEWGRID_MessagePumpSuspendFlag, _Global_UIBusyFlag
; WRITES:
;   (none observed)
; DESC:
;   Forwards to NEWGRID message processing only when no modal/input-busy gate is set.
; NOTES:
;   Gated by _ESQDISP_GridMessagePumpBlockFlag, _Global_UIBusyFlag, and _NEWGRID_MessagePumpSuspendFlag.
;------------------------------------------------------------------------------
_ESQDISP_ProcessGridMessagesIfIdle:
    TST.W   _ESQDISP_GridMessagePumpBlockFlag
    BNE.S   .lab_08C3

    TST.W   _Global_UIBusyFlag
    BNE.S   .lab_08C3

    TST.L   _NEWGRID_MessagePumpSuspendFlag
    BNE.S   .lab_08C3

    JSR     _ESQDISP_JMPTBL_NEWGRID_ProcessGridMessages(PC)

.lab_08C3:
    RTS

;!======