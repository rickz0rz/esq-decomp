#include <stdint.h>

extern uint16_t ESQ_CopperStatusDigitsA[];
extern uint16_t ESQ_CopperStatusDigitsB[];

void ESQ_MoveCopperEntryTowardStart(int32_t dst_index, int32_t src_index) {
    int16_t d1 = (int16_t)(dst_index & 0x1F);
    int16_t d2 = (int16_t)(src_index & 0x1F);
    int16_t d4 = 0x001C;
    uint8_t *a1 = (uint8_t *)ESQ_CopperStatusDigitsA;
    uint8_t *a0 = (uint8_t *)ESQ_CopperStatusDigitsB;

    d1 = (int16_t)(d1 << 2);
    d2 = (int16_t)(d2 << 2);

    int16_t d3 = (int16_t)(d2 - 4);
    uint16_t keep = *(uint16_t *)(a1 + d2);

    while (d2 >= d1) {
        uint16_t moved = *(uint16_t *)(a1 + d3);
        *(uint16_t *)(a1 + d2) = moved;
        if (d2 <= d4) {
            *(uint16_t *)(a0 + d2) = moved;
        }
        d2 = (int16_t)(d2 - 4);
        d3 = (int16_t)(d3 - 4);
    }

    *(uint16_t *)(a1 + d1) = keep;
    if (d2 < d4) {
        *(uint16_t *)(a0 + d1) = keep;
    }
}
