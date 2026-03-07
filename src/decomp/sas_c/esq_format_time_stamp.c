void ESQ_FormatTimeStamp(char *outBuf, void *timePtr)
{
    const LONG OUTBUF_END_OFFSET = 0x0B;
    const LONG TIME_HOUR_OFFSET = 8;
    const LONG TIME_MINUTE_OFFSET = 10;
    const LONG TIME_SECOND_OFFSET = 12;
    const LONG TIME_AMPM_OFFSET = 18;
    const short BASE10 = 10;
    const char CH_NUL = '\0';
    const char CH_M = 'M';
    const char CH_P = 'P';
    const char CH_A = 'A';
    const char CH_SPACE = ' ';
    const char CH_COLON = ':';
    const char CH_0 = '0';
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
    p = outBuf + OUTBUF_END_OFFSET;

    *p = CH_NUL;
    *--p = CH_M;

    ampm = *(short *)(t + TIME_AMPM_OFFSET);
    if (ampm < 0) {
        *--p = CH_P;
    } else {
        *--p = CH_A;
    }

    *--p = CH_SPACE;

    second = *(short *)(t + TIME_SECOND_OFFSET);
    q = (short)(second / BASE10);
    r = (short)(second % BASE10);
    tens = (char)(q + CH_0);
    ones = (char)(r + CH_0);
    *--p = ones;
    *--p = tens;

    *--p = CH_COLON;

    minute = *(short *)(t + TIME_MINUTE_OFFSET);
    q = (short)(minute / BASE10);
    r = (short)(minute % BASE10);
    tens = (char)(q + CH_0);
    ones = (char)(r + CH_0);
    *--p = ones;
    *--p = tens;

    *--p = CH_COLON;

    hour = *(short *)(t + TIME_HOUR_OFFSET);
    q = (short)(hour / BASE10);
    r = (short)(hour % BASE10);
    ones = (char)(r + CH_0);
    *--p = ones;

    if (q == 0) {
        *--p = CH_SPACE;
    } else {
        *--p = (char)(q + CH_0);
    }
}
