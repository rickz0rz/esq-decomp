#include <exec/types.h>
extern WORD CTRL_H;
extern WORD CTRL_HPreviousSample;
extern WORD Global_REF_CLOCKDATA_STRUCT;

extern WORD PARSEINI_CtrlHChangeGateFlag;
extern WORD PARSEINI_CtrlHClockSnapshot;
extern WORD PARSEINI_CtrlHChangeGateCounter;
extern WORD PARSEINI_CtrlHChangePendingFlag;

extern void ESQDISP_UpdateStatusMaskAndRefresh(LONG statusMask, LONG statusValue);

LONG PARSEINI_CheckCtrlHChange(void)
{
    const LONG CHANGED_FALSE = 0L;
    const LONG CHANGED_TRUE = -1L;
    const WORD FLAG_FALSE = 0;
    const WORD FLAG_TRUE = 1;
    const LONG STATUSMASK_CTRL_H = 16L;
    const LONG GATE_STABLE_COUNT = 3;
    LONG changed;
    WORD secondSample;

    changed = (CTRL_H != CTRL_HPreviousSample) ? CHANGED_TRUE : CHANGED_FALSE;
    if (changed != 0 && PARSEINI_CtrlHChangeGateFlag != 0) {
        PARSEINI_CtrlHClockSnapshot = Global_REF_CLOCKDATA_STRUCT;
        PARSEINI_CtrlHChangeGateCounter = 0;
        if (PARSEINI_CtrlHChangePendingFlag == FLAG_TRUE) {
            return changed;
        }
        PARSEINI_CtrlHChangePendingFlag = FLAG_TRUE;
        ESQDISP_UpdateStatusMaskAndRefresh(STATUSMASK_CTRL_H, FLAG_TRUE);
        return changed;
    }

    if (PARSEINI_CtrlHChangePendingFlag == FLAG_FALSE) {
        return changed;
    }

    secondSample = Global_REF_CLOCKDATA_STRUCT;
    if (secondSample == PARSEINI_CtrlHClockSnapshot) {
        return changed;
    }

    PARSEINI_CtrlHClockSnapshot = secondSample;
    if (PARSEINI_CtrlHChangeGateFlag != 0) {
        ++PARSEINI_CtrlHChangeGateCounter;
        if (PARSEINI_CtrlHChangeGateCounter < GATE_STABLE_COUNT) {
            return changed;
        }
    }

    PARSEINI_CtrlHChangePendingFlag = FLAG_FALSE;
    ESQDISP_UpdateStatusMaskAndRefresh(STATUSMASK_CTRL_H, CHANGED_FALSE);
    return changed;
}
