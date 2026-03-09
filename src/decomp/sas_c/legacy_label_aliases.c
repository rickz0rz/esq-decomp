typedef signed long LONG;

extern LONG CTASKS_IFFTaskCleanup(void);
extern void LADFUNC_UpdateHighlightState(void);
extern LONG PARSEINI_TestMemoryAndOpenTopazFont(void **fontHandlePtr, void *textAttr);

LONG LAB_0386(void)
{
    return CTASKS_IFFTaskCleanup();
}

void LADFUNC_UpdateHighlightCycle(void)
{
    LADFUNC_UpdateHighlightState();
}

LONG TEST_MEMORY_AND_OPEN_TOPAZ_FONT(void **fontHandlePtr, void *textAttr)
{
    return PARSEINI_TestMemoryAndOpenTopazFont(fontHandlePtr, textAttr);
}
