#include "esq_types.h"

extern u16 Global_WORD_H_VALUE;
extern u16 Global_WORD_T_VALUE;
extern u16 Global_REF_CLOCKDATA_STRUCT;
extern u16 PARSEINI_ClockSecondsSnapshot;
extern u16 PARSEINI_ClockChangeActiveFlag;
extern u16 PARSEINI_ClockChangeSampleCounter;

void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(s32, s32) __attribute__((noinline));

s32 PARSEINI_MonitorClockChange(void) __attribute__((noinline, used));

s32 PARSEINI_MonitorClockChange(void)
{
    s32 changed = ((u16)Global_WORD_H_VALUE != (u16)Global_WORD_T_VALUE) ? -1 : 0;

    if (changed != 0) {
        PARSEINI_ClockSecondsSnapshot = (u16)Global_REF_CLOCKDATA_STRUCT;
        if ((u16)PARSEINI_ClockChangeActiveFlag == 1) {
            return changed;
        }

        PARSEINI_ClockChangeActiveFlag = 1;
        SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(1, 1);
        return changed;
    }

    if ((u16)PARSEINI_ClockChangeActiveFlag != 0) {
        u16 now = (u16)Global_REF_CLOCKDATA_STRUCT;
        if ((u16)PARSEINI_ClockSecondsSnapshot != now) {
            PARSEINI_ClockChangeSampleCounter =
                (u16)((u16)PARSEINI_ClockChangeSampleCounter + 1);
            PARSEINI_ClockSecondsSnapshot = now;
            if ((u16)PARSEINI_ClockChangeSampleCounter >= 3) {
                PARSEINI_ClockChangeActiveFlag = 0;
                SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(1, 0);
            }
        }
    }

    return changed;
}
