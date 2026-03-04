typedef unsigned char UBYTE;

UBYTE Test_ToUpperChar(UBYTE c)
{
    if (c >= 'a' && c <= 'z') {
        c = (UBYTE)(c - ('a' - 'A'));
    }
    return c;
}
