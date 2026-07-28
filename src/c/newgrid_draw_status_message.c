/* RESTORES: _NEWGRID_DrawStatusMessage
 * MODULE:   modules/groups/b/a/newgrid1b_p2_p1_2.s
 * STATUS:   behavioural
 *
 * Draws the one-line multiplex status banner: a frame, a left and a right
 * bevel, and one centered line of text built from a clock entry and the
 * template pointer GCOMMAND_MplexAtTemplatePtr.
 *
 * The text is fitted by SHORTENING it, not by wrapping. The loop drops one
 * character at a time until TextLength fits three columns less 12 pixels, so a
 * long message is cut rather than clipped by the rastport.
 *
 * The fitted length is measured again for the centering, and that second
 * measurement uses the full three-column width without the 12-pixel margin. The
 * two widths differ on purpose in the original and are reproduced.
 *
 * The frame pen and the text pen are separate globals, so the banner can be
 * drawn in two colors.
 *
 * SASC-MISMATCH: a5-frame
 *   ref:     4e55ff4c                   LINK.W A5,#-180
 *   got:     9efc00a8                   SUBA.W #168,A7
 *   summary: 418 bytes in the original against 444 emitted, +26 over 17
 *            regions. The frame class plus 4EBA against 6100 on the calls.
 *            Not itemised further -- see AGENTS.md rule 3.
 *   scope:   program-wide.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"
#include <string.h>

struct GridCtx {
    char            pad0[32];
    long            visibleLines;   /* 32 */
    char            pad1[16];
    short           headerHalf;     /* 52 */
    char            pad2[6];
    struct RastPort rp;             /* 60 */
};

extern void  NEWGRID_DrawGridFrame(struct GridCtx *ctx, long a, long b, long c,
                                   long d);
extern void  NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(long code,
                                                            char *out);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern void  PARSEINI_JMPTBL_WDISP_SPrintf(char *buf, char *fmt, ...);
extern void  NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
                struct RastPort *rp, long x0, long y0, long x1, long y1);
extern void  NEWGRID_ValidateSelectionCode(struct GridCtx *ctx, long code);

extern long  GCOMMAND_MplexMessageFramePen;
extern long  GCOMMAND_MplexMessageTextPen;
extern char *GCOMMAND_MplexAtTemplatePtr;
extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_ColumnWidthPx;

void NEWGRID_DrawStatusMessage(struct GridCtx *ctx, short code)
{
    char text[132];
    char clock[31];
    char *body;
    long len, drawn, x, y;

    NEWGRID_DrawGridFrame(ctx, 7L, GCOMMAND_MplexMessageFramePen,
                          GCOMMAND_MplexMessageFramePen, 33L);
    NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry((long)code, clock);
    body = NEWGRID2_JMPTBL_STR_SkipClass3Chars(clock);
    PARSEINI_JMPTBL_WDISP_SPrintf(text, GCOMMAND_MplexAtTemplatePtr, body);

    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&ctx->rp, 0L, 0L,
        (long)NEWGRID_ColumnStartXPx + 35, 33L);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(&ctx->rp,
        (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, 33L);

    SetAPen(&ctx->rp, GCOMMAND_MplexMessageTextPen);
    SetDrMd(&ctx->rp, 0L);

    len = (long)strlen(text);
    while (TextLength(&ctx->rp, text, len)
           > (long)NEWGRID_ColumnWidthPx * 3 - 12)
        len--;

    drawn = TextLength(&ctx->rp, text, len);
    x = (long)NEWGRID_ColumnStartXPx
        + ((long)NEWGRID_ColumnWidthPx * 3 - drawn) / 2 + 36;
    y = (34 - (long)ctx->rp.Font->tf_Baseline) / 2
        + (long)ctx->rp.Font->tf_Baseline - 1;
    Move(&ctx->rp, x, y);
    Text(&ctx->rp, text, len);

    ctx->headerHalf = 17;
    ctx->visibleLines = 17;
    NEWGRID_ValidateSelectionCode(ctx, 66L);
}
