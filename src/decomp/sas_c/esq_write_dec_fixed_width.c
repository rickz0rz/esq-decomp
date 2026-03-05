void ESQ_WriteDecFixedWidth(char *outBuf, long value, long digits)
{
    unsigned short n;
    short v;
    short rem;
    char *p;

    n = (unsigned short)digits;
    p = outBuf + n;
    *p = '\0';

    if (n == 0) {
        return;
    }

    n--;
    v = (short)value;

    for (;;) {
        rem = (short)(v % 10);
        *--p = (char)(rem + '0');
        v = (short)(v / 10);

        if (n == 0) {
            break;
        }
        n--;
    }
}
