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
    NEWGRID_ClockScratch scratch;
    ULONG *src;
    ULONG *dst;
    WORD copyCount;
    LONG slot;
    LONG offsetMinutes;
    LONG minute;
    src = (ULONG *)clockPtr;
    dst = (ULONG *)&scratch;

    for (copyCount = 4; copyCount >= 0; --copyCount) {
        *dst++ = *src++;
    }

    scratch.word10 = *(UWORD *)src;

    slot = (UWORD)NEWGRID2_JMPTBL_ESQ_GetHalfHourSlotIndex(&scratch);
    offsetMinutes = GCOMMAND_MplexClockOffsetMinutes;
    minute = (WORD)scratch.word10;

    if (minute < 60 - offsetMinutes) {
        if (minute < 30 - offsetMinutes) {
            return slot;
        }

        if ((WORD)scratch.word10 > 29) {
            return slot;
        }
    }

    ++slot;
    if (slot > 48) {
        slot = 1;
    }

    return slot;
}
