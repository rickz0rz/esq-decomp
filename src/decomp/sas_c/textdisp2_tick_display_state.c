typedef signed long LONG;
typedef short WORD;

extern WORD ESQ_GlobalTickCounter;
extern WORD TEXTDISP_TickSuspendFlag;
extern WORD Global_UIBusyFlag;
extern WORD SCRIPT_RuntimeMode;
extern WORD TEXTDISP_DeferredActionCountdown;
extern WORD TEXTDISP_DeferredActionArmed;
extern WORD TEXTDISP_DeferredActionDelayTicks;
extern LONG LOCAVAIL_FilterPrevClassId;
extern WORD Global_RefreshTickCounter;

extern WORD TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan(void);
extern void SCRIPT_AssertCtrlLineIfEnabled(void);
extern void TEXTDISP_UpdateHighlightOrPreview(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);
extern void TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations(void);

void TEXTDISP_TickDisplayState(void)
{
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    const WORD MODE_RUNTIME_PLAYBACK = 2;
    const WORD COUNTDOWN_TRIGGER_A = 3;
    const WORD COUNTDOWN_TRIGGER_B = 2;
    const LONG FILTER_CLASS_INVALID = -1;
    const WORD REFRESH_WRAP = 0xB4;

    ESQ_GlobalTickCounter = FLAG_FALSE;

    if (TEXTDISP_TickSuspendFlag != FLAG_FALSE) {
        TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
        return;
    }

    if (Global_UIBusyFlag == FLAG_FALSE && SCRIPT_RuntimeMode != MODE_RUNTIME_PLAYBACK) {
        if (TEXTDISP_DeferredActionCountdown != FLAG_FALSE && TEXTDISP_DeferredActionArmed != FLAG_FALSE) {
            TEXTDISP_DeferredActionArmed = FLAG_FALSE;

            if (TEXTDISP_DeferredActionCountdown == COUNTDOWN_TRIGGER_A ||
                TEXTDISP_DeferredActionCountdown == COUNTDOWN_TRIGGER_B) {
                TEXTDISP_DeferredActionDelayTicks = TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan();
                SCRIPT_AssertCtrlLineIfEnabled();
                TEXTDISP_UpdateHighlightOrPreview();
            } else if (LOCAVAIL_FilterPrevClassId != FILTER_CLASS_INVALID) {
                LOCAVAIL_FilterPrevClassId = FILTER_CLASS_INVALID;
            }

            if (TEXTDISP_DeferredActionCountdown > FLAG_FALSE) {
                TEXTDISP_DeferredActionCountdown--;
            }
        }

        if (Global_RefreshTickCounter >= REFRESH_WRAP) {
            Global_RefreshTickCounter = FLAG_FALSE;
            TEXTDISP_ResetSelectionAndRefresh();
        }
    } else {
        Global_RefreshTickCounter++;
        if (Global_RefreshTickCounter == FLAG_FALSE) {
            Global_RefreshTickCounter = FLAG_FALSE;
        }
    }

    TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
}
