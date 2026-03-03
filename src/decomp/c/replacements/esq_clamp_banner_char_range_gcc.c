#include <stdint.h>

extern int16_t WDISP_BannerCharRangeStart;
extern int16_t WDISP_BannerCharRangeEnd;

void ESQ_ClampBannerCharRange(int32_t value0, int32_t value1, int32_t value2) {
    int16_t d0 = (int16_t)value0;
    int16_t d1 = (int16_t)value1;
    int16_t d2 = (int16_t)value2;
    int16_t d3;
    int16_t d4;

    if (d1 < 65) {
        d1 = 65;
    } else if (d1 >= 67) {
        d1 = 65;
    }

    if (d2 < 65 || d2 > 73) {
        d2 = 69;
    }

    d1 = (int16_t)(d1 - 65);
    d2 = (int16_t)(d2 - 65);
    d2 = (int16_t)(d2 + 1);

    d4 = 48;
    d3 = d0;

    if (d1 != 0) {
        d0 = (int16_t)(d0 - d1);
        if (d0 < 1) {
            d0 = (int16_t)(d0 + d4);
        }
    }

    d3 = (int16_t)(d3 + d2);
    if (d3 > d4) {
        d3 = (int16_t)(d3 - d4);
    }

    WDISP_BannerCharRangeStart = d0;
    WDISP_BannerCharRangeEnd = d3;
}
