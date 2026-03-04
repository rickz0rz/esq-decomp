typedef unsigned long ULONG;
typedef unsigned char UBYTE;

ULONG STRING_ToUpperChar(ULONG c)
{
    UBYTE ch = (UBYTE)c;

    if (ch >= 'a' && ch <= 'z') {
        ch = (UBYTE)(ch - 0x20);
    }

    return (ULONG)ch;
}
