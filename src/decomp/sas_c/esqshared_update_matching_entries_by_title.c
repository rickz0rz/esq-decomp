/*
 * ESQSHARED_UpdateMatchingEntriesByTitle -- for every entry in the target group
 * whose title matches an incoming wildcard key, apply slot flags/bitfields,
 * replace the targeted title-slot string with a filtered payload, and normalize
 * any embedded duration / bracketed-time text in place.
 *
 * Restored from src/modules/groups/a/p/esqshared.s:1102. The 32-bit MATH_Mulu32 /
 * MATH_DivS32 "calls" in the original are SAS/C's own runtime mul/div helpers,
 * emitted here automatically from C * / / % on longs.
 *
 * Args:
 *   key        (A3)   wildcard title key
 *   groupCode  (byte) which group (primary/secondary) to scan
 *   slotArg    (byte) 1..48 slot index; bit6 (0x40) selects set-bit behavior
 *   valueArg   (byte) value stored into the matched title slot flag
 *   payload    (A2)   compact program text applied to matched entries
 *
 * Entry record: +0x22 slot bitset, +27 filter flag, +40 status byte.
 * Title record: +7+slot slot flags, +56+slot*4 owned slot-string pointer, +498 group code.
 */
#include <exec/types.h>

extern UBYTE ESQSHARED_JMPTBL_ESQ_WildcardMatch(const char *text, const char *pattern);
extern LONG  ESQSHARED_JMPTBL_ESQ_TestBit1Based(const UBYTE *base, ULONG bitIndex);
extern void  ESQSHARED_JMPTBL_ESQ_SetBit1Based(UBYTE *base, ULONG bitIndex);
extern LONG  ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(LONG slot, LONG groupCode);
extern void  ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString(char *text, LONG hourOffset);
extern LONG  WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern char *GROUP_AR_JMPTBL_STRING_AppendAtNull(char *dst, const char *src);
extern char *GROUP_AS_JMPTBL_STR_FindCharPtr(const char *text, LONG ch);
extern char *ESQPARS_ReplaceOwnedString(const char *newSrc, char *oldOwned);
extern void  ESQSHARED_ApplyProgramTitleTextFilters(UBYTE *buf, LONG flag);
extern void *ESQIFF_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, LONG size, LONG flags);
extern void  ESQIFF_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, LONG size);

extern const char Global_STR_ESQPARS2_C_1[];
extern const char Global_STR_ESQPARS2_C_2[];
extern const char ESQPARS2_DurationFmt_DecimalWithSpace[];
extern const char ESQPARS2_DurationFmt_OpenParenHours[];
extern const char ESQPARS2_DurationFmt_OpenParenMinutes[];
extern const char ESQPARS2_DurationFmt_CloseParen[];
extern const char SCRIPT_StrHoursPluralSuffix[];
extern const char SCRIPT_StrHourSingularSuffix[];
extern const char SCRIPT_StrMinutesSuffix[];
extern const UBYTE WDISP_CharClassTable[];
extern UBYTE CLOCK_FormatVariantCode;

extern void *TEXTDISP_PrimaryEntryPtrTable[];
extern void *TEXTDISP_PrimaryTitlePtrTable[];
extern void *TEXTDISP_SecondaryEntryPtrTable[];
extern void *TEXTDISP_SecondaryTitlePtrTable[];
extern BYTE TEXTDISP_PrimaryGroupCode;
extern BYTE TEXTDISP_SecondaryGroupCode;
extern BYTE TEXTDISP_SecondaryGroupPresentFlag;
extern WORD TEXTDISP_PrimaryGroupEntryCount;
extern WORD TEXTDISP_SecondaryGroupEntryCount;

#define MEMF_PUBLIC 1L
#define MEMF_CLEAR  0x10000L
#define IS_DIGIT(c) (WDISP_CharClassTable[(UBYTE)(c)] & 4)

