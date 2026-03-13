typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern WORD Global_WORD_SELECT_CODE_IS_RAVESC;
extern char CONFIG_MSN_FlagChar;
extern WORD Global_RefreshTickCounter;
extern WORD SCRIPT_StatusRefreshHoldFlag;
extern LONG ESQDISP_DisplayActiveFlag;
extern WORD SCRIPT_StatusMaskRefreshPending;
extern WORD Global_REF_CLOCKDATA_STRUCT;
extern WORD Global_WORD_CLOCK_SECONDS;
extern WORD Global_UIBusyFlag;

extern WORD SCRIPT_CTRL_READ_INDEX;
extern WORD SCRIPT_CTRL_CHECKSUM;
extern WORD SCRIPT_CTRL_STATE;
extern char SCRIPT_CTRL_CMD_BUFFER[];
extern char SCRIPT_CTRL_CONTEXT[];

extern WORD SCRIPT_CtrlCmdCount;
extern WORD TEXTDISP_DeferredActionCountdown;
extern WORD SCRIPT_CtrlCmdDeferCounter;
extern WORD SCRIPT_CtrlCmdChecksumErrorCount;
extern WORD SCRIPT_CtrlCmdLengthErrorCount;
extern WORD SCRIPT_RuntimeMode;

extern LONG PARSEINI_CheckCtrlHChange(void);
extern LONG ESQ_CaptureCtrlBit4StreamBufferByte(void);
extern LONG SCRIPT_HandleBrushCommand(char *ctx, char *cmd, LONG cmdLen);
extern void SCRIPT_ApplyPendingBannerTarget(void);
extern void ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void TEXTDISP_SetRastForMode(LONG mode);
extern void SCRIPT_ProcessCtrlContextPlaybackTick(char *ctx);
extern void ESQDISP_UpdateStatusMaskAndRefresh(LONG mode, LONG flag);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

