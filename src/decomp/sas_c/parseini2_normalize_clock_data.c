typedef signed long LONG;
typedef short WORD;

struct ClockNormData {
    WORD w0;
    WORD w1;
    WORD w2;
    WORD w3;
    WORD w4;
    WORD w5;
    WORD w6;
    WORD w7;
    WORD w8;
    WORD w9;
    WORD w10;
};

extern WORD PARSEINI2_JMPTBL_DATETIME_IsLeapYear(LONG year);
extern void PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(struct ClockNormData *clockData);

void PARSEINI_NormalizeClockData(struct ClockNormData *dstClockData, struct ClockNormData *srcClockData)
{
    int i;

    for (i = 0; i < 11; ++i) {
        ((WORD *)dstClockData)[i] = ((WORD *)srcClockData)[i];
    }

    if (dstClockData->w3 < 1900) {
        dstClockData->w3 = (WORD)(dstClockData->w3 + 1900);
    }

    if (dstClockData->w4 >= 12) {
        dstClockData->w9 = (WORD)-1;
    } else {
        dstClockData->w9 = 0;
    }

    if (dstClockData->w4 == 0) {
        dstClockData->w4 = 12;
    }
    if (dstClockData->w4 > 12) {
        dstClockData->w4 = (WORD)(dstClockData->w4 - 12);
    }

    dstClockData->w2 = (WORD)(dstClockData->w2 + 1);

    if (PARSEINI2_JMPTBL_DATETIME_IsLeapYear((LONG)dstClockData->w3) != 0) {
        dstClockData->w10 = (WORD)-1;
    } else {
        dstClockData->w10 = 0;
    }

    PARSEINI2_JMPTBL_ESQ_CalcDayOfYearFromMonthDay(dstClockData);
}
