/* RESTORES: DATETIME_AdjustMonthIndex
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008302b000848c0720c4ebac38a4a6b00126704700c60027000d280374100082001265f4e75
 *   got:     48e703042a6f0010302d000848c04878000c2f00610000002e00504f4a6d001267047c0c60027c00de8620073b4000084cdf20c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DateRec { char pad[8]; short month; char pad2[8]; short flag; };
extern long GROUP_AG_JMPTBL_MATH_DivS32(long a, long b);
long DATETIME_AdjustMonthIndex(struct DateRec *d)
{
    long m = GROUP_AG_JMPTBL_MATH_DivS32((long)d->month, 12);
    long off;

    if (d->flag != 0)
        off = 12;
    else
        off = 0;
    m += off;
    d->month = (short)m;
    return m;
}
