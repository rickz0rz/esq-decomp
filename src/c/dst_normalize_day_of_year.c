/* RESTORES: DST_NormalizeDayOfYear
 * MODULE:   modules/groups/a/j/dst2.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: loop-shape
 *   ref:     48e707003e2f00123c2f0016200648c02f0061000488584f4a406708203c0000016e6006203c0000016d2a00be456f269e455246200648c02f0061000460584f4a406708203c0000016e6006203c0000016d2a0060d620074cdf00e04e75
 *   got:     48e70f003e2f00163c073a2f001a300548c02f0061000000584f283c0000016e4a406606283c0000016d300648c0b0846f28300648c090842c005245300548c02f0061000000584f283c0000016e4a4066d8283c0000016d60d030064cdf00f04e754e71
 *   summary: 94 bytes against 100. The original keeps day/year/days in D7/D6/D5
 *            as 16-bit values and compares with CMP.W; SAS/C allocates a fourth
 *            register (mask 48E70F00 vs 48E70700), widens the comparisons to
 *            32-bit with EXT.L, and rotates the loop differently. The rewritten
 *            while-loop reproduces the semantics but not the register economy.
 *   tried:   short vs long locals, register qualifiers, do/while and for shapes.
 *   scope:   loops over 16-bit counters.
 *   retest:  worth re-attempting on a compiler that keeps 16-bit arithmetic
 *            16-bit; see the SHORTINT note on ED_IsConfirmKey.
 */
extern short DATETIME_IsLeapYear(long year);
short DST_NormalizeDayOfYear(short day, short year)
{
    register short d = day, y = year;
    register long days = DATETIME_IsLeapYear((long)y) ? 366 : 365;
    while (d > days) {
        d -= days;
        y++;
        days = DATETIME_IsLeapYear((long)y) ? 366 : 365;
    }
    return d;
}
