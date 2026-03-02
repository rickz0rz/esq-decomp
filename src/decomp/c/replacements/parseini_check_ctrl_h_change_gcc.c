#include "esq_types.h"

extern u16 CTRL_H;
extern u16 CTRL_HPreviousSample;
extern u16 PARSEINI_CtrlHChangeGateFlag;
extern u16 PARSEINI_CtrlHClockSnapshot;
extern u16 PARSEINI_CtrlHChangeGateCounter;
extern u16 PARSEINI_CtrlHChangePendingFlag;
extern u16 Global_REF_CLOCKDATA_STRUCT;

void SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(s32, s32) __attribute__((noinline));

s32 PARSEINI_CheckCtrlHChange(void) __attribute__((noinline, used));

s32 PARSEINI_CheckCtrlHChange(void)
{
    s32 changed = ((u16)CTRL_H != (u16)CTRL_HPreviousSample) ? -1 : 0;

    if (changed != 0 && (u16)PARSEINI_CtrlHChangeGateFlag != 0) {
        PARSEINI_CtrlHClockSnapshot = (u16)Global_REF_CLOCKDATA_STRUCT;
        PARSEINI_CtrlHChangeGateCounter = 0;
        if ((u16)PARSEINI_CtrlHChangePendingFlag != 1) {
            PARSEINI_CtrlHChangePendingFlag = 1;
            SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16, 1);
        }
        return changed;
    }

    if ((u16)PARSEINI_CtrlHChangePendingFlag != 0) {
        u16 now = (u16)Global_REF_CLOCKDATA_STRUCT;
        if ((u16)PARSEINI_CtrlHClockSnapshot != now) {
            PARSEINI_CtrlHClockSnapshot = now;
            if ((u16)PARSEINI_CtrlHChangeGateFlag != 0) {
                PARSEINI_CtrlHChangeGateCounter =
                    (u16)((u16)PARSEINI_CtrlHChangeGateCounter + 1);
                if ((u16)PARSEINI_CtrlHChangeGateCounter < 3) {
                    return changed;
                }
            }

            PARSEINI_CtrlHChangePendingFlag = 0;
            SCRIPT3_JMPTBL_ESQDISP_UpdateStatusMaskAndRefresh(16, 0);
        }
    }

    return changed;
}
