#include "esq_types.h"

extern volatile u8 CIAB_PRA;

s32 SCRIPT_ReadHandshakeBit5Mask(void) __attribute__((noinline, used));

s32 SCRIPT_ReadHandshakeBit5Mask(void)
{
    u8 v = CIAB_PRA;
    return (s32)(v & 0x20u);
}
