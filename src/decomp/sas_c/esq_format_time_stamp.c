void ESQ_FormatTimeStamp(char *outBuf, void *timePtr)
{
    unsigned char *t;
    char *p;
    short hour;
    short minute;
    short second;
    short ampm;
    short q;
    short r;
    char tens;
    char ones;

    t = (unsigned char *)timePtr;
    p = outBuf + 0x0B;

    *p = '\0';
    *--p = 'M';

    ampm = *(short *)(t + 18);
    if (ampm < 0) {
        *--p = 'P';
    } else {
        *--p = 'A';
    }

    *--p = ' ';

    second = *(short *)(t + 12);
    q = (short)(second / 10);
    r = (short)(second % 10);
    tens = (char)(q + '0');
    ones = (char)(r + '0');
    *--p = ones;
    *--p = tens;

    *--p = ':';

    minute = *(short *)(t + 10);
    q = (short)(minute / 10);
    r = (short)(minute % 10);
    tens = (char)(q + '0');
    ones = (char)(r + '0');
    *--p = ones;
    *--p = tens;

    *--p = ':';

    hour = *(short *)(t + 8);
    q = (short)(hour / 10);
    r = (short)(hour % 10);
    ones = (char)(r + '0');
    *--p = ones;

    if (q == 0) {
        *--p = ' ';
    } else {
        *--p = (char)(q + '0');
    }
}
