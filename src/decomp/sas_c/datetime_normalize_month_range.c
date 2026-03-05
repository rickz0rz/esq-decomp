typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

LONG DATETIME_NormalizeMonthRange(void *ctx)
{
    UBYTE *p = (UBYTE *)ctx;
    WORD month = *(WORD *)(p + 8);
    WORD overflow = (month > 11) ? (WORD)-1 : (WORD)0;
    WORD rem;

    *(WORD *)(p + 18) = overflow;

    rem = (WORD)(month % 12);
    *(WORD *)(p + 8) = rem;

    if (rem == 0) {
        *(WORD *)(p + 8) = 12;
    }

    return (LONG)rem;
}
