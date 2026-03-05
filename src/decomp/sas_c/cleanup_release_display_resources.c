typedef long LONG;

extern LONG Global_REF_96_BYTES_ALLOCATED;
extern LONG Global_REF_RASTPORT_1;
extern LONG WDISP_LivePlaneRasterTable0;
extern LONG WDISP_352x240RasterPtrTable;
extern LONG WDISP_BannerRowScratchRasterTable0;
extern LONG WDISP_DisplayContextPlanePointer0;
extern LONG WDISP_BannerWorkRasterPtr;
extern LONG Global_HANDLE_PREVUE_FONT;
extern LONG Global_HANDLE_TOPAZ_FONT;
extern LONG Global_HANDLE_H26F_FONT;
extern LONG Global_HANDLE_PREVUEC_FONT;
extern LONG Global_REF_UTILITY_LIBRARY;
extern LONG Global_REF_DISKFONT_LIBRARY;
extern LONG Global_REF_DOS_LIBRARY;
extern LONG Global_REF_INTUITION_LIBRARY;
extern LONG Global_REF_GRAPHICS_LIBRARY;
extern char Global_STR_CLEANUP_C_6[];
extern char Global_STR_CLEANUP_C_7[];
extern char Global_STR_CLEANUP_C_8[];
extern char Global_STR_CLEANUP_C_9[];
extern char Global_STR_CLEANUP_C_10[];
extern char Global_STR_CLEANUP_C_11[];
extern char Global_STR_CLEANUP_C_12[];

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *file, LONG line, void *ptr, LONG size);
void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(void *rast, LONG width, LONG height, LONG line, const char *file);
void _LVOCloseFont(void);
void _LVOCloseLibrary(void);

void CLEANUP_ReleaseDisplayResources(void)
{
    LONG i;

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_6, 148, (void *)Global_REF_96_BYTES_ALLOCATED, 96);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_7, 152, (void *)Global_REF_RASTPORT_1, 100);

    for (i = 0; i < 4; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(*(void **)(WDISP_LivePlaneRasterTable0 + (i << 2)), 696, 2, 158, Global_STR_CLEANUP_C_8);
    }
    for (i = 0; i < 4; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(*(void **)(WDISP_352x240RasterPtrTable + (i << 2)), 352, 240, 163, Global_STR_CLEANUP_C_9);
    }
    for (i = 0; i < 4; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(*(void **)(WDISP_BannerRowScratchRasterTable0 + (i << 2)), 696, 34, 168, Global_STR_CLEANUP_C_10);
    }
    for (i = 0; i < 4; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(*(void **)(WDISP_DisplayContextPlanePointer0 + (i << 2)), 696, 240, 173, Global_STR_CLEANUP_C_11);
    }
    GROUP_AB_JMPTBL_GRAPHICS_FreeRaster((void *)WDISP_BannerWorkRasterPtr, 696, 34, 178, Global_STR_CLEANUP_C_12);

    _LVOCloseFont();
    _LVOCloseFont();
    _LVOCloseFont();
    _LVOCloseFont();

    _LVOCloseLibrary();
    _LVOCloseLibrary();
    _LVOCloseLibrary();
    _LVOCloseLibrary();
    _LVOCloseLibrary();
}
