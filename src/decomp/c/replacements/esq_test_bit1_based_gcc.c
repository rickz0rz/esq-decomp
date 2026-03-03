#include <stdint.h>

int32_t ESQ_TestBit1Based(const uint8_t *base, uint32_t bit_index) {
    uint32_t n = bit_index - 1u;
    uint32_t bit_i = n & 7u;
    uint32_t byte_i = (uint16_t)n >> 3;

    return (base[byte_i] & (uint8_t)(1u << bit_i)) ? -1 : 0;
}
