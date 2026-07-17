#include <exec/types.h>
UWORD __stdargs TESTFN(UBYTE *src)
{
    UWORD r, g, b;
    r = (UWORD)(*src++ & 0x0F);
    g = (UWORD)(*src++ & 0x0F);
    b = (UWORD)(*src++ & 0x0F);
    return (UWORD)((r << 8) + (g << 4) + b);
}
