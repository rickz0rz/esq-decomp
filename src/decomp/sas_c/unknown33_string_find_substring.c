typedef unsigned char UBYTE;

UBYTE *STRING_FindSubstring(UBYTE *haystack, const UBYTE *needle)
{
    UBYTE *start;
    const UBYTE *p;
    UBYTE *q;

    for (;;) {
        q = haystack;
        p = needle;

        for (;;) {
            if (*p == 0) {
                return haystack;
            }
            if (*q++ != *p++) {
                break;
            }
        }

        if (*q == 0) {
            return (UBYTE *)0;
        }

        haystack++;
        if (*haystack == 0) {
            return (UBYTE *)0;
        }

        start = haystack;
        (void)start;
    }
}
