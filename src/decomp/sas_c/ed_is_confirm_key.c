#include <exec/types.h>
extern UBYTE ED_LastKeyCode;

LONG ED_IsConfirmKey(void)
{
    LONG d0;
    LONG d7;

    d0 = (LONG)ED_LastKeyCode;
    d0 -= 0x59;

    if (d0 == 0) {
        d7 = 0;
    } else {
        d0 -= 0x20;
        if (d0 != 0) {
            d7 = 1;
        } else {
            d7 = 0;
        }
    }

    return d7;
}
