typedef signed long LONG;
typedef short WORD;

extern WORD CTRL_H;
extern WORD CTRL_HPreviousSample;
extern WORD Global_REF_CLOCKDATA_STRUCT;

extern WORD PARSEINI_CtrlHChangeGateFlag;
extern WORD PARSEINI_CtrlHClockSnapshot;
extern WORD PARSEINI_CtrlHChangeGateCounter;
extern WORD PARSEINI_CtrlHChangePendingFlag;

extern void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(LONG statusMask, LONG statusValue);

LONG PARSEINI_CheckCtrlHChange(void)
{
    LONG changed;
    WORD secondSample;

    changed = (CTRL_H != CTRL_HPreviousSample) ? -1L : 0L;
    if (changed != 0 && PARSEINI_CtrlHChangeGateFlag != 0) {
        PARSEINI_CtrlHClockSnapshot = Global_REF_CLOCKDATA_STRUCT;
        PARSEINI_CtrlHChangeGateCounter = 0;
        if (PARSEINI_CtrlHChangePendingFlag == 1) {
            return changed;
        }
        PARSEINI_CtrlHChangePendingFlag = 1;
        SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16L, 1L);
        return changed;
    }

    if (PARSEINI_CtrlHChangePendingFlag == 0) {
        return changed;
    }

    secondSample = Global_REF_CLOCKDATA_STRUCT;
    if (secondSample == PARSEINI_CtrlHClockSnapshot) {
        return changed;
    }

    PARSEINI_CtrlHClockSnapshot = secondSample;
    if (PARSEINI_CtrlHChangeGateFlag != 0) {
        ++PARSEINI_CtrlHChangeGateCounter;
        if (PARSEINI_CtrlHChangeGateCounter < 3) {
            return changed;
        }
    }

    PARSEINI_CtrlHChangePendingFlag = 0;
    SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16L, 0L);
    return changed;
}
