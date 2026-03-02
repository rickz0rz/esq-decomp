#include "esq_types.h"

extern s32 PARSEINI_CurrentRangeTableIndex;

extern const char PARSEINI_DelimSpaceTab_RangeKey[];
extern const char PARSEINI_DelimSpaceSemicolonTab_RangeValue[];
extern const char PARSEINI_TAG_TABLE[];
extern const char PARSEINI_TAG_DONE[];
extern const char PARSEINI_TAG_COLOR[];

char *PARSEINI_JMPTBL_STR_FindCharPtr(const char *s, s32 ch) __attribute__((noinline));
char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s) __attribute__((noinline));
char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(char *s, const char *delims) __attribute__((noinline));
s32 PARSEINI_JMPTBL_STRING_CompareNoCaseN(const char *a, const char *b, s32 n) __attribute__((noinline));
void PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(void *table) __attribute__((noinline));
s32 SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(const char *s) __attribute__((noinline));
s32 PARSEINI_ParseHexValueFromString(const char *s) __attribute__((noinline));

s32 PARSEINI_ParseRangeKeyValue(char *source, u16 *range_table) __attribute__((noinline, used));

s32 PARSEINI_ParseRangeKeyValue(char *source, u16 *range_table)
{
    char *key = source;
    char *value = 0;

    if (source != 0) {
        value = PARSEINI_JMPTBL_STR_FindCharPtr(source, 61);
    }

    if (source != 0 && value != 0) {
        char *end;

        key = NEWGRID2_JMPTBL_STR_SkipClass3Chars(source);
        end = PARSEINI_JMPTBL_STR_FindAnyCharPtr(key, PARSEINI_DelimSpaceTab_RangeKey);
        if (end != 0) {
            *end = '\0';
        }

        *value++ = '\0';
        value = NEWGRID2_JMPTBL_STR_SkipClass3Chars(value);
        end = PARSEINI_JMPTBL_STR_FindAnyCharPtr(value, PARSEINI_DelimSpaceSemicolonTab_RangeValue);
        if (end != 0) {
            *end = '\0';
        }
    }

    if (key == 0 || value == 0) {
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(key, PARSEINI_TAG_TABLE, 5) == 0 &&
        PARSEINI_JMPTBL_STRING_CompareNoCaseN(value, PARSEINI_TAG_DONE, 4) == 0) {
        PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(range_table);
        PARSEINI_CurrentRangeTableIndex = -1;
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(key, PARSEINI_TAG_COLOR, 5) == 0) {
        s32 idx = 0;
        s32 v;

        if (key[5] != '\0') {
            idx = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(key + 5);
        }

        if (idx < 0 || idx >= 16) {
            PARSEINI_CurrentRangeTableIndex = -1;
        } else {
            PARSEINI_CurrentRangeTableIndex = idx;
            range_table[idx] = 0;
        }

        if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
            return 0;
        }

        v = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(value);
        if (v < 1 || v > 63) {
            v = -1;
        } else {
            v += 1;
        }

        range_table[PARSEINI_CurrentRangeTableIndex] = (u16)v;
        return 0;
    }

    if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
        return 0;
    }

    if ((s16)range_table[PARSEINI_CurrentRangeTableIndex] <= 0) {
        return 0;
    }

    {
        s32 n = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(key);
        s32 color = PARSEINI_ParseHexValueFromString(value);
        u16 max = range_table[PARSEINI_CurrentRangeTableIndex];
        u8 *base;

        if (n <= 0 || n >= (s16)max) {
            return 0;
        }
        if (color < 0 || color >= 0x1000) {
            return 0;
        }

        base = (u8 *)range_table + ((u32)PARSEINI_CurrentRangeTableIndex << 7);
        *(u16 *)(void *)(base + ((u32)n << 1) + 32u) = (u16)color;
    }

    return 0;
}
