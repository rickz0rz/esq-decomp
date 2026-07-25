/* RESTORES: LOCAVAIL_ResetFilterStateStruct
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * Resets a filter state record to defaults. 42 bytes ref vs 40 -- the
 * original clears the two reference slots with a single SUBA.L/MOVE.L pair
 * where SAS/C emits two CLR.L, on top of the A3/A5 difference.
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
struct LocAvailFilterState {
    char  flag;
    char  pad;
    long  word;
    char  kind;
    char  pad2;
    long  cursorA;
    long  cursorB;
    long  refA;
    long  refB;
};

void LOCAVAIL_ResetFilterStateStruct(struct LocAvailFilterState *st)
{
    st->flag = 0;
    st->word = 0;
    st->refA = 0;
    st->refB = 0;
    st->kind = 'F';
    st->cursorA = -1;
    st->cursorB = -1;
}
