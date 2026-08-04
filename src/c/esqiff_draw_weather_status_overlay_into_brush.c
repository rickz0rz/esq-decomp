/* RESTORES: ESQIFF_DrawWeatherStatusOverlayIntoBrush
 * MODULE:   modules/groups/a/n/esqiff.s
 * STATUS:   behavioural
 *
 * Renders the weather status text into a brush as TWO COLUMNS: even segments
 * left-aligned, odd segments right-aligned, sharing a baseline. The text is one
 * string split on character 24.
 *
 * THE SPLIT IS DESTRUCTIVE AND COUNTED IN THE SAME PASS. Every 24 becomes a NUL
 * and increments the segment count, so the count is the number of DELIMITERS,
 * not of segments -- and a string with no leading text has its count decremented
 * to compensate, which is what the empty-first-byte test does.
 *
 * The count is clamped to 10 AFTER that adjustment, so at most five rows are
 * ever drawn.
 *
 * THE BRUSH NAME COMES FROM A POINTER TABLE THAT THE DISASSEMBLY LABELS AS A
 * STRING. `ESQFUNC_STR_I5` is the anchor of an indexed longword table, not the
 * string it appears to be -- the code adds `index * 4` and dereferences. The
 * assembly carries a comment saying so and it is worth repeating: treating the
 * label as its own value passes a string where a pointer is wanted.
 *
 * THE ROW PITCH IS DERIVED, NOT FIXED: the 160-pixel height less the space the
 * rows themselves occupy, divided by one more than the row count -- so the gaps
 * above, between and below are equal. Both divisions are signed and round
 * toward zero.
 *
 * THE VERTICAL CLIP TESTS THE ROW BOTTOM, not the baseline: `y + YSize -
 * Baseline >= 160` stops before a row would overflow the brush. It is a break,
 * so the remaining segments are silently dropped.
 *
 * THE PEN AND DRAW MODE ARE SAVED FROM INSIDE THE RASTPORT, at +61 and +64 of
 * the brush -- which are RastPort.FgPen and RastPort.DrawMode, since the
 * rastport starts at +36. Reading them as brush fields in their own right
 * works but hides that they are the same storage SetAPen and SetDrMd write.
 *
 * The odd column's x is measured from the brush's right edge and has an extra
 * -1 the left column does not; the left column's centring subtracts 1 BEFORE
 * halving, the right column does not. The two are not mirror images.
 *
 * BOTH COLUMNS ADVANCE THE CURSOR, and there is a third advance at the bottom
 * of the loop -- so an even segment drawn alone still steps past its text. The
 * cursor advance is `strlen + 1` each time, stepping over the NUL the split
 * wrote.
 *
 * 806 ref vs 792 got, 26 differing regions. The table lookup, the owned-string
 * replacement, the destructive split with its count adjustment, the 10 clamp,
 * the four rastport setup calls, the brush blit, the derived row pitch with
 * both signed divisions, the vertical clip, both trim-and-measure pairs, both
 * asymmetric centring computations, all three cursor advances, the free with
 * the pre-split length and both restore calls match in kind and size.
 *
 * SASC-MISMATCH: volatile-a6-reload
 *   ref:     the graphics base cached across the four setup calls and across
 *            each Move/Text pair
 *   got:     reloaded before each
 *   summary: part of the difference, in the direction that costs bytes -- and
 *            the rest of the frame class more than cancels it, which is why the
 *            candidate is 14 bytes UNDER rather than over.
 *   tried:   NOT attempted. This function calls
 *            ESQFUNC_TrimTextToPixelWidthWordBoundary between library calls, so
 *            esq-graphics-leaf.h is not applicable and a cached base is the A6
 *            bug src/c/esq-libbase.md documents.
 *   scope:   every restoration that mixes library and ESQ calls.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
#include <string.h>
#include "esq-graphics.h"

struct WsBrush {
    char            pad0[36];
    struct RastPort rp;                 /* +36; FgPen at +61, DrawMode at +64 */
    struct BitMap   bm;                 /* +136 */
    short           w176;               /* +176 */
    short           w178;               /* +178 */
};

struct WsOverlay {
    char  pad0[176];
    short w176;                         /* +176 */
    char  pad178[178];
    long  f356;                         /* +356 */
    long  f360;                         /* +360 */
};

extern struct WsOverlay *BRUSH_FindBrushByPredicate(char *name,
                                                                  void *head);
