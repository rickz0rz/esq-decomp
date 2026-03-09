typedef unsigned char UBYTE;

extern UBYTE WDISP_CharClassTable[];

char *TEXTDISP_SkipControlCodes(char *text)
{
    if (text == (char *)0) {
        return text;
    }

    if (text[0] == 40) {
        text += 8;
    }

    while ((WDISP_CharClassTable[text[0]] & 8) != 0) {
        ++text;
    }

    return text;
}
