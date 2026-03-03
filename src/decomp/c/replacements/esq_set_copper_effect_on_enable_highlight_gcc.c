#include <stdint.h>

extern void ESQ_SetCopperEffectParams(uint8_t a, uint8_t b);
extern void GCOMMAND_EnableHighlight(void);

void ESQ_SetCopperEffect_OnEnableHighlight(void) {
    volatile uint8_t *const ciab_pra = (volatile uint8_t *)0x00BFE001UL;
    uint8_t v = *ciab_pra;
    v |= (uint8_t)((1u << 6) | (1u << 7));
    *ciab_pra = v;
    ESQ_SetCopperEffectParams(0x3F, 0);
    GCOMMAND_EnableHighlight();
}