extern char *ESQPARS_ReplaceOwnedString(char *newStr, char *old);
extern void  BRUSH_SelectBrushSlot(struct WsOverlay *b, long z0,
                                                 long z1, long w, long h,
                                                 struct RastPort *rp,
                                                 long z2);
extern long __asm MATH_Mulu32(register __d0 long a,
                        register __d1 long b);
extern long __asm MATH_DivS32(register __d0 long a,
                        register __d1 long b);
extern long  ESQFUNC_TrimTextToPixelWidthWordBoundary(struct RastPort *rp,
                                                      long width, char *text);
extern void  MEMORY_DeallocateMemory(char *who, long line,
                                                   void *p, long size);

extern char *ESQFUNC_STR_I5[];
extern void *ESQFUNC_PwBrushListHead;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern unsigned char WDISP_WeatherStatusBrushIndex;
extern char *WDISP_WeatherStatusOverlayTextPtr;
extern char  Global_STR_ESQIFF_C_1[];

void ESQIFF_DrawWeatherStatusOverlayIntoBrush(struct WsBrush *brush)
{
    struct WsOverlay *overlay;
    struct RastPort  *rp;
    char *textBase;
    char *cursor;
    char  savedDrMd;
    char  savedAPen;
    long  segCount;
    long  segIdx;
    long  textLen1;
    long  fontHeight;
    long  halfCount;
    long  lineStep;
    long  halfWidth;
    long  trimLen;
    long  w;
    long  x;
    long  y;

    textBase = 0;
    segCount = 0;
    segIdx   = 0;

    overlay = BRUSH_FindBrushByPredicate(
                  ESQFUNC_STR_I5[WDISP_WeatherStatusBrushIndex],
                  &ESQFUNC_PwBrushListHead);

    textBase = ESQPARS_ReplaceOwnedString(WDISP_WeatherStatusOverlayTextPtr,
                                          textBase);

    textLen1 = strlen(textBase) + 1;

    cursor = textBase;
    while (*cursor != 0) {
        if (*cursor == 24) {
            *cursor = 0;
            segCount++;
        }
        cursor++;
    }

    cursor = textBase;
    if (*cursor == 0) {
        cursor++;
        segCount--;
    }

    if (segCount > 10)
        segCount = 10;

    rp = &brush->rp;

    savedDrMd = rp->DrawMode;
    savedAPen = rp->FgPen;

    SetDrMd(rp, 0L);
    SetAPen(rp, 1L);
    SetFont(rp, Global_HANDLE_PREVUEC_FONT);
    SetRast(rp, 7L);

    overlay->f360 = overlay->f356 = 1;

    BRUSH_SelectBrushSlot(overlay, 0L, 0L,
                                        (long)brush->w176,
                                        (long)brush->w178, rp, 0L);

    fontHeight = Global_HANDLE_PREVUEC_FONT->tf_YSize;
    halfCount  = (segCount + 1) / 2;

    lineStep = MATH_DivS32(
                   160 - MATH_Mulu32(fontHeight, halfCount),
                   halfCount + 1);

    halfWidth = ((long)brush->w176 - (long)overlay->w176) / 2;

    while (segIdx < segCount) {

        y = MATH_Mulu32(segIdx / 2, lineStep + fontHeight)
            + lineStep + (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline;

        if (y + (long)Global_HANDLE_PREVUEC_FONT->tf_YSize
                - (long)Global_HANDLE_PREVUEC_FONT->tf_Baseline >= 160)
            break;

        trimLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(rp, halfWidth,
                                                           cursor);
        w = TextLength(rp, cursor, trimLen);

        x = (halfWidth - w - 1) / 2;

        Move(rp, x, y);
        Text(rp, cursor, trimLen);

        segIdx++;

        if (segIdx < segCount) {

            cursor += strlen(cursor) + 1;

            trimLen = ESQFUNC_TrimTextToPixelWidthWordBoundary(rp, halfWidth,
                                                               cursor);
            w = TextLength(rp, cursor, trimLen);

            x = (long)brush->w176 - (halfWidth + w) / 2 - 1;

            Move(rp, x, y);
            Text(rp, cursor, trimLen);

            segIdx++;
        }

        cursor += strlen(cursor) + 1;
    }

    MEMORY_DeallocateMemory(Global_STR_ESQIFF_C_1, 672L,
                                          textBase, textLen1);

    SetDrMd(rp, (long)savedDrMd);
    SetAPen(rp, (long)savedAPen);
}
