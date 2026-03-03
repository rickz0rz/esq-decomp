#include <stdint.h>

uint16_t ESQ_DecColorStep(uint16_t color) {
    uint16_t high = color & 0x0F00u;
    uint16_t mid = color & 0x00F0u;
    uint16_t low = color & 0x000Fu;

    if (high != 0) {
        high -= 0x0100u;
    }
    if (mid != 0) {
        mid -= 0x0010u;
    }
    if (low != 0) {
        low -= 0x0001u;
    }

    return (uint16_t)(high + mid + low);
}
