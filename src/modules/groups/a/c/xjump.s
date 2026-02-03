GROUP_AC_JMPTBL_PARSEINI_UpdateClockFromRtc:
    JMP     PARSEINI_UpdateClockFromRtc

GROUP_AC_JMPTBL_ESQFUNC_DrawDiagnosticsScreen:
    JMP     ESQFUNC_DrawDiagnosticsScreen

GROUP_AC_JMPTBL_ESQFUNC_DrawMemoryStatusScreen:
    JMP     ESQFUNC_DrawMemoryStatusScreen

GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlStateMachine:
    JMP     SCRIPT_UpdateCtrlStateMachine

GROUP_AC_JMPTBL_GCOMMAND_UpdateBannerBounds:
    JMP     GCOMMAND_UpdateBannerBounds

GROUP_AC_JMPTBL_SCRIPT_UpdateCtrlLineTimeout:
    JMP     SCRIPT_UpdateCtrlLineTimeout

GROUP_AC_JMPTBL_SCRIPT_ClearCtrlLineIfEnabled:
    JMP     SCRIPT_ClearCtrlLineIfEnabled

GROUP_AC_JMPTBL_ESQFUNC_PruneEntryTextPointers:
    JMP     ESQFUNC_PruneEntryTextPointers

GROUP_AC_JMPTBL_ESQDISP_DrawStatusBanner:
    JMP     ESQDISP_DrawStatusBanner

GROUP_AC_JMPTBL_DST_UpdateBannerQueue:
    JMP     DST_UpdateBannerQueue

GROUP_AC_JMPTBL_DST_RefreshBannerBuffer:
    JMP     DST_RefreshBannerBuffer

GROUP_AC_JMPTBL_ESQFUNC_DrawEscMenuVersion:
    JMP     ESQFUNC_DrawEscMenuVersion

GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat:
    JMP     PARSEINI_AdjustHoursTo24HrFormat

;!======

    ; Alignment
    MOVEQ   #97,D0