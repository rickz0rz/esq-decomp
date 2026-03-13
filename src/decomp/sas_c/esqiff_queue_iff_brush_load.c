typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;
typedef signed short WORD;

typedef struct ESQIFF_BannerBrushResource {
    char pathText[190];
    UBYTE sourceType190;
    UBYTE pad191[43];
    struct ESQIFF_BannerBrushResource *next234;
} ESQIFF_BannerBrushResource;

typedef struct ESQIFF_PendingBrushDescriptor {
    char pathText[128];
    UWORD width128;
    UWORD height130;
    UBYTE pad132[4];
    UBYTE depth136;
    UBYTE pad137[53];
    UBYTE taskState190;
} ESQIFF_PendingBrushDescriptor;

extern LONG ESQIFF_BannerBrushResourceCursor;
extern LONG PARSEINI_BannerBrushResourceHead;
extern LONG CTASKS_PendingIffBrushDescriptor;
extern void *WDISP_WeatherStatusBrushListHead;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UWORD CTASKS_IffTaskState;

extern const char ESQIFF_STR_WEATHER[];
extern const char Global_STR_ESQIFF_C_2[];

extern LONG ESQIFF_JMPTBL_STRING_CompareNoCase(const char *lhs, const char *rhs);
extern void *ESQIFF_JMPTBL_BRUSH_AllocBrushNode(const char *brushLabel, LONG flags);
extern void *ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(void *srcRec);
extern void ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess(void);
extern void ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG size);
extern void ESQIFF_DrawWeatherStatusOverlayIntoBrush(UBYTE *rastCtx);

void ESQIFF_QueueIffBrushLoad(WORD mode)
{
    volatile LONG weatherOverlayGate;
    ESQIFF_BannerBrushResource *cursor;
    ESQIFF_PendingBrushDescriptor *pendingDesc;
    void *overlayBrush;

    weatherOverlayGate = 0;

    if (ESQIFF_BannerBrushResourceCursor == 0 || mode == 1) {
        ESQIFF_BannerBrushResourceCursor = PARSEINI_BannerBrushResourceHead;
    }

    cursor = (ESQIFF_BannerBrushResource *)ESQIFF_BannerBrushResourceCursor;

    if (weatherOverlayGate != 0) {
        if (ESQIFF_JMPTBL_STRING_CompareNoCase(cursor->pathText, ESQIFF_STR_WEATHER) == 0 ||
            mode == 2) {
            if (WDISP_WeatherStatusCountdown > 0 && WDISP_WeatherStatusDigitChar != 48) {
                pendingDesc = (ESQIFF_PendingBrushDescriptor *)
                    ESQIFF_JMPTBL_BRUSH_AllocBrushNode(cursor->pathText, 0);
                CTASKS_PendingIffBrushDescriptor = (LONG)pendingDesc;
                pendingDesc->taskState190 = 11;
                pendingDesc->width128 = 0x280;
                pendingDesc->height130 = 160;
                pendingDesc->depth136 = 3;

                overlayBrush = ESQIFF_JMPTBL_BRUSH_CloneBrushRecord(
                    (void *)CTASKS_PendingIffBrushDescriptor);
                WDISP_WeatherStatusBrushListHead = overlayBrush;
                ESQIFF_DrawWeatherStatusOverlayIntoBrush((UBYTE *)overlayBrush);
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(
                    Global_STR_ESQIFF_C_2,
                    724,
                    (void *)CTASKS_PendingIffBrushDescriptor,
                    238);
            }
        }
    } else if (ESQIFF_BannerBrushResourceCursor != 0) {
        pendingDesc = (ESQIFF_PendingBrushDescriptor *)
            ESQIFF_JMPTBL_BRUSH_AllocBrushNode(cursor->pathText, 0);
        CTASKS_PendingIffBrushDescriptor = (LONG)pendingDesc;
        pendingDesc->taskState190 = 6;
        CTASKS_IffTaskState = 6;
        ESQIFF_JMPTBL_CTASKS_StartIffTaskProcess();
    }

    if (mode != 2 && ESQIFF_BannerBrushResourceCursor != 0) {
        cursor = (ESQIFF_BannerBrushResource *)ESQIFF_BannerBrushResourceCursor;
        ESQIFF_BannerBrushResourceCursor = (LONG)cursor->next234;
    }
}
