typedef signed long LONG;
typedef short WORD;
typedef unsigned char UBYTE;

extern LONG PARSEINI_CurrentRangeTableIndex;

extern const char PARSEINI_DelimSpaceTab_RangeKey[];
extern const char PARSEINI_DelimSpaceSemicolonTab_RangeValue[];
extern const char PARSEINI_TAG_TABLE[];
extern const char PARSEINI_TAG_DONE[];
extern const char PARSEINI_TAG_COLOR[];

extern char *STR_FindCharPtr(const char *s, LONG ch);
extern char *STR_SkipClass3Chars(const char *s);
extern char *STR_FindAnyCharPtr(const char *s, const char *delim);
extern LONG STRING_CompareNoCaseN(const char *a, const char *b, LONG n);
extern void GCOMMAND_ValidatePresetTable(WORD *rangeTable);
extern LONG PARSE_ReadSignedLongSkipClass3_Alt(const char *s);
extern LONG PARSEINI_ParseHexValueFromString(const char *hexText);

LONG PARSEINI_ParseRangeKeyValue(char *sourceLine, WORD *rangeTable)
{
    char *keyToken;
    char *valueToken;
    char *splitPtr;
    LONG colorIndex;
    LONG parsedRangeLen;
    LONG slotIndex;
    LONG colorValue;
    const char *p;

    keyToken = sourceLine;
    splitPtr = (sourceLine != (char *)0) ? STR_FindCharPtr(sourceLine, 61) : (char *)0;
    valueToken = splitPtr;

    if (keyToken != (char *)0 && valueToken != (char *)0) {
        keyToken = STR_SkipClass3Chars(keyToken);
        keyToken = STR_FindAnyCharPtr(keyToken, PARSEINI_DelimSpaceTab_RangeKey);
        if (keyToken != (char *)0) {
            *keyToken = 0;
        }

        *valueToken++ = 0;
        valueToken = STR_SkipClass3Chars(valueToken);
        splitPtr = STR_FindAnyCharPtr(valueToken, PARSEINI_DelimSpaceSemicolonTab_RangeValue);
        if (splitPtr != (char *)0) {
            *splitPtr = 0;
        }
    }

    if (keyToken == (char *)0 || valueToken == (char *)0) {
        return 0;
    }

    if (STRING_CompareNoCaseN(keyToken, PARSEINI_TAG_TABLE, 5) == 0 &&
        STRING_CompareNoCaseN(valueToken, PARSEINI_TAG_DONE, 4) == 0) {
        GCOMMAND_ValidatePresetTable(rangeTable);
        PARSEINI_CurrentRangeTableIndex = -1;
        return 0;
    }

    if (STRING_CompareNoCaseN(keyToken, PARSEINI_TAG_COLOR, 5) == 0) {
        colorIndex = 0;
        p = keyToken + 5;
        if (p != (const char *)0 && *p != 0) {
            colorIndex = PARSE_ReadSignedLongSkipClass3_Alt(p);
        }

        if (colorIndex < 0 || colorIndex >= 16) {
            PARSEINI_CurrentRangeTableIndex = -1;
        } else {
            PARSEINI_CurrentRangeTableIndex = colorIndex;
            rangeTable[colorIndex] = 0;
        }

        if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
            return 0;
        }

        parsedRangeLen = PARSE_ReadSignedLongSkipClass3_Alt(valueToken);
        if (parsedRangeLen < 1 || parsedRangeLen > 63) {
            parsedRangeLen = -1;
        } else {
            parsedRangeLen += 1;
        }

        rangeTable[PARSEINI_CurrentRangeTableIndex] = (WORD)parsedRangeLen;
        return 0;
    }

    if (PARSEINI_CurrentRangeTableIndex < 0 || PARSEINI_CurrentRangeTableIndex >= 16) {
        return 0;
    }
    if (rangeTable[PARSEINI_CurrentRangeTableIndex] <= 0) {
        return 0;
    }

    slotIndex = PARSE_ReadSignedLongSkipClass3_Alt(keyToken);
    colorValue = PARSEINI_ParseHexValueFromString(valueToken);
    if (slotIndex <= 0) {
        return 0;
    }
    if (slotIndex >= rangeTable[PARSEINI_CurrentRangeTableIndex]) {
        return 0;
    }
    if (colorValue < 0 || colorValue >= 0x1000) {
        return 0;
    }

    *((WORD *)((char *)rangeTable + (PARSEINI_CurrentRangeTableIndex << 7) + (slotIndex << 1) + 32)) = (WORD)colorValue;
    return 0;
}
