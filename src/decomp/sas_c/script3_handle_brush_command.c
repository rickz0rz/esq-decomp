typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern WORD SCRIPT_RuntimeMode;
extern LONG SCRIPT_PlaybackCursor;
extern WORD SCRIPT_PrimarySearchFirstFlag;
extern WORD TEXTDISP_PrimaryChannelCode;
extern WORD TEXTDISP_SecondaryChannelCode;
extern WORD TEXTDISP_CurrentMatchIndex;
extern WORD SCRIPT_PendingBannerTargetChar;
extern UBYTE SCRIPT_PendingTextdispCmdChar;
extern UBYTE SCRIPT_PendingTextdispCmdArg;
extern char *SCRIPT_CommandTextPtr;
extern WORD SCRIPT_ReadModeActiveLatch;
extern WORD ESQPARS2_ReadModeFlags;
extern WORD SCRIPT_PlaybackFallbackCounter;

extern void SCRIPT_LoadCtrlContextSnapshot(char *ctx);
extern void SCRIPT_SaveCtrlContextSnapshot(char *ctx);
extern LONG SCRIPT_SelectPlaybackCursorFromSearchText(LONG matchCountOrIndex, char *parseBuffer);
extern void SCRIPT_SplitAndNormalizeSearchBuffer(char *parseBuffer, LONG parseLen);
extern void TEXTDISP_HandleScriptCommand(LONG command, LONG arg, char *text);
extern char *ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(char *newValue, char *oldValue);

LONG SCRIPT_HandleBrushCommand(char *ctx, char *cmd, LONG cmdLen)
{
    LONG ok;
    WORD savedRuntimeMode;
    LONG sub;

    ok = 1;
    savedRuntimeMode = SCRIPT_RuntimeMode;
    SCRIPT_LoadCtrlContextSnapshot(ctx);

    SCRIPT_PlaybackCursor = 0;
    cmd[cmdLen] = 0;

    sub = (LONG)cmd[0] - 1;
    if (sub >= 0 && sub < 22) {
        switch (sub) {
        case 0:
            if (SCRIPT_SelectPlaybackCursorFromSearchText(0, cmd) == 0) {
                ok = 0;
            }
            break;
        case 3:
            if (cmd[1] == 'L') {
                SCRIPT_PrimarySearchFirstFlag = 1;
            } else if (cmd[1] == 'R') {
                SCRIPT_PrimarySearchFirstFlag = 0;
            } else {
                SCRIPT_PrimarySearchFirstFlag = (WORD)(SCRIPT_PrimarySearchFirstFlag == 0);
            }
            break;
        case 4:
            TEXTDISP_PrimaryChannelCode = (WORD)cmd[1];
            TEXTDISP_SecondaryChannelCode = (WORD)cmd[2];
            break;
        case 6:
            SCRIPT_PlaybackCursor = 15;
            break;
        case 10:
            SCRIPT_PlaybackCursor = 2;
            TEXTDISP_CurrentMatchIndex = -1;
            break;
        case 11:
            SCRIPT_PlaybackCursor = 2;
            break;
        case 14:
            SCRIPT_PlaybackCursor = 14;
            break;
        case 15:
            SCRIPT_SplitAndNormalizeSearchBuffer(cmd, cmdLen);
            break;
        case 20:
            SCRIPT_PendingTextdispCmdChar = cmd[1];
            SCRIPT_PendingTextdispCmdArg = cmd[2];
            SCRIPT_CommandTextPtr = ESQPROTO_JMPTBL_ESQPARS_ReplaceOwnedString(cmd + 3, SCRIPT_CommandTextPtr);
            SCRIPT_PendingBannerTargetChar = -2;
            SCRIPT_PlaybackCursor = 9;
            break;
        case 21:
            if (cmd[1] == '9') {
                SCRIPT_ReadModeActiveLatch = 1;
                ESQPARS2_ReadModeFlags = 256;
            } else if (cmd[1] == '8') {
                SCRIPT_PendingTextdispCmdChar = cmd[1];
                SCRIPT_PendingTextdispCmdArg = cmd[2];
                SCRIPT_PlaybackCursor = 8;
            } else {
                SCRIPT_PlaybackFallbackCounter = (WORD)(SCRIPT_PlaybackFallbackCounter + 1);
            }
            break;
        default:
            break;
        }
    }

    SCRIPT_SaveCtrlContextSnapshot(ctx);

    if (SCRIPT_PlaybackCursor != 0) {
        TEXTDISP_HandleScriptCommand(-1, -1, (char *)0);
    }

    SCRIPT_RuntimeMode = savedRuntimeMode;
    return ok;
}
