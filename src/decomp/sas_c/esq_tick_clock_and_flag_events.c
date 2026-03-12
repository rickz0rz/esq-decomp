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
    short zero = 0;
    short one = 1;
    short sixty = 60;
    short value;
    short limit;

    if (time_ptr->second < sixty) {
        goto done;
    }

    time_ptr->second = (short)(time_ptr->second - sixty);
    status = one;

    value = (short)(time_ptr->minute + one);
    time_ptr->minute = value;

    if (value == 30) {
        status = 2;
        goto done;
    }

    if (value >= sixty) {
        time_ptr->minute = zero;
        status = 2;

        value = (short)(time_ptr->hour + one);
        time_ptr->hour = value;
        if (value >= 12) {
            if (value != 12) {
                time_ptr->hour = one;
                goto done;
            }

            time_ptr->am_pm_flag ^= (short)-1;
            if (time_ptr->am_pm_flag >= 0) {
                value = (short)(time_ptr->day_of_week + one);
                time_ptr->day_of_week = value;
                if (value == 7) {
                    time_ptr->day_of_week = zero;
                }

                value = (short)(time_ptr->day_of_year + one);
                time_ptr->day_of_year = value;
                limit = 0x016E;
                if (time_ptr->leap_flag != 0) {
                    limit = (short)(limit + one);
                }
                if (value >= limit) {
                    value = (short)(time_ptr->year + one);
                    time_ptr->year = value;
                    time_ptr->day_of_year = one;
                    time_ptr->leap_flag = zero;
                    if (((unsigned short)value & 3u) == 0u) {
                        time_ptr->leap_flag = (short)-1;
                    }
                }

                ESQ_UpdateMonthDayFromDayOfYear(time_ptr);
            }
        }

        goto done;
    }

    if (value == CLOCK_MinuteTriggerBaseOffset || value == CLOCK_MinuteTriggerBaseOffsetPlus30) {
        status = 5;
        goto done;
    }

    if (value == 20 || value == 50) {
        status = 4;
        goto done;
    }

    if (value == CLOCK_MinuteTrigger30MinusBase || value == CLOCK_MinuteTrigger60MinusBase) {
        status = 3;
    }

done:
    return status;
}
