#include <stdint.h>

uint16_t ESQ_BumpColorTowardTargets(uint16_t color, const uint8_t *targets) {
    uint16_t high = color & 0x0F00u;
    uint16_t mid = color & 0x00F0u;
    uint16_t low = color & 0x000Fu;

    uint16_t target = (uint16_t)(*targets++) << 8;
    if (high != target) {
        high += 0x0100u;
    }

    target = (uint16_t)(*targets++) << 4;
    if (mid != target) {
        mid += 0x0010u;
    }

    target = (uint16_t)(*targets++);
    if (low != target) {
        low += 0x0001u;
    }

    return (uint16_t)(high + mid + low);
}
