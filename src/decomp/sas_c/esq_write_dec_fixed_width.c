typedef long LONG;
typedef short WORD;

void ESQ_WriteDecFixedWidth(char *outBuf, LONG value, LONG digits)
{
    WORD count;
    WORD currentValue;
    WORD quotient;
    WORD remainder;
    char *p;

    p = outBuf + digits;
    *p = '\0';
    count = (WORD)(digits - 1);
    currentValue = (WORD)value;

    do {
        quotient = (WORD)(currentValue / 10);
        remainder = (WORD)(currentValue % 10);
        *--p = (char)(remainder + '0');
        currentValue = quotient;
    } while (count-- != 0);
}
