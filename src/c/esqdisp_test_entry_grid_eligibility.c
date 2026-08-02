/* RESTORES: ESQDISP_TestEntryGridEligibility
 * MODULE:   modules/groups/a/n/esqdispb_p0_p1_2.s
 * STATUS:   behavioural
 *
 * Answers whether entry `index` may appear in the grid. It returns 1 or 0, and
 * every rejection path returns the same 0.
 *
 * THE INDEX RANGE IS 1 TO 48, NOT 0 TO 48. Entry 0 is rejected by `TST.W /
 * BLE`, which matches displib_find_previous_valid_entry_index.c -- entry 0 is a
 * sentinel in this table, not a row.
 *
 * THE NULL TEST COMES AFTER THE RANGE TESTS, which is the order the original
 * uses and is worth keeping: a caller passing a null base with a bad index is
 * rejected on the index, so the two paths are not interchangeable if either
 * ever gains a side effect.
 *
 * TWO SEPARATE TABLES ARE CONSULTED, at +7 and +252, both indexed by the same
 * entry number. Bit 4 at +7 is an unconditional pass. Failing that, the byte at
 * +252 must be BETWEEN 5 AND 10 inclusive -- `BCS` on 5 then `BLS` on 10, both
 * unsigned, so it is a closed range and not two independent tests.
 */

long ESQDISP_TestEntryGridEligibility(unsigned char *base, short index)
{
    unsigned char kind;

    if (index <= 0)
        return 0;
    if (index >= 49)
        return 0;
    if (base == 0)
        return 0;

    if (base[7 + index] & 0x10)
        return 1;

    kind = base[252 + index];
    if (kind < 5)
        return 0;
    if (kind <= 10)
        return 1;
    return 0;
}
