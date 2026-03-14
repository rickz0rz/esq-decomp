#include <exec/types.h>
LONG ESQIFF2_ValidateAsciiNumericByte(BYTE value)
{
    LONG d0 = 1;
    BYTE d7 = value;

    if (d7 >= 1 && d7 <= 48) {
        d0 = (LONG)d7;
    }

    return d0;
}
