#include <exec/types.h>
void ESQ_FormatTimeStamp(char *outBuf, void *timePtr)
{
    char *p;
    unsigned char *t;
    WORD hour;
    WORD minute;
    WORD second;
    WORD ampm;
    WORD q;
    WORD r;

    t = (unsigned char *)timePtr;
    p = outBuf + 0x0B;

    *p = '\0';
    *--p = 'M';

    ampm = *(WORD *)(t + 18);
    if (ampm < 0) {
        *--p = 'P';
    } else {
        *--p = 'A';
    }

    *--p = ' ';

    second = *(WORD *)(t + 12);
    q = (WORD)(second / 10);
    r = (WORD)(second % 10);
    *--p = (char)(r + '0');
    *--p = (char)(q + '0');

    *--p = ':';

    minute = *(WORD *)(t + 10);
    q = (WORD)(minute / 10);
    r = (WORD)(minute % 10);
    *--p = (char)(r + '0');
    *--p = (char)(q + '0');

    *--p = ':';

    hour = *(WORD *)(t + 8);
    q = (WORD)(hour / 10);
    r = (WORD)(hour % 10);
    *--p = (char)(r + '0');

    if (q == 0) {
        *--p = ' ';
    } else {
        *--p = (char)(q + '0');
    }
}
