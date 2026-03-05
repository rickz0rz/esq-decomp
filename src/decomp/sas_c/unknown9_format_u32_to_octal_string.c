typedef unsigned long ULONG;

ULONG FORMAT_U32ToOctalString(char *out, ULONG value)
{
    char tmp[12];
    char *p = tmp;
    char *start = p;

    do {
        ULONG digit = value & 7U;
        *p++ = (char)('0' + digit);
        value >>= 3;
    } while (value != 0);

    {
        char *end = p;
        while (p != start) {
            *out++ = *--p;
        }
        *out = '\0';
        return (ULONG)(end - start);
    }
}
