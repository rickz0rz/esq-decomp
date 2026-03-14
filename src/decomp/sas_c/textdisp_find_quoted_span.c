#include <exec/types.h>
extern char *STR_FindCharPtr(const char *s, LONG needle);
extern const UBYTE WDISP_CharClassTable[];

LONG TEXTDISP_FindQuotedSpan(const char *src, char **outStart, const char *endHint, LONG *hasQuotes)
{
    const LONG FLAG_FALSE = 0;
    const LONG FLAG_TRUE = 1;
    const LONG ASCII_QUOTE = 34;
    const LONG ASCII_LPAREN = 40;
    const LONG PREFIX_SKIP_LEN = 8;
    const LONG CHARCLASS_WHITESPACE = 8;
    const LONG PTR_BACK_ONE = 1;
    const char *start;
    const char *end;
    const char *firstQuote;
    const char *secondQuote;

    *hasQuotes = FLAG_FALSE;

    firstQuote = STR_FindCharPtr(src, ASCII_QUOTE);
    secondQuote = 0;
    if (firstQuote != 0) {
        secondQuote = STR_FindCharPtr(firstQuote + 1, ASCII_QUOTE);
    }

    start = firstQuote;
    end = secondQuote;

    if (end == 0) {
        if (start == 0) {
            start = src;
        }
        if (*start == ASCII_LPAREN) {
            start += PREFIX_SKIP_LEN;
        }

        if (endHint != 0) {
            end = endHint - PTR_BACK_ONE;
        } else {
            end = src;
            while (*end != '\0') {
                ++end;
            }
            --end;
        }
    } else {
        *hasQuotes = FLAG_TRUE;
    }

    while ((WDISP_CharClassTable[(UBYTE)*start] & CHARCLASS_WHITESPACE) != 0) {
        ++start;
    }

    while ((WDISP_CharClassTable[(UBYTE)*end] & CHARCLASS_WHITESPACE) != 0) {
        --end;
    }

    *outStart = (char *)start;
    return (LONG)(end - start) + PTR_BACK_ONE;
}
