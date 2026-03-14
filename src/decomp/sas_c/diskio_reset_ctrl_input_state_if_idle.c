#include <exec/types.h>
enum {
    DISKIO_STATE_CLEAR = 0
};

extern WORD Global_UIBusyFlag;
extern WORD CTRL_BufferedByteCount;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_H;
extern WORD Global_RefreshTickCounter;
extern WORD ESQPARS2_ReadModeFlags;

extern void *AbsExecBase;
extern void _LVODisable(void);
extern void _LVOEnable(void);

void DISKIO_ResetCtrlInputStateIfIdle(void)
{
    if (Global_UIBusyFlag != DISKIO_STATE_CLEAR) {
        return;
    }

    (void)AbsExecBase;

    _LVODisable();
    CTRL_BufferedByteCount = DISKIO_STATE_CLEAR;
    CTRL_HPreviousSample = DISKIO_STATE_CLEAR;
    CTRL_H = DISKIO_STATE_CLEAR;
    _LVOEnable();

    Global_RefreshTickCounter = DISKIO_STATE_CLEAR;
    ESQPARS2_ReadModeFlags = DISKIO_STATE_CLEAR;
}
