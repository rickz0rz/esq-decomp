typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_AuxData {
    UBYTE pad0[56];
    const char *titleTable[110];
    UBYTE pad1[2];
    UBYTE slotCode;
} TEXTDISP_AuxData;

extern WORD TEXTDISP_ActiveGroupId;
extern WORD TEXTDISP_CurrentMatchIndex;
extern UBYTE CLOCK_FormatVariantCode;
extern const char *TEXTDISP_PrimaryTitlePtrTable[];
extern const char *TEXTDISP_SecondaryTitlePtrTable[];
extern const char *Global_REF_STR_CLOCK_FORMAT[];

extern LONG TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow(LONG row, LONG slot);
extern void TLIBA1_JMPTBL_CLEANUP_FormatClockFormatEntry(LONG slotIndex, char *out);
extern LONG MATH_DivS32(LONG a, LONG b);
extern LONG MATH_Mulu32(LONG a, LONG b);

void TEXTDISP_FormatEntryTime(char *out, WORD entryIndex)
{
    const TEXTDISP_AuxData *title;
    const char *timeText;
    LONG slotIndex;

    if (TEXTDISP_ActiveGroupId != 0) {
        title = (const TEXTDISP_AuxData *)TEXTDISP_PrimaryTitlePtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
    } else {
        title = (const TEXTDISP_AuxData *)TEXTDISP_SecondaryTitlePtrTable[(LONG)TEXTDISP_CurrentMatchIndex];
    }

    timeText = title->titleTable[(LONG)entryIndex];
    slotIndex = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)entryIndex, (LONG)title->slotCode);

    if (timeText == 0 || *timeText == 0) {
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
        const char *src;

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
        out[-3] = (char)(MATH_DivS32(variant, 10) + '0');
        out[-2] = (char)((variant % 10) + '0');
    }
}

void TEXTDISP_FormatEntryTimeForIndex(char *out, WORD entryIndex, char *entryTable)
{
    const TEXTDISP_AuxData *aux;
    const char *timeText;
    LONG slotIndex;

    aux = (const TEXTDISP_AuxData *)entryTable;
    timeText = aux->titleTable[(LONG)entryIndex];
    slotIndex = TLIBA1_JMPTBL_ESQDISP_ComputeScheduleOffsetForRow((LONG)entryIndex, (LONG)aux->slotCode);

    if (timeText == 0 || *timeText == 0) {
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
        const char *src;

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
        out[-3] = (char)(MATH_DivS32(variant, 10) + '0');
        out[-2] = (char)((variant % 10) + '0');
    }
}
