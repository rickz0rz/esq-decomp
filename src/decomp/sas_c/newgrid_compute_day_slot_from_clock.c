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

typedef struct NEWGRID_ClockView {
    ULONG word0;
    ULONG word1;
    ULONG word2;
    ULONG word3;
    ULONG word4;
    UWORD minute;
} NEWGRID_ClockView;

extern WORD ESQ_GetHalfHourSlotIndex(void *clockPtr);

LONG NEWGRID_ComputeDaySlotFromClock(void *clockPtr)
{
    const LONG CLOCK_COPY_WORDS32 = 5;
    const LONG MINUTE_ROUND_UP_HI = 50;
    const LONG MINUTE_ROUND_UP_LO_A = 20;
    const LONG MINUTE_ROUND_UP_LO_B = 29;
    const LONG SLOT_STEP = 1;
    const LONG SLOT_LAST = 48;
    const LONG SLOT_FIRST = 1;
    NEWGRID_ClockScratch scratch;
    LONG slot;
    WORD minute;
    ULONG *src32;
    ULONG *dst32;
    LONG i;

    src32 = (ULONG *)clockPtr;
    dst32 = (ULONG *)&scratch;
    for (i = 0; i < CLOCK_COPY_WORDS32; ++i) {
        dst32[i] = src32[i];
    }

    scratch.word10 = ((NEWGRID_ClockView *)clockPtr)->minute;

    slot = (UWORD)ESQ_GetHalfHourSlotIndex(&scratch);
    minute = (WORD)scratch.word10;

    if ((minute >= MINUTE_ROUND_UP_HI) || ((minute >= MINUTE_ROUND_UP_LO_A) && (minute <= MINUTE_ROUND_UP_LO_B))) {
        slot += SLOT_STEP;
        if (slot > SLOT_LAST) {
            slot = SLOT_FIRST;
        }
    }

    return slot;
}
