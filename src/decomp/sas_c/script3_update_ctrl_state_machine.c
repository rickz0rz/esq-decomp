typedef short WORD;
typedef unsigned char UBYTE;

extern WORD SCRIPT_RuntimeMode;
extern WORD SCRIPT_CtrlHandshakeStage;
extern WORD SCRIPT_CtrlHandshakeRetryCount;
extern UBYTE ED_DiagVinModeChar;
extern WORD Global_UIBusyFlag;
extern char SCRIPT_Tag_YL[];

extern char *STR_FindCharPtr(char *s, WORD c);
extern UBYTE SCRIPT_ReadHandshakeBit3Flag(void);
extern void SCRIPT_DeassertCtrlLineNow(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

static void SCRIPT_RefreshCtrlState(void)
{
    if (STR_FindCharPtr(SCRIPT_Tag_YL, (WORD)ED_DiagVinModeChar) != 0) {
        if (SCRIPT_ReadHandshakeBit3Flag() != 0) {
            SCRIPT_CtrlHandshakeStage = 2;
        } else {
            SCRIPT_CtrlHandshakeStage = 1;
        }
    } else {
        SCRIPT_CtrlHandshakeStage = 0;
    }
}

void SCRIPT_UpdateCtrlStateMachine(void)
{
    SCRIPT_RefreshCtrlState();

    if (SCRIPT_RuntimeMode == 2) {
        if (SCRIPT_CtrlHandshakeStage == 1) {
            SCRIPT_CtrlHandshakeRetryCount = (WORD)(SCRIPT_CtrlHandshakeRetryCount + 1);
            if (SCRIPT_CtrlHandshakeRetryCount >= 3) {
                SCRIPT_CtrlHandshakeRetryCount = 0;
                SCRIPT_RuntimeMode = 3;
                SCRIPT_DeassertCtrlLineNow();
                TEXTDISP_ResetSelectionAndRefresh();
            }
        } else if (SCRIPT_CtrlHandshakeStage == 2) {
            SCRIPT_CtrlHandshakeRetryCount = 0;
        } else if (Global_UIBusyFlag != 0) {
            SCRIPT_RuntimeMode = 3;
        }
    } else {
        SCRIPT_CtrlHandshakeRetryCount = 0;
    }
}
