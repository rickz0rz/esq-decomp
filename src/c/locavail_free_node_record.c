/* RESTORES: LOCAVAIL_FreeNodeRecord
 * MODULE:   modules/groups/a/y/locavail.s
 * STATUS:   behavioural
 *
 * Zeroes an availability node. 26 bytes both ways; only A3 vs A5 differs.
 *
 * NOTE: the chained assignment order is load-bearing -- the original stores
 * `first` before `second`, so it must be written `second = first = 0`.
 * Four separate `= 0` statements make SAS/C emit CLR.W and diverge further.
 *
 * SASC-MISMATCH: register-allocation-order
 *   summary: SAS/C 6.51 allocates A5 for the first pointer local where the
 *            original always uses A3, and D6 before D7 where the original uses
 *            D7 first. Every other byte matches. Not the data model (reproduces
 *            with and without DATA=FAR, and these touch no globals) and not an
 *            option: NOAUTOREG, OPTIMIZE and SHORTINT all leave it in place.
 *            Consistent across every function with a pointer local, so it is a
 *            code-generator difference, not a source-form one.
 *   tried:   DATA=FAR on/off, NOAUTOREG, OPTIMIZE, SHORTINT.
 *   retest:  a compiler that picks A3 before A5, and D7 before D6, should match
 *            these sources unchanged.
 */
struct LocAvailNode {
    char  kind;
    char  pad;
    short first;
    short second;
    long  link;
};

void LOCAVAIL_FreeNodeRecord(struct LocAvailNode *node)
{
    node->kind   = 0;
    node->second = node->first = 0;
    node->link   = 0;
}
