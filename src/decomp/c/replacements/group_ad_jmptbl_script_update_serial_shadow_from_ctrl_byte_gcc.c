#include "esq_types.h"

/*
 * Target 152 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_UpdateSerialShadowFromCtrlByte.
 */
void SCRIPT_UpdateSerialShadowFromCtrlByte(void) __attribute__((noinline));

void GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(void) __attribute__((noinline, used));

void GROUP_AD_JMPTBL_SCRIPT_UpdateSerialShadowFromCtrlByte(void)
{
    SCRIPT_UpdateSerialShadowFromCtrlByte();
}
