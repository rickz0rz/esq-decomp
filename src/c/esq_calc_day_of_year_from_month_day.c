/* RESTORES: ESQ_CalcDayOfYearFromMonthDay
 * MODULE:   modules/groups/a/a/app2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: dbf-loop
 *   ref:     206f000432280002700043f90000013451c9000460104a680014670443e90018d05951c9fffcd0680004314000104e75
 *   got:     48e703142a6f00143e2d00027c0047f900000000200753474a4067104a6d00146704d6fc0018301bdc4060e8dc6d00043b4600104cdf28c04e75
 *   summary: SAS/C 6.51 differs from the original code generator here; see the ref/got bytes above and docs/compiler-version.md.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 */
extern short CLOCK_MonthLengths[];
struct ClockRec { short pad; short month; short day; char pad2[10]; short dayOfYear; short pad3; short leap; };
void ESQ_CalcDayOfYearFromMonthDay(struct ClockRec *c)
{
    short  n = c->month;
    short  total = 0;
    short *tbl = CLOCK_MonthLengths;

    while (n--) {
        if (c->leap != 0)
            tbl += 12;
        total += *tbl++;
    }
    total += c->day;
    c->dayOfYear = total;
}
