#include <exec/types.h>
extern UBYTE CONFIG_NewgridSelectionCode34PrimaryEnabledFlag;
extern UBYTE CONFIG_NewgridSelectionCode34AltEnabledFlag;

LONG NEWGRID_TestModeFlagActive(LONG mode)
{
    if (mode == 0) {
        if (CONFIG_NewgridSelectionCode34PrimaryEnabledFlag == (UBYTE)89) {
            return 1;
        }
    }

    if (mode == 1) {
        if (CONFIG_NewgridSelectionCode34AltEnabledFlag == (UBYTE)89) {
            return 1;
        }
    }

    return 0;
}
