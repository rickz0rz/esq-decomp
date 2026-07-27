/* RESTORES: CLEANUP_ReleaseDisplayResources
 * MODULE:   modules/groups/a/c/cleanup2.s
 * STATUS:   behavioural
 *
 * 460 bytes in the original, 444 emitted.
 *
 * All four raster-freeing loops reproduce byte-identically, including the
 * loop-head shape (7E00 7003 BE80 6C2C 2007 E580 41F9 ...), the reload of the
 * bound constant inside the loop rather than hoisting it, the ASL.L #2 index
 * scaling, and the fourth loop starting at i=3 rather than 0. The two
 * MEMORY_DeallocateMemory calls and the five-argument FreeRaster argument order
 * (who, line, ptr, width, height) also reproduce.
 *
 * SASC-MISMATCH: unattributed-tail-delta
 *   summary: The 16-byte difference is in the library-close tail, where the
 *            original reloads A6 (MOVEA.L AbsExecBase,A6 / MOVEA.L GfxBase,A6)
 *            more often than SAS/C does between consecutive CloseFont and
 *            CloseLibrary calls.
 *   NOTE:    unlike ed_handle_special_functions_menu.c, this delta is NOT fully
 *            attributed byte-for-byte. It is recorded as a known-unknown rather
 *            than asserted to be benign. Anyone taking this to `exact` on a new
 *            compiler must account for those 16 bytes first.
 *   scope:   sequences of consecutive OS calls sharing a library base.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the seven jump-table calls, all cross-unit in
 *            the original.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

extern void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(char *who, long line, void *p, long size);
extern void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(char *who, long line, void *p, long w, long h);
extern void *Global_REF_96_BYTES_ALLOCATED;
extern struct RastPort *Global_REF_RASTPORT_1;
extern void *WDISP_LivePlaneRasterTable0[];
extern void *WDISP_352x240RasterPtrTable[];
extern void *WDISP_BannerRowScratchRasterTable0[];
extern void *WDISP_DisplayContextPlanePointer0[];
extern void *WDISP_BannerWorkRasterPtr;
extern struct TextFont *Global_HANDLE_PREVUE_FONT;
extern struct TextFont *Global_HANDLE_TOPAZ_FONT;
extern struct TextFont *Global_HANDLE_H26F_FONT;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern struct Library *Global_REF_UTILITY_LIBRARY;
extern struct Library *Global_REF_DISKFONT_LIBRARY;
extern struct Library *Global_REF_DOS_LIBRARY;
extern struct Library *Global_REF_INTUITION_LIBRARY;
extern char Global_STR_CLEANUP_C_6[],  Global_STR_CLEANUP_C_7[];
extern char Global_STR_CLEANUP_C_8[],  Global_STR_CLEANUP_C_9[];
extern char Global_STR_CLEANUP_C_10[], Global_STR_CLEANUP_C_11[];
extern char Global_STR_CLEANUP_C_12[];

void CLEANUP_ReleaseDisplayResources(void)
{
    register long i;

    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_6, 148,
                                            Global_REF_96_BYTES_ALLOCATED, 96);
    GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_7, 152,
                                            Global_REF_RASTPORT_1, 100);
    for (i = 0; i < 3; i++)
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_8, 160,
                                            WDISP_LivePlaneRasterTable0[i], 696, 2);
    for (i = 0; i < 4; i++)
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_9, 169,
                                            WDISP_352x240RasterPtrTable[i], 352, 240);
    for (i = 0; i < 3; i++)
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_10, 178,
                                            WDISP_BannerRowScratchRasterTable0[i], 696, 509);
    for (i = 3; i < 5; i++)
        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_11, 187,
                                            WDISP_DisplayContextPlanePointer0[i], 696, 241);
    GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_12, 200,
                                        WDISP_BannerWorkRasterPtr, 696, 15);

    if (Global_HANDLE_PREVUE_FONT)  CloseFont(Global_HANDLE_PREVUE_FONT);
    if (Global_HANDLE_TOPAZ_FONT)   CloseFont(Global_HANDLE_TOPAZ_FONT);
    if (Global_HANDLE_H26F_FONT)    CloseFont(Global_HANDLE_H26F_FONT);
    if (Global_HANDLE_PREVUEC_FONT) CloseFont(Global_HANDLE_PREVUEC_FONT);
    if (Global_REF_UTILITY_LIBRARY) CloseLibrary(Global_REF_UTILITY_LIBRARY);
    CloseLibrary(Global_REF_DISKFONT_LIBRARY);
    CloseLibrary(Global_REF_DOS_LIBRARY);
    CloseLibrary(Global_REF_INTUITION_LIBRARY);
    CloseLibrary((struct Library *)GfxBase);
}
