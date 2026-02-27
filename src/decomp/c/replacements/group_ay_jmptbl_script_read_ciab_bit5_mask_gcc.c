#include "esq_types.h"

/*
 * Target 181 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_ReadHandshakeBit5Mask.
 */
void SCRIPT_ReadHandshakeBit5Mask(void) __attribute__((noinline));

void GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void) __attribute__((noinline, used));

void GROUP_AY_JMPTBL_SCRIPT_ReadCiaBBit5Mask(void)
{
    SCRIPT_ReadHandshakeBit5Mask();
}
