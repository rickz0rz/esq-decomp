#include <stdint.h>

extern void ESQ_SetCopperEffectParams(uint8_t a, uint8_t b);

void ESQ_SetCopperEffect_Default(void) {
    ESQ_SetCopperEffectParams(0, 0x3F);
}

