#include <stdint.h>

extern uint16_t ESQ_CopperStatusDigitsA[];
extern uint16_t ESQ_CopperStatusDigitsB[];

void ESQ_MoveCopperEntryTowardEnd(int32_t src_index, int32_t dst_index) {
    int16_t d1 = (int16_t)(src_index & 0x1F);
    int16_t d2 = (int16_t)(dst_index & 0x1F);
    int16_t d4 = 0x0020;
    uint8_t *a1 = (uint8_t *)ESQ_CopperStatusDigitsA;
    uint8_t *a0 = (uint8_t *)ESQ_CopperStatusDigitsB;

    d1 = (int16_t)(d1 << 2);
    d2 = (int16_t)(d2 << 2);

    int16_t d3 = (int16_t)(d1 + 4);
    uint16_t keep = *(uint16_t *)(a1 + d1);

    while (d1 < d2) {
        uint16_t moved = *(uint16_t *)(a1 + d3);
        *(uint16_t *)(a1 + d1) = moved;
        if (d1 < d4) {
            *(uint16_t *)(a0 + d1) = moved;
        }
        d1 = (int16_t)(d1 + 4);
        d3 = (int16_t)(d3 + 4);
    }

    *(uint16_t *)(a1 + d1) = keep;
    if (d1 < d4) {
        *(uint16_t *)(a0 + d1) = keep;
    }
}
