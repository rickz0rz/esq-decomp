#include <stdint.h>

void ESQ_ReverseBitsIn6Bytes(uint8_t *dst, const uint8_t *src) {
    int16_t i;

    for (i = 0; i < 6; ++i) {
        uint8_t b = *src++;

        if (b != 0 && b != 0xFFu) {
            uint8_t r = 0;
            uint8_t bit;
            for (bit = 0; bit < 8; ++bit) {
                if (b & (uint8_t)(1u << (7u - bit))) {
                    r = (uint8_t)(r | (uint8_t)(1u << bit));
                }
            }
            b = r;
        }

        *dst++ = b;
    }
}
