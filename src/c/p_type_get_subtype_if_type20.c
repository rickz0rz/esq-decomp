/* RESTORES: P_TYPE_GetSubtypeIfType20
 * MODULE:   modules/groups/b/a/p_type.s
 * STATUS:   behavioural
 *
 * Returns the subtype byte of a type-20 record, or 0. 38 bytes both ways;
 * only the address register differs (ref A3, got A5).
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
long P_TYPE_GetSubtypeIfType20(unsigned char *rec)
{
    long sub = 0;

    if (rec != 0 && rec[0] == 20 && rec[1] != 0)
        sub = rec[1];
    return sub;
}
