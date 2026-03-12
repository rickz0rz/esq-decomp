void ESQ_WriteDecFixedWidth(char *outBuf, long value, long digits)
{
    register short count;
    register short currentValue;
    register char *p;

    p = outBuf + digits;
    *p = '\0';
    count = (short)(digits - 1);
    currentValue = (short)value;

    do {
        *--p = (char)((short)(currentValue % 10) + '0');
        currentValue = (short)(currentValue / 10);
    } while (count-- != 0);
}
