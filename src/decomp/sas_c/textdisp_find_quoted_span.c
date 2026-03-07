typedef signed long LONG;
typedef unsigned char UBYTE;

extern char *STR_FindCharPtr(char *s, LONG needle);
extern UBYTE WDISP_CharClassTable[];

LONG TEXTDISP_FindQuotedSpan(char *src, char **outStart, char *endHint, LONG *hasQuotes)
{
    char *start;
    char *end;
    char *firstQuote;
    char *secondQuote;

    *hasQuotes = 0;

    firstQuote = STR_FindCharPtr(src, 34);
    secondQuote = 0;
    if (firstQuote != 0) {
        secondQuote = STR_FindCharPtr(firstQuote + 1, 34);
    }

    start = firstQuote;
    end = secondQuote;

    if (end == 0) {
        if (start == 0) {
            start = src;
        }
        if (*start == 40) {
            start += 8;
        }

        if (endHint != 0) {
            end = endHint - 1;
        } else {
            end = src;
            while (*end != '\0') {
                ++end;
            }
            --end;
        }
    } else {
        *hasQuotes = 1;
    }

    while ((WDISP_CharClassTable[(UBYTE)*start] & 8) != 0) {
        ++start;
    }

    while ((WDISP_CharClassTable[(UBYTE)*end] & 8) != 0) {
        --end;
    }

    *outStart = start;
    return (LONG)(end - start) + 1;
}
