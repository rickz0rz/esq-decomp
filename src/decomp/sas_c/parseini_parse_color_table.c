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

extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, LONG indexValue);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(const char *a, const char *b);
extern LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(LONG ch);
extern void ESQIFF_RunCopperRiseTransition(void);

void PARSEINI_ParseColorTable(const char *entryKey, const char *entryValue, LONG mode)
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

    colorIndex = 0;
    while (colorIndex < maxColors) {
        PARSEINI_JMPTBL_WDISP_SPrintf(keyBuffer, Global_STR_COLOR_PERCENT_D, colorIndex);
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(entryKey, keyBuffer) == 0) {
            channelIndex = 0;
            while (channelIndex < PARSE_COLOR_CHANNEL_COUNT) {
                tripleOffset = (colorIndex << 2) - colorIndex;
                tripleOffset += channelIndex;
                targetTriples[tripleOffset] =
                    (UBYTE)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((LONG)(UBYTE)entryValue[channelIndex]);
                ++channelIndex;
            }
        }
        ++colorIndex;
    }

    if (mode == PARSE_COLOR_MODE_CUSTOM) {
        ESQIFF_RunCopperRiseTransition();
    }
}
