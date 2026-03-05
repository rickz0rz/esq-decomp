typedef signed short WORD;

extern WORD ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange(void);
extern void ESQFUNC_ServiceUiTickIfRunning(void);

void ESQFUNC_WaitForClockChangeAndServiceUi(void)
{
    for (;;) {
        if (ESQFUNC_JMPTBL_PARSEINI_MonitorClockChange() != 0) {
            return;
        }

        ESQFUNC_ServiceUiTickIfRunning();
    }
}
