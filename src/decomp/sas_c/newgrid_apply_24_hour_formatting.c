typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern char *Global_JMPTBL_HALF_HOURS_24_HR_FMT[];

extern char *PARSEINI_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern LONG NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(LONG rowIndex, LONG minuteIndex);

void NEWGRID_Apply24HourFormatting(char *text, WORD rowIndex, UBYTE minuteIndex)
{
    char *timePtr;
    char *slot;
    LONG idx;

    if (Global_REF_STR_USE_24_HR_CLOCK != 'Y') {
        return;
    }
    if (text == 0) {
        return;
    }

    timePtr = PARSEINI_JMPTBL_STR_FindCharPtr(text, 40);
    if (timePtr == 0) {
        return;
    }
    if (timePtr[3] != ':') {
        return;
    }

    idx = NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)rowIndex, (LONG)minuteIndex);
    slot = Global_JMPTBL_HALF_HOURS_24_HR_FMT[idx];
    timePtr[1] = slot[0];

    idx = NEWGRID2_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)rowIndex, (LONG)minuteIndex);
    slot = Global_JMPTBL_HALF_HOURS_24_HR_FMT[idx];
    timePtr[2] = slot[1];
}
