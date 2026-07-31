/* RESTORES: _SCRIPT_SetupHighlightEffect
 * MODULE:   modules/groups/b/a/script4b_p0_p0_script_setuphighlighteffect.s
 * STATUS:   behavioural
 * OPTIONS:  SHORTINT (see src/c/scopts.txt)
 *
 * Drops the display, renders a highlight banner with inline colour and inset
 * escapes, and raises it again. The text is drawn in RUNS: printable characters
 * accumulate a length and each control byte flushes the run before acting.
 *
 * THE DISPLAY CONTEXT IS BUILT THREE TIMES with two different view modes -- 4
 * to open, 3 to draw into, and 4 again to close. The rastport captured for
 * drawing is the one from the FIRST mode-4 context, taken BEFORE the mode-3
 * context replaces the global. So the text is drawn into a rastport the global
 * no longer points at.
 *
 * THE INPUT STRING IS TRUNCATED IN PLACE. The prefix scan copies up to 128
 * printable characters into a work buffer and then, if it stopped early,
 * writes a NUL at the stopping point of the CALLER'S string. The parse loop
 * that follows therefore walks the truncated text.
 *
 * FOUR CONTROL BYTES, dispatched by chained subtraction from 19:
 *
 *   19  flush the run and skip the byte
 *   20  flush the run through the INSET renderer, then clear the gate flag
 *   24  flush and switch to pen 1
 *   25  flush and switch to pen 3
 *
 * THE RUN LENGTH ONLY COUNTS PRINTABLE CHARACTERS, but the run POINTER covers
 * everything between control bytes. So a run containing a byte below 32 is
 * drawn with a length shorter than its span, and the trailing characters are
 * dropped rather than the low byte being skipped over.
 *
 * THE CENTRING WIDTH IS MEASURED FROM THE PREFIX BUFFER, not from the text that
 * is eventually drawn -- the buffer holds the printable characters with all
 * control bytes removed, which is the right measurement, but it is taken before
 * any inset expansion.
 *
 * The 8-pixel inset allowance is added only when the gate flag is set AND the
 * primary nibble is not 255, the same pair as in
 * tliba1_draw_formatted_text_block.c. The inset control byte then CLEARS that
 * gate, so only the first inset in a string gets the allowance.
 *
 * The baseline is 26 pixels above the context height, and the transition length
 * is the height divided by 1 or 2 depending on bit 2 of the context word, plus
 * 22.
 *
 * 748 ref vs 748 got, 26 differing regions.
 *
 * SHORTINT IS LOAD-BEARING and this is the clearest case in the tranche: the
 * plain form gives 752, SHORTINT gives 748 -- exactly the reference. The
 * dispatch is the chained-subtract shape (`SUBI.W #19` / `SUBQ.W #1` /
 * `SUBQ.W #4` / `SUBQ.W #1`) and the transition-step arithmetic is genuinely a
 * word in the original, so both halves of the AGENTS.md rule apply here at
 * once. Seventh SHORTINT measurement in this tranche, second to be adopted.
 *
 * The size agreement is still not proof -- 26 regions says the streams diverge
 * throughout -- but unlike the coincidental ties elsewhere in this set, here it
 * arrived by making a specific structural change for a stated reason.
 *
 * All three context builds with their differing modes, the copper drop and
 * rise, the palette restore, the divisor test, the transition begin, the
 * truncating prefix scan, the width measurement with its inset allowance, the
 * centring divide, the four-way control dispatch, all four run flushes, the
 * inset render with its gate clear and both pen selections match in kind and
 * size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ff50 ... 2b48fffc   LINK.W A5,#-176 / MOVE.L A0,-4(A5)
 *   got:     the same slots addressed from A7
 *   summary: the frame class, fully cancelled at the totals. A 128-byte work
 *            buffer dominates the frame, so most accesses are displacements
 *            either way and the residual differences net to zero.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-graphics.h"

struct ShCtx {
    short           w0;                 /* +0  */
    short           w2;                 /* +2  */
    short           w4;                 /* +4  */
    char            pad6[4];
    struct RastPort rp;                 /* +10 */
};

extern void  TLIBA3_ClearViewModeRastPort(long mode, long zero);
extern struct ShCtx *TLIBA3_BuildDisplayContextForViewMode(long mode,
                                                           long zero,
                                                           long arg);
