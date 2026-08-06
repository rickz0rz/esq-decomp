/* RESTORES: _NEWGRID_InitGridResources
 * MODULE:   modules/groups/b/a/newgrid.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: rastport-pointer-cached
 *   ref:     4a7900006bac6600016033fc000100006bac4eba6d344eba12864eba50602f3c000100014878006448780063487900006bae4eba12644fef001023c000006ba44a806700012422402c79000028584eaeff3a207900006ba4217c000087320004227900006ba470002c79000028584eaefe9e227900006ba42079000029304eaeffbe2f3c000100014878006448780070487900006bb84eba12004fef001023c000006ba84a80670000c022402c79000028584eaeff3a207900006ba8217c0000875a0004227900006ba870002c79000028584eaefe9e227900006ba82079000029304eaeffbe610009a67008227900006ba441f900006bc22c79000028584eaeffca33c00000b40a0640000c33c00000b40c72003200203c00000270908172034eba114c33c00000b40e227900006ba4206900347000302800145380d080508033c00000b40872003200200172024eba111e4a81670e30390000b408534033c00000b408610009284e75
 *   got:     2f0e3039000000006600015833fc0001000000006100000061000000610000002f3c0001000148780064487800634879000000006100000023c0000000004fef00106700011e22402c79000000004eaeff3a207900000000217c0000000000042279000000002c790000000070004eaefe9e2279000000002079000000002c79000000004eaeffbe2f3c0001000148780064487800704879000000006100000023c0000000004fef0010670000b622402c79000000004eaeff3a207900000000217c0000000000042279000000002c790000000070004eaefe9e2279000000002079000000002c79000000004eaeffbe6100000022790000000041f9000000002c790000000070084eaeffca33c0000000000640000c33c00000000072003200704ee788908172036100000033c0000000002279000000002069003470003028001453802200d281508133c100000000080100006708534133c100000000610000002c5f4e754e71
 *   summary: 360 got vs 362 ref, two bytes SHORT. The original reloads the rastport pointer global before each of the four library calls that follow an allocation; 6.51 keeps it in an address register across the SetDrMd/SetFont pair, which is what accounts for the small deficit. Both allocations with their distinct source line numbers, both InitRastPort calls, both bitmap assignments, the sample-width TextLength, the column-start and column-width arithmetic, the row-height computation from the font height and the odd-height correction match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include "esq-graphics.h"

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L

extern short NEWGRID_GridResourcesInitializedFlag;
extern struct RastPort *NEWGRID_MainRastPortPtr;
extern struct RastPort *NEWGRID_HeaderRastPortPtr;
extern struct BitMap    Global_REF_696_400_BITMAP;
extern struct BitMap    WDISP_BannerGridBitmapStruct;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern short NEWGRID_SampleTimeTextWidthPx;
extern short NEWGRID_ColumnStartXPx;
extern short NEWGRID_ColumnWidthPx;
extern short NEWGRID_RowHeightPx;
extern char  Global_STR_44_44_44[];

extern void NEWGRID2_EnsureBuffersAllocated(void);
extern void DISPTEXT_InitBuffers(void);
extern void NEWGRID_InitShowtimeBuckets(void);
extern struct RastPort *MEMORY_AllocateMemory(char *who,
                long line, long size, long flags);
extern void NEWGRID_DrawTopBorderLine(void);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);

void NEWGRID_InitGridResources(void)
{
    if (NEWGRID_GridResourcesInitializedFlag != 0)
        return;
    NEWGRID_GridResourcesInitializedFlag = 1;

    NEWGRID2_EnsureBuffersAllocated();
    DISPTEXT_InitBuffers();
    NEWGRID_InitShowtimeBuckets();

    NEWGRID_MainRastPortPtr = MEMORY_AllocateMemory(
        "NEWGRID.c", 99, 100, MEMF_PUBLIC + MEMF_CLEAR);
    if (NEWGRID_MainRastPortPtr == 0)
        return;
    InitRastPort(NEWGRID_MainRastPortPtr);
    NEWGRID_MainRastPortPtr->BitMap = &Global_REF_696_400_BITMAP;
    SetDrMd(NEWGRID_MainRastPortPtr, 0);
    SetFont(NEWGRID_MainRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_HeaderRastPortPtr = MEMORY_AllocateMemory(
        "NEWGRID.c", 112, 100, MEMF_PUBLIC + MEMF_CLEAR);
    if (NEWGRID_HeaderRastPortPtr == 0)
        return;
    InitRastPort(NEWGRID_HeaderRastPortPtr);
    NEWGRID_HeaderRastPortPtr->BitMap = &WDISP_BannerGridBitmapStruct;
    SetDrMd(NEWGRID_HeaderRastPortPtr, 0);
    SetFont(NEWGRID_HeaderRastPortPtr, Global_HANDLE_PREVUEC_FONT);

    NEWGRID_DrawTopBorderLine();

    NEWGRID_ColumnStartXPx = (NEWGRID_SampleTimeTextWidthPx =
        TextLength(NEWGRID_MainRastPortPtr, Global_STR_44_44_44, 8)) + 12;
    NEWGRID_ColumnWidthPx = (624 - (unsigned short)NEWGRID_ColumnStartXPx) / 3;

    NEWGRID_RowHeightPx =
        ((long)NEWGRID_MainRastPortPtr->Font->tf_YSize - 1) * 2 + 8;
    if ((unsigned short)NEWGRID_RowHeightPx % 2 != 0)
        NEWGRID_RowHeightPx = NEWGRID_RowHeightPx - 1;

    NEWGRID_DrawTopBorderLine();
}
