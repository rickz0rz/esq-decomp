#include <stdint.h>

extern uint16_t HIGHLIGHT_CopperEffectSeed;
extern uint8_t ESQ_CopperEffectTemplateRowsSet0[];
extern uint8_t ESQ_CopperEffectListA[];
extern uint8_t ESQ_CopperEffectListB[];

static uint32_t rol32(uint32_t v, unsigned n) {
    return (v << n) | (v >> (32u - n));
}

int16_t ESQ_UpdateCopperListsFromParams(void) {
    uint16_t d1 = *(uint16_t *)(ESQ_CopperEffectTemplateRowsSet0 + 26);
    uint32_t d0 = *(uint32_t *)&HIGHLIGHT_CopperEffectSeed;

    uint8_t *a0 = ESQ_CopperEffectListA + 6;
    uint8_t *a1 = ESQ_CopperEffectListB + 6;

    d0 = (d0 & 0xFFFFFF00u) | ((uint32_t)(((d0 & 0xFFu) << 1) & 0xFFu));
    d0 = (d0 & 0xFFFFFF00u) | ((uint32_t)(((d0 & 0xFFu) << 1) & 0xFFu));
    d0 = (d0 & 0xFFFF0000u) | ((uint32_t)(((d0 & 0xFFFFu) << 1) & 0xFFFFu));
    d0 = (d0 & 0xFFFF0000u) | ((uint32_t)(((d0 & 0xFFFFu) << 1) & 0xFFFFu));
    d0 = (d0 << 16) | (d0 >> 16);
    if ((d0 & 0xFFu) == 0) {
        d0 = 0;
    }

    d0 = rol32(d0, 5);

    {
        uint16_t d3 = (uint16_t)(d1 & (uint16_t)~0x0100u);
        uint16_t d4;
        for (d4 = 0; d4 <= 15; ++d4) {
            uint16_t d2 = (uint16_t)(0x0100u & (uint16_t)d0);
            d2 = (uint16_t)(d2 | d3);

            *(uint16_t *)(a0 + 0) = d2;
            *(uint16_t *)(a1 + 0) = d2;
            *(uint16_t *)(a0 + 4) = d2;
            *(uint16_t *)(a1 + 4) = d2;
            *(uint16_t *)(a0 + 136) = d2;
            *(uint16_t *)(a1 + 136) = d2;
            *(uint16_t *)(a0 + 140) = d2;
            *(uint16_t *)(a1 + 140) = d2;

            a0 += 8;
            a1 += 8;
            d0 = rol32(d0, 1);
        }
    }

    *(uint16_t *)(a0 + 0) = d1;
    *(uint16_t *)(a1 + 0) = d1;
    *(uint16_t *)(a0 + 136) = d1;
    *(uint16_t *)(a1 + 136) = d1;

    return 0;
}
