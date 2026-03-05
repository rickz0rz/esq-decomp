typedef signed char BYTE;
typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE WDISP_CharClassTable[];

LONG LADFUNC_ParseHexDigit(BYTE ch)
{
    LONG v;

    v = (LONG)ch;
    if ((WDISP_CharClassTable[v] & (1u << 2)) != 0) {
        return v - 48;
    }

    if ((WDISP_CharClassTable[v] & (1u << 7)) != 0) {
        if ((WDISP_CharClassTable[v] & (1u << 1)) != 0) {
            v -= 32;
        }
        return v - 55;
    }

    return 0;
}
