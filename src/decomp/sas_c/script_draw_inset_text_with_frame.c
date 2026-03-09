typedef signed long LONG;
typedef signed char BYTE;
typedef unsigned char UBYTE;

extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOTextLength(char *rastport, const char *text, LONG len);
extern void _LVOText(char *rastport, const char *text, LONG len);
extern void _LVOSetAPen(char *rastport, LONG pen);
extern void TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(char *rastport, LONG framePen, LONG width, LONG depth);

static LONG cstrlen_local(const char *s)
{
    LONG n = 0;
    while (s[n] != '\0') {
        n++;
    }
    return n;
}

void SCRIPT_DrawInsetTextWithFrame(char *rastport, BYTE textPenOverride, BYTE framePen, const char *text)
{
    const LONG PEN_NONE = -1;
    const LONG RP_X_OFFSET = 36;
    const LONG RP_Y_OFFSET = 38;
    const LONG RP_FONT_HEIGHT_OFFSET = 58;
    const LONG RP_APEN_OFFSET = 25;
    const LONG FRAME_WIDTH_PAD = 4;
    const LONG FRAME_Y_RESTORE = 2;
    const char CH_NUL = '\0';
    LONG textLen;
    LONG savedPen = 0;
    UBYTE *rp = (UBYTE *)rastport;

    if (text == 0 || *text == CH_NUL) {
        return;
    }

    if ((LONG)framePen != PEN_NONE) {
        *(unsigned short *)(rp + RP_X_OFFSET) =
            (unsigned short)(*(unsigned short *)(rp + RP_X_OFFSET) + FRAME_WIDTH_PAD);
        textLen = cstrlen_local(text);
        TEXTDISP_JMPTBL_CLEANUP_DrawInsetRectFrame(
            rastport,
            (LONG)framePen,
            _LVOTextLength(rastport, text, textLen),
            (LONG)*(unsigned short *)(rp + RP_FONT_HEIGHT_OFFSET));
    }

    if ((LONG)textPenOverride != PEN_NONE) {
        savedPen = (LONG)rp[RP_APEN_OFFSET];
        _LVOSetAPen(rastport, (LONG)textPenOverride);
    }

    textLen = cstrlen_local(text);
    _LVOText(rastport, text, textLen);

    if ((LONG)textPenOverride != PEN_NONE) {
        _LVOSetAPen(rastport, savedPen);
    }

    if ((LONG)framePen != PEN_NONE) {
        *(unsigned short *)(rp + RP_Y_OFFSET) =
            (unsigned short)(*(unsigned short *)(rp + RP_Y_OFFSET) - FRAME_Y_RESTORE);
        *(unsigned short *)(rp + RP_X_OFFSET) =
            (unsigned short)(*(unsigned short *)(rp + RP_X_OFFSET) + FRAME_WIDTH_PAD);
    }
}
