typedef unsigned short UWORD;

void ESQ_WriteDecFixedWidth(char *outBuf, long value, long digits)
{
    register UWORD count;
    register long currentValue;
    register char *p;

    p = outBuf + digits;
    *p = '\0';
    count = (UWORD)(digits - 1);
    currentValue = value;

    do {
        *--p = (char)(currentValue % 10 + '0');
        currentValue /= 10;
    } while (count-- != 0);
}