void ESQSHARED_UpdateMatchingEntriesByTitle(char *key, LONG groupCode, LONG slotArg,
                                            LONG valueArg, UBYTE *payload)
{
    UBYTE groupByte;
    UBYTE valueByte;
    UBYTE setFlag;
    WORD  slot;
    WORD  entryCount;
    WORD  i;
    UBYTE *entry;
    UBYTE *title;
    LONG  *slotPtrs;

    groupByte = (UBYTE)groupCode;
    valueByte = (UBYTE)valueArg;
    setFlag = (UBYTE)(slotArg & 0x40);
    slot = (WORD)(slotArg & 0x3F);

    if (slot < 1 || slot > 48)
        return;

    if (groupByte == (UBYTE)TEXTDISP_SecondaryGroupCode &&
        TEXTDISP_SecondaryGroupPresentFlag == 1) {
        entryCount = TEXTDISP_SecondaryGroupEntryCount;
    } else if (groupByte == (UBYTE)TEXTDISP_PrimaryGroupCode) {
        entryCount = TEXTDISP_PrimaryGroupEntryCount;
    } else {
        return;
    }

    for (i = 0; i < entryCount; i++) {
        WORD  testResult;
        UBYTE *payloadEnd;
        UBYTE hasHours;
        UBYTE minutesOnly;

        if (groupByte == (UBYTE)TEXTDISP_SecondaryGroupCode &&
            TEXTDISP_SecondaryGroupPresentFlag == 1) {
            entry = (UBYTE *)TEXTDISP_SecondaryEntryPtrTable[i];
            title = (UBYTE *)TEXTDISP_SecondaryTitlePtrTable[i];
        } else {
            entry = (UBYTE *)TEXTDISP_PrimaryEntryPtrTable[i];
            title = (UBYTE *)TEXTDISP_PrimaryTitlePtrTable[i];
        }

        if (ESQSHARED_JMPTBL_ESQ_WildcardMatch((char *)title, key) != 0)
            continue;

        testResult = (WORD)ESQSHARED_JMPTBL_ESQ_TestBit1Based(entry + 0x22, (ULONG)slot);
        if (setFlag == 0 && testResult != 0)
            continue;
        if (setFlag != 0)
            ESQSHARED_JMPTBL_ESQ_SetBit1Based(entry + 0x22, (ULONG)slot);

        title[7 + slot] = valueByte;
        ESQSHARED_ApplyProgramTitleTextFilters(payload, (LONG)entry[27]);

        /* locate a trailing "(H:MM)" or "(:MM)" duration group in the payload */
        payloadEnd = payload;
        while (*payloadEnd != 0)
            payloadEnd++;
        hasHours = 0;
        minutesOnly = 0;
        if (payloadEnd[-1] == 41 && payloadEnd[-4] == 58 && payloadEnd[-6] == 40)
            hasHours = 1;
        if (payloadEnd[-1] == 41 && payloadEnd[-4] == 58 && payloadEnd[-5] == 40)
            minutesOnly = 1;

        if (hasHours != 0 || minutesOnly != 0) {
            char  buf52[16];
            char  buf62[16];
            char *allocBuf;
            char *workBuf;
            LONG  hoursVal;
            LONG  minutesVal;

            hoursVal = 0;
            minutesVal = 0;
            allocBuf = (char *)ESQIFF_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_ESQPARS2_C_1, 720, 50, MEMF_PUBLIC + MEMF_CLEAR);
            workBuf = allocBuf;

            if (hasHours != 0)
                hoursVal = payloadEnd[-5] - 48;
            minutesVal = (payloadEnd[-3] - 48) * 10 + payloadEnd[-2] - 48;

            if (hoursVal > 0) {
                WDISP_SPrintf(buf52, ESQPARS2_DurationFmt_DecimalWithSpace, minutesVal);
                WDISP_SPrintf(buf62, ESQPARS2_DurationFmt_OpenParenHours, hoursVal);
                GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, buf62);
                if (hoursVal == 1)
                    GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, SCRIPT_StrHourSingularSuffix);
                else
                    GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, SCRIPT_StrHoursPluralSuffix);
            } else {
                WDISP_SPrintf(buf52, ESQPARS2_DurationFmt_OpenParenMinutes, minutesVal);
            }

            if (minutesVal > 0) {
                GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, buf52);
                GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, SCRIPT_StrMinutesSuffix);
            } else {
                char *p = workBuf;
                while (*p != 0)
                    p++;
                workBuf[(p - workBuf) - 1] = 0;
                GROUP_AR_JMPTBL_STRING_AppendAtNull(workBuf, ESQPARS2_DurationFmt_CloseParen);
            }

            /* splice the reformatted duration back over the original "(...)" */
            {
                UBYTE *dst = payloadEnd - 6;
                char  *src = workBuf;
                do {
                    *dst++ = *src;
                } while (*src++ != 0);
            }
            if (allocBuf != 0)
                ESQIFF_JMPTBL_MEMORY_DeallocateMemory(Global_STR_ESQPARS2_C_2, 765, allocBuf, 50);
        }

        /* replace the owned slot string, then normalize any [HH:MM] text */
        slotPtrs = (LONG *)(title + 56);
        slotPtrs[slot] = (LONG)ESQPARS_ReplaceOwnedString((char *)payload, (char *)slotPtrs[slot]);

        if (CLOCK_FormatVariantCode > 0) {
            UBYTE *bracket = (UBYTE *)GROUP_AS_JMPTBL_STR_FindCharPtr((char *)slotPtrs[slot], 91);
            if (bracket != 0) {
                WORD hoursAcc;
                WORD minutesAcc;
                WORD tens;

                hoursAcc = (WORD)((IS_DIGIT(bracket[1]) ? (bracket[1] - 48) * 10 : 0)
                                  + (IS_DIGIT(bracket[2]) ? bracket[2] - 48 : 0));
                minutesAcc = (WORD)((IS_DIGIT(bracket[4]) ? (bracket[4] - 48) * 10 : 0)
                                    + (IS_DIGIT(bracket[5]) ? bracket[5] - 48 : 0)
                                    + CLOCK_FormatVariantCode);

                while (minutesAcc > 59) {
                    minutesAcc -= 60;
                    hoursAcc++;
                }
                while (hoursAcc > 12)
                    hoursAcc -= 12;

                tens = hoursAcc / 10;
                bracket[2] = (UBYTE)((hoursAcc % 10) + 48);
                bracket[1] = (tens > 0) ? (UBYTE)(tens + 48) : (UBYTE)32;
                bracket[4] = (UBYTE)((minutesAcc / 10) + 48);
                bracket[5] = (UBYTE)((minutesAcc % 10) + 48);
            }
        }

        {
            LONG timeWord = (WORD)ESQSHARED_JMPTBL_DST_BuildBannerTimeWord(
                (LONG)slot, (LONG)(UBYTE)title[498]);
            ESQSHARED_JMPTBL_ESQ_AdjustBracketedHourInString((char *)slotPtrs[slot], timeWord);
        }

        if (title[7 + slot] & 0x10)
            entry[40] |= 0x01;
        entry[40] = (UBYTE)(entry[40] | 0x80);
    }
}
