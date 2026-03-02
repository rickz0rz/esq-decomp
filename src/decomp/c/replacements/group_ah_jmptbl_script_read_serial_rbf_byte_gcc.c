#include "esq_types.h"

/*
 * Target 256 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_ReadNextRbfByte.
 */
void SCRIPT_ReadNextRbfByte(void) __attribute__((noinline));

void GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void) __attribute__((noinline, used));

void GROUP_AH_JMPTBL_SCRIPT_ReadSerialRbfByte(void)
{
    SCRIPT_ReadNextRbfByte();
}
