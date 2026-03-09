typedef signed long LONG;

extern void *AbsExecBase;
extern LONG DesiredMemoryAvailability;
extern void *Global_HANDLE_TOPAZ_FONT;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_REF_DISKFONT_LIBRARY;

extern void _LVOCloseFont(void *graphicsBase, void *font);
extern void _LVOForbid(void *execBase);
extern void * _LVOAllocMem(void *execBase, LONG bytes, LONG flags);
extern void _LVOFreeMem(void *execBase, void *mem, LONG bytes);
extern void _LVOPermit(void *execBase);
extern void * _LVOOpenDiskFont(void *diskfontBase, void *textAttr);

LONG PARSEINI_TestMemoryAndOpenTopazFont(void **fontHandlePtr, void *textAttr)
{
    LONG result;
    void *memoryProbe;

    result = 0;
    if (*fontHandlePtr == (void *)0) {
        return result;
    }

    if (*fontHandlePtr != Global_HANDLE_TOPAZ_FONT) {
        _LVOCloseFont(Global_REF_GRAPHICS_LIBRARY, *fontHandlePtr);
    }

    _LVOForbid(AbsExecBase);
    memoryProbe = _LVOAllocMem(AbsExecBase, DesiredMemoryAvailability, 1);
    if (memoryProbe != (void *)0) {
        _LVOFreeMem(AbsExecBase, memoryProbe, DesiredMemoryAvailability);
    }
    _LVOPermit(AbsExecBase);

    *fontHandlePtr = _LVOOpenDiskFont(Global_REF_DISKFONT_LIBRARY, textAttr);
    if (*fontHandlePtr != (void *)0) {
        result = 1;
    } else {
        *fontHandlePtr = Global_HANDLE_TOPAZ_FONT;
    }

    return result;
}
