typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern const UBYTE Global_CharClassTable[];

char *STRING_ToUpperInPlace(char *s)
{
    char *p;

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
