extern unsigned short CLOCK_MonthLengths[];

typedef struct ESQ_TimeFields {
    unsigned char pad0[2];
    unsigned short month;
    unsigned short day;
    unsigned char pad6[10];
    unsigned short dayOfYear;
    unsigned char pad18[2];
    unsigned short leapYearFlag;
} ESQ_TimeFields;

void ESQ_UpdateMonthDayFromDayOfYear(void *timePtr)
{
    ESQ_TimeFields *p;
    unsigned short dayOfYear;
    unsigned short month;
    unsigned short leap;
    unsigned short *table;
    unsigned short mlen;

    p = (ESQ_TimeFields *)timePtr;
    dayOfYear = p->dayOfYear;
    month = 0;

    table = CLOCK_MonthLengths;
    leap = p->leapYearFlag;
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

    p->month = month;
    p->day = dayOfYear;
}
