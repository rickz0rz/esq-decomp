#include <stdint.h>

extern int16_t CLOCK_MonthLengths[];

typedef struct {
    int16_t f00;
    int16_t month_index;
    int16_t day_of_month;
    int16_t f06;
    int16_t f08;
    int16_t f0a;
    int16_t f0c;
    int16_t f0e;
    int16_t day_of_year;
    int16_t f12;
    int16_t leap_flag;
} ClockFields;

void ESQ_UpdateMonthDayFromDayOfYear(ClockFields *time_ptr) {
    int16_t day = time_ptr->day_of_year;
    int16_t month = 0;
    int16_t *table = CLOCK_MonthLengths;

    if (time_ptr->leap_flag != 0) {
        table = (int16_t *)((uint8_t *)table + 24);
    }

    for (;;) {
        int16_t span = *table++;
        if (day <= span) {
            break;
        }
        day = (int16_t)(day - span);
        month = (int16_t)(month + 1);
    }

    time_ptr->month_index = month;
    time_ptr->day_of_month = day;
}
