typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    PARSE_COLOR_MODE_CUSTOM = 4,
    PARSE_COLOR_MODE_BASE = 5,
    PARSE_COLOR_MAX = 8,
    PARSE_COLOR_CHANNEL_COUNT = 3
};

extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern UBYTE ESQFUNC_BasePaletteRgbTriples[];

extern const char Global_STR_COLOR_PERCENT_D[];

extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, LONG indexValue);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(LONG ch);
extern void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void);

void PARSEINI_ParseColorTable(char *entryKey, char *entryValue, LONG mode)
{
    UBYTE *targetTriples;
    LONG maxColors;
    LONG colorIndex;
    LONG channelIndex;
    LONG tripleOffset;
    char keyBuffer[112];

    targetTriples = (UBYTE *)0;
    maxColors = 0;
    if (mode == PARSE_COLOR_MODE_CUSTOM) {
        targetTriples = KYBD_CustomPaletteTriplesRBase;
        maxColors = PARSE_COLOR_MAX;
    } else if (mode == PARSE_COLOR_MODE_BASE) {
        targetTriples = ESQFUNC_BasePaletteRgbTriples;
        maxColors = PARSE_COLOR_MAX;
    }

    for (colorIndex = 0; colorIndex < maxColors; ++colorIndex) {
        PARSEINI_JMPTBL_WDISP_SPrintf(keyBuffer, Global_STR_COLOR_PERCENT_D, colorIndex);
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, keyBuffer) != 0) {
            continue;
        }

        for (channelIndex = 0; channelIndex < PARSE_COLOR_CHANNEL_COUNT; ++channelIndex) {
            tripleOffset = (colorIndex * PARSE_COLOR_CHANNEL_COUNT) + channelIndex;
            targetTriples[tripleOffset] = (UBYTE)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((LONG)(UBYTE)entryValue[channelIndex]);
        }
    }

    if (mode == PARSE_COLOR_MODE_CUSTOM) {
        TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
    }
}
