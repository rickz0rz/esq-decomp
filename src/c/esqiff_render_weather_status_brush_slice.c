/* RESTORES: ESQIFF_RenderWeatherStatusBrushSlice
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: truncated-reference-and-a7-frame
 *   ref:     48e72330266f0018246f001c200a660c700033c000005b1860000150303900005b184a406f084a7900005a686720700033c000005a68322a00b213fc000100005b1c33c000005b1a33c100005b18303900005b18721eb0416c042e0060022e017009b02a0020666c7c2a7000302a00b0d086220748c141eb003c343900005b1a48c22f022f082f012f0042a72f062f0a4eba11247000302a00b0223c0000028e92802c01538672003200d286200748c041eb003c343900005b1a48c22e822f082f002f0142a72f062f0a4eba10ea4fef003460767000302a00b0223c000002b892804a816a025281e2812c01538672003200d286200748c041eb003c343900005b1a48c22f022f082f002f0142a72f062f0a4eba10a24fef001c700bb02a002066287001b03900005b1c661e1039000006147259b0016612487800102f0b4eba1034504f423900005b1c9f7900005b18df7900005b1a20074a406a025240e24037400034303900005b18
 *   got:     48e72314266f001c2a6f0018200b660e700033c0000000007000600001603039000000006f08303900000000672042790000000013fc000100000000700033c000000000322b00b233c100000000303900000000721eb0416d043e0160023e007009b02b0020666e7c2a302b00b048c0d086320748c141ed003c34390000000048c22f022f082f012f0042a72f062f0b61000000302b00b048c0223c0000028e92802c015386302b00b048c0d086320748c141ed003c34390000000048c22e822f082f012f0042a72f062f0b610000004fef00346076302b00b048c07257e78992804a816a025281e2812c015386302b00b048c0d086320748c141ed003c34390000000048c22f022f082f012f0042a72f062f0b610000004fef001c700bb02b002066281039000000005300661e1039000000007259b0016612487800102f0d61000000504f4239000000003039000000003200924733c100000000303900000000d04733c00000000030076a025240e2403b4000343039000000004cdf28c44e754e71
 *   summary: 388 got vs 362 ref, but the reference stops at ESQIFF_RenderWeatherStatusBrushSlice_Return so the MOVEM/RTS is not counted; the true comparison is 388 against about 370. 6.51 reloads the slice globals before each store where the original keeps them in D0 and D1 across the reset block. All three seven-argument BRUSH_SelectBrushSlot calls, the 30-pixel clamp, the kind-9 two-edge layout, the centred layout with its halving divide, the kind-11 validation gate and the remaining/offset advance match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>

struct GridPanel {
    char            pad0[52];
    short           halfSlice;      /* +52 */
    char            pad54[6];
    struct RastPort rp;             /* +60 */
};

struct WeatherBrush {
    char  pad0[32];
    unsigned char kind;             /* +32 */
    char  pad33[143];
    short originX;                  /* +176 */
    short sliceWidth;               /* +178 */
};

extern short ESQIFF_WeatherSliceRemainingWidth;
extern short ESQIFF_WeatherSliceSourceOffset;
extern char  ESQIFF_WeatherSliceValidateGateFlag;
extern short ESQFUNC_WeatherSliceWidthInitGate;
extern unsigned char CONFIG_NewgridSelectionCode16EnabledFlag;

extern void BRUSH_SelectBrushSlot(struct WeatherBrush *brush,
                long x, long flags, long right, long width,
                struct RastPort *rp, long srcOffset);
extern void NEWGRID_ValidateSelectionCode(struct GridPanel *panel,
                long code);

short ESQIFF_RenderWeatherStatusBrushSlice(struct GridPanel *panel,
                                           struct WeatherBrush *brush)
{
    short width;
    long  x;

    if (brush == 0) {
        ESQIFF_WeatherSliceRemainingWidth = 0;
        return 0;
    }

    if (ESQIFF_WeatherSliceRemainingWidth <= 0
        || ESQFUNC_WeatherSliceWidthInitGate != 0) {
        ESQFUNC_WeatherSliceWidthInitGate = 0;
        ESQIFF_WeatherSliceValidateGateFlag = 1;
        ESQIFF_WeatherSliceSourceOffset = 0;
        ESQIFF_WeatherSliceRemainingWidth = brush->sliceWidth;
    }

    if (ESQIFF_WeatherSliceRemainingWidth >= 30)
        width = 30;
    else
        width = ESQIFF_WeatherSliceRemainingWidth;

    if (brush->kind == 9) {
        x = 42;
        BRUSH_SelectBrushSlot(brush, x, 0,
            (long)brush->originX + x, (long)width, &panel->rp,
            (long)ESQIFF_WeatherSliceSourceOffset);
        x = 654 - brush->originX - 1;
        BRUSH_SelectBrushSlot(brush, x, 0,
            (long)brush->originX + x, (long)width, &panel->rp,
            (long)ESQIFF_WeatherSliceSourceOffset);
    } else {
        x = (696 - brush->originX) / 2 - 1;
        BRUSH_SelectBrushSlot(brush, x, 0,
            (long)brush->originX + x, (long)width, &panel->rp,
            (long)ESQIFF_WeatherSliceSourceOffset);
        if (brush->kind == 11 && ESQIFF_WeatherSliceValidateGateFlag == 1
            && CONFIG_NewgridSelectionCode16EnabledFlag == 89) {
            NEWGRID_ValidateSelectionCode(panel, 16);
            ESQIFF_WeatherSliceValidateGateFlag = 0;
        }
    }

    ESQIFF_WeatherSliceRemainingWidth -= width;
    ESQIFF_WeatherSliceSourceOffset += width;
    panel->halfSlice = width / 2;
    return ESQIFF_WeatherSliceRemainingWidth;
}
