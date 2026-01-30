GROUPA1_JMP_TBL_PARSEINI_UpdateClockFromRtc:
LAB_020D:
    JMP     PARSEINI_UpdateClockFromRtc

GROUPA1_JMP_TBL_ESQFUNC_DrawDiagnosticsScreen:
LAB_020E:
    JMP     ESQFUNC_DrawDiagnosticsScreen

GROUPA1_JMP_TBL_ESQFUNC_DrawMemoryStatusScreen:
LAB_020F:
    JMP     ESQFUNC_DrawMemoryStatusScreen

GROUPA1_JMP_TBL_SCRIPT_UpdateCtrlStateMachine:
LAB_0210:
    JMP     SCRIPT_UpdateCtrlStateMachine

GROUPA1_JMP_TBL_GCOMMAND_UpdateBannerBounds:
LAB_0211:
    JMP     GCOMMAND_UpdateBannerBounds

GROUPA1_JMP_TBL_SCRIPT_UpdateCtrlLineTimeout:
LAB_0212:
    JMP     SCRIPT_UpdateCtrlLineTimeout

GROUPA1_JMP_TBL_SCRIPT_ClearCtrlLineIfEnabled:
LAB_0213:
    JMP     SCRIPT_ClearCtrlLineIfEnabled

GROUPA1_JMP_TBL_ESQFUNC_PruneEntryTextPointers:
LAB_0214:
    JMP     ESQFUNC_PruneEntryTextPointers

GROUPA1_JMP_TBL_ESQDISP_DrawStatusBanner:
LAB_0215:
    JMP     ESQDISP_DrawStatusBanner

GROUPA1_JMP_TBL_DST_UpdateBannerQueue:
LAB_0216:
    JMP     DST_UpdateBannerQueue

GROUPA1_JMP_TBL_DST_RefreshBannerBuffer:
LAB_0217:
    JMP     DST_RefreshBannerBuffer

GROUPA1_JMP_TBL_DRAW_ESC_MENU_VERSION_SCREEN:
LAB_0218:
    JMP     DRAW_ESC_MENU_VERSION_SCREEN

JMP_TBL_ADJUST_HOURS_TO_24_HR_FMT:
    JMP     ADJUST_HOURS_TO_24_HR_FMT

;!======

    ; Alignment
    MOVEQ   #97,D0