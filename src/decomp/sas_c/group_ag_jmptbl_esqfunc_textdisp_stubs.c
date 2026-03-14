#include <exec/types.h>
extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern void ESQFUNC_UpdateRefreshModeState(LONG unusedSuspendFlag, LONG request);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void)
{
    ESQFUNC_ServiceUiTickIfRunning();
}

void GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(LONG unusedSuspendFlag, LONG request)
{
    ESQFUNC_UpdateRefreshModeState(unusedSuspendFlag, request);
}

void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void)
{
    TEXTDISP_ResetSelectionAndRefresh();
}
