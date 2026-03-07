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
    const WORD HANDSHAKE_STAGE_NONE = 0;
    const WORD HANDSHAKE_STAGE_WAIT = 1;
    const WORD HANDSHAKE_STAGE_READY = 2;
    if (STR_FindCharPtr(SCRIPT_Tag_YL, (WORD)ED_DiagVinModeChar) != 0) {
        if (SCRIPT_ReadHandshakeBit3Flag() != 0) {
            SCRIPT_CtrlHandshakeStage = HANDSHAKE_STAGE_READY;
        } else {
            SCRIPT_CtrlHandshakeStage = HANDSHAKE_STAGE_WAIT;
        }
    } else {
        SCRIPT_CtrlHandshakeStage = HANDSHAKE_STAGE_NONE;
    }
}

void SCRIPT_UpdateCtrlStateMachine(void)
{
    const WORD RUNTIME_MODE_ACTIVE = 2;
    const WORD RUNTIME_MODE_FALLBACK = 3;
    const WORD HANDSHAKE_STAGE_WAIT = 1;
    const WORD HANDSHAKE_STAGE_READY = 2;
    const WORD HANDSHAKE_RETRY_MAX = 3;
    const WORD COUNT_RESET = 0;
    SCRIPT_RefreshCtrlState();

    if (SCRIPT_RuntimeMode == RUNTIME_MODE_ACTIVE) {
        if (SCRIPT_CtrlHandshakeStage == HANDSHAKE_STAGE_WAIT) {
            SCRIPT_CtrlHandshakeRetryCount = (WORD)(SCRIPT_CtrlHandshakeRetryCount + 1);
            if (SCRIPT_CtrlHandshakeRetryCount >= HANDSHAKE_RETRY_MAX) {
                SCRIPT_CtrlHandshakeRetryCount = COUNT_RESET;
                SCRIPT_RuntimeMode = RUNTIME_MODE_FALLBACK;
                SCRIPT_DeassertCtrlLineNow();
                TEXTDISP_ResetSelectionAndRefresh();
            }
        } else if (SCRIPT_CtrlHandshakeStage == HANDSHAKE_STAGE_READY) {
            SCRIPT_CtrlHandshakeRetryCount = COUNT_RESET;
        } else if (Global_UIBusyFlag != 0) {
            SCRIPT_RuntimeMode = RUNTIME_MODE_FALLBACK;
        }
    } else {
        SCRIPT_CtrlHandshakeRetryCount = COUNT_RESET;
    }
}
