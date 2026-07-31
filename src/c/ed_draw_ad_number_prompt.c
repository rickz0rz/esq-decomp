/* RESTORES: ED_DrawAdNumberPrompt
 * MODULE:   modules/groups/a/l/ed3bb_p2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: volatile-base-reload
 *   ref:     4e55fffc48e73100487800066100faba22790000870270002c79000028584eaefe9e22790000870270014eaefeaa4879000025aa4878014a487800282f39000087024ebaa5de487800022f390000860e4879000082f84eba10304879000082f84878014a487801542f39000087024ebaa5b24879000025c04878014a487801722f39000087024ebaa59a4879000025c848780168487800282f39000087024ebaa5824fef00504879000025e848780186487800282f39000087024ebaa56622790000870270012c79000028584eaefe9e22790000870270064eaefeaa22790000870270287244243c0000028076624eaefece22790000870270014eaefeaa22790000870270004eaefe9e4879000025ea4878005a487800282f39000087024ebaa5024fef002022790000870270012c79000028584eaefe9e700c23c0000081807e00700ebe806c3041f9000082f8d1c710bc002041f900008460d1c748780001487800022f4800144eba0f0c504f206f000c1080528760ca4239000083066100000a4cdf008c4e5d4e75
 *   got:     594f48e7310248780006610000002279000000002c790000000070004eaefe9e2279000000002c790000000070014eaefeaa4879000000004878014a487800282f390000000061000000487800022f3900000000487900000000610000004879000000004878014a487801542f3900000000610000004879000000004878014a487801722f39000000006100000048790000000048780168487800282f3900000000610000004fef005048790000000048780186487800282f3900000000610000002279000000002c790000000070014eaefe9e2279000000002c790000000070064eaefeaa2279000000002c7900000000702872447450e78a76624eaefece2279000000002c790000000070014eaefeaa2279000000002c790000000070004eaefe9e4879000000004878005a487800282f3900000000610000004fef00202279000000002c790000000070014eaefe9e700c23c0000000007e00700ebe806c3041f900000000d1c710bc002041f900000000d1c748780001487800022f48001861000000504f206f00101080528760ca423900000000610000004cdf408c584f4e75
 *   summary: 420 got vs 394 ref. The original loads the graphics base three times; esq-graphics.h reloads before each of the nine library calls. The help panel, the six text placements at their original coordinates, the fixed-width ad-number render, the 40x68 to 640x98 fill, the cursor offset of 12 and the fourteen-cell space-and-attribute initialisation match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include "esq-graphics.h"

extern struct RastPort *Global_REF_RASTPORT_1;
extern long ED_MaxAdNumber;
extern long ED_EditCursorOffset;
extern char ED_EditBufferScratch[];
extern unsigned char ED_EditBufferLive[];
extern char ED_AdNumberPromptStateBlock;
extern char Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN[];
extern char Global_STR_LEFT_PARENTHESIS_THEN[];
extern char Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2[];
extern char Global_STR_SINGLE_SPACE_4[];
extern char Global_STR_AD_NUMBER_QUESTIONMARK[];

extern void ED_DrawHelpPanels(long mode);
extern void DISPLIB_DisplayTextAtPosition(struct RastPort *rp, long x, long y,
                                          char *text);
extern void GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(char *buf, long value,
                                                   long width);
extern long GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(long hi, long lo);
extern void ED_RedrawCursorChar(void);

void ED_DrawAdNumberPrompt(void)
{
    long i;

    ED_DrawHelpPanels(6);

    SetDrMd(Global_REF_RASTPORT_1, 0);
    SetAPen(Global_REF_RASTPORT_1, 1);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 330,
                                  Global_STR_ENTER_AD_NUMBER_ONE_HYPHEN);
    GROUP_AL_JMPTBL_ESQ_WriteDecFixedWidth(ED_EditBufferScratch, ED_MaxAdNumber,
                                           2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 340, 330,
                                  ED_EditBufferScratch);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 370, 330,
                                  Global_STR_LEFT_PARENTHESIS_THEN);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 360,
                                  Global_STR_PUSH_RETURN_TO_ENTER_SELECTION_2);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 390,
                                  Global_STR_SINGLE_SPACE_4);

    SetDrMd(Global_REF_RASTPORT_1, 1);
    SetAPen(Global_REF_RASTPORT_1, 6);
    RectFill(Global_REF_RASTPORT_1, 40, 68, 640, 98);
    SetAPen(Global_REF_RASTPORT_1, 1);
    SetDrMd(Global_REF_RASTPORT_1, 0);

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 90,
                                  Global_STR_AD_NUMBER_QUESTIONMARK);

    SetDrMd(Global_REF_RASTPORT_1, 1);

    ED_EditCursorOffset = 12;
    for (i = 0; i < 14; i++) {
        ED_EditBufferScratch[i] = ' ';
        ED_EditBufferLive[i] = GROUP_AL_JMPTBL_LADFUNC_PackNibblesToByte(2, 1);
    }

    ED_AdNumberPromptStateBlock = 0;
    ED_RedrawCursorChar();
}
