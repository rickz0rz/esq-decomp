#include <stdint.h>

typedef struct {
    int16_t f00;
    int16_t f02;
    int16_t f04;
    int16_t f06;
    int16_t hour_12;
    int16_t minute;
    int16_t f0c;
    int16_t f0e;
    int16_t f10;
    int16_t am_pm_flag;
} TimeFields;

extern uint8_t CLOCK_HalfHourSlotLookup[];

int32_t ESQ_GetHalfHourSlotIndex(const TimeFields *time_ptr) {
    int16_t d0 = time_ptr->hour_12;

    if (time_ptr->am_pm_flag < 0) {
        d0 = (int16_t)(d0 + 12);
    } else if (d0 == 12) {
        d0 = 0;
    }

    if (d0 != 24) {
        d0 = (int16_t)(d0 + d0);
    }

    if (time_ptr->minute >= 30) {
        d0 = (int16_t)(d0 + 1);
    }

    return (int32_t)CLOCK_HalfHourSlotLookup[(uint16_t)d0];
}
