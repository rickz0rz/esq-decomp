typedef signed long LONG;
typedef short WORD;

extern WORD Global_WORD_H_VALUE;
extern WORD Global_WORD_T_VALUE;
extern WORD Global_REF_CLOCKDATA_STRUCT;

extern WORD PARSEINI_ClockSecondsSnapshot;
extern WORD PARSEINI_ClockChangeActiveFlag;
extern WORD PARSEINI_ClockChangeSampleCounter;

extern void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(LONG statusMask, LONG statusValue);

LONG PARSEINI_MonitorClockChange(void)
{
    LONG changed;
    WORD secondSample;

    changed = (Global_WORD_H_VALUE != Global_WORD_T_VALUE) ? -1L : 0L;
    if (changed != 0) {
        PARSEINI_ClockSecondsSnapshot = Global_REF_CLOCKDATA_STRUCT;
        if (PARSEINI_ClockChangeActiveFlag == 1) {
            return changed;
        }
        PARSEINI_ClockChangeActiveFlag = 1;
        SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(1L, 1L);
        return changed;
    }

    if (PARSEINI_ClockChangeActiveFlag == 0) {
        return changed;
    }

    secondSample = Global_REF_CLOCKDATA_STRUCT;
    if (secondSample == PARSEINI_ClockSecondsSnapshot) {
        return changed;
    }

    ++PARSEINI_ClockChangeSampleCounter;
    PARSEINI_ClockSecondsSnapshot = secondSample;
    if (PARSEINI_ClockChangeSampleCounter < 3) {
        return changed;
    }

    PARSEINI_ClockChangeActiveFlag = 0;
    SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(1L, 0L);
    return changed;
}
