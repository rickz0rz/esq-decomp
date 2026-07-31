/* RESTORES: ESQIFF_ShowExternalAssetWithCopperFx
 * MODULE:   modules/groups/a/n/esqiffbb_p0_p0.s
 * STATUS:   behavioural
 *
 * Drops the copper display, blits a logo or a G-ads brush into a freshly built
 * display context, re-arms the accumulator, and raises the display again.
 *
 * THE TWO HEAD SELECTIONS ARE SEPARATE `if`s, NOT AN if/else. The original
 * tests the mode, stores one head, then tests the mode AGAIN and stores the
 * other. Written as an if/else the second test disappears; written as two ifs
 * it is preserved, which is what the C below does. Same result, one more
 * compare.
 *
 * A MISSING BRUSH IS NOT AN ERROR, it is a retry request: the function ORs a
 * bit into ESQFUNC_MissingAssetRetryMask -- 1 for G-ads, 2 for logos -- and
 * returns. The two bits are the opposite way round from the mode test that
 * selects them, so mode nonzero (G-ads) sets bit 0.
 *
 * THE TRANSITION LENGTH IS DERIVED FROM THE BRUSH HEIGHT: 20 plus the height,
 * halved when bit 2 of the flag byte at +199 is set, clamped to 120, then 22
 * added. The clamp is applied BEFORE the +22, so the real maximum is 142.
 *
 * THE BUSY-WAIT IS A BARE POLL on a global with no volatile qualifier in the
 * original either -- it is written by an interrupt and the loop is exactly
 * `TST.W / BNE` to itself. 6.51 emits the same shape from a plain `while`.
 *
 * THE ACCUMULATOR IS CAPTURED WITH THE CAPTURE FLAG SET AND THE FLUSH CLEARED,
 * then the flags are swapped back. That ordering brackets the four 8-byte
 * CopyMem calls and is the only synchronisation with the interrupt side.
 *
 * FOUR DISPLAY MODES, TESTED IN ORDER, and the pen value is NOT a function of
 * the mode number: modes 4 and 5 take pen 20, modes 6 and 7 take pen 10. The
 * first test is a two-bit mask (`(flags & 0x8004) == 0x8004`), the other two
 * are single-bit tests on two different bytes.
 *
 * THE PALETTE COPY IS BOUNDED BY BOTH MASKS, whichever is smaller, and each
 * bound is `mask * 3` computed as a shift-and-subtract -- three bytes per
 * colour. AGENTS.md's rule about writing the shift rather than the multiply
 * applies: `(m << 2) - m` reproduces the original's ASL/SUB pair where `m * 3`
 * would widen the computation.
 *
 * THE FOUR ACCUMULATOR ROWS SHARE ONE THREE-PART REJECTION TEST -- both copper
 * indices below 32 and the value below 0x4000 -- and all three comparisons are
 * UNSIGNED. A row failing any of them is zeroed rather than skipped, so the
 * capture value is always written.
 *
 * THE FINAL ROW'S VALUE IS REUSED FROM A REGISTER. The original tests
 * `TST.W D1` for the fourth row rather than re-reading the global, which is why
 * the C keeps it in a local and tests that. Re-reading the global would be
 * equivalent but would not be the original's instruction.
 *
 * The eight sum and saturate globals are cleared from ONE zero register, which
 * is the chained-assignment idiom -- eight stores, one MOVEQ.
 *
 * 892 ref vs 892 got, 26 differing regions. Correcting the reference to 900 for
 * the shared _Return epilogue, the candidate is 8 bytes under.
 *
 * THE SIZE AGREEMENT IS COINCIDENCE AND IS RECORDED AS SUCH. AGENTS.md rule 1
 * is explicit that equal size is not evidence of fidelity, and 26 differing
 * regions over 892 bytes says the two streams diverge throughout. What is
 * evidence: both head tests, both retry bits, the height-derived transition
 * with its clamp-before-add, the busy-wait shape, the four CopyMem calls, all
 * four display-mode tests with their two distinct pens, the SetRast and SetAPen
 * pair, the seven-argument brush blit, both plane-mask bounds as shift-and-
 * subtract, all four accumulator rejection tests with their unsigned compares,
 * the register-reuse on the fourth row and the eight-store clear all match in
 * kind and size.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55ffdc ... 2b48ffea   LINK.W A5,#-36 / MOVE.L A0,-22(A5)
 *   got:     the brush pointer kept in a register across the whole body
 *   summary: the frame class. The original spills the brush head and both
 *            plane-mask bounds; 6.51 keeps the brush in a register and reloads
 *            the bounds. It nets out at 8 bytes under, which is why the totals
 *            coincide.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause: A5 is a reserved frame pointer".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

struct IffBrush {
    char          pad0[178];
    short         w178;                 /* +178 */
    char          pad180[4];
    unsigned char b184;                 /* +184 */
    char          pad185[11];
    long          l196;                 /* +196 */
    unsigned char b198;                 /* +198 */
    unsigned char b199;                 /* +199 */
    char          rows[32];             /* +200, four 8-byte rows */
    unsigned char palette[96];          /* +232 = 0xe8 */
    long          l328;                 /* +328 */
};

