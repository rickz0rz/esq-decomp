#include <exec/types.h>
extern LONG SCRIPT_ReadHandshakeBit3Flag(void);

LONG ESQFUNC_JMPTBL_SCRIPT_ReadCiaBBit3Flag(void)
{
    return SCRIPT_ReadHandshakeBit3Flag();
}
