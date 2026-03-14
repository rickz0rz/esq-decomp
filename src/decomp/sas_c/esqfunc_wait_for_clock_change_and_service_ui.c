#include <exec/types.h>
extern WORD PARSEINI_MonitorClockChange(void);
extern void ESQFUNC_ServiceUiTickIfRunning(void);

void ESQFUNC_WaitForClockChangeAndServiceUi(void)
{
    for (;;) {
        if (PARSEINI_MonitorClockChange() != 0) {
            return;
        }

        ESQFUNC_ServiceUiTickIfRunning();
    }
}
