#include <exec/types.h>
extern void *AbsExecBase;
extern UBYTE GCOMMAND_DefaultPresetTable[];
extern UWORD GCOMMAND_PresetWorkResetPendingFlag;

extern void _LVODisable(void *execBase);
extern void _LVOEnable(void *execBase);
extern void _LVOCopyMem(void *execBase, const void *src, void *dst, LONG len);
extern void GCOMMAND_UpdateBannerBounds(LONG a0, LONG a1, LONG a2, LONG a3);

void GCOMMAND_ValidatePresetTable(UWORD *presetTable)
{
    LONG valid = 1;
    LONG row = 0;

    while (valid && row < 16) {
        LONG count = (LONG)presetTable[row];
        LONG col = 0;

        valid = (count > 1 && count <= 0x40) ? 1 : 0;

        while (valid && col < count) {
            UWORD value = *(UWORD *)((UBYTE *)presetTable + (row << 7) + 32 + (col << 1));
            valid = (value < 0x1000) ? 1 : 0;
            ++col;
        }

        ++row;
    }

    if (valid == 0) {
        return;
    }

    _LVODisable(AbsExecBase);
    _LVOCopyMem(AbsExecBase, presetTable, GCOMMAND_DefaultPresetTable, 0x820);
    GCOMMAND_PresetWorkResetPendingFlag = 1;
    GCOMMAND_UpdateBannerBounds(0, 5, 6, 0);
    _LVOEnable(AbsExecBase);
}
