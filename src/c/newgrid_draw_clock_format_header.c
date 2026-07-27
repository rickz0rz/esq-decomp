/* RESTORES: NEWGRID_DrawClockFormatHeader
 * MODULE:   modules/groups/b/a/newgrid1b.s
 * STATUS:   behavioural
 *
 * 420 bytes in the original, 412 emitted, 22 differing regions.
 *
 * Reproduces: the rastport reached as ctx+60, SetAPen taking the RETURN VALUE of
 * NEWGRID_SetRowColor directly as its pen, the full-width RectFill and header
 * bevel, the three-column loop with its 48-slot wrap, the per-column x as
 * ColumnStartXPx + i*ColumnWidthPx + 36, the special-cased right edge of 695 on
 * the last column, the (ColumnWidthPx - textWidth)/2 + 2 horizontal centring and
 * the (34 - tf_Baseline)/2 + tf_Baseline - 1 vertical centring, both inlined
 * strlen calls, and the trailing ctx+52 = 17 / validate / ctx+32 = ctx+52
 * sequence with its zero-extending word-to-long copy.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ff94                   LINK.W A5,#-108
 *   got:     9efc0074                   SUBA.W #116,A7
 *   summary: The A5-frame class. The 97-byte label buffer and the spilled
 *            rastport pointer all move from -n(A5) to n(A7), which is most of the
 *            22 regions.
 *
 * SASC-MISMATCH: multiply-strength-reduction
 *   ref:     4eba0cca                   JSR NEWGRID_JMPTBL_MATH_Mulu32
 *   got:     inline shift/add
 *   summary: i * ColumnWidthPx. The original calls the helper even though one
 *            operand is a small loop counter.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
#include <proto/graphics.h>
#include <string.h>

extern long NEWGRID_SetRowColor(unsigned char *ctx, long a, long b);
extern void NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rp, long x0, long y0,
                                                             long x1, long y1);
extern void NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(long slot, char *out);
extern void NEWGRID_ValidateSelectionCode(unsigned char *ctx, long code);
extern short NEWGRID_ColumnStartXPx;
extern short NEWGRID_ColumnWidthPx;

void NEWGRID_DrawClockFormatHeader(unsigned char *ctx, long startSlot)
{
    char label[97];
    struct RastPort *rp;
    register long i;
    register long x;
    long slot;
    long right;
    long w;
    long y;
    struct TextFont *font;

    rp = (struct RastPort *)(ctx + 60);
    SetDrMd(rp, 0L);
    SetAPen(rp, NEWGRID_SetRowColor(ctx, 0, 0));
    RectFill(rp, 0L, 0L, 695L, 33L);
    NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rp, 0, 0,
                                                     NEWGRID_ColumnStartXPx + 35L, 33L);

    for (i = 0; i < 3; i++) {
        slot = startSlot + i;
        if (slot > 48)
            slot -= 48;
        NEWGRID2_JMPTBL_CLEANUP_FormatClockFormatEntry(slot, label);

        x = NEWGRID_ColumnStartXPx + i * NEWGRID_ColumnWidthPx + 36;
        if (i == 2)
            right = 695;
        else
            right = NEWGRID_ColumnWidthPx + x - 1;
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(rp, x, 0, right, 33);

        SetAPen(rp, 3L);
        w = TextLength(rp, label, (long)strlen(label));
        x += (NEWGRID_ColumnWidthPx - w) / 2 + 2;

        font = rp->Font;
        y = (34 - font->tf_Baseline) / 2 + font->tf_Baseline - 1;
        Move(rp, x, y);
        Text(rp, label, (long)strlen(label));
    }

    *(unsigned short *)(ctx + 52) = 17;
    NEWGRID_ValidateSelectionCode(ctx, 64);
    *(long *)(ctx + 32) = *(unsigned short *)(ctx + 52);
}
