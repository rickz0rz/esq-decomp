/* RESTORES: BRUSH_SelectBrushSlot
 * MODULE:   modules/groups/a/a/brush_p1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: a5-frame-and-span-reuse
 *   ref:     4e55ffe848e73f30266d00082e2d000c2c2d00102a2d0014246d001c200b670001dc2005908722005281242b015cb4816f4c2b47fffc222b01647602b283660e2802988053842b44ffec600000947001b280662028024a846a025284e2842205928752814a816a025281e28198812b44ffec606c282b01542b44ffec6062200590875280b4806c4a202b01542b40ffec222b01647602b283660c2805988252842b44fffc603a538166222205928752814a816a025281e281d28728024a846a025284e28492842b41fffc60142b47fffc600e202b015422072b40ffec2b41fffc202d00182200928626015283282b0160b8836f4c2b46fff8262b01687402b682660e2004908153802b40ffe8600000947201b681662026044a836a025283e2832800988652844a846a025284e28496842b43ffe8606c242b01582b42ffe86062220092865281b8816c4a222b01582b41ffe8262b01687402b682660c2200928452812b41fff8603a538366222600968652834a836a025283e283d68624044a826a025282e28296822b43fff860142b46fff8600e222b015826062b41ffe82b43fff8200590875280222b015cb0816f022001222d00189286528148ed0001fff4242b0160b2826f02220241eb00882b41fff0242d00204a826e04242dffe8487800c02f012f002f2dfff82f2dfffc2f0a2f022f2dffec2f084eba2754
 *   got:     9efc002448e73f142a2f00542c2f00502e2f004c266f005c2a6f0048200d6700021420059087222d0164240052822f40002848ef00020024b2826f4e2f470040242d016c48ef000400207602b483660e2801988053842f440038600000965382661e20016a025280e2802405948752824a826a025282e28290822f4000386072202d015c2f4000386068200590875280b2806c50202d015c242d016c48ef0001003848ef000400207602b483660c2805988152842f4400406038538266202405948752824a826a025282e282d48728016a025284e28494842f42004060142f470040600e202d015c24072f4000382f420040202f005824009486262d0168280252842f42002848ef00080024b6846f4e2f46003c282d017048ef001000207202b881660e2003908253802f400034600000965384661e24036a025282e2822800988652844a846a025284e28494842f4200346072242d01602f4200346068240094865282b6826c50242d0160282d017048ef0004003448ef001000207202b881660c2400948352822f42003c6038538466202800988652844a846a025284e284d88622036a025281e28198812f44003c60142f46003c600e242d016028062f4200342f44003c20059087528048ef00010030222d0164b0816f042f410030202f00589086528048ef0001002cb0836f042f43002c202f006048ef000100206e08222f00342f41002041ed0088487800c02f2f00302f2f00382f2f00482f2f00502f0b2f2f00382f2f00542f08610000004fef00244cdf28fcdefc00244e754e71
 *   summary: 576 got vs 508 ref, and the reference stops at BRUSH_SelectBrushSlot_Return so the epilogue is not counted. The original keeps all six results -- both source offsets, both destination offsets and both extents -- in negative A5 slots and holds the running span and clip limit in D0 to D4 across each axis; 6.51 spills more of them to A7 and reloads the y1 argument at each of its five uses. The two axes are byte-for-byte the same shape in the original and come out the same shape here: the fits-inside arm, the too-wide arm and the exact arm, each with its own mode-2 flush-right, mode-1 centre and default sub-arm. The extent clamps, the override-or-source-Y selection and the nine-argument blit match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>

struct BrushRecord {
    char pad0[136];
    struct BitMap bitmap;       /* +136 */
    /* struct BitMap is 40 bytes, NOT 32: BytesPerRow+Rows+Flags+Depth+pad = 8,
     * plus PLANEPTR Planes[8] = 32. The bitmap therefore ends at 176, not 168.
     * The old pad assumed 32 and put every field below 8 bytes late, so srcX
     * read clipWidth and the blit got garbage dimensions -- the TV Guide logo
     * never drew. cdiff cannot see this: struct offsets are not validated by a
     * byte diff. Verified against the original's 340/344/348/352/356/360. */
    char padToSrcX[164];
    long srcX;                  /* +340 */
    long srcY;                  /* +344 */
    long clipWidth;             /* +348 */
    long clipHeight;            /* +352 */
    long modeX;                 /* +356 */
    long modeY;                 /* +360 */
};

extern void GRAPHICS_BltBitMapRastPort(struct BitMap *src,
                long sx, long sy, struct RastPort *rp, long dx, long dy,
                long w, long h, long minterm);

void BRUSH_SelectBrushSlot(struct BrushRecord *brush, long x0, long y0, long x1,
                           long y1, struct RastPort *rp, long override)
{
    long destX;
    long destY;
    long srcX;
    long srcY;
    long width;
    long height;
    long span;
    long limit;
    long mode;

    if (brush == 0)
        return;

    span = x1 - x0;
    limit = brush->clipWidth;
    if (limit > span + 1) {
        destX = x0;
        mode = brush->modeX;
        if (mode == 2) {
            srcX = limit - span - 1;
        } else if (mode == 1) {
            srcX = limit / 2 - (x1 - x0 + 1) / 2;
        } else {
            srcX = brush->srcX;
        }
    } else if (limit < x1 - x0 + 1) {
        srcX = brush->srcX;
        mode = brush->modeX;
        if (mode == 2) {
            destX = x1 - limit + 1;
        } else if (mode == 1) {
            destX = (x1 - x0 + 1) / 2 + x0 - limit / 2;
        } else {
            destX = x0;
        }
    } else {
        srcX = brush->srcX;
        destX = x0;
    }

    span = y1 - y0;
    limit = brush->clipHeight;
    if (limit > span + 1) {
        destY = y0;
        mode = brush->modeY;
        if (mode == 2) {
            srcY = limit - span - 1;
        } else if (mode == 1) {
            srcY = limit / 2 - (y1 - y0 + 1) / 2;
        } else {
            srcY = brush->srcY;
        }
    } else if (limit < y1 - y0 + 1) {
        srcY = brush->srcY;
        mode = brush->modeY;
        if (mode == 2) {
            destY = y1 - limit + 1;
        } else if (mode == 1) {
            destY = (y1 - y0 + 1) / 2 + y0 - limit / 2;
        } else {
            destY = y0;
        }
    } else {
        srcY = brush->srcY;
        destY = y0;
    }

    width = x1 - x0 + 1;
    if (width > brush->clipWidth)
        width = brush->clipWidth;

    height = y1 - y0 + 1;
    if (height > brush->clipHeight)
        height = brush->clipHeight;

    mode = override;
    if (mode <= 0)
        mode = srcY;

    GRAPHICS_BltBitMapRastPort(&brush->bitmap, srcX, mode, rp,
                                               destX, destY, width, height, 192);
}
