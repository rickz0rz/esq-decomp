
    JSR     _ESQDISP_ProcessGridMessagesIfIdle(PC)

    TST.W   CLEANUP_PendingAlertFlag
    BEQ.S   .lab_0980

    JSR     ESQFUNC_JMPTBL_CLEANUP_ProcessAlerts(PC)

.lab_0980:
    JSR     ESQFUNC_JMPTBL_TEXTDISP_TickDisplayState(PC)

    RTS

;!======