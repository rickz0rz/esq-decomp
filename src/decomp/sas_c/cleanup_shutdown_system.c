typedef unsigned short UWORD;
typedef long LONG;

#define CLEANUP_NULL 0
#define CLEANUP_LINEHEAD_MODE_PRIMARY 1
#define CLEANUP_LINEHEAD_MODE_SECONDARY 2
#define CLEANUP_REMOVE_GROUP_PRIMARY 1
#define CLEANUP_REMOVE_GROUP_SECONDARY 2
#define CLEANUP_HILITE_PORT_SIZE 34
#define CLEANUP_HILITE_MSG_DEALLOC_LINE 318
#define CLEANUP_HILITE_REPLY_DEALLOC_LINE 319
#define CLEANUP_RASTER_ROWS 5
#define CLEANUP_RASTER_COLS 4
#define CLEANUP_RASTER_ROW_STRIDE 40
#define CLEANUP_RASTER_COL_SHIFT 2
#define CLEANUP_RASTER_PTR_OFFSET 8
#define CLEANUP_EXEC_HOOK_WINDOW_OFFSET 184

extern LONG LOCAVAIL_PrimaryFilterState;
extern LONG LOCAVAIL_SecondaryFilterState;
extern LONG ESQIFF_BrushIniListHead;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQFUNC_PwBrushListHead;
extern LONG ESQIFF_RecordBufferPtr;
extern const char Global_STR_CLEANUP_C_13[];
extern LONG ESQ_HighlightMsgPort;
extern LONG ESQ_HighlightReplyPort;
extern const char Global_STR_CLEANUP_C_14[];
extern const char Global_STR_CLEANUP_C_15[];
extern UWORD WDISP_HighlightRasterHeightPx;
extern LONG ESQDISP_HighlightBitmapTable;
extern const char Global_STR_CLEANUP_C_16[];
extern char *WDISP_WeatherStatusTextPtr;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern LONG Global_REF_BACKED_UP_INTUITION_AUTOREQUEST;
extern LONG Global_REF_BACKED_UP_INTUITION_DISPLAYALERT;
extern LONG Global_REF_INTUITION_LIBRARY;
extern LONG ESQ_ProcessWindowPtrBackup;
extern LONG WDISP_ExecBaseHookPtr;

void _LVOForbid(void);
void GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain(void *state);
void BRUSH_FreeBrushList(void *head, LONG arg0);
void CLEANUP_ClearVertbInterruptServer(void);
void CLEANUP_ClearAud1InterruptVector(void);
void CLEANUP_ClearRbfInterruptAndSerial(void);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
void CLEANUP_ShutdownInputDevices(void);
void CLEANUP_ReleaseDisplayResources(void);
void GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries(void);
void GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers(void);
char *GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(UWORD mode);
void GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(void);
void GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(UWORD group);
void GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(void);
void GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(void);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
LONG GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *file, LONG line, void *rast, LONG width, LONG height);
char *GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(const char *new_ptr, char *old_ptr);
void _LVOSetFunction(void);
void _LVOVBeamPos(void);
void GROUP_AB_JMPTBL_UNKNOWN2A_Stub0(void);
void _LVOPermit(void);

void CLEANUP_ShutdownSystem(void)
{
    LONG rowIndex, colIndex;

    _LVOForbid();

    GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain((void *)&LOCAVAIL_PrimaryFilterState);
    GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain((void *)&LOCAVAIL_SecondaryFilterState);

    BRUSH_FreeBrushList((void *)&ESQIFF_BrushIniListHead, CLEANUP_NULL);
    BRUSH_FreeBrushList((void *)&ESQIFF_GAdsBrushListHead, CLEANUP_NULL);
    BRUSH_FreeBrushList((void *)&ESQIFF_LogoBrushListHead, CLEANUP_NULL);
    BRUSH_FreeBrushList((void *)&ESQFUNC_PwBrushListHead, CLEANUP_NULL);

    CLEANUP_ClearVertbInterruptServer();
    CLEANUP_ClearAud1InterruptVector();
    CLEANUP_ClearRbfInterruptAndSerial();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_13, 260, (void *)ESQIFF_RecordBufferPtr, 9000);

    CLEANUP_ShutdownInputDevices();
    CLEANUP_ReleaseDisplayResources();

    GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries();
    GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers();
    GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(CLEANUP_LINEHEAD_MODE_PRIMARY);
    GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(CLEANUP_LINEHEAD_MODE_SECONDARY);
    GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData();
    GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(CLEANUP_REMOVE_GROUP_SECONDARY);
    GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(CLEANUP_REMOVE_GROUP_PRIMARY);
    GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers();
    GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_14,
        CLEANUP_HILITE_MSG_DEALLOC_LINE,
        (void *)ESQ_HighlightMsgPort,
        CLEANUP_HILITE_PORT_SIZE);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_15,
        CLEANUP_HILITE_REPLY_DEALLOC_LINE,
        (void *)ESQ_HighlightReplyPort,
        CLEANUP_HILITE_PORT_SIZE);

    for (rowIndex = 0; rowIndex < CLEANUP_RASTER_ROWS; rowIndex++) {
        for (colIndex = 0; colIndex < CLEANUP_RASTER_COLS; colIndex++) {
            LONG rasterOffset = GROUP_AG_JMPTBL_MATH_Mulu32(rowIndex, CLEANUP_RASTER_ROW_STRIDE) + (colIndex << CLEANUP_RASTER_COL_SHIFT);
            LONG rasterPtr = *(LONG *)(ESQDISP_HighlightBitmapTable + rasterOffset + CLEANUP_RASTER_PTR_OFFSET);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_16, 329, (void *)rasterPtr, 696, (LONG)WDISP_HighlightRasterHeightPx);
        }
    }

    WDISP_WeatherStatusTextPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)CLEANUP_NULL, WDISP_WeatherStatusTextPtr);
    WDISP_WeatherStatusOverlayTextPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString((const char *)CLEANUP_NULL, WDISP_WeatherStatusOverlayTextPtr);

    _LVOSetFunction();
    _LVOSetFunction();
    _LVOVBeamPos();

    if (ESQ_ProcessWindowPtrBackup != CLEANUP_NULL) {
        *(LONG *)(WDISP_ExecBaseHookPtr + CLEANUP_EXEC_HOOK_WINDOW_OFFSET) = ESQ_ProcessWindowPtrBackup;
    }

    GROUP_AB_JMPTBL_UNKNOWN2A_Stub0();
    _LVOPermit();
}
