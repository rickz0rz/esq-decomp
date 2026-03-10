typedef unsigned char UBYTE;

extern const UBYTE WDISP_CharClassTable[];

char *TEXTDISP_SkipControlCodes(const char *text)
{
    if (text == (char *)0) {
        return (char *)text;
    }

    if (text[0] == 40) {
        text += 8;
    }

    while ((WDISP_CharClassTable[text[0]] & 8) != 0) {
        ++text;
    }

    return (char *)text;
}
