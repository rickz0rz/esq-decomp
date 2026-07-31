/* RESTORES: _TLIBA3_DrawViewModeOverlay
 * MODULE:   modules/groups/b/a/tliba3_p1_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: stride-local-and-dead-field-reads
 *   ref:     4e55ffa848e707002e2d00082007724dd2814eba31ea41f90000cdbc2248d3c07c003c2900022248d3c07a003a290004d1c043e8000a2079000029302c79000028584eaeffbe2007724dd2814eba31b041f90000cdbcd1c043e8000a70004eaeff162007724dd2814eba319441f90000cdbcd1c043e8000a70014eaefe9e2007724dd2814eba317841f90000cdbcd1c043e8000a70014eaefeaa2007724dd2814eba315c41f90000cdbcd1c043e8000a70004eaefea42007724dd2814eba314041f90000cdbcd1c043e8000a2f096100feae2e87487900007814486dffa84eba28f62007724dd2814eba311441f90000cdbcd1c043e8000a4878005a486dffa82f096100fa344ced00e0ff9c4e5d4e75
 *   got:     9efc005848e703022e2f00687c4ddc86200722066100000041f900000000d1c043e8000a2079000000002c79000000004eaeffbe200722066100000041f900000000d1c043e8000a70004eaeff16200722066100000041f900000000d1c043e8000a70014eaefe9e200722066100000041f900000000d1c043e8000a70014eaefeaa200722066100000041f900000000d1c043e8000a70004eaefea4200722066100000041f900000000d1c043e8000a2f09610000002e87487900000000486f001461000000200722066100000041f900000000d1c043e8000a4878005a486f001c2f09610000004fef00184cdf40c0defc00584e754e71
 *   summary: 272 got vs 272 ref, in 10 differing regions -- equal size is NOT a fidelity claim, see AGENTS.md rule 1. It reached the reference size only after the A6 fix below; the leaf header had it at 248, so the original reloads the base exactly where the volatile header does. The 154-byte table stride is held in a local, the lever from tliba1_draw_formatted_text_block.c: written as an ordinary subscript 6.51 strength-reduces every one of the eight index scalings into shift-and-add and the function is 336 bytes; through a stride local it calls the 32x32 helper eight times, which is the original's instruction. It materialises the constant once (7c4d dc86) where the original rebuilds MOVEQ #77 / ADD.L per site, -16. The original also loads two table fields at +2 and +4 into D6 and D5 and never reads them again -- 20 bytes of dead loads that no C source expresses. Uses esq-graphics.h, NOT the leaf header. An earlier version used the leaf header on the claim that its library calls are contiguous. That claim was wrong: the function also calls TLIBA3_DrawCenteredWrappedTextLines, TLIBA3_DrawViewModeGuides and WDISP_SPrintf, which are ESQ assembly and do not preserve A6. a6_audit flagged four call sites reached through a stale base. The volatile header costs 6 bytes a site and is correct.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/text.h>
#include "esq-graphics.h"

struct VmRuntimeEntry {
    char            pad0[2];
    unsigned short  w2;             /* +2 */
    unsigned short  w4;             /* +4 */
    char            pad6[4];
    struct RastPort rp;             /* +10 */
    char            tail[44];       /* entry stride is 154 bytes */
};

extern struct VmRuntimeEntry TLIBA3_VmArrayRuntimeTable[];
extern struct TextFont      *Global_HANDLE_PREVUEC_FONT;
extern char                  TLIBA1_FMT_VIEWMODE_PCT_LD[];

extern void TLIBA3_DrawViewModeGuides(struct RastPort *rp);
extern void WDISP_SPrintf(char *buf, char *fmt, long value);
extern void TLIBA3_DrawCenteredWrappedTextLines(struct RastPort *rp, char *text,
                                                long width);

void TLIBA3_DrawViewModeOverlay(long index)
{
    char buf[88];
    long stride;

    stride = 154;

    SetFont(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp, Global_HANDLE_PREVUEC_FONT);
    SetRast(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp, 0);
    SetDrMd(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp, 1);
    SetAPen(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp, 1);
    SetBPen(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp, 0);
    TLIBA3_DrawViewModeGuides(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp);
    WDISP_SPrintf(buf, TLIBA1_FMT_VIEWMODE_PCT_LD, index);
    TLIBA3_DrawCenteredWrappedTextLines(&((struct VmRuntimeEntry *)((char *)TLIBA3_VmArrayRuntimeTable + index * stride))->rp,
                                        buf, 90);
}
