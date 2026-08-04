/* RESTORES: NEWGRID_DrawShowtimesPrompt
 * MODULE:   modules/groups/b/a/newgrid1bb_p1.s
 * STATUS:   behavioural
 *
 * Draws the banner above the showtimes list: a bevelled frame in two pieces
 * with a centred caption built from the entry's own text.
 *
 * THE CAPTION IS ASSEMBLED FROM FOUR PIECES -- a mode-dependent prefix, the
 * entry tail from +19, a channel separator, and the channel text from +1. Both
 * text fields are run through the control-code skipper first, so the leading
 * markers never reach the buffer.
 *
 * THE CHANNEL TEXT IS SPLIT IN RAVESC MODE. When the select code is RAVESC the
 * suffix is emitted as `first-two` + a dash + `from the third character on`,
 * using a second small buffer whose terminator is written at index 2. In every
 * other mode it is appended whole. So the same data renders as "12-34" or
 * "1234" depending on a global.
 *
 * THE TWO BEVEL CALLS TAKE THEIR ARGUMENTS IN DIFFERENT ORDERS. The first is
 * (rp, 0, 0, x, 33) and the second (rp, x, 0, 695, 33) -- the same function,
 * the same five slots, but the left piece passes its width where the right
 * piece passes its origin. Reading them as one shape draws both halves in the
 * same place.
 *
 * The two x values differ by one: 35 for the left piece's extent and 36 for the
 * right piece's origin, so the frames abut without overlapping.
 *
 * THE CAPTION IS CENTRED OVER THREE COLUMNS, not over the frame -- the width
 * used is `ColumnWidthPx * 3`, and the result is offset by the column start
 * plus the same 36 the right bevel uses. The vertical position centres the
 * font's BASELINE in 34 pixels and then adds the baseline back, less one.
 *
 * BOTH THE SELECTION WORD AND THE LONG ARE SET TO 17 before validating -- one
 * a word at +52, one a long at +32, from the same register.
 *
 * 600 ref vs 592 got, 26 differing regions. The null guard, both control-code
 * skips, the mode-dependent prefix, the counted append, the RAVESC split with
 * its index-2 terminator, both bevel calls with their differing argument
 * orders, the grid frame, both pen changes, the draw mode, the three-column
 * centring, the baseline arithmetic, the text draw and both selection stores
 * match in kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff58 ... 2b48fffc   LINK.W A5,#-168 / MOVE.L A0,-4(A5)
 *   got:     both string pointers kept in registers
 *   summary: the frame class. A 128-byte caption buffer dominates the frame, so
 *            the 8 bytes are in the two pointers the original spills.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

struct NgpCtx {
    char            pad0[32];
    long            f32;                /* +32  */
    char            pad36[16];
    short           w52;                /* +52  */
    char            pad54[6];
    struct RastPort rp;                 /* +60  */
    char            pad160[12];
    struct TextFont *font;              /* +112 */
};

extern char *STR_SkipClass3Chars(char *s);
extern void  STRING_AppendN(char *dst, char *src, long n);
extern void  STRING_AppendAtNull(char *dst, char *src);
extern void  NEWGRID_DrawGridFrame(struct NgpCtx *ctx, long a, long b, long c,
                                   long h);
extern void  BEVEL_DrawBevelFrameWithTopRight(
                 struct RastPort *rp, long a, long b, long c, long d);
extern void  NEWGRID_ValidateSelectionCode(struct NgpCtx *ctx, long code);

extern char *SCRIPT_PtrSummaryOfPrefix;
extern char *SCRIPT_PtrSportsOnPrefix;
extern char *SCRIPT_PtrChannelSuffix;
extern char  NEWGRID_ShowtimeRangeDash[];
extern short Global_WORD_SELECT_CODE_IS_RAVESC;
extern short NEWGRID_RowHeightPx;
extern short NEWGRID_ColumnStartXPx;
extern short NEWGRID_ColumnWidthPx;

void NEWGRID_DrawShowtimesPrompt(struct NgpCtx *ctx, char *entry, long mode)
{
    struct RastPort *rp;
    char *tail;
    char *suffix;
    char  prompt[128];
    char  sbuf[10];
    long  w;
    long  x;
    long  y;

    if (entry == 0)
        return;

    tail   = STR_SkipClass3Chars(entry + 19);
    suffix = STR_SkipClass3Chars(entry + 1);

    if (mode == 0)
        strcpy(prompt, SCRIPT_PtrSummaryOfPrefix);
    else
        strcpy(prompt, SCRIPT_PtrSportsOnPrefix);

    STRING_AppendN(prompt, tail, strlen(tail));

    if (suffix != 0 && *suffix != 0) {

        STRING_AppendAtNull(prompt, SCRIPT_PtrChannelSuffix);

        if (Global_WORD_SELECT_CODE_IS_RAVESC != 0) {

            strcpy(sbuf, suffix);
            sbuf[2] = 0;

            STRING_AppendAtNull(prompt, sbuf);
            STRING_AppendAtNull(prompt,
                                                NEWGRID_ShowtimeRangeDash);
            STRING_AppendAtNull(prompt, suffix + 2);

        } else {
            STRING_AppendAtNull(prompt, suffix);
        }
    }

    rp = &ctx->rp;

    SetAPen(rp, 6L);

    NEWGRID_DrawGridFrame(ctx, 7L, 6L, 6L, (long)NEWGRID_RowHeightPx + 3);

    BEVEL_DrawBevelFrameWithTopRight(
        &ctx->rp, 0L, 0L, (long)NEWGRID_ColumnStartXPx + 35, 33L);

    BEVEL_DrawBevelFrameWithTopRight(
        &ctx->rp, (long)NEWGRID_ColumnStartXPx + 36, 0L, 695L, 33L);

    SetAPen(&ctx->rp, 3L);
    SetDrMd(&ctx->rp, 0L);

    w = TextLength(&ctx->rp, prompt, strlen(prompt));

    x = (long)NEWGRID_ColumnStartXPx
        + ((long)NEWGRID_ColumnWidthPx * 3 - w) / 2 + 36;

    y = (34 - (long)ctx->font->tf_Baseline) / 2
        + (long)ctx->font->tf_Baseline - 1;

    Move(&ctx->rp, x, y);

    Text(&ctx->rp, prompt, strlen(prompt));

    ctx->w52 = 17;
    ctx->f32 = 17;

    NEWGRID_ValidateSelectionCode(ctx, 67L);
}
