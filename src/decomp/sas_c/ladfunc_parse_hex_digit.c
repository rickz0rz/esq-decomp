#include <exec/types.h>
enum {
    CHARCLASS_DECIMAL_DIGIT_BIT = 2,
    CHARCLASS_ALPHA_BIT = 7,
    CHARCLASS_LOWERCASE_BIT = 1,
    ASCII_ZERO = 48,
    ASCII_UPPERCASE_DELTA = 32,
    ASCII_HEX_ALPHA_BASE = 55
};

extern const UBYTE WDISP_CharClassTable[];

LONG LADFUNC_ParseHexDigit(BYTE ch)
{
    LONG code;

    code = (LONG)ch;
    if ((WDISP_CharClassTable[code] & (1u << CHARCLASS_DECIMAL_DIGIT_BIT)) != 0) {
        return code - ASCII_ZERO;
    }

    if ((WDISP_CharClassTable[code] & (1u << CHARCLASS_ALPHA_BIT)) != 0) {
        if ((WDISP_CharClassTable[code] & (1u << CHARCLASS_LOWERCASE_BIT)) != 0) {
            code -= ASCII_UPPERCASE_DELTA;
        }
        return code - ASCII_HEX_ALPHA_BASE;
    }

    return 0;
}