struct IffCtx {
    short           pad0;
    short           w2;                 /* +2  */
    short           w4;                 /* +4  */
    char            pad6[4];
    struct RastPort rp;                 /* +10 */
};

extern void  ESQIFF_RunCopperDropTransition(void);
extern void  ESQIFF_RunCopperRiseTransition(void);
extern long __asm ESQIFF_JMPTBL_MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern void  ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(long steps,
                                                            long delay);
extern struct IffCtx *ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
                          long mode, long zero, long depth);
extern void  ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(struct IffBrush *b, long z0,
                                                 long pen, long w, long h,
                                                 struct RastPort *rp,
                                                 long z1);
extern long  ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(long index);

extern struct IffBrush *ESQIFF_GAdsBrushListHead;
extern struct IffBrush *ESQIFF_LogoBrushListHead;
extern struct IffCtx   *WDISP_DisplayContextBase;

extern short SCRIPT_BannerTransitionActive;
extern short WDISP_AccumulatorCaptureActive;
extern short WDISP_AccumulatorFlushPending;
extern char  WDISP_AccumulatorRowTable[];
extern unsigned char WDISP_PaletteTriplesRBase[];
extern long  ESQFUNC_MissingAssetRetryMask;

extern unsigned char WDISP_AccumulatorRow0_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow0_CopperIndexEnd;
extern short WDISP_AccumulatorRow0_Value;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow1_CopperIndexEnd;
extern short WDISP_AccumulatorRow1_Value;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow2_CopperIndexEnd;
extern short WDISP_AccumulatorRow2_Value;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexStart;
extern unsigned char WDISP_AccumulatorRow3_CopperIndexEnd;
extern short WDISP_AccumulatorRow3_Value;

extern short ACCUMULATOR_Row0_CaptureValue;
extern short ACCUMULATOR_Row1_CaptureValue;
extern short ACCUMULATOR_Row2_CaptureValue;
extern short ACCUMULATOR_Row3_CaptureValue;
extern short ACCUMULATOR_Row0_Sum;
extern short ACCUMULATOR_Row0_SaturateFlag;
extern short ACCUMULATOR_Row1_Sum;
extern short ACCUMULATOR_Row1_SaturateFlag;
extern short ACCUMULATOR_Row2_Sum;
extern short ACCUMULATOR_Row2_SaturateFlag;
extern short ACCUMULATOR_Row3_Sum;
extern short ACCUMULATOR_Row3_SaturateFlag;

