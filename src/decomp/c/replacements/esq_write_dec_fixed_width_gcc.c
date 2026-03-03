#include <stdint.h>

void ESQ_WriteDecFixedWidth(char *out_buf, int32_t value, int32_t digits) {
    int16_t remaining = (int16_t)digits;
    int16_t counter;
    int16_t q;
    int16_t r;

    out_buf += remaining;
    *out_buf = '\0';

    counter = (int16_t)(remaining - 1);
    do {
        r = (int16_t)(value % 10);
        q = (int16_t)(value / 10);
        *--out_buf = (char)(r + '0');
        value = q;
    } while (counter-- != 0);
}
