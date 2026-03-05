extern void ESQFUNC_ServiceUiTickIfRunning(void);
extern void ESQFUNC_UpdateRefreshModeState(void);
extern void TEXTDISP_ResetSelectionAndRefresh(void);

void GROUP_AG_JMPTBL_ESQFUNC_ServiceUiTickIfRunning(void)
{
    ESQFUNC_ServiceUiTickIfRunning();
}

void GROUP_AG_JMPTBL_ESQFUNC_UpdateRefreshModeState(void)
{
    ESQFUNC_UpdateRefreshModeState();
}

void GROUP_AG_JMPTBL_TEXTDISP_ResetSelectionAndRefresh(void)
{
    TEXTDISP_ResetSelectionAndRefresh();
}
