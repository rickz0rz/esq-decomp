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

extern LONG GCOMMAND_MplexClockOffsetMinutes;
extern WORD NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(void *clockPtr);

LONG NEWGRID_ComputeDaySlotFromClockWithOffset(void *clockPtr)
{
    const LONG CLOCK_COPY_WORDS32 = 5;
    const LONG MINUTES_PER_HOUR = 60;
    const LONG HALF_HOUR_MARK = 30;
    const LONG LOWER_HALF_MAX = 29;
    const LONG SLOT_STEP = 1;
    const LONG SLOT_LAST = 48;
    const LONG SLOT_FIRST = 1;
    NEWGRID_ClockScratch scratch;
    LONG slot;
    LONG offsetMinutes;
    LONG upperThreshold;
    LONG lowerThreshold;
    LONG minute;
    ULONG *src32;
    ULONG *dst32;
    LONG i;

    src32 = (ULONG *)clockPtr;
    dst32 = (ULONG *)&scratch;
    for (i = 0; i < CLOCK_COPY_WORDS32; ++i) {
        dst32[i] = src32[i];
    }
    scratch.word10 = ((NEWGRID_ClockView *)clockPtr)->minute;

    slot = (UWORD)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&scratch);

    offsetMinutes = GCOMMAND_MplexClockOffsetMinutes;
    minute = (WORD)scratch.word10;

    upperThreshold = MINUTES_PER_HOUR - offsetMinutes;
    if (minute >= upperThreshold) {
        slot += SLOT_STEP;
        if (slot > SLOT_LAST) {
            slot = SLOT_FIRST;
        }
        return slot;
    }

    lowerThreshold = HALF_HOUR_MARK - offsetMinutes;
    if (minute >= lowerThreshold) {
        if (minute <= LOWER_HALF_MAX) {
            slot += SLOT_STEP;
            if (slot > SLOT_LAST) {
                slot = SLOT_FIRST;
            }
        }
    }

    return slot;
}
