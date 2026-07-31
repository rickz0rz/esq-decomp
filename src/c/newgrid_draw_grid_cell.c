/* RESTORES: NEWGRID_DrawGridCell
 * MODULE:   modules/groups/b/a/newgrid1_p0.s
 * STATUS:   behavioural
 *
 * Draws one grid cell: a bevelled frame whose style depends on the mode, then
 * the cell text.
 *
 * Both entry text fields are run through the class-3 skipper BEFORE the frame
 * is drawn, and the results are parked in frame slots across both calls. The
 * +1 field is skipped first and the +19 field second.
 *
 * The two frame variants compute their corners SEPARATELY -- the original emits
 * the whole MOVEQ #0 / MOVE.W / ADDQ #35 / MOVE.W / SUBQ #1 sequence twice,
 * once in each arm, rather than hoisting it above the branch. The C below
 * duplicates it for the same reason.
 *
 * Both dimension globals are widened with MOVEQ #0 / MOVE.W, so both are
 * unsigned shorts, and the height is used minus one.
 *
 * The text call takes the SECOND skip result before the first -- the push order
 * is D7, first, second, rp, so the argument order is (rp, second, first, mode).
 *
 * 176 ref vs 164 got. BOTH corner computations are VERBATIM
 * (7000 3039.... 7223 d081 7200 3239.... 5381) and so are both five-argument
 * pushes, both LEA 20(A7),A7 cleanups and the closing text call.
 *
 * SASC-MISMATCH: link-frame-and-spill
 *   ref:     4e55fff8 ... 2b48fffc 2b49fff8 ... 2eadfff8 2b40fffc ... 4e5d
 *            LINK / both skip results spilled and reloaded around the calls
 *   got:     594f ... 2440 2e88 2f400014 ... 2f0a 2f2f001c
 *            SUBQ.W #4,A7, results kept in registers where possible
 *   summary: the original parks both skip results in frame slots across the two
 *            skip calls and reloads them for the text call; 6.51 keeps one in an
 *            address register and spills only the other. The frame plus the
 *            extra store/reload pair is the 12 bytes.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridCellEntry {
    char pad0;
    char text1[18];             /* +1  */
    char text19[8];             /* +19 */
};

extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern void  NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(void *rp, long x1, long y1,
                                                    long x2, long y2);
extern void  NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(void *rp, long x1,
                                                              long y1, long x2,
                                                              long y2);
extern void  NEWGRID_DrawGridCellText(void *rp, char *second, char *first,
                                      long mode);

extern unsigned short NEWGRID_ColumnStartXPx;
extern unsigned short NEWGRID_RowHeightPx;

void NEWGRID_DrawGridCell(void *rp, struct NewGridCellEntry *e, long mode)
{
    char *first;
    char *second;

    first  = NEWGRID2_JMPTBL_STR_SkipClass3Chars(e->text1);
    second = NEWGRID2_JMPTBL_STR_SkipClass3Chars(e->text19);

    if (mode != 0)
        NEWGRID2_JMPTBL_BEVEL_DrawBevelFrameWithTopRight(
            rp, 0L, 0L,
            (long)NEWGRID_ColumnStartXPx + 35, (long)NEWGRID_RowHeightPx - 1);
    else
        NEWGRID2_JMPTBL_BEVEL_DrawBeveledFrame(
            rp, 0L, 0L,
            (long)NEWGRID_ColumnStartXPx + 35, (long)NEWGRID_RowHeightPx - 1);

    NEWGRID_DrawGridCellText(rp, second, first, mode);
}
