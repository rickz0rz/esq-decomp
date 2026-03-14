#include <exec/types.h>
extern LONG TLIBA1_CurrentViewModeIndex;
extern LONG WDISP_DisplayContextBase;

extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a1, LONG a2);
extern void TLIBA3_DrawViewModeOverlay(LONG viewMode);

void TLIBA3_SelectNextViewMode(void)
{
    TLIBA1_CurrentViewModeIndex = (TLIBA1_CurrentViewModeIndex + 1) % 9;
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(
        TLIBA1_CurrentViewModeIndex,
        0,
        -1);
    TLIBA3_DrawViewModeOverlay(TLIBA1_CurrentViewModeIndex);
}
