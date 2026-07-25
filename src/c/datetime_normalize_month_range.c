/* RESTORES: DATETIME_NormalizeMonthRange
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: register-allocation-order
 *   ref:     2f0b266f0008302b0008720bb0416f0472ff6002720037410012302b000848c0720c81c14840374000084a40660437410008265f4e75
 *   got:     48e701042a6f000c302d0008720bb0416f047eff60027e003b470012302d000848c0720c81c148403b40000866043b4100084cdf20804e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
struct DateTimeRec {
    char  pad[8];
    short month;
    char  pad2[8];
    short overflow;
};
void DATETIME_NormalizeMonthRange(struct DateTimeRec *d)
{
    short over;

    if (d->month > 11)
        over = -1;
    else
        over = 0;
    d->overflow = over;
    d->month = d->month % 12;
    if (d->month == 0)
        d->month = 12;
}
