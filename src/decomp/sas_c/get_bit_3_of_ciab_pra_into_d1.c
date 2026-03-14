#include <exec/types.h>
WORD GET_BIT_3_OF_CIAB_PRA_INTO_D1(void)
{
    volatile UBYTE *ciabPra;
    UBYTE v;

    ciabPra = (volatile UBYTE *)0x00BFE001UL;
    v = *ciabPra;

    if ((v & 8) == 0) {
        return (WORD)-1;
    }
    return 0;
}
