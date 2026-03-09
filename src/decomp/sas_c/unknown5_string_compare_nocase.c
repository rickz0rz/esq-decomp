typedef signed long LONG;
typedef unsigned char UBYTE;

LONG STRING_CompareNoCase(const char *a, const char *b)
{
    UBYTE ca;
    UBYTE cb;

    for (;;) {
        ca = *a++;
        cb = *b++;

        if (ca >= 'a' && ca <= 'z') {
            ca = (UBYTE)(ca - 0x20);
        }
        if (cb >= 'a' && cb <= 'z') {
            cb = (UBYTE)(cb - 0x20);
        }

        if ((LONG)ca - (LONG)cb != 0) {
            return (LONG)ca - (LONG)cb;
        }

        if (cb == 0) {
            return 0;
        }
    }
}
