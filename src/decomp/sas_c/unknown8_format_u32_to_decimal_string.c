typedef unsigned long ULONG;

extern ULONG MATH_DivU32(ULONG dividend, ULONG divisor);

ULONG FORMAT_U32ToDecimalString(char *out, ULONG value)
{
    char tmp[12];
    char *p = tmp;
    char *start = p;

    do {
        ULONG q = MATH_DivU32(value, 10);
        ULONG rem = value - q * 10;
        *p++ = (char)('0' + rem);
        value = q;
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
