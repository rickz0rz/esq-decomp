#include <exec/types.h>
extern UBYTE CIAB_PRA;

LONG SCRIPT_ReadHandshakeBit5Mask(void)
{
    return (LONG)(CIAB_PRA & (UBYTE)0x20);
}
