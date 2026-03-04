typedef unsigned char UBYTE;

void *Test_MemMove(void *dst, const void *src, unsigned long len)
{
    UBYTE *d = (UBYTE *)dst;
    const UBYTE *s = (const UBYTE *)src;

    if (d == s || len == 0) {
        return dst;
    }

    if (d < s) {
        while (len--) {
            *d++ = *s++;
        }
    } else {
        d += len;
        s += len;
        while (len--) {
            *--d = *--s;
        }
    }

    return dst;
}
