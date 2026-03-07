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
    const LONG CHANGED_FALSE = 0L;
    const LONG CHANGED_TRUE = -1L;
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    const LONG SETTLE_SAMPLE_COUNT = 3;
    const LONG STATUSMASK_CLOCK = 1L;
    LONG changed;
    WORD secondSample;

    changed = (Global_WORD_H_VALUE != Global_WORD_T_VALUE) ? CHANGED_TRUE : CHANGED_FALSE;
    if (changed != 0) {
        PARSEINI_ClockSecondsSnapshot = Global_REF_CLOCKDATA_STRUCT;
        if (PARSEINI_ClockChangeActiveFlag == FLAG_TRUE) {
            return changed;
        }
        PARSEINI_ClockChangeActiveFlag = FLAG_TRUE;
        SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(STATUSMASK_CLOCK, STATUSMASK_CLOCK);
        return changed;
    }

    if (PARSEINI_ClockChangeActiveFlag == FLAG_FALSE) {
        return changed;
    }

    secondSample = Global_REF_CLOCKDATA_STRUCT;
    if (secondSample == PARSEINI_ClockSecondsSnapshot) {
        return changed;
    }

    ++PARSEINI_ClockChangeSampleCounter;
    PARSEINI_ClockSecondsSnapshot = secondSample;
    if (PARSEINI_ClockChangeSampleCounter < SETTLE_SAMPLE_COUNT) {
        return changed;
    }

    PARSEINI_ClockChangeActiveFlag = FLAG_FALSE;
    SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(STATUSMASK_CLOCK, CHANGED_FALSE);
    return changed;
}
