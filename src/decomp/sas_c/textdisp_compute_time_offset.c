#include <exec/types.h>
typedef struct TEXTDISP_AuxData {
    UBYTE pad0[56];
    const char *titleTable[110];
    UBYTE pad1[2];
    UBYTE slotCode;
} TEXTDISP_AuxData;

extern WORD CLOCK_CurrentMonthIndex;
extern WORD CLOCK_CurrentDayOfMonth;
extern WORD CLOCK_CurrentYearValue;
extern WORD Global_WORD_CURRENT_HOUR;
extern WORD Global_WORD_CURRENT_MINUTE;
extern WORD CLOCK_CurrentAmPmFlag;

extern LONG TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(LONG rowIndex, LONG mode, LONG mode2, LONG slot);
extern void TLIBA2_ComputeBroadcastTimeWindow(WORD groupCode, const void *entryContext, LONG entryIndex, LONG slotIndex, LONG *outDateTriplet, LONG *outTimePair);
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG TEXTDISP_ComputeTimeOffset(LONG groupCode, const char *title, LONG index)
{
    const TEXTDISP_AuxData *aux;
    LONG dateTriplet[3];
    LONG timePair[2];
    LONG dayDelta;
    LONG targetMinutes;
    LONG currentMinutes;
    LONG currentHour12;
    LONG slotIndex;

    aux = (const TEXTDISP_AuxData *)title;
    slotIndex = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(
        index,
        groupCode,
        groupCode,
        (LONG)aux->slotCode);

    TLIBA2_ComputeBroadcastTimeWindow(
        (WORD)groupCode,
        (const void *)title,
        index,
        slotIndex,
        dateTriplet,
        timePair);

    dayDelta = dateTriplet[0] - (LONG)CLOCK_CurrentYearValue;
    if (dayDelta == 0) {
        dayDelta = dateTriplet[1] - (LONG)CLOCK_CurrentMonthIndex;
    }
    if (dayDelta == 0) {
        dayDelta = dateTriplet[2] - (LONG)CLOCK_CurrentDayOfMonth;
    }

    targetMinutes = MATH_Mulu32(timePair[0], 60) + timePair[1];

    currentHour12 = (LONG)Global_WORD_CURRENT_HOUR % 12;
    if (CLOCK_CurrentAmPmFlag != 0) {
        currentHour12 += 12;
    }

    currentMinutes = MATH_Mulu32(currentHour12, 60) + (LONG)Global_WORD_CURRENT_MINUTE;

    return targetMinutes - currentMinutes + MATH_Mulu32(dayDelta, 0x5a0);
}
