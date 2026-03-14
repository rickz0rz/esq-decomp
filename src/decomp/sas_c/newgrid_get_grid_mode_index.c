#include <exec/types.h>
extern LONG NEWGRID_ModeSelectorState;

LONG NEWGRID_GetGridModeIndex(void)
{
    if (NEWGRID_ModeSelectorState == 1) {
        return 1;
    }
    return 6;
}
