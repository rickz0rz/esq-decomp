typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    CHARCLASS_ALPHA_BIT_MASK = 0x80
};

extern UBYTE WDISP_CharClassTable[];
extern LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(LONG ch);

LONG PARSEINI_ParseHexValueFromString(const UBYTE *hexText)
{
    LONG parsedValue;
    LONG ch;

    parsedValue = 0;
    while (hexText != (const UBYTE *)0) {
        ch = (LONG)(*hexText);
        if ((WDISP_CharClassTable[(UBYTE)ch] & CHARCLASS_ALPHA_BIT_MASK) == 0) {
            break;
        }

        parsedValue <<= 4;
        parsedValue += (LONG)(UBYTE)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(ch);
        ++hexText;
    }

    return parsedValue;
}
