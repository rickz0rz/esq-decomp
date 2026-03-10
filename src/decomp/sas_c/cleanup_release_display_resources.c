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
LONG GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *file, LONG line, void *rast, LONG width, LONG height);
void _LVOCloseFont(void);
void _LVOCloseLibrary(void);

void CLEANUP_ReleaseDisplayResources(void)
{
    const LONG ALLOC96_SIZE = 96;
    const LONG RASTPORT1_SIZE = 100;
    const LONG RASTER_TABLE_COUNT = 4;
    const LONG PTR_STRIDE_SHIFT = 2;
    const LONG RASTER_WIDE = 696;
    const LONG RASTER_NARROW = 352;
    const LONG RASTER_H_2 = 2;
    const LONG RASTER_H_34 = 34;
    const LONG RASTER_H_240 = 240;
    const LONG FREE96_LINE = 148;
    const LONG FREE_RP_LINE = 152;
    const LONG FREE_LIVE_LINE = 158;
    const LONG FREE_352_LINE = 163;
    const LONG FREE_BANNER_LINE = 168;
    const LONG FREE_CTX_LINE = 173;
    const LONG FREE_WORK_LINE = 178;
    LONG i;

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_6, FREE96_LINE, (void *)Global_REF_96_BYTES_ALLOCATED, ALLOC96_SIZE);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
        Global_STR_CLEANUP_C_7, FREE_RP_LINE, (void *)Global_REF_RASTPORT_1, RASTPORT1_SIZE);

    for (i = 0; i < RASTER_TABLE_COUNT; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
            Global_STR_CLEANUP_C_8,
            FREE_LIVE_LINE,
            *(void **)(WDISP_LivePlaneRasterTable0 + (i << PTR_STRIDE_SHIFT)),
            RASTER_WIDE,
            RASTER_H_2);
    }
    for (i = 0; i < RASTER_TABLE_COUNT; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
            Global_STR_CLEANUP_C_9,
            FREE_352_LINE,
            *(void **)(WDISP_352x240RasterPtrTable + (i << PTR_STRIDE_SHIFT)),
            RASTER_NARROW,
            RASTER_H_240);
    }
    for (i = 0; i < RASTER_TABLE_COUNT; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
            Global_STR_CLEANUP_C_10,
            FREE_BANNER_LINE,
            *(void **)(WDISP_BannerRowScratchRasterTable0 + (i << PTR_STRIDE_SHIFT)),
            RASTER_WIDE,
            RASTER_H_34);
    }
    for (i = 0; i < RASTER_TABLE_COUNT; i++) {
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
            Global_STR_CLEANUP_C_11,
            FREE_CTX_LINE,
            *(void **)(WDISP_DisplayContextPlanePointer0 + (i << PTR_STRIDE_SHIFT)),
            RASTER_WIDE,
            RASTER_H_240);
    }
    GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
        Global_STR_CLEANUP_C_12, FREE_WORK_LINE, (void *)WDISP_BannerWorkRasterPtr, RASTER_WIDE, RASTER_H_34);

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
