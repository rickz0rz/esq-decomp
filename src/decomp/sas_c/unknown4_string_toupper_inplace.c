typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern UBYTE Global_CharClassTable[];

UBYTE *STRING_ToUpperInPlace(UBYTE *s)
{
    UBYTE *p;

    p = s;
    while (*p != 0) {
        ULONG c;

        c = (ULONG)(*p);
        if ((Global_CharClassTable[c] & 0x02) != 0) {
            *p = (UBYTE)(c - 32);
        } else {
            *p = (UBYTE)c;
        }
        p++;
    }

    return s;
}
