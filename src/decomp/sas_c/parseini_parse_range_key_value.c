typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern LONG PARSEINI_CurrentRangeTableIndex;

extern char PARSEINI_DelimSpaceTab_RangeKey[];
extern char PARSEINI_DelimSpaceSemicolonTab_RangeValue[];
extern char PARSEINI_TAG_TABLE[];
extern char PARSEINI_TAG_DONE[];
extern char PARSEINI_TAG_COLOR[];

extern char *PARSEINI_JMPTBL_STR_FindCharPtr(char *s, LONG ch);
extern char *NEWGRID2_JMPTBL_STR_SkipClass3Chars(char *s);
extern char *PARSEINI_JMPTBL_STR_FindAnyCharPtr(char *s, char *delim);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCaseN(char *a, char *b, LONG n);
extern void PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(WORD *rangeTable);
extern LONG SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(char *s);
extern LONG PARSEINI_ParseHexValueFromString(UBYTE *hexString);

LONG PARSEINI_ParseRangeKeyValue(char *sourceLine, WORD *rangeTable)
{
    char *keyToken;
    char *valueToken;
    char *splitPtr;
    LONG idx;
    LONG parsed;
    LONG slot;
    LONG color;
    char *p;

    keyToken = sourceLine;
    splitPtr = (sourceLine != (char *)0) ? PARSEINI_JMPTBL_STR_FindCharPtr(sourceLine, 61) : (char *)0;
    valueToken = splitPtr;

    if (keyToken != (char *)0 && valueToken != (char *)0) {
        keyToken = NEWGRID2_JMPTBL_STR_SkipClass3Chars(keyToken);
        keyToken = PARSEINI_JMPTBL_STR_FindAnyCharPtr(keyToken, PARSEINI_DelimSpaceTab_RangeKey);
        if (keyToken != (char *)0) {
            *keyToken = 0;
        }

        *valueToken++ = 0;
        valueToken = NEWGRID2_JMPTBL_STR_SkipClass3Chars(valueToken);
        splitPtr = PARSEINI_JMPTBL_STR_FindAnyCharPtr(valueToken, PARSEINI_DelimSpaceSemicolonTab_RangeValue);
        if (splitPtr != (char *)0) {
            *splitPtr = 0;
        }
    }

    if (keyToken == (char *)0 || valueToken == (char *)0) {
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(keyToken, PARSEINI_TAG_TABLE, 5) == 0 &&
        PARSEINI_JMPTBL_STRING_CompareNoCaseN(valueToken, PARSEINI_TAG_DONE, 4) == 0) {
        PARSEINI_JMPTBL_GCOMMAND_ValidatePresetTable(rangeTable);
        PARSEINI_CurrentRangeTableIndex = -1;
        return 0;
    }

    if (PARSEINI_JMPTBL_STRING_CompareNoCaseN(keyToken, PARSEINI_TAG_COLOR, 5) == 0) {
        idx = 0;
        p = keyToken + 5;
        if (p != (char *)0 && *p != 0) {
            idx = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(p);
        }

        if (idx < 0 || idx >= 16) {
            PARSEINI_CurrentRangeTableIndex = -1;
        } else {
            PARSEINI_CurrentRangeTableIndex = idx;
            rangeTable[idx] = 0;
        }

        if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
            return 0;
        }

        parsed = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(valueToken);
        if (parsed < 1 || parsed > 63) {
            parsed = -1;
        } else {
            parsed += 1;
        }

        rangeTable[PARSEINI_CurrentRangeTableIndex] = (WORD)parsed;
        return 0;
    }

    if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
        return 0;
    }
    if (rangeTable[PARSEINI_CurrentRangeTableIndex] <= 0) {
        return 0;
    }

    slot = SCRIPT3_JMPTBL_PARSE_ReadSignedLongSkipClass3_Alt(keyToken);
    color = PARSEINI_ParseHexValueFromString((UBYTE *)valueToken);
    if (slot <= 0) {
        return 0;
    }
    if (slot >= rangeTable[PARSEINI_CurrentRangeTableIndex]) {
        return 0;
    }
    if (color < 0 || color >= 0x1000) {
        return 0;
    }

    *((WORD *)((char *)rangeTable + (PARSEINI_CurrentRangeTableIndex << 7) + (slot << 1) + 32)) = (WORD)color;
    return 0;
}
