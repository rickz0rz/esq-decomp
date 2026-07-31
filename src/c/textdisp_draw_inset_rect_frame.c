/* RESTORES: TEXTDISP_DrawInsetRectFrame
 * MODULE:   modules/groups/b/a/textdisp3_p1_p1_p0.s
 * STATUS:   behavioural
 *
 * Draws a text block inset into the display context, choosing between the
 * shared RastPort and the context's own depending on the mode.
 *
 * The two draw calls take the SAME six arguments in the same order; only the
 * RastPort differs. The original proves it by using different register
 * assignments for the two paths (D1/D2/D3/D0 versus D0/D1/D2/D3) while pushing
 * them in the same positional order.
 *
 * Mode 2 and mode 3 are tested SEPARATELY and are not exclusive: mode 2 sets
 * the x inset and then falls into the mode-3 test, so a mode of 2 draws through
 * the context RastPort with a non-zero x. Writing this as an if/else chain
 * would lose that.
 *
 * The x inset is (width / 2) + 1 at WORD width -- the halving is
 * TST.W / BPL / ADDQ.W #1 / ASR.W #1, not the long form.
 *
 * Both dimensions come from the context header at +2 and +4 and are used minus
 * one, and the context's own RastPort is at +10 -- the offset AGENTS.md records
 * for a display context.
 *
 * 162 ref vs 156 got. Both draw calls with all six arguments in the same
 * positional order, the two SUBQ.W #1 dimension adjustments, the word-width
 * halving (4a41 6a02 5241 e241), the ADDQ.W #1 inset, both mode compares and
 * both LEA 24(A7),A7 cleanups match in kind and size -- including the fact that
 * mode 2 falls THROUGH into the mode-3 test rather than branching past it.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     266d0008 2079....86fe 3028 2f0b 43e8000a
 *            the context in A0, the text in A3
 *   got:     2a6f0028 267900000000 382b 2f0d 41eb000a
 *            the context in A3, the text in A5
 *   summary: the two pointers land in different address registers and 6.51
 *            needs one more saved register, which is most of the 6 bytes. Same
 *            instructions otherwise, and the context RastPort is still reached
 *            as a +10 displacement off the context base in both.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 */
struct WDispDisplayContext {
    short f0;
    short width;                /* +2  */
    short height;               /* +4  */
    char  pad6[4];
    char  rast10[1];            /* +10 */
};

extern void TLIBA1_DrawFormattedTextBlock(void *rp, char *text, long x, long y,
                                          long w, long h);

extern struct WDispDisplayContext *WDISP_DisplayContextBase;
extern void *Global_REF_RASTPORT_2;

void TEXTDISP_DrawInsetRectFrame(char *text, short mode)
{
    struct WDispDisplayContext *ctx;
    short x = 0;
    short y = 0;
    short w;
    short h;

    ctx = WDISP_DisplayContextBase;
    w = ctx->width - 1;
    h = ctx->height - 1;

    if (mode == 2)
        x = (short)(w / 2) + 1;

    if (mode == 3)
        TLIBA1_DrawFormattedTextBlock(Global_REF_RASTPORT_2, text,
                                      (long)x, (long)y, (long)w, (long)h);
    else
        TLIBA1_DrawFormattedTextBlock(ctx->rast10, text,
                                      (long)x, (long)y, (long)w, (long)h);
}
