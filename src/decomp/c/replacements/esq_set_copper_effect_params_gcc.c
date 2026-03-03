#include <stdint.h>

extern uint8_t HIGHLIGHT_CopperEffectParamA;
extern uint8_t HIGHLIGHT_CopperEffectParamB;
extern int16_t HIGHLIGHT_CopperEffectSeed;

extern void ESQ_UpdateCopperListsFromParams(void);

void ESQ_SetCopperEffectParams(uint8_t a, uint8_t b) {
    HIGHLIGHT_CopperEffectParamA = a;
    HIGHLIGHT_CopperEffectParamB = b;
    HIGHLIGHT_CopperEffectSeed = 5;
    ESQ_UpdateCopperListsFromParams();
}

