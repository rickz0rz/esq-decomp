typedef signed long LONG;

extern LONG DesiredMemoryAvailability;
extern void *Global_HANDLE_TOPAZ_FONT;

extern void _LVOForbid(void);
extern void _LVOPermit(void);
extern void *_LVOAllocMem(LONG byteSize, LONG flags);
extern void _LVOFreeMem(void *bufferPtr, LONG byteSize);
extern void _LVOCloseFont(void *fontHandle);
extern void *_LVOOpenDiskFont(void *textAttr);

LONG PARSEINI_TestMemoryAndOpenTopazFont(void **fontHandleOut, void *textAttr)
{
    LONG failed;
    void *probe;

    failed = 0;
    if (*fontHandleOut == (void *)0) {
        return failed;
    }

    if (*fontHandleOut != Global_HANDLE_TOPAZ_FONT) {
        _LVOCloseFont(*fontHandleOut);
    }

    _LVOForbid();
    probe = _LVOAllocMem(DesiredMemoryAvailability, 1);
    if (probe != (void *)0) {
        _LVOFreeMem(probe, DesiredMemoryAvailability);
    }
    _LVOPermit();

    *fontHandleOut = _LVOOpenDiskFont(textAttr);
    if (*fontHandleOut == (void *)0) {
        *fontHandleOut = Global_HANDLE_TOPAZ_FONT;
    } else {
        failed = 1;
    }

    return failed;
}
