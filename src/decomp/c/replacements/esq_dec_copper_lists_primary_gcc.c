#include <stdint.h>

extern uint16_t ESQ_CopperStatusDigitsA[];
extern uint16_t ESQ_CopperStatusDigitsB[];

uint16_t ESQ_DecColorStep(uint16_t color);

void ESQ_DecCopperListsPrimary(void) {
    uint8_t *a = (uint8_t *)ESQ_CopperStatusDigitsA;
    uint8_t *b = (uint8_t *)ESQ_CopperStatusDigitsB;
    int16_t off = 0;
    int16_t i;

    for (i = 0; i <= 7; i++) {
        uint16_t v = *(uint16_t *)(a + off);
        v = ESQ_DecColorStep(v);
        *(uint16_t *)(a + off) = v;
        *(uint16_t *)(b + off) = v;
        off = (int16_t)(off + 4);
    }

    for (i = 0; i <= 23; i++) {
        uint16_t v = *(uint16_t *)(a + off);
        v = ESQ_DecColorStep(v);
        *(uint16_t *)(a + off) = v;
        off = (int16_t)(off + 4);
    }
}
