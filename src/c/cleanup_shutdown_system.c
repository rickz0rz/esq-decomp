/* RESTORES: CLEANUP_ShutdownSystem
 * MODULE:   modules/groups/a/b/cleanup_p1_p0.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     48e703002c7800044eaeff7c48790000b3cc4eba01e448790000b3e44eba01da4297487900005a804ebaee664297487900005a844ebaee5a4297487900005a884ebaee4e4297487900005a8c4ebaee426100fc866100fcb06100fce2487823282f390000a3bc487801044879000002f04eba5f586100fd386100fdba4eba01684eba7c9a487800014eba0180487800024eba01784eba014a487800024eba0136487800014eba012e4eba013020790000285823e8002600dff0804eba0136487800222f39000028c44878013e4879000002fa4eba5ef64fef0048487800222f39000028c84878013f4879000003044eba5eda4fef00107c007004bc806c4a7e007003be806c3e200672284eba5f0641f90000a71ad1c02007e580d1c070003039000087b02f00487802b82f2800084878014948790000030e4eba00c44fef0014528760bc528660b02f39000028e642a74eba3ebe23c0000028e62eb90000295042a74eba3eac4fef000c23c00000295020790000b400200822790000285c307cfea42c7800044eaefe5c20790000b404200822790000285c307cffa64eaefe5c2c790000285c4eaefe804ab9000028cc670e2079000087b22179000028cc00b84eba002a2c7800044eaeff764cdf00c04e750000
 *   got:     48e707027a282c79000000004eaeff7c4879000000006100000048790000000061000000429748790000000061000000429748790000000061000000429748790000000061000000429748790000000061000000610000006100000061000000487823282f390000000048780104487900000000610000006100000061000000610000006100000048780001610000004878000261000000610000004878000261000000487800016100000061000000207900000000d0fc002623d00000000061000000487800222f39000000004878013e487900000000610000004fef0048487800222f39000000004878013f487900000000610000004fef00107e007004be806c4c7c007003bc806c40200722056100000041f900000000d1c02006e580d1c043e8000870003039000000002f00487802b82f1148780149487900000000610000004fef0014528660ba528760ae2f390000000042a76100000023c0000000002eb90000000042a76100000023c0000000004fef000c2279000000002039000000002c7900000000307cfea44eaefe5c2279000000002039000000002c7900000000307cffa64eaefe5c2c79000000004eaefe80203900000000670c207900000000d0fc00b82080610000002c79000000004eaeff764cdf40e04e754e71
 *   summary: 480 got vs 468 ref, first divergence at byte 2. The exec base is reached through the volatile esq-exec.h symbol, six bytes a site, where the original writes MOVEA.L AbsExecBase,A6 in four, at three sites; the intuition base likewise reloads. The 40-byte raster-table stride is held in a local so its scaling calls the 32x32 helper as the original does. The Forbid/Permit bracket, both filter chains, all four brush lists, the three interrupt teardowns, the four record deallocations with their distinct line numbers, the copper-list pointer restore through COP1LCH, the 4x3 raster free loop, both owned-string releases and both SetFunction restores match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include "esq-exec.h"
#include "esq-graphics.h"
#include "esq-intuition.h"

extern long COP1LCH;
extern char  LOCAVAIL_PrimaryFilterState;
extern char  LOCAVAIL_SecondaryFilterState;
extern char *ESQIFF_BrushIniListHead;
extern char *ESQIFF_GAdsBrushListHead;
extern char *ESQIFF_LogoBrushListHead;
extern char *ESQFUNC_PwBrushListHead;
extern char *ESQIFF_RecordBufferPtr;
extern char *ESQ_HighlightMsgPort;
extern char *ESQ_HighlightReplyPort;
extern char  ESQDISP_HighlightBitmapTable[];
extern unsigned short WDISP_HighlightRasterHeightPx;
extern char *WDISP_WeatherStatusTextPtr;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char *Global_REF_BACKED_UP_INTUITION_AUTOREQUEST;
extern char *Global_REF_BACKED_UP_INTUITION_DISPLAYALERT;
extern long  ESQ_ProcessWindowPtrBackup;
extern char *WDISP_ExecBaseHookPtr;
extern char  Global_STR_CLEANUP_C_13[];
extern char  Global_STR_CLEANUP_C_14[];
extern char  Global_STR_CLEANUP_C_15[];
extern char  Global_STR_CLEANUP_C_16[];

extern void LOCAVAIL_FreeResourceChain(char *state);
extern void BRUSH_FreeBrushList(char **head, long flags);
extern void CLEANUP_ClearVertbInterruptServer(void);
extern void CLEANUP_ClearAud1InterruptVector(void);
extern void CLEANUP_ClearRbfInterruptAndSerial(void);
extern void MEMORY_DeallocateMemory(char *who, long line,
                                                    char *ptr, long size);
extern void CLEANUP_ShutdownInputDevices(void);
extern void CLEANUP_ReleaseDisplayResources(void);
extern void LADFUNC_FreeBannerRectEntries(void);
extern void ESQPARS_ClearAliasStringPointers(void);
extern void ESQIFF2_ClearLineHeadTailByMode(long mode);
extern void ESQIFF_DeallocateAdsAndLogoLstData(void);
extern void ESQPARS_RemoveGroupEntryAndReleaseStrings(long mode);
extern void ESQFUNC_FreeLineTextBuffers(void);
extern void NEWGRID_ShutdownGridResources(void);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void GRAPHICS_FreeRaster(char *who, long line, long ptr,
                                                long width, long height);
extern char *ESQPARS_ReplaceOwnedString(char *src, char *owned);
extern void UNKNOWN2A_Stub0(void);

void CLEANUP_ShutdownSystem(void)
{
    long row;
    long col;
    long stride;

    stride = 40;

    Forbid();

    LOCAVAIL_FreeResourceChain(&LOCAVAIL_PrimaryFilterState);
    LOCAVAIL_FreeResourceChain(&LOCAVAIL_SecondaryFilterState);

    BRUSH_FreeBrushList(&ESQIFF_BrushIniListHead, 0);
    BRUSH_FreeBrushList(&ESQIFF_GAdsBrushListHead, 0);
    BRUSH_FreeBrushList(&ESQIFF_LogoBrushListHead, 0);
    BRUSH_FreeBrushList(&ESQFUNC_PwBrushListHead, 0);

    CLEANUP_ClearVertbInterruptServer();
    CLEANUP_ClearAud1InterruptVector();
    CLEANUP_ClearRbfInterruptAndSerial();

    MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_13, 260,
                                            ESQIFF_RecordBufferPtr, 9000);

    CLEANUP_ShutdownInputDevices();
    CLEANUP_ReleaseDisplayResources();
    LADFUNC_FreeBannerRectEntries();
    ESQPARS_ClearAliasStringPointers();
    ESQIFF2_ClearLineHeadTailByMode(1);
    ESQIFF2_ClearLineHeadTailByMode(2);
    ESQIFF_DeallocateAdsAndLogoLstData();
    ESQPARS_RemoveGroupEntryAndReleaseStrings(2);
    ESQPARS_RemoveGroupEntryAndReleaseStrings(1);
    ESQFUNC_FreeLineTextBuffers();

    COP1LCH = *(long *)((char *)GfxBase + 38);

    NEWGRID_ShutdownGridResources();

    MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_14, 318,
                                            ESQ_HighlightMsgPort, 34);
    MEMORY_DeallocateMemory(Global_STR_CLEANUP_C_15, 319,
                                            ESQ_HighlightReplyPort, 34);

    row = 0;
    while (row < 4) {
        col = 0;
        while (col < 3) {
            GRAPHICS_FreeRaster(Global_STR_CLEANUP_C_16, 329,
                *(long *)(ESQDISP_HighlightBitmapTable + row * stride
                          + (col << 2) + 8),
                696, (long)WDISP_HighlightRasterHeightPx);
            col++;
        }
        row++;
    }

    WDISP_WeatherStatusTextPtr = ESQPARS_ReplaceOwnedString(0,
        WDISP_WeatherStatusTextPtr);
    WDISP_WeatherStatusOverlayTextPtr =
        ESQPARS_ReplaceOwnedString(0,
            WDISP_WeatherStatusOverlayTextPtr);

    SetFunction((struct Library *)IntuitionBase, -348,
                (unsigned long (*)())Global_REF_BACKED_UP_INTUITION_AUTOREQUEST);
    SetFunction((struct Library *)IntuitionBase, -90,
                (unsigned long (*)())Global_REF_BACKED_UP_INTUITION_DISPLAYALERT);

    VBeamPos();

    if (ESQ_ProcessWindowPtrBackup != 0)
        *(long *)(WDISP_ExecBaseHookPtr + 184) = ESQ_ProcessWindowPtrBackup;

    UNKNOWN2A_Stub0();
    Permit();
}
