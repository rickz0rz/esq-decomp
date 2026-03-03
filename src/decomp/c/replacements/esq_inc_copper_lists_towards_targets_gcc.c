#include <stdint.h>

extern uint8_t WDISP_PaletteTriplesRBase[];
extern uint16_t ESQ_CopperStatusDigitsA[];
extern uint16_t ESQ_CopperStatusDigitsB[];

uint16_t ESQ_BumpColorTowardTargets(uint16_t color, const uint8_t *targets);

void ESQ_IncCopperListsTowardsTargets(void) {
    uint8_t *targets = WDISP_PaletteTriplesRBase;
    uint8_t *a = (uint8_t *)ESQ_CopperStatusDigitsA;
    uint8_t *b = (uint8_t *)ESQ_CopperStatusDigitsB;
    int16_t off = 0;
    int16_t i;

    for (i = 0; i <= 7; i++) {
        uint16_t v = *(uint16_t *)(a + off);
        v = ESQ_BumpColorTowardTargets(v, targets);
        *(uint16_t *)(a + off) = v;
        *(uint16_t *)(b + off) = v;
        off = (int16_t)(off + 4);
        targets += 3;
    }

    for (i = 0; i <= 23; i++) {
        uint16_t v = *(uint16_t *)(a + off);
        v = ESQ_BumpColorTowardTargets(v, targets);
        *(uint16_t *)(a + off) = v;
        off = (int16_t)(off + 4);
        targets += 3;
    }
}
