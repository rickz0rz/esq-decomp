typedef unsigned char UBYTE;
typedef signed long LONG;

extern UBYTE WDISP_CharClassTable[];

LONG LOCAVAIL_MapFilterTokenCharToClass(UBYTE token)
{
    UBYTE cls = WDISP_CharClassTable[token];

    if ((cls & 0x04) != 0) {
        return (LONG)token - 48;
    }

    if ((cls & 0x03) == 0) {
        return 0;
    }

    if ((cls & 0x02) != 0) {
        return (LONG)token - 32 - 55;
    }

    return (LONG)token - 55;
}
