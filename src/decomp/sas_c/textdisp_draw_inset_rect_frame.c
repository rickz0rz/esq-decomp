typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG WDISP_DisplayContextBase;
extern void *Global_REF_RASTPORT_2;

extern void TLIBA1_DrawFormattedTextBlock(void *rastPort, const char *text, LONG x1, LONG y1, LONG x2, LONG y2);

void TEXTDISP_DrawInsetRectFrame(UBYTE *text, WORD mode)
{
    UBYTE *context;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;

    context = (UBYTE *)WDISP_DisplayContextBase;
    x1 = 0;
    x2 = (LONG)*(WORD *)(context + 2) - 1;
    y1 = 0;
    y2 = (LONG)*(WORD *)(context + 4) - 1;

    if (mode == 2) {
        x1 = x2;
        if ((WORD)x1 < 0) {
            ++x1;
        }
        x1 >>= 1;
        x1 += 1;
    }

    if (mode == 3) {
        TLIBA1_DrawFormattedTextBlock(Global_REF_RASTPORT_2, (const char *)text, x1, y1, x2, y2);
    } else {
        TLIBA1_DrawFormattedTextBlock((void *)(context + 10), (const char *)text, x1, y1, x2, y2);
    }
}
