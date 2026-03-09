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

void ESQ_CalcDayOfYearFromMonthDay(void *timePtr)
{
    ESQ_TimeFields *p;
    unsigned short month;
    unsigned short day;
    unsigned short leap;
    unsigned short total;
    unsigned short i;
    unsigned short *table;

    p = (ESQ_TimeFields *)timePtr;
    month = p->month;
    day = p->day;
    leap = p->leapYearFlag;

    table = CLOCK_MonthLengths;
    if (leap != 0) {
        table = (unsigned short *)((unsigned char *)table + 0x18);
    }

    total = 0;
    for (i = 0; i < month; i++) {
        total = (unsigned short)(total + table[i]);
    }

    total = (unsigned short)(total + day);
    p->dayOfYear = total;
}
