typedef unsigned long ULONG;
typedef unsigned char UBYTE;

char *STRING_CopyPadNul(char *dst, const char *src, ULONG maxLen)
{
    char *ret;

    ret = dst;

    while (maxLen-- != 0) {
        *dst = *src;
        if (*src++ == 0) {
            while (maxLen-- != 0) {
                *++dst = 0;
            }
            return ret;
        }
        dst++;
    }

    return ret;
}
