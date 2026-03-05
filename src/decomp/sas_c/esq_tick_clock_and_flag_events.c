extern short CLOCK_MinuteTrigger30MinusBase;
extern short CLOCK_MinuteTrigger60MinusBase;
extern short CLOCK_MinuteTriggerBaseOffsetPlus30;
extern short CLOCK_MinuteTriggerBaseOffset;

typedef struct {
    short day_of_week;
    short month_index;
    short day_of_month;
    short year;
    short hour;
    short minute;
    short second;
    short f0e;
    short day_of_year;
    short am_pm_flag;
    short leap_flag;
} ClockFields;

extern void ESQ_UpdateMonthDayFromDayOfYear(ClockFields *time_ptr);

short ESQ_TickClockAndFlagEvents(ClockFields *time_ptr)
{
    short status = 0;

    if (time_ptr->second >= 60) {
        short v;
        short one = 1;
        short zero = 0;

        time_ptr->second = (short)(time_ptr->second - 60);
        status = 1;

        v = (short)(time_ptr->minute + one);
        time_ptr->minute = v;

        if (v == 30) {
            status = 2;
            return status;
        }

        if (v >= 60) {
            time_ptr->minute = zero;
            status = 2;

            v = (short)(time_ptr->hour + one);
            time_ptr->hour = v;
            if (v >= 12) {
                if (v != 12) {
                    time_ptr->hour = one;
                    return status;
                }

                time_ptr->am_pm_flag ^= (short)-1;
                if (time_ptr->am_pm_flag >= 0) {
                    v = (short)(time_ptr->day_of_week + one);
                    time_ptr->day_of_week = v;
                    if (v == 7) {
                        time_ptr->day_of_week = zero;
                    }

                    v = (short)(time_ptr->day_of_year + one);
                    time_ptr->day_of_year = v;

                    {
                        short limit = 0x016E;
                        if (time_ptr->leap_flag != 0) {
                            limit = (short)(limit + one);
                        }
                        if (v >= limit) {
                            short year = (short)(time_ptr->year + one);
                            short leap = zero;
                            time_ptr->year = year;
                            time_ptr->day_of_year = one;
                            if (((unsigned short)year & 3u) == 0u) {
                                leap = (short)-1;
                            }
                            time_ptr->leap_flag = leap;
                        }
                    }

                    ESQ_UpdateMonthDayFromDayOfYear(time_ptr);
                }
            }

            return status;
        }

        if (v == CLOCK_MinuteTriggerBaseOffset || v == CLOCK_MinuteTriggerBaseOffsetPlus30) {
            status = 5;
            return status;
        }

        if (v == 20 || v == 50) {
            status = 4;
            return status;
        }

        if (v == CLOCK_MinuteTrigger30MinusBase || v == CLOCK_MinuteTrigger60MinusBase) {
            status = 3;
            return status;
        }
    }

    return status;
}
