/* RESTORES: PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData,
 *           PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay,
 *           PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch,
 *           PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock,
 *           PARSEINI2_JMPTBL_DATETIME_IsLeapYear,
 *           PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock,
 *           PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch
 * MODULE:   modules/groups/b/a/parseini2_p1.s   (7 of its 8 labels)
 * STATUS:   behavioural
 *
 * The seven clock jump-table thunks that share a module with
 * PARSEINI_NormalizeClockData. A C file replaces a whole module, so all seven
 * had to be restored before that function's own restoration could be linked.
 * tools/jmptbl_to_c.py cannot generate this file, because the module is not a
 * pure jump table.
 *
 * EVERY SIGNATURE IS COPIED FROM THE TARGET'S OWN RESTORATION. A thunk written
 * `void f(void)` compiles, links, and silently passes no arguments -- a whole
 * bug class in this project's history. The declarations here match
 * parseini_normalize_clock_data.c and its neighbours field for field, and the
 * struct is guarded so a merge in either order compiles.
 *
 * TWO STRUCTS, NOT ONE. The clock targets divide into those that take the
 * eleven-field ParseIniClockData record and those that take the RTC record.
 * They are different layouts and the tree already declares both; using either
 * for the other would compile and read the wrong fields.
 *
 * SASC-MISMATCH: tail-jump
 *   ref:     JMP target
 *   got:     a call and a return, +2 bytes and one extra frame
 *   summary: the same divergence every converted jump table carries.
 *   scope:   all converted tables.
 *   retest:  needs a compiler that can emit a tail jump; SAS/C 6.51 cannot.
 */
#ifndef PARSEINICLOCKDATA_DEFINED
struct ParseIniClockData;
#endif
#ifndef PARSEINIRTCRECORD_DEFINED
struct ParseIniRtcRecord;
#endif
#ifndef AMIGACLOCKDATA_DEFINED
struct AmigaClockData;
#endif

extern void CLOCK_ConvertAmigaSecondsToClockData(long seconds,
                                                 struct AmigaClockData *out);
extern void ESQ_CalcDayOfYearFromMonthDay(struct ParseIniClockData *c);
extern long CLOCK_CheckDateOrSecondsFromEpoch(struct ParseIniRtcRecord *r);
extern long BATTCLOCK_GetSecondsFromBatteryBackedClock(void);
extern long DATETIME_IsLeapYear(long year);
extern void BATTCLOCK_WriteSecondsToBatteryBackedClock(long seconds);
extern long CLOCK_SecondsFromEpoch(struct ParseIniRtcRecord *r);

void PARSEINI2_JMPTBL_CLOCK_ConvertAmigaSecondsToClockData(
        long seconds, struct AmigaClockData *out)
{
    CLOCK_ConvertAmigaSecondsToClockData(seconds, out);
}

void PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(struct ParseIniClockData *c)
{
    ESQ_CalcDayOfYearFromMonthDay(c);
}

long PARSEINI2_JMPTBL_CLOCK_CheckDateOrSecondsFromEpoch(
        struct ParseIniRtcRecord *r)
{
    return CLOCK_CheckDateOrSecondsFromEpoch(r);
}

long PARSEINI2_JMPTBL_BATTCLOCK_GetSecondsFromBatteryBackedClock(void)
{
    return BATTCLOCK_GetSecondsFromBatteryBackedClock();
}

long PARSEINI2_JMPTBL_DATETIME_IsLeapYear(long year)
{
    return DATETIME_IsLeapYear(year);
}

void PARSEINI2_JMPTBL_BATTCLOCK_WriteSecondsToBatteryBackedClock(long seconds)
{
    BATTCLOCK_WriteSecondsToBatteryBackedClock(seconds);
}

long PARSEINI2_JMPTBL_CLOCK_SecondsFromEpoch(struct ParseIniRtcRecord *r)
{
    return CLOCK_SecondsFromEpoch(r);
}
