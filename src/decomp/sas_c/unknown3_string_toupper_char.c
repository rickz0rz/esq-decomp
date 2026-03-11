typedef unsigned long ULONG;
typedef unsigned char UBYTE;

ULONG STRING_ToUpperChar(ULONG c)
{
    if ((UBYTE)c >= 'a' && (UBYTE)c <= 'z') {
        c -= 0x20;
    }

    return c;
}
