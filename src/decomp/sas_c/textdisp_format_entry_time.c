typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_CurrentMatchIndex;
extern UBYTE CLOCK_FormatVariantCode;
extern UBYTE *TEXTDISP_PrimaryTitlePtrTable[];
extern UBYTE *TEXTDISP_SecondaryTitlePtrTable[];
extern UBYTE **Global_REF_STR_CLOCK_FORMAT;

extern LONG TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(LONG row, LONG slot);
extern void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slotIndex, UBYTE *out);
extern LONG MATH_DivS32(LONG a, LONG b);
extern LONG MATH_Mulu32(LONG a, LONG b);

void TEXTDISP_FormatEntryTime(UBYTE *out, WORD entryIndex)
{
    UBYTE *title;
    UBYTE *timeText;
    LONG slotIndex;

    if (TEXTDISP_ActiveGroupId != 0) {
        title = TEXTDISP_PrimaryTitlePtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
    } else {
        title = TEXTDISP_SecondaryTitlePtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
    }

    timeText = *(UBYTE **)(title + 56 + ((LONG)entryIndex << 2));
    slotIndex = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)entryIndex, (LONG)(UBYTE)title[498]);

    if (timeText == (UBYTE *)0 || *timeText == 0) {
        *out = 0;
        return;
    }

    if (timeText[0] != '(' || timeText[3] != ':') {
        slotIndex += MATH_DivS32((LONG)(UBYTE)CLOCK_FormatVariantCode, 30);
        TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(slotIndex, out);
        return;
    }

    {
        LONG minutes;
        LONG minuteRemainder;
        LONG variantRemainder;
        LONG variant;
        UBYTE *src;

        minutes = MATH_Mulu32((LONG)(UBYTE)(timeText[4] - '0'), 10);
        minutes += (LONG)(UBYTE)(timeText[5] - '0');
        minutes -= '0';

        slotIndex += MATH_DivS32((LONG)(UBYTE)CLOCK_FormatVariantCode, 30);

        minuteRemainder = minutes % 30;
        variantRemainder = (LONG)(UBYTE)CLOCK_FormatVariantCode % 30;
        if (minuteRemainder < variantRemainder) {
            ++slotIndex;
        }

        minutes %= 30;
        if (slotIndex > 48) {
            slotIndex -= 48;
        }

        src = Global_REF_STR_CLOCK_FORMAT[slotIndex];
        while ((*out++ = *src++) != 0) {
        }

        variant = MATH_Mulu32((LONG)(UBYTE)(out[-3] - '0'), 10) + minutes;
        out[-3] = (UBYTE)(MATH_DivS32(variant, 10) + '0');
        out[-2] = (UBYTE)((variant % 10) + '0');
    }
}

void TEXTDISP_FormatEntryTimeForIndex(UBYTE *out, WORD entryIndex, UBYTE *entryTable)
{
    UBYTE *timeText;
    LONG slotIndex;

    timeText = *(UBYTE **)(entryTable + 56 + ((LONG)entryIndex << 2));
    slotIndex = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)entryIndex, (LONG)(UBYTE)entryTable[498]);

    if (timeText == (UBYTE *)0 || *timeText == 0) {
        *out = 0;
        return;
    }

    if (timeText[0] != '(' || timeText[3] != ':') {
        slotIndex += MATH_DivS32((LONG)(UBYTE)CLOCK_FormatVariantCode, 30);
        TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(slotIndex, out);
        return;
    }

    {
        LONG minutes;
        LONG minuteRemainder;
        LONG variantRemainder;
        LONG variant;
        UBYTE *src;

        minutes = MATH_Mulu32((LONG)(UBYTE)(timeText[4] - '0'), 10);
        minutes += (LONG)(UBYTE)(timeText[5] - '0');
        minutes -= '0';

        slotIndex += MATH_DivS32((LONG)(UBYTE)CLOCK_FormatVariantCode, 30);

        minuteRemainder = minutes % 30;
        variantRemainder = (LONG)(UBYTE)CLOCK_FormatVariantCode % 30;
        if (minuteRemainder < variantRemainder) {
            ++slotIndex;
        }

        minutes %= 30;
        if (slotIndex > 48) {
            slotIndex -= 48;
        }

        src = Global_REF_STR_CLOCK_FORMAT[slotIndex];
        while ((*out++ = *src++) != 0) {
        }

        variant = MATH_Mulu32((LONG)(UBYTE)(out[-3] - '0'), 10) + minutes;
        out[-3] = (UBYTE)(MATH_DivS32(variant, 10) + '0');
        out[-2] = (UBYTE)((variant % 10) + '0');
    }
}
