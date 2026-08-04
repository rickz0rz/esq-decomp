/* RESTORES: GENERATE_GRID_DATE_STRING
 * MODULE:   modules/groups/b/a/script3.s
 * STATUS:   behavioural
 *
 * Formats the grid's date line from the four clock globals. Every one of them
 * is widened with EXT.L, so they are signed shorts -- the same modeling the
 * other clock users in src/c already carry.
 *
 * The two name tables are indexed by longword (ASL.L #2), so they are arrays
 * of pointers, and the format string takes the two names before the two
 * numbers.
 *
 * 86 ref vs 90 got (plus 2 bytes of object alignment padding). All six
 * argument pushes, both LEA table bases, all four EXT.L widenings and the
 * LEA 24(A7),A7 cleanup agree exactly.
 *
 * SASC-MISMATCH: a3-vs-a5-register-allocation
 *   ref:     2f0b 266f0008 ... 265f    MOVE.L A3,-(A7) / MOVEA.L 8(A7),A3 / MOVEA.L (A7)+,A3
 *   got:     2f0d 2a6f0008 ... 2a5f    the same three against A5
 *   summary: the destination pointer lives in A3 in the original and A5 in
 *            6.51. Same instructions, same sizes, one register apart.
 *   scope:   program-wide. docs/compiler-version.md, "The A3/A5 divergence has
 *            a single root cause".
 *   retest:  a compiler that reserves A5; the same doc gives the probe.
 *
 * SASC-MISMATCH: index-shift-needs-a-copy
 *   ref:     48c0 e580               EXT.L D0 / ASL.L #2,D0        (4 bytes, twice)
 *   got:     48c0 2200 e581          EXT.L D0 / MOVE.L D0,D1 / ASL.L #2,D1  (6, twice)
 *   summary: scaling the table index by 4, the original shifts the widened
 *            value in place; 6.51 copies it to a second register first and
 *            shifts there. Same index, 2 bytes more each time, and the two
 *            table lookups are the whole 4-byte difference.
 *   tried:   nothing from the source side -- both subscripts are plain array
 *            indexing, which is already the shape the original compiled from.
 *   retest:  re-run tools/mismatches.py --recheck against a different SAS/C
 *            version; see docs/compiler-version.md.
 */
extern void  WDISP_SPrintf(char *dst, char *fmt, char *day,
                                           char *month, long dom, long year);

extern short CLOCK_CurrentDayOfWeekIndex;
extern short CLOCK_CurrentMonthIndex;
extern short CLOCK_CurrentDayOfMonth;
extern short CLOCK_CurrentYearValue;
extern char *Global_JMPTBL_DAYS_OF_WEEK[];
extern char *Global_JMPTBL_MONTHS[];
extern char  Global_STR_GRID_DATE_FORMAT_STRING[];

void GENERATE_GRID_DATE_STRING(char *dst)
{
    WDISP_SPrintf(dst, Global_STR_GRID_DATE_FORMAT_STRING,
                                  Global_JMPTBL_DAYS_OF_WEEK[CLOCK_CurrentDayOfWeekIndex],
                                  Global_JMPTBL_MONTHS[CLOCK_CurrentMonthIndex],
                                  (long)CLOCK_CurrentDayOfMonth,
                                  (long)CLOCK_CurrentYearValue);
}
