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

void ESQ_CalcDayOfYearFromMonthDay(ClockFields *time_ptr) {
    int16_t month = time_ptr->month_index;
    int16_t sum = 0;
    int16_t *table = CLOCK_MonthLengths;
    int16_t i;

    if (time_ptr->leap_flag != 0) {
        table = (int16_t *)((uint8_t *)table + 24);
    }

    for (i = 0; i < month; ++i) {
        sum = (int16_t)(sum + table[i]);
    }

    sum = (int16_t)(sum + time_ptr->day_of_month);
    time_ptr->day_of_year = sum;
}
