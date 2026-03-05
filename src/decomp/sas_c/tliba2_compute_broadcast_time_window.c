typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD CLOCK_CurrentDayOfWeekIndex[];
extern WORD TLIBA2_BroadcastWindowClockSnapshotA[];
extern UBYTE TEXTDISP_PrimaryGroupCode;

extern void TLIBA2_JMPTBL_DST_AddTimeOffset(WORD *clockData, LONG hourDelta, LONG minuteDelta);
extern LONG TLIBA2_ParseEntryTimeWindow(void *entryContext, LONG entryIndex, LONG *outPair);

void TLIBA2_ComputeBroadcastTimeWindow(WORD groupCode, void *entryContext, LONG entryIndex, LONG slotIndex, LONG *outDateTriplet, LONG *outTimePair)
{
    WORD clockScratch[6];
    LONG parsedRange[2];
    LONG hourDelta;
    LONG minuteDelta;
    LONG i;
    LONG parseOk;

    for (i = 0; i < 6; ++i) {
        TLIBA2_BroadcastWindowClockSnapshotA[i] = CLOCK_CurrentDayOfWeekIndex[i];
    }

    minuteDelta = (slotIndex & 1) ? 30 : 0;
    hourDelta = (slotIndex - 1) / 2 + 5;

    if ((LONG)groupCode != (LONG)TEXTDISP_PrimaryGroupCode) {
        hourDelta += 24;
    }

    for (i = 0; i < 6; ++i) {
        clockScratch[i] = TLIBA2_BroadcastWindowClockSnapshotA[i];
    }
    clockScratch[4] = 0;
    clockScratch[5] = 0;

    TLIBA2_JMPTBL_DST_AddTimeOffset(clockScratch, hourDelta, minuteDelta);

    outDateTriplet[0] = (LONG)clockScratch[1];
    outDateTriplet[1] = (LONG)clockScratch[0];
    outDateTriplet[2] = (LONG)clockScratch[2];
    outTimePair[0] = (LONG)clockScratch[4];
    outTimePair[1] = (LONG)clockScratch[5];

    if (outTimePair[0] == 12) {
        outTimePair[0] = 0;
    } else if (outTimePair[0] < 12) {
        outTimePair[0] += 12;
    }

    if (entryContext != (void *)0) {
        parseOk = TLIBA2_ParseEntryTimeWindow(entryContext, entryIndex, parsedRange);
    } else {
        parseOk = 0;
    }

    if (parseOk != 0 && parsedRange[0] > outTimePair[1]) {
        outTimePair[1] = parsedRange[0];
    }
}
