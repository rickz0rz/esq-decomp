#include <stdint.h>

typedef struct {
    int16_t f00;
    int16_t f02;
    int16_t f04;
    int16_t f06;
    int16_t hour;
    int16_t minute;
    int16_t second;
    int16_t f0e;
    int16_t f10;
    int16_t am_pm_flag;
} TimeStampFields;

void ESQ_FormatTimeStamp(char *out_buf, const TimeStampFields *time_ptr) {
    int32_t v;

    out_buf += 11;
    *out_buf = '\0';
    *--out_buf = 'M';
    *--out_buf = (time_ptr->am_pm_flag < 0) ? 'P' : 'A';
    *--out_buf = ' ';

    v = time_ptr->second;
    *--out_buf = (char)('0' + (v % 10));
    *--out_buf = (char)('0' + (v / 10));
    *--out_buf = ':';

    v = time_ptr->minute;
    *--out_buf = (char)('0' + (v % 10));
    *--out_buf = (char)('0' + (v / 10));
    *--out_buf = ':';

    v = time_ptr->hour;
    *--out_buf = (char)('0' + (v % 10));
    if ((v / 10) == 0) {
        *--out_buf = ' ';
    } else {
        *--out_buf = (char)('0' + (v / 10));
    }
}
