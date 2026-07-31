
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   _CLEANUP_PendingAlertFlag
    BEQ.S   .lab_0980

    JSR     _ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

.lab_0980:
    JSR     _ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    RTS

;!======