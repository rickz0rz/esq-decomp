/* RESTORES: ED_UpdateCursorPosFromIndex
 * MODULE:   modules/groups/a/k/ed.s
 * STATUS:   behavioural
 *
 * Reproduces: the column/row split of a linear cursor index by the 40-column
 * line width, and the clamp loop that walks the viewport back one line at a
 * time -- subtracting a whole line from the edit offset per step -- until the
 * viewport is inside the text limit.
 *
 * The original calls MATH_DivS32 twice, once for each half of the split, taking
 * the remainder from D1 the first time and the quotient from D0 the second.
 * Written as `% 40` and `/ 40`, which is the only form that reaches the
 * remainder from C -- see datetime_is_leap_year.c for why the helper cannot be
 * called directly with an ordinary prototype.
 */
extern long ED_CursorColumnIndex;
extern long ED_ViewportOffset;
extern long ED_TextLimit;
extern long ED_EditCursorOffset;

void ED_UpdateCursorPosFromIndex(long index)
{
    ED_CursorColumnIndex = index % 40;
    ED_ViewportOffset    = index / 40;

    while (ED_ViewportOffset >= ED_TextLimit) {
        ED_ViewportOffset -= 1;
        ED_EditCursorOffset -= 40;
    }
}
