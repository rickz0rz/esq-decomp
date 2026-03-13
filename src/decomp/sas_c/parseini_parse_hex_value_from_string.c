typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    CHARCLASS_ALPHA_BIT_MASK = 0x80
};

extern const UBYTE WDISP_CharClassTable[];
extern LONG LADFUNC_ParseHexDigit(LONG ch);

LONG PARSEINI_ParseHexValueFromString(const char *hexText)
{
    LONG parsedValue;
    LONG ch;

    parsedValue = 0;
    while (hexText != (const char *)0) {
        ch = (LONG)(*hexText);
        if ((WDISP_CharClassTable[(UBYTE)ch] & CHARCLASS_ALPHA_BIT_MASK) == 0) {
            break;
        }

        parsedValue <<= 4;
        parsedValue += (LONG)(UBYTE)LADFUNC_ParseHexDigit(ch);
        ++hexText;
    }

    return parsedValue;
}