void SCRIPT_HandleSerialCtrlCmd(void)
{
    LONG hasCtrl;
    UBYTE inputByte;
    WORD state;

    if (Global_WORD_SELECT_CODE_IS_RAVESC != 0 || CONFIG_MSN_FlagChar == 'M') {
        Global_RefreshTickCounter = -1;
    } else if (SCRIPT_StatusRefreshHoldFlag != 0) {
        Global_RefreshTickCounter = 0;
        return;
    } else if (ESQDISP_DisplayActiveFlag == 1) {
        return;
    }

    if (SCRIPT_StatusMaskRefreshPending != 0) {
        if (Global_REF_CLOCKDATA_STRUCT != Global_WORD_CLOCK_SECONDS) {
            Global_WORD_CLOCK_SECONDS = (WORD)(Global_WORD_CLOCK_SECONDS + 1);
            if (Global_WORD_CLOCK_SECONDS >= 3) {
                SCRIPT_StatusMaskRefreshPending = 0;
                ESQDISP_UpdateStatusMaskAndRefresh(32, 0);
            }
        }
    }

    hasCtrl = PARSEINI_CheckCtrlHChange();
    if (Global_UIBusyFlag != 0 || hasCtrl == 0) {
        return;
    }

    Global_RefreshTickCounter = (WORD)(Global_RefreshTickCounter + 1);
    if (Global_RefreshTickCounter != 0) {
        Global_RefreshTickCounter = 0;
    }

    inputByte = (UBYTE)ESQ_CaptureCtrlBit4StreamBufferByte();
    state = SCRIPT_CTRL_STATE;

    if (state == 0) {
        WORD cmd = (WORD)inputByte - 1;
        if (cmd < 0 || cmd >= 22) {
            goto finish_dispatch;
        }

        switch (cmd) {
        case 0:
        case 11:
        case 14:
            SCRIPT_CTRL_CMD_BUFFER[SCRIPT_CTRL_READ_INDEX] = (char)inputByte;
            SCRIPT_CTRL_CHECKSUM = (WORD)inputByte;
            SCRIPT_CtrlCmdCount = (WORD)(SCRIPT_CtrlCmdCount + 1);
            SCRIPT_CTRL_STATE = 1;
            break;

        case 12:
            SCRIPT_CTRL_STATE = 3;
            break;

        case 1:
        case 2:
        case 3:
        case 4:
        case 6:
        case 10:
        case 15:
        case 16:
        case 19:
        case 21:
            if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
                return;
            }
            SCRIPT_CTRL_CMD_BUFFER[SCRIPT_CTRL_READ_INDEX] = (char)inputByte;
            SCRIPT_CTRL_CHECKSUM = (WORD)inputByte;
            SCRIPT_CtrlCmdCount = (WORD)(SCRIPT_CtrlCmdCount + 1);
            SCRIPT_CTRL_STATE = 1;
            break;

        default:
            break;
        }

    } else if (state == 1) {
        SCRIPT_CTRL_READ_INDEX = (WORD)(SCRIPT_CTRL_READ_INDEX + 1);
        SCRIPT_CTRL_CMD_BUFFER[SCRIPT_CTRL_READ_INDEX] = (char)inputByte;
        if (inputByte == 13) {
            SCRIPT_CTRL_STATE = 2;
        }
        SCRIPT_CTRL_CHECKSUM = (WORD)(SCRIPT_CTRL_CHECKSUM ^ (WORD)inputByte);

    } else if (state == 2) {
        if ((WORD)inputByte == SCRIPT_CTRL_CHECKSUM) {
            if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {
                SCRIPT_HandleBrushCommand((char *)SCRIPT_CTRL_CONTEXT, SCRIPT_CTRL_CMD_BUFFER, (LONG)SCRIPT_CTRL_READ_INDEX);
                SCRIPT_ApplyPendingBannerTarget();
                ESQ_SetCopperEffect_OnEnableHighlight();
                TEXTDISP_SetRastForMode(0);
            } else {
                if (TEXTDISP_DeferredActionCountdown == 0) {
                    SCRIPT_HandleBrushCommand((char *)SCRIPT_CTRL_CONTEXT, SCRIPT_CTRL_CMD_BUFFER, (LONG)SCRIPT_CTRL_READ_INDEX);
                    SCRIPT_ProcessCtrlContextPlaybackTick((char *)SCRIPT_CTRL_CONTEXT);
                } else {
                    TEXTDISP_DeferredActionCountdown = (WORD)(TEXTDISP_DeferredActionCountdown - 1);
                    if (TEXTDISP_DeferredActionCountdown == 0) {
                        SCRIPT_HandleBrushCommand((char *)SCRIPT_CTRL_CONTEXT, SCRIPT_CTRL_CMD_BUFFER, (LONG)SCRIPT_CTRL_READ_INDEX);
                        SCRIPT_ProcessCtrlContextPlaybackTick((char *)SCRIPT_CTRL_CONTEXT);
                    } else {
                        SCRIPT_CtrlCmdDeferCounter = (WORD)(SCRIPT_CtrlCmdDeferCounter + 1);
                    }
                }
            }
        } else {
            ESQDISP_UpdateStatusMaskAndRefresh(32, 1);
            Global_WORD_CLOCK_SECONDS = Global_REF_CLOCKDATA_STRUCT;
            SCRIPT_CtrlCmdChecksumErrorCount = (WORD)(SCRIPT_CtrlCmdChecksumErrorCount + 1);
            SCRIPT_StatusMaskRefreshPending = 1;
        }

        SCRIPT_CTRL_CHECKSUM = 0;
        SCRIPT_CTRL_READ_INDEX = 0;
        SCRIPT_CTRL_STATE = 0;

    } else if (state == 3) {
        SCRIPT_CTRL_STATE = 0;

    } else {
        SCRIPT_CTRL_CHECKSUM = 0;
        SCRIPT_CTRL_READ_INDEX = 0;
        SCRIPT_CTRL_STATE = 0;
    }

finish_dispatch:
    if (SCRIPT_CTRL_READ_INDEX > 198) {
        SCRIPT_CtrlCmdLengthErrorCount = (WORD)(SCRIPT_CtrlCmdLengthErrorCount + 1);
        SCRIPT_CTRL_CHECKSUM = 0;
        SCRIPT_CTRL_READ_INDEX = 0;
        state = SCRIPT_RuntimeMode;
        SCRIPT_CTRL_STATE = 0;
        if (state == 0) {
            TEXTDISP_ResetSelectionAndRefresh();
        }
    }
}
