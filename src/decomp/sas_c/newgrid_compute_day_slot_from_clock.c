typedef signed long LONG;
typedef signed short WORD;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

typedef struct NEWGRID_ClockScratch {
    ULONG word0;
    ULONG word1;
    ULONG word2;
    ULONG word3;
    ULONG word4;
    UWORD word10;
} NEWGRID_ClockScratch;

extern WORD NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(void *clockPtr);

LONG NEWGRID_ComputeDaySlotFromClock(void *clockPtr)
{
    NEWGRID_ClockScratch scratch;
    LONG slot;
    WORD minute;
    ULONG *src32;
    ULONG *dst32;
    LONG i;

    src32 = (ULONG *)clockPtr;
    dst32 = (ULONG *)&scratch;
    for (i = 0; i < 5; ++i) {
        dst32[i] = src32[i];
    }

    scratch.word10 = *((UWORD *)((UBYTE *)clockPtr + 20));

    slot = (UWORD)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&scratch);
    minute = (WORD)scratch.word10;

    if ((minute >= 50) || ((minute >= 20) && (minute <= 29))) {
        slot += 1;
        if (slot > 48) {
            slot = 1;
        }
    }

    return slot;
}
