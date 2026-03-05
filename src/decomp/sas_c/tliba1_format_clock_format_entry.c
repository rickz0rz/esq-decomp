typedef signed long LONG;
typedef unsigned char UBYTE;

extern char TLIBA1_FormatFallbackBuffer[];
extern char *TEXTDISP_FormatEntryFallbackTable;
extern char TLIBA1_FormatFallbackFieldPtr0[];
extern char TLIBA1_FormatFallbackFieldPtr1[];
extern char TLIBA1_FormatFallbackFieldPtr2[];
extern char TLIBA1_FormatFallbackFieldPtr3[];
extern char TLIBA1_FMT_PCT_C_PCT_S[];

extern LONG WDISP_SPrintf(char *dst, char *fmt, LONG c, char *s);
extern char *STRING_AppendAtNull(char *dst, char *src);

static LONG TLIBA1_StrLen(const char *s)
{
    LONG n;
    n = 0;
    while (s[n] != 0) {
        ++n;
    }
    return n;
}

void TLIBA1_FormatClockFormatEntry(char *dst, char *f0, char *f1, char *f2, char *f3, char *fallbackStyle, LONG useFallbackSet)
{
    char scratch[512];
    char *fieldList[4];
    LONG i;
    LONG lenField;
    LONG lenDst;
    UBYTE tag;

    for (i = 0; i < 512; ++i) {
        scratch[i] = TLIBA1_FormatFallbackBuffer[i];
    }

    if (f0 == (char *)0) {
        f0 = TLIBA1_FormatFallbackFieldPtr0;
    }
    if (f1 == (char *)0) {
        f1 = TLIBA1_FormatFallbackFieldPtr1;
    }
    if (f2 == (char *)0) {
        f2 = TLIBA1_FormatFallbackFieldPtr2;
    }
    if (f3 == (char *)0) {
        f3 = TLIBA1_FormatFallbackFieldPtr3;
    }

    fieldList[0] = f0;
    fieldList[1] = f1;
    fieldList[2] = f2;
    fieldList[3] = f3;

    if (dst == (char *)0) {
        return;
    }
    dst[0] = 0;

    for (i = 0; i < 4; ++i) {
        lenField = TLIBA1_StrLen(fieldList[i]);
        if (lenField <= 0 || lenField >= 512) {
            continue;
        }

        lenDst = TLIBA1_StrLen(dst);
        if ((lenDst + lenField) >= 512) {
            continue;
        }

        if (useFallbackSet == 0 && fallbackStyle != (char *)0 && fallbackStyle[0] != 0) {
            tag = (UBYTE)fallbackStyle[0] - (UBYTE)'A' + 1;
        } else {
            tag = (UBYTE)TEXTDISP_FormatEntryFallbackTable[i];
        }

        scratch[0] = 0;
        WDISP_SPrintf(scratch, TLIBA1_FMT_PCT_C_PCT_S, (LONG)tag, fieldList[i]);
        STRING_AppendAtNull(dst, scratch);
    }
}
