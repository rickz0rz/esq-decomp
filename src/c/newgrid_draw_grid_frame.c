/* RESTORES: NEWGRID_DrawGridFrame
 * MODULE:   modules/groups/b/a/newgrid_p4.s
 * STATUS:   behavioural
 *
 * Resolves two row colours and fills the grid rectangles with them.
 *
 * The second parameter is genuinely UNUSED. It is read by nobody: the original
 * loads 8(A5) into A3 and 16/20/24(A5) into D7/D6/D5, and never touches
 * 12(A5). It is kept in the signature because dropping it would shift every
 * later argument and change what the callers pass.
 *
 * The two colour calls take (row, -1, a) and (row, 0, b). The FIRST result is
 * parked in a frame local (MOVE.L D0,40(A7) into the LINK area) while the
 * second call runs, then both are pushed for the fill -- so the fill takes the
 * results in call order, not in the order they sit on the stack. The rectangle
 * pointer is &row->rects, a LEA 60(A3),A0 computed before either call and also
 * held in the frame.
 *
 * The argument order for the fill was derived from the stack, not guessed. The
 * four pushes land at A5-56, A5-52, A5-48 and A5-44, holding the rect pointer,
 * the FIRST colour (reloaded from its frame slot at A5-4), the SECOND colour
 * (still in D0) and the last parameter -- so the fill reads
 * (rects, c1, c2, c) in call order.
 *
 * 84 ref vs 80 got. Both colour calls, their argument pushes, the PEA -1 and
 * the CLR.L match exactly.
 *
 * SASC-MISMATCH: link-frame-vs-stack-adjust
 *   ref:     4e55fff8 ... 4ced08e0ffe8 4e5d    LINK / MOVEM from A5 / UNLK
 *   got:     594f ... 4cdf20f0 584f            SUBQ.W #4,A7 / MOVEM / ADDQ.W
 *   summary: the frame class again, and here it also moves WHERE the rect
 *            pointer is computed: the original does LEA 60(A3),A0 up front and
 *            parks it in the frame across both calls (2f48001c), 6.51 has no
 *            frame to park it in so it recomputes the LEA after the calls
 *            (41ed003c). Same address, same two calls in between.
 *   scope:   program-wide. docs/compiler-version.md, "The same property, seen
 *            from the local-variable side".
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 *
 * SASC-MISMATCH: results-in-registers-vs-frame
 *   ref:     2f00 2f2f002c 2f2f002c   push D0 / push 44(A7) / push 44(A7)
 *   got:     2f00 2f04 2f08           push D0 / push D4 / push A0
 *   summary: the original reloads both earlier values from frame slots to build
 *            the fill's argument list; 6.51 still has them in registers and
 *            pushes those. Same four arguments in the same order.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
struct NewGridRow {
    char pad0[60];
    char rects[1];              /* +60 */
};

extern long NEWGRID_SetRowColor(struct NewGridRow *row, long which, long value);
extern void NEWGRID_FillGridRects(char *rects, long c1, long c2, long c3);

void NEWGRID_DrawGridFrame(struct NewGridRow *row, long unused, long a, long b,
                           long c)
{
    long c1, c2;

    c1 = NEWGRID_SetRowColor(row, -1L, a);
    c2 = NEWGRID_SetRowColor(row, 0L, b);
    NEWGRID_FillGridRects(row->rects, c1, c2, c);
}
