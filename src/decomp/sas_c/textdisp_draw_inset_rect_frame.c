typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG WDISP_DisplayContextBase;
extern char *Global_REF_RASTPORT_2;

extern void TLIBA1_DrawFormattedTextBlock(char *rastPort, const char *text, LONG x1, LONG y1, LONG x2, LONG y2);

typedef struct TEXTDISP_DisplayContext {
    UBYTE pad0[2];
    WORD width;
    WORD height;
    UBYTE pad6[4];
    UBYTE rastPort[1];
} TEXTDISP_DisplayContext;

void TEXTDISP_DrawInsetRectFrame(const char *text, WORD mode)
{
    TEXTDISP_DisplayContext *context;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;

    context = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;
    x1 = 0;
    x2 = (LONG)context->width - 1;
    y1 = 0;
    y2 = (LONG)context->height - 1;

    if (mode == 2) {
        x1 = x2;
        if ((WORD)x1 < 0) {
            ++x1;
        }
        x1 >>= 1;
        x1 += 1;
    }

    if (mode == 3) {
        TLIBA1_DrawFormattedTextBlock(Global_REF_RASTPORT_2, text, x1, y1, x2, y2);
    } else {
        TLIBA1_DrawFormattedTextBlock((char *)context->rastPort, text, x1, y1, x2, y2);
    }
}
