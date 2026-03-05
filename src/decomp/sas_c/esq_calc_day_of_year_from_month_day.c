extern unsigned short CLOCK_MonthLengths[];

void ESQ_CalcDayOfYearFromMonthDay(void *timePtr)
{
    unsigned char *p;
    unsigned short month;
    unsigned short day;
    unsigned short leap;
    unsigned short total;
    unsigned short i;
    unsigned short *table;

    p = (unsigned char *)timePtr;
    month = *(unsigned short *)(p + 2);
    day = *(unsigned short *)(p + 4);
    leap = *(unsigned short *)(p + 20);

    table = CLOCK_MonthLengths;
    if (leap != 0) {
        table = (unsigned short *)((unsigned char *)table + 0x18);
    }

    total = 0;
    for (i = 0; i < month; i++) {
        total = (unsigned short)(total + table[i]);
    }

    total = (unsigned short)(total + day);
    *(unsigned short *)(p + 16) = total;
}
