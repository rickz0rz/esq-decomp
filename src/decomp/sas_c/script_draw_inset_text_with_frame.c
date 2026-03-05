typedef signed long LONG;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOTextLength(void *rastport, const char *text, LONG len);
extern void _LVOText(void *rastport, const char *text, LONG len);
extern void _LVOSetAPen(void *rastport, LONG pen);
extern void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(void *rastport, LONG framePen, LONG width, LONG depth);

static LONG cstrlen_local(const char *s)
{
    LONG n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_DrawInsetTextWithFrame(void *rastport, BYTE textPenOverride, BYTE framePen, const char *text)
{
    LONG textLen;
    LONG savedPen = 0;
    UBYTE *rp = (UBYTE *)rastport;

    if (text == 0 || *text == '\0') {
        return;
    }

    if ((LONG)framePen != -1) {
        *(unsigned short *)(rp + 36) = (unsigned short)(*(unsigned short *)(rp + 36) + 4);
        textLen = cstrlen_local(text);
        TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(
            rastport,
            (LONG)framePen,
            _LVOTextLength(rastport, text, textLen),
            (LONG)*(unsigned short *)(rp + 58));
    }

    if ((LONG)textPenOverride != -1) {
        savedPen = (LONG)rp[25];
        _LVOSetAPen(rastport, (LONG)textPenOverride);
    }

    textLen = cstrlen_local(text);
    _LVOText(rastport, text, textLen);

    if ((LONG)textPenOverride != -1) {
        _LVOSetAPen(rastport, savedPen);
    }

    if ((LONG)framePen != -1) {
        *(unsigned short *)(rp + 38) = (unsigned short)(*(unsigned short *)(rp + 38) - 2);
        *(unsigned short *)(rp + 36) = (unsigned short)(*(unsigned short *)(rp + 36) + 4);
    }
}
