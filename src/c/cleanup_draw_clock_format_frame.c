/* RESTORES: CLEANUP_DrawClockFormatFrame
 * MODULE:   modules/groups/a/c/cleanup2.s
 * STATUS:   behavioural
 *
 * Scrolls the clock-format strip left by copying the grid bitmap onto itself,
 * source and destination both offset 36 pixels past the column start. The width
 * shrinks as the column start moves right, so the copy always stops at x=660.
 *
 * The source and destination x are the same expression and the original computes
 * it twice, into two registers -- so it is written twice here rather than hoisted
 * into a local.
 *
 * 84 bytes in the original, 84 emitted, ONE differing hunk: the call encoding.
 * Every other byte matches, including both copies of the x expression in separate
 * registers, the 660 as a MOVE.L immediate, and all nine argument pushes in order.
 *
 * A clean confirmation of two AGENTS.md rules at once. Hoisting the repeated
 * `NEWGRID_ColumnStartXPx + 36` into a local would collapse the two register
 * computations into one; and 660 is neither 2n nor ~n for an n in MOVEQ range, so
 * the six-byte MOVE.L is exactly what the constant rule predicts.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the one cross-unit call. The whole difference.
 */

extern void GRAPHICS_BltBitMapRastPort(void *srcBM, long srcX,
                                                       long srcY, void *destRP,
                                                       long destX, long destY,
                                                       long width, long height,
                                                       long minterm);

extern struct RastPort *NEWGRID_MainRastPortPtr;
extern unsigned short NEWGRID_ColumnStartXPx;

struct RastPort {
    char pad[4];
    void *BitMap;       /* 4 */
};

void CLEANUP_DrawClockFormatFrame(void)
{
    GRAPHICS_BltBitMapRastPort(
        NEWGRID_MainRastPortPtr->BitMap,
        NEWGRID_ColumnStartXPx + 36, 0L,
        NEWGRID_MainRastPortPtr,
        NEWGRID_ColumnStartXPx + 36, 34L,
        660 - NEWGRID_ColumnStartXPx, 34L, 192L);
}
