typedef unsigned short UWORD;
typedef long LONG;

extern LONG LOCAVAIL_PrimaryFilterState;
extern LONG LOCAVAIL_SecondaryFilterState;
extern LONG ESQIFF_BrushIniListHead;
extern LONG ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_LogoBrushListHead;
extern LONG ESQFUNC_PwBrushListHead;
extern LONG ESQIFF_RecordBufferPtr;
extern char Global_STR_CLEANUP_C_13[];
extern LONG ESQ_HighlightMsgPort;
extern LONG ESQ_HighlightReplyPort;
extern char Global_STR_CLEANUP_C_14[];
extern char Global_STR_CLEANUP_C_15[];
extern UWORD WDISP_HighlightRasterHeightPx;
extern LONG ESQDISP_HighlightBitmapTable;
extern char Global_STR_CLEANUP_C_16[];
extern LONG WDISP_WeatherStatusTextPtr;
extern LONG WDISP_WeatherStatusOverlayTextPtr;
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
void GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(LONG mode);
void GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData(void);
void GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(LONG group);
void GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers(void);
void GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources(void);
LONG GROUP_AG_JMPTBL_MATH_Mulu32(LONG a, LONG b);
void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(void *rast, LONG width, LONG height, LONG line, const char *file);
LONG GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(LONG old_ptr, LONG new_ptr);
void _LVOSetFunction(void);
void _LVOVBeamPos(void);
void GROUP_AB_JMPTBL_UNKNOWN2A_Stub0(void);
void _LVOPermit(void);

void CLEANUP_ShutdownSystem(void)
{
    LONG r, c;

    _LVOForbid();

    GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain((void *)&LOCAVAIL_PrimaryFilterState);
    GROUP_AB_JMPTBL_LOCAVAIL_FreeResourceChain((void *)&LOCAVAIL_SecondaryFilterState);

    BRUSH_FreeBrushList((void *)&ESQIFF_BrushIniListHead, 0);
    BRUSH_FreeBrushList((void *)&ESQIFF_GAdsBrushListHead, 0);
    BRUSH_FreeBrushList((void *)&ESQIFF_LogoBrushListHead, 0);
    BRUSH_FreeBrushList((void *)&ESQFUNC_PwBrushListHead, 0);

    CLEANUP_ClearVertbInterruptServer();
    CLEANUP_ClearAud1InterruptVector();
    CLEANUP_ClearRbfInterruptAndSerial();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_13, 260, (void *)ESQIFF_RecordBufferPtr, 9000);

    CLEANUP_ShutdownInputDevices();
    CLEANUP_ReleaseDisplayResources();

    GROUP_AB_JMPTBL_LADFUNC_FreeBannerRectEntries();
    GROUP_AH_JMPTBL_ESQPARS_ClearAliasStringPointers();
    GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(1);
    GROUP_AB_JMPTBL_ESQIFF2_ClearLineHeadTailByMode(2);
    GROUP_AB_JMPTBL_ESQIFF_DeallocateAdsAndLogoLstData();
    GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(2);
    GROUP_AB_JMPTBL_ESQPARS_RemoveGroupEntryAndReleaseStrings(1);
    GROUP_AB_JMPTBL_ESQFUNC_FreeLineTextBuffers();
    GROUP_AB_JMPTBL_NEWGRID_ShutdownGridResources();

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_14, 318, (void *)ESQ_HighlightMsgPort, 34);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_15, 319, (void *)ESQ_HighlightReplyPort, 34);

    for (r = 0; r < 5; r++) {
        for (c = 0; c < 4; c++) {
            LONG off = GROUP_AG_JMPTBL_MATH_Mulu32(r, 40) + (c << 2);
            LONG rast = *(LONG *)(ESQDISP_HighlightBitmapTable + off + 8);
            GROUP_AB_JMPTBL_GRAPHICS_FreeRaster((void *)rast, 696, (LONG)WDISP_HighlightRasterHeightPx, 329, Global_STR_CLEANUP_C_16);
        }
    }

    WDISP_WeatherStatusTextPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(WDISP_WeatherStatusTextPtr, 0);
    WDISP_WeatherStatusOverlayTextPtr = GROUP_AE_JMPTBL_ESQPARS_ReplaceOwnedString(WDISP_WeatherStatusOverlayTextPtr, 0);

    _LVOSetFunction();
    _LVOSetFunction();
    _LVOVBeamPos();

    if (ESQ_ProcessWindowPtrBackup != 0) {
        *(LONG *)(WDISP_ExecBaseHookPtr + 184) = ESQ_ProcessWindowPtrBackup;
    }

    GROUP_AB_JMPTBL_UNKNOWN2A_Stub0();
    _LVOPermit();
}
