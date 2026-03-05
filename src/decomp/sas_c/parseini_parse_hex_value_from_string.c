typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE WDISP_CharClassTable[];
extern LONG SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(LONG ch);

LONG PARSEINI_ParseHexValueFromString(UBYTE *hexString)
{
    LONG value;
    LONG ch;

    value = 0;
    while (hexString != (UBYTE *)0) {
        ch = (LONG)(*hexString);
        if ((WDISP_CharClassTable[(UBYTE)ch] & 0x80) == 0) {
            break;
        }

        value <<= 4;
        value += (LONG)(UBYTE)SCRIPT3_JMPTBL_LADFUNC_ParseHexDigit(ch);
        ++hexString;
    }

    return value;
}
