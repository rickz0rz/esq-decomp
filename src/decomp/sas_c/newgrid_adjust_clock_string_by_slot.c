typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ClockScratch {
    ULONG word0;
    ULONG word1;
    ULONG word2;
    ULONG word3;
    ULONG word4;
    UWORD word10;
} NEWGRID_ClockScratch;

extern UBYTE CLOCK_FormatVariantCode;
extern LONG DATETIME_NormalizeStructToSeconds(void *clockPtr);
extern LONG MATH_DivS32(LONG a, LONG b);
extern ULONG MATH_Mulu32(ULONG a, ULONG b);
extern void *DATETIME_SecondsToStruct(LONG seconds, void *clockPtr);
extern LONG NEWGRID_ComputeDaySlotFromClock(void *clockPtr);

LONG NEWGRID_AdjustClockStringBySlot(void *clockPtr)
{
    NEWGRID_ClockScratch scratch;
    LONG seconds;
    LONG slotDiv;
    UBYTE *src;
    UBYTE *dst;
    LONG i;

    src = (UBYTE *)clockPtr;
    dst = (UBYTE *)&scratch;
    for (i = 0; i < 22; ++i) {
        dst[i] = src[i];
    }

    seconds = DATETIME_NormalizeStructToSeconds(&scratch);
    slotDiv = MATH_DivS32((LONG)(UBYTE)CLOCK_FormatVariantCode, 30);
    seconds -= (LONG)MATH_Mulu32(60, (ULONG)slotDiv);

    DATETIME_SecondsToStruct(seconds, &scratch);
    return NEWGRID_ComputeDaySlotFromClock(&scratch);
}
