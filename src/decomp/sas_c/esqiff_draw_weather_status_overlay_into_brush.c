typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern UBYTE WDISP_WeatherStatusBrushIndex;
extern void *WDISP_WeatherStatusOverlayTextPtr;
extern ULONG ESQFUNC_PwBrushListHead;
extern ULONG ESQFUNC_STR_I5[];
extern const char Global_STR_ESQIFF_C_1[];

extern void *ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(void *predicate, void *listHead);
extern UBYTE *ESQPARS_ReplaceOwnedString(void *src, UBYTE *oldPtr);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG pool, void *ptr, LONG size);

void ESQIFF_DrawWeatherStatusOverlayIntoBrush(UBYTE *rastCtx)
{
    void *brush;
    UBYTE *ownedText;
    UBYTE *scan;
    LONG len;
    LONG segmentCount;

    (void)rastCtx;

    brush = ESQIFF_JMPTBL_BRUSH_FindBrushByPredicate(
        (void *)ESQFUNC_STR_I5[(ULONG)WDISP_WeatherStatusBrushIndex],
        (void *)&ESQFUNC_PwBrushListHead);
    (void)brush;

    ownedText = ESQPARS_ReplaceOwnedString(WDISP_WeatherStatusOverlayTextPtr, (UBYTE *)0);
    if (ownedText == (UBYTE *)0) {
        return;
    }

    len = 0;
    while (ownedText[len] != 0) {
        len++;
    }

    segmentCount = 0;
    scan = ownedText;
    while (scan[0] != 0) {
        if (scan[0] == 24) {
            scan[0] = 0;
            segmentCount++;
        }
        scan++;
    }

    scan = ownedText;
    if (scan[0] == 0) {
        scan++;
        segmentCount--;
    }

    if (segmentCount > 10) {
        segmentCount = 10;
    }

    ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_1, 672, ownedText, len + 1);
}
