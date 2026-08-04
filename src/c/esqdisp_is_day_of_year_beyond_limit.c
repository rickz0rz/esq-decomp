/* RESTORES: ESQDISP_IsDayOfYearBeyondLimit
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_p0.s   (1 of its 4 blocks)
 * STATUS:   behavioural
 *
 * Tests whether a day-of-year is past the end of its year.
 *
 * IT IS THE ONLY ONE OF THE FOUR THAT DOES ANYTHING, and its two limits are
 * the point: 366 when the leap flag is -1, 365 when it is 0, and false for
 * any other flag value. The original tests the two flag values separately
 * rather than deriving the limit, so a flag of 1 falls through both arms and
 * returns 0 -- which is not what `365 + isLeap` would give.

 * It is one of four range predicates on the grid's time and date fields that
 * share this module. NONE OF THEM CARRIED A LABEL UNTIL 2026-08-04, and the module before them in
 * src/Prevue.asm ends in RTS, so nothing can reach any of them -- by name or by
 * fall-through. Adding four labels is byte-neutral; test-hash.sh and
 * build-split.sh both pass across the change. Every name is OURS, chosen from
 * what the block tests.
 *
 * THE BOOLEAN SHAPE IS `Scc` / `NEG.B` / `EXT.W` / `EXT.L`, WHICH RETURNS +1.
 * `Scc` alone sets 0xff, and the NEG.B turns that into +1 rather than the -1 a
 * bare sign extension would give. Writing `return -(x > 23);` would be the
 * natural reading of Scc and would return the wrong sign; the comparison is
 * written plainly so the result is 1 or 0.
 *
 * THE ARGUMENT IS A WORD IN A LONG SLOT. Each reads `10(A7)` after a 4-byte
 * push and a 4-byte return address, which is the LOW half of the long argument
 * at 8(A7). Declaring the parameter `short` would be wrong under SHORTINT and
 * right otherwise; `long` narrowed at the point of use matches the slot the
 * caller pushes and every other declaration in the tree.
 *
 * SASC-MISMATCH: booleanize-shape
 *   summary: SAS/C 6.51 emits a compare and a conditional branch over a pair of
 *            constant loads where the original uses Scc/NEG.B/EXT/EXT. Same
 *            two results; a few bytes either way per predicate. This is the
 *            divergence disptext_is_last_line_selected.c records.
 *   scope:   program-wide.
 *   retest:  a compiler that emits the Scc form.
 */
long ESQDISP_IsDayOfYearBeyondLimit(long dayOfYear, long leapFlag)
{
    short day  = (short)dayOfYear;
    short leap = (short)leapFlag;

    if (leap == -1 && day > 366)
        return 1;
    if (leap == 0 && day > 365)
        return 1;
    return 0;
}
