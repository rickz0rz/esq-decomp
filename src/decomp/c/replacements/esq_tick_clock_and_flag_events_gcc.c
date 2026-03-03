#include <stdint.h>

extern int16_t CLOCK_MinuteTrigger30MinusBase;
extern int16_t CLOCK_MinuteTrigger60MinusBase;
extern int16_t CLOCK_MinuteTriggerBaseOffsetPlus30;
extern int16_t CLOCK_MinuteTriggerBaseOffset;

typedef struct {
    int16_t day_of_week;
    int16_t month_index;
    int16_t day_of_month;
    int16_t year;
    int16_t hour;
    int16_t minute;
    int16_t second;
    int16_t f0e;
    int16_t day_of_year;
    int16_t am_pm_flag;
    int16_t leap_flag;
} ClockFields;

void ESQ_UpdateMonthDayFromDayOfYear(ClockFields *time_ptr);

int16_t ESQ_TickClockAndFlagEvents(ClockFields *time_ptr) {
    int16_t status = 0;

    if (time_ptr->second >= 60) {
        int16_t v;
        int16_t one = 1;
        int16_t zero = 0;

        time_ptr->second = (int16_t)(time_ptr->second - 60);
        status = 1;

        v = (int16_t)(time_ptr->minute + one);
        time_ptr->minute = v;

        if (v == 30) {
            status = 2;
            return status;
        }

        if (v >= 60) {
            time_ptr->minute = zero;
            status = 2;

            v = (int16_t)(time_ptr->hour + one);
            time_ptr->hour = v;
            if (v >= 12) {
                if (v != 12) {
                    time_ptr->hour = one;
                    return status;
                }

                time_ptr->am_pm_flag ^= (int16_t)-1;
                if (time_ptr->am_pm_flag >= 0) {
                    v = (int16_t)(time_ptr->day_of_week + one);
                    time_ptr->day_of_week = v;
                    if (v == 7) {
                        time_ptr->day_of_week = zero;
                    }

                    v = (int16_t)(time_ptr->day_of_year + one);
                    time_ptr->day_of_year = v;

                    {
                        int16_t limit = 0x016E;
                        if (time_ptr->leap_flag != 0) {
                            limit = (int16_t)(limit + one);
                        }
                        if (v >= limit) {
                            int16_t year = (int16_t)(time_ptr->year + one);
                            int16_t leap = zero;
                            time_ptr->year = year;
                            time_ptr->day_of_year = one;
                            if (((uint16_t)year & 3u) == 0u) {
                                leap = (int16_t)-1;
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
