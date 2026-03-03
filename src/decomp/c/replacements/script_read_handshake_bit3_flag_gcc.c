#include "esq_types.h"

extern volatile u8 CIAB_PRA;

s32 SCRIPT_ReadHandshakeBit3Flag(void) __attribute__((noinline, used));

s32 SCRIPT_ReadHandshakeBit3Flag(void)
{
    u8 v = CIAB_PRA;
    return ((v & 0x08u) != 0u) ? 1 : 0;
}
