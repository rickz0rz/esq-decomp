typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE KYBD_CustomPaletteTriplesRBase[];
extern UBYTE ESQFUNC_BasePaletteRgbTriples[];

extern char Global_STR_COLOR_PERCENT_D[];

extern LONG PARSEINI_JMPTBL_WDISP_SPrintf(char *dst, char *fmt, LONG indexValue);
extern LONG PARSEINI_JMPTBL_STRING_CompareNoCase(char *a, char *b);
extern LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(LONG ch);
extern void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void);

void PARSEINI_ParseColorTable(char *keyName, char *rgbHexTriplet, LONG mode)
{
    UBYTE *targetTriples;
    LONG maxColors;
    LONG colorIndex;
    LONG channelIndex;
    LONG tripleOffset;
    char keyBuffer[112];

    targetTriples = (UBYTE *)0;
    maxColors = 0;
    if (mode == 4) {
        targetTriples = KYBD_CustomPaletteTriplesRBase;
        maxColors = 8;
    } else if (mode == 5) {
        targetTriples = ESQFUNC_BasePaletteRgbTriples;
        maxColors = 8;
    }

    for (colorIndex = 0; colorIndex < maxColors; ++colorIndex) {
        PARSEINI_JMPTBL_WDISP_SPrintf(keyBuffer, Global_STR_COLOR_PERCENT_D, colorIndex);
        if (PARSEINI_JMPTBL_STRING_CompareNoCase(keyName, keyBuffer) != 0) {
            continue;
        }

        for (channelIndex = 0; channelIndex < 3; ++channelIndex) {
            tripleOffset = (colorIndex * 3) + channelIndex;
            targetTriples[tripleOffset] = (UBYTE)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit((LONG)(UBYTE)rgbHexTriplet[channelIndex]);
        }
    }

    if (mode == 4) {
        TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
    }
}