extern void  WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern void  WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern void  WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void  SCRIPT_BeginBannerCharTransition(long steps, long delay);
extern void  STRING_CopyPadNul(char *dst, char *src, long n);
extern void  SCRIPT_DrawInsetTextWithFrame(struct RastPort *rp, long low,
                                           long high, char *text);
extern void  TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void);

extern struct ShCtx *WDISP_DisplayContextBase;
extern short WDISP_AccumulatorCaptureActive;
extern short WDISP_AccumulatorFlushPending;
extern char  CLOCK_AlignedInsetRenderGateFlag;
extern unsigned char CLEANUP_AlignedInsetNibblePrimary;
extern unsigned char CLEANUP_AlignedInsetNibbleSecondary;

void SCRIPT_SetupHighlightEffect(char *text)
{
    struct RastPort *rp;
    char *scanPtr;
    char *runStart;
    char *p;
    char  buf[128];
    long  ctxWidth;
    long  textWidth;
    long  runLen;
    long  done;
    long  div;
    long  extra;
    long  n;
    long  w;
    long  x;
    long  y;
    long  h;
    long  pen;
    short steps;
    short c;

    TLIBA3_ClearViewModeRastPort(4L, 0L);

    WDISP_DisplayContextBase =
        TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 3L);

    WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();

    h        = WDISP_DisplayContextBase->w4;
    ctxWidth = WDISP_DisplayContextBase->w2;

    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();
    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();

    if (WDISP_DisplayContextBase->w0 & 4)
        div = 2;
    else
        div = 1;

    steps = (short)MATH_DivS32(h, div);
    steps = steps + 22;

    SCRIPT_BeginBannerCharTransition((long)steps, 500L);

    if (text == 0)
        goto returnPath;
    if (*text == 0)
        goto returnPath;

    rp = &WDISP_DisplayContextBase->rp;

    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending  = 0;

    WDISP_DisplayContextBase =
        TLIBA3_BuildDisplayContextForViewMode(3L, 0L, 0L);

    n = 0;
    p = text;

    while (*p != 0 && n < 128) {
        if ((unsigned char)*p >= 32)
            buf[n++] = *p;
        p++;
    }

    if (*p != 0)
        *p = 0;

    buf[n] = 0;

    w = TextLength(rp, buf, n);

    if (CLOCK_AlignedInsetRenderGateFlag != 0
        && (long)CLEANUP_AlignedInsetNibblePrimary != 255)
        extra = 8;
    else
        extra = 0;

    w += extra;

    x = (ctxWidth - w) / 2;
    y = h - 26;

    textWidth = w;

    SetDrMd(rp, 0L);
    SetAPen(rp, 1L);
    Move(rp, x, y);

    runStart = scanPtr = text;
    runLen = 0;
    done   = 0;

    while (!done) {

        c = (short)(unsigned char)*scanPtr;

        if (c == 0) {

            if (runLen > 0)
                Text(rp, runStart, runLen);
            done = 1;

        } else if (c == 19) {

            if (runLen > 0)
                Text(rp, runStart, runLen);
            runStart = scanPtr + 1;
            runLen   = 0;

        } else if (c == 20) {

            STRING_CopyPadNul(buf, runStart, runLen);
            buf[runLen] = 0;

            SCRIPT_DrawInsetTextWithFrame(
                rp, (long)CLEANUP_AlignedInsetNibbleSecondary,
                (long)CLEANUP_AlignedInsetNibblePrimary, buf);

            runStart = scanPtr + 1;
            runLen   = 0;
            CLOCK_AlignedInsetRenderGateFlag = 0;

        } else if (c == 24 || c == 25) {

            if (runLen > 0)
                Text(rp, runStart, runLen);

            if ((unsigned char)*scanPtr == 24)
                pen = 1;
            else
                pen = 3;

            SetAPen(rp, pen);

            runStart = scanPtr + 1;
            runLen   = 0;

        } else {

            if ((unsigned char)*scanPtr >= 32)
                runLen++;
        }

        scanPtr++;
    }

    WDISP_DisplayContextBase =
        TLIBA3_BuildDisplayContextForViewMode(4L, 0L, 3L);

returnPath:
    TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
}
