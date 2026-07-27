/* RESTORES: SCRIPT_DrawInsetTextWithFrame
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * 236 bytes in the original, 220 emitted, 10 differing regions.
 *
 * Reproduces: the null/empty guard, the two independent 255-sentinel tests (one
 * gating the frame, one gating the pen change), the cursor nudge of +4 before
 * the frame and the -2/+4 after, the saved-and-restored foreground pen, and both
 * inlined-strlen measurements feeding TextLength and Text.
 *
 * Two details worth recording:
 *
 *   - The 255 sentinel is materialised as MOVEQ #0,D1 / NOT.B D1 rather than an
 *     immediate. That is a THIRD sighting of the MOVEQ + NOT.B constant form
 *     (after cleanup_draw_grid_time_banner.c and esqiff2_show_attention_overlay.c,
 *     both of which used it for 215), and the first where the constant is 255.
 *     It confirms the form is a general rule in the original code generator, not
 *     tied to one value.
 *
 *   - The original reads its parameters off A7 (36(A7), 43(A7), 47(A7), 48(A7))
 *     even though it has built an A5 frame, having accounted for the LINK and the
 *     MOVEM push itself. RastPort fields decode as standard: FgPen 25, cp_x 36,
 *     cp_y 38, TxHeight 58.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55fff8                   LINK.W A5,#-8
 *   got:     594f                       SUBQ.W #4,A7
 *   summary: The A5-frame class; the single saved-pen local needs no frame at
 *            all for SAS/C, which is most of the -16.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the cross-unit frame call.
 */
#include "esq-graphics.h"
#include <string.h>

extern void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(void *rp, long flag,
                                                       long width, long height);

void SCRIPT_DrawInsetTextWithFrame(struct RastPort *rp, char pen, char frameFlag,
                                   char *text)
{
    register char savedPen;

    if (text == 0 || *text == 0)
        return;

    if ((unsigned char)frameFlag != 255) {
        rp->cp_x += 4;
        TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(rp, (long)frameFlag,
                                                   (long)TextLength(rp, text,
                                                                    (long)strlen(text)),
                                                   (long)rp->TxHeight);
    }

    if ((unsigned char)pen != 255) {
        savedPen = rp->FgPen;
        SetAPen(rp, (long)(unsigned char)pen);
    }

    Text(rp, text, (long)strlen(text));

    if ((unsigned char)pen != 255)
        SetAPen(rp, (long)savedPen);

    if ((unsigned char)frameFlag != 255) {
        rp->cp_y -= 2;
        rp->cp_x += 4;
    }
}