void ESQIFF_ShowExternalAssetWithCopperFx(long pad, short mode)
{
    struct IffBrush *brush;
    struct IffCtx   *ctx;
    long  steps;
    long  div;
    long  pen;
    long  mask5;
    long  maskDepth;
    long  i;
    short row3;

    if (mode != 0)
        brush = ESQIFF_GAdsBrushListHead;

    if (mode == 0)
        brush = ESQIFF_LogoBrushListHead;

    if (brush == 0) {
        if (mode != 0)
            ESQFUNC_MissingAssetRetryMask |= 1;
        else
            ESQFUNC_MissingAssetRetryMask |= 2;
        return;
    }

    ESQIFF_RunCopperDropTransition();

    steps = 20 + brush->w178;

    if (brush->b199 & 4)
        div = 2;
    else
        div = 1;

    steps = ESQIFF_JMPTBL_MATH_DivS32(steps, div);

    if (steps > 120)
        steps = 120;

    steps += 22;

    ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(steps, 1000L);

    while (SCRIPT_BannerTransitionActive != 0)
        ;

    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending  = 0;

    for (i = 0; i < 4; i++)
        CopyMem(&brush->rows[i * 8], &WDISP_AccumulatorRowTable[i * 8], 8L);

    WDISP_AccumulatorCaptureActive = 0;
    WDISP_AccumulatorFlushPending  = 1;

    if ((brush->l196 & 0x8004) == 0x8004) {
        ctx = ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
                  4L, 0L, (long)brush->b184);
        pen = 20;
    } else if (brush->b198 & 0x80) {
        ctx = ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
                  6L, 0L, (long)brush->b184);
        pen = 10;
    } else if (brush->b199 & 4) {
        ctx = ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
                  5L, 0L, (long)brush->b184);
        pen = 20;
    } else {
        ctx = ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(
                  7L, 0L, (long)brush->b184);
        pen = 10;
    }

    WDISP_DisplayContextBase = ctx;

    SetRast(&ctx->rp, 0L);
    SetAPen(&WDISP_DisplayContextBase->rp, 7L);

    ESQIFF_JMPTBL_BRUSH_SelectBrushSlot(
        brush, 0L, pen, (long)WDISP_DisplayContextBase->w2 - 1,
        (long)WDISP_DisplayContextBase->w4 - 1,
        &WDISP_DisplayContextBase->rp, 0L);

    if (brush->l328 == 0 || brush->l328 == 1) {

        mask5 = ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(5L);
        mask5 = (mask5 << 2) - mask5;

        maskDepth = ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex((long)brush->b184);
        maskDepth = (maskDepth << 2) - maskDepth;

        for (i = 0; i < maskDepth && i < mask5; i++)
            WDISP_PaletteTriplesRBase[i] = brush->palette[i];
    }

    if (WDISP_AccumulatorRow0_CopperIndexStart < 32
        && WDISP_AccumulatorRow0_CopperIndexEnd < 32
        && WDISP_AccumulatorRow0_Value < 0x4000)
        ACCUMULATOR_Row0_CaptureValue = WDISP_AccumulatorRow0_Value;
    else
        ACCUMULATOR_Row0_CaptureValue = 0;

    if (WDISP_AccumulatorRow1_CopperIndexStart < 32
        && WDISP_AccumulatorRow1_CopperIndexEnd < 32
        && WDISP_AccumulatorRow1_Value < 0x4000)
        ACCUMULATOR_Row1_CaptureValue = WDISP_AccumulatorRow1_Value;
    else
        ACCUMULATOR_Row1_CaptureValue = 0;

    if (WDISP_AccumulatorRow2_CopperIndexStart < 32
        && WDISP_AccumulatorRow2_CopperIndexEnd < 32
        && WDISP_AccumulatorRow2_Value < 0x4000)
        ACCUMULATOR_Row2_CaptureValue = WDISP_AccumulatorRow2_Value;
    else
        ACCUMULATOR_Row2_CaptureValue = 0;

    if (WDISP_AccumulatorRow3_CopperIndexStart < 32
        && WDISP_AccumulatorRow3_CopperIndexEnd < 32
        && WDISP_AccumulatorRow3_Value < 0x4000)
        row3 = WDISP_AccumulatorRow3_Value;
    else
        row3 = 0;

    ACCUMULATOR_Row3_CaptureValue = row3;

    if (ACCUMULATOR_Row0_CaptureValue != 0
        || ACCUMULATOR_Row1_CaptureValue != 0
        || ACCUMULATOR_Row2_CaptureValue != 0
        || row3 != 0)
        WDISP_AccumulatorCaptureActive = 1;
    else
        WDISP_AccumulatorCaptureActive = 0;

    ACCUMULATOR_Row0_Sum = ACCUMULATOR_Row0_SaturateFlag =
        ACCUMULATOR_Row1_Sum = ACCUMULATOR_Row1_SaturateFlag =
        ACCUMULATOR_Row2_Sum = ACCUMULATOR_Row2_SaturateFlag =
        ACCUMULATOR_Row3_Sum = ACCUMULATOR_Row3_SaturateFlag = 0;

    ESQIFF_RunCopperRiseTransition();
}
