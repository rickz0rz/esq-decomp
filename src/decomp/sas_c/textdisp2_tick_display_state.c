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
    ESQ_GlobalTickCounter = 0;

    if (TEXTDISP_TickSuspendFlag != 0) {
        TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
        return;
    }

    if (Global_UIBusyFlag == 0 && SCRIPT_RuntimeMode != 2) {
        if (TEXTDISP_DeferredActionCountdown != 0 && TEXTDISP_DeferredActionArmed != 0) {
            TEXTDISP_DeferredActionArmed = 0;

            if (TEXTDISP_DeferredActionCountdown == 3 || TEXTDISP_DeferredActionCountdown == 2) {
                TEXTDISP_DeferredActionDelayTicks = TEXTDISP2_JMPTBL_LOCAVAIL_GetFilterWindowHalfSpan();
                SCRIPT_AssertCtrlLineIfEnabled();
                TEXTDISP_UpdateHighlightOrPreview();
            } else if (LOCAVAIL_FilterPrevClassId != -1) {
                LOCAVAIL_FilterPrevClassId = -1;
            }

            if (TEXTDISP_DeferredActionCountdown > 0) {
                TEXTDISP_DeferredActionCountdown--;
            }
        }

        if (Global_RefreshTickCounter >= 0xB4) {
            Global_RefreshTickCounter = 0;
            TEXTDISP_ResetSelectionAndRefresh();
        }
    } else {
        Global_RefreshTickCounter++;
        if (Global_RefreshTickCounter == 0) {
            Global_RefreshTickCounter = 0;
        }
    }

    TEXTDISP2_JMPTBL_ESQIFF_RunPendingCopperAnimations();
}
