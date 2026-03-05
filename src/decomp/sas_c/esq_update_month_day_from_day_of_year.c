extern unsigned short CLOCK_MonthLengths[];

void ESQ_UpdateMonthDayFromDayOfYear(void *timePtr)
{
    unsigned char *p;
    unsigned short dayOfYear;
    unsigned short month;
    unsigned short leap;
    unsigned short *table;
    unsigned short mlen;

    p = (unsigned char *)timePtr;
    dayOfYear = *(unsigned short *)(p + 16);
    month = 0;

    table = CLOCK_MonthLengths;
    leap = *(unsigned short *)(p + 20);
    if (leap != 0) {
        table = (unsigned short *)((unsigned char *)table + 0x18);
    }

    for (;;) {
        mlen = *table++;
        if (dayOfYear <= mlen) {
            break;
        }
        dayOfYear = (unsigned short)(dayOfYear - mlen);
        month = (unsigned short)(month + 1);
    }

    *(unsigned short *)(p + 2) = month;
    *(unsigned short *)(p + 4) = dayOfYear;
}
