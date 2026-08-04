/* RESTORES: _ED_LoadCurrentAdIntoBuffers
 * MODULE:   modules/groups/a/l/ed3bbbb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55ffd048e7310020390000860a53804879000084604879000082f82f004eba03564fef000c41f9000082f822484a1966fc538993c82e0920390000818cbe806c40d1c790877220600210c1538064fa41f900008460d1c748780001487800022f4800144eba02f8504f7200120020390000818c9087206f000c600210c1538064fa41f9000082f8d1f90000818c4210700123c0000086126100f7dc700023c00000818023c00000818423c0000081902f006100f630700123c0000023282e806100f5a422790000870270072c79000028584eaefeaa700890b9000085ca721e4eba4cd2223c0000012e92802279000087027028243c00000280263c000001344eaefece70001039000084602e806100f48c22790000870270012c79000028584eaefeaa22790000870270074eaefea42eb90000860a4879000026d2486dffd44eba10b2486dffd44878012c487800be2f39000087024eba97b222790000870270012c79000028584eaefe9e22790000870270024eaefea46100f2f84ced008cffc44e5d4e75
 *   got:     9efc003048e733027c1e20390000000053804879000000004879000000002f00610000004fef000c41f90000000022484a1966fc538993c82e09203900000000be806c3cd1c790877220600210c1538064fa41f900000000d1c748780001487800022f48001c61000000504f2239000000009287206f0014600210c0538164fa41f900000000d1f9000000004210700123c00000000061000000700023c00000000023c00000000023c0000000002f0061000000700123c0000000002e80610000002279000000002c790000000070074eaefeaa700890b900000000220661000000223c0000012e92802279000000002c790000000070287450e78a764de58b4eaefece70001039000000002e80610000002279000000002c790000000070014eaefeaa2279000000002c790000000070074eaefea42eb900000000487900000000486f002061000000486f00244878012c487800be2f3900000000610000002279000000002c790000000070014eaefe9e2279000000002c790000000070024eaefea4610000004fef001c4cdf40ccdefc00304e754e71
 *   summary: 408 got vs 390 ref. The original loads the graphics base three times; esq-graphics.h reloads before each of the eight library calls. The row height of 30 is held in a local so the fill-height scaling calls the 32x32 helper as the original does. The buffer build, both variable-length memset fills of the text and attribute buffers, the terminating NUL at the block offset, the three chained zero stores, both draw helpers, the RectFill whose top edge scales with the text limit, the colour indicator, the ad-number label and the two pen restores match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <string.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_BlockOffset;
extern long ED_TextLimit;
extern long ED_AdDisplayResetFlag;
extern long ED_EditCursorOffset;
extern long ED_ViewportOffset;
extern long Global_REF_LONG_CURRENT_EDITING_AD_NUMBER;
extern long Global_REF_BOOL_IS_LINE_OR_PAGE;
extern long Global_REF_BOOL_IS_TEXT_OR_CURSOR;
extern char ED_EditBufferScratch[];
extern unsigned char ED_EditBufferLive[];
extern char Global_STR_EDITING_AD_NUMBER_FORMATTED_2[];

extern void LADFUNC_BuildEntryBuffersOrDefault(long index,
                char *text, unsigned char *attr);
extern long LADFUNC_ComposePackedPenByte(long hi, long lo);
extern void ED_RedrawAllRows(void);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(long mode);
extern void SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(long mode);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern void ED_DrawCurrentColorIndicator(long pen);
extern void WDISP_SPrintf(char *buf, char *fmt, long n);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern void ED_RedrawCursorChar(void);

void ED_LoadCurrentAdIntoBuffers(void)
{
    char label[44];
    long len;
    long rows;

    rows = 30;

    LADFUNC_BuildEntryBuffersOrDefault(
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER - 1, ED_EditBufferScratch,
        ED_EditBufferLive);

    len = strlen(ED_EditBufferScratch);
    if (len < ED_BlockOffset) {
        memset(ED_EditBufferScratch + len, ' ', ED_BlockOffset - len);
        memset(ED_EditBufferLive + len,
               LADFUNC_ComposePackedPenByte(2, 1),
               ED_BlockOffset - len);
    }
    ED_EditBufferScratch[ED_BlockOffset] = 0;

    ED_AdDisplayResetFlag = 1;
    ED_RedrawAllRows();

    ED_EditCursorOffset = ED_ViewportOffset = Global_REF_BOOL_IS_LINE_OR_PAGE = 0;
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_LINE_OR_PAGE(0);
    Global_REF_BOOL_IS_TEXT_OR_CURSOR = 1;
    SET_A_PEN_1_B_PEN_6_DRMD_1_DRAW_TEXT_OR_CURSOR(1);

    SetAPen(Global_REF_RASTPORT_1, 7);
    RectFill(Global_REF_RASTPORT_1, 40, 302 - (8 - ED_TextLimit) * rows, 640,
             308);

    ED_DrawCurrentColorIndicator((long)ED_EditBufferLive[0]);

    SetAPen(Global_REF_RASTPORT_1, 1);
    SetBPen(Global_REF_RASTPORT_1, 7);

    WDISP_SPrintf(label,
        Global_STR_EDITING_AD_NUMBER_FORMATTED_2,
        Global_REF_LONG_CURRENT_EDITING_AD_NUMBER);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 190, 300, label);

    SetDrMd(Global_REF_RASTPORT_1, 1);
    SetBPen(Global_REF_RASTPORT_1, 2);
    ED_RedrawCursorChar();
}
