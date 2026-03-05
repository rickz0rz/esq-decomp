typedef signed short WORD;

extern void *AbsExecBase;
extern WORD Global_UIBusyFlag;
extern WORD CTRL_BufferedByteCount;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_H;
extern WORD Global_RefreshTickCounter;
extern WORD ESQPARS2_ReadModeFlags;

extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);

void DISKIO_ResetCtrlInputStateIfIdle(void)
{
    if (Global_UIBusyFlag != 0) {
        return;
    }

    _LVODisable(AbsExecBase);
    CTRL_BufferedByteCount = 0;
    CTRL_HPreviousSample = 0;
    CTRL_H = 0;
    _LVOEnable(AbsExecBase);

    Global_RefreshTickCounter = 0;
    ESQPARS2_ReadModeFlags = 0;
}
