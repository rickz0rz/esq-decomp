#include <exec/types.h>
extern void CTASKS_IFFTaskCleanup(void);
extern void LADFUNC_UpdateHighlightState(void);
extern void ESQDISP_PropagatePrimaryTitleMetadataToSecondary(void);
extern LONG PARSEINI_TestMemoryAndOpenTopazFont(void **fontHandlePtr, void *textAttr);

void LAB_0386(void)
{
    CTASKS_IFFTaskCleanup();
}

void LADFUNC_UpdateHighlightCycle(void)
{
    LADFUNC_UpdateHighlightState();
}

LONG TEST_MEMORY_AND_OPEN_TOPAZ_FONT(void **fontHandlePtr, void *textAttr)
{
    return PARSEINI_TestMemoryAndOpenTopazFont(fontHandlePtr, textAttr);
}

void ESQDISP_PropagatePrimaryTitleMetadataToSecondary_Return(void)
{
    ESQDISP_PropagatePrimaryTitleMetadataToSecondary();
}
