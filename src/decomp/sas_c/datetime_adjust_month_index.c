typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

LONG DATETIME_AdjustMonthIndex(void *ctx)
{
    UBYTE *p = (UBYTE *)ctx;
    LONG month = (LONG)(WORD)(*(WORD *)(p + 8));
    LONG rem = month % 12;

    if (*(WORD *)(p + 18) != 0) {
        rem += 12;
    }

    *(WORD *)(p + 8) = (WORD)rem;
    return rem;
}
