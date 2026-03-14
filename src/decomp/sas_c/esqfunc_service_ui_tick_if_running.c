#include <exec/types.h>
extern WORD ESQ_MainLoopUiTickEnabledFlag;

extern void ESQFUNC_ProcessUiFrameTick(void);

void ESQFUNC_ServiceUiTickIfRunning(void)
{
    if (ESQ_MainLoopUiTickEnabledFlag != 0) {
        ESQFUNC_ProcessUiFrameTick();
    }
}
