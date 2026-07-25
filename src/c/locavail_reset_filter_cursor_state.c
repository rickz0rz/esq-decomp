/* RESTORES: LOCAVAIL_ResetFilterCursorState
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * Resets the availability filter cursor. 32 bytes ref vs 36.
 *
 * SASC-MISMATCH: register-allocation-order
 *   summary: SAS/C 6.51 allocates A5 for the first pointer local where the
 *            original uses A3, and prefers MOVEM over a single MOVE.L for one
 *            saved register. See docs/compiler-version.md; this is the same
 *            code-generator divergence that blocks four functions in the first
 *            batch, not a source-form problem.
 *   tried:   DATA=FAR on/off, NOAUTOREG, OPTIMIZE, SHORTINT.
 *   retest:  a compiler preferring A3 before A5 should match these unchanged.
 */
struct LocAvailFilterCursor {
    char pad[8];
    long cursorA;
    long cursorB;
};
extern long LOCAVAIL_FilterClassId;
extern long LOCAVAIL_FilterStep;

void LOCAVAIL_ResetFilterCursorState(struct LocAvailFilterCursor *st)
{
    long none = -1;

    st->cursorA = none;
    st->cursorB = none;
    LOCAVAIL_FilterClassId = none;
    LOCAVAIL_FilterStep = 0;
}
