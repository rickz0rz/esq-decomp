#include <stdint.h>

uint8_t *ESQ_PackBitsDecode(uint8_t *src, uint8_t *dst, int32_t dst_len) {
    int16_t out_count = 0;
    int16_t limit = (int16_t)dst_len;

    while (out_count < limit) {
        int8_t run = (int8_t)*src++;
        if (run >= 0) {
            int16_t n = (int16_t)run + 1;
            while (n > 0) {
                *dst++ = *src++;
                out_count = (int16_t)(out_count + 1);
                if (out_count >= limit) {
                    return src;
                }
                n = (int16_t)(n - 1);
            }
        } else {
            if (run == -1) {
                continue;
            }
            {
                int16_t n = (int16_t)(-(int16_t)run + 1);
                uint8_t value = *src++;
                while (n > 0) {
                    *dst++ = value;
                    out_count = (int16_t)(out_count + 1);
                    if (out_count >= limit) {
                        return src;
                    }
                    n = (int16_t)(n - 1);
                }
            }
        }
    }

    return src;
}
