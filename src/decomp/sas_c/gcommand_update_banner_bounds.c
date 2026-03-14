#include <exec/types.h>
extern void *AbsExecBase;
extern WORD Global_UIBusyFlag;

extern LONG GCOMMAND_BannerBoundLeft;
extern LONG GCOMMAND_BannerBoundTop;
extern LONG GCOMMAND_BannerBoundRight;
extern LONG GCOMMAND_BannerBoundBottom;
extern LONG GCOMMAND_BannerStepLeft;
extern LONG GCOMMAND_BannerStepTop;
extern LONG GCOMMAND_BannerStepRight;
extern LONG GCOMMAND_BannerStepBottom;
extern WORD GCOMMAND_BannerRebuildPendingFlag;

extern LONG GCOMMAND_ComputePresetIncrement(LONG presetIndex, LONG span);
extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);

void GCOMMAND_UpdateBannerBounds(LONG left, LONG top, LONG right, LONG bottom)
{
    LONG seed;

    GCOMMAND_BannerBoundLeft = left;
    GCOMMAND_BannerBoundTop = top;
    GCOMMAND_BannerBoundRight = right;
    GCOMMAND_BannerBoundBottom = bottom;

    if (Global_UIBusyFlag != 0) {
        seed = 0;
    } else {
        seed = 17;
    }

    GCOMMAND_BannerStepLeft = GCOMMAND_ComputePresetIncrement(left, seed);
    GCOMMAND_BannerStepTop = GCOMMAND_ComputePresetIncrement(top, seed);
    GCOMMAND_BannerStepRight = GCOMMAND_ComputePresetIncrement(right, seed);
    GCOMMAND_BannerStepBottom = GCOMMAND_ComputePresetIncrement(bottom, seed);

    _LVODisable(AbsExecBase);
    GCOMMAND_BannerRebuildPendingFlag = 1;
    _LVOEnable(AbsExecBase);
}
