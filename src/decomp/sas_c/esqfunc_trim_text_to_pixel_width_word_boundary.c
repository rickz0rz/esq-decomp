typedef signed long LONG;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern UBYTE WDISP_CharClassTable[];

extern LONG _LVOTextLength(void *rastport, char *text, LONG len);

LONG ESQFUNC_TrimTextToPixelWidthWordBoundary(void *rastport, LONG max_width, char *text)
{
    LONG len;
    char *scan;

    scan = text;
    while (*scan != 0) {
        ++scan;
    }

    len = (LONG)(scan - text);

    for (;;) {
        if (len <= 0) {
            return len;
        }

        if (_LVOTextLength(rastport, text, len) <= max_width) {
            return len;
        }

        do {
            len -= 1;
            if (len <= 0) {
                break;
            }
        } while ((WDISP_CharClassTable[(UBYTE)text[len - 1]] & 8) == 0);

        while (len > 0 && (WDISP_CharClassTable[(UBYTE)text[len - 1]] & 8) != 0) {
            len -= 1;
        }
    }
}
