#include <exec/types.h>
extern void *Global_REF_INTUITION_LIBRARY;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char Global_STR_PLEASE_STANDBY_1[];
extern const char Global_STR_ATTENTION_SYSTEM_ENGINEER_1[];
extern const char Global_STR_REPORT_CODE_ER003[];
extern const char Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE[];

extern LONG DOS_Delay(LONG ticks);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern void STREAM_BufferedWriteString(const char *text);
extern LONG BUFFER_FlushAllAndCloseWithCode(LONG code);

extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVORectFill(char *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void _LVOMove(char *rastPort, LONG x, LONG y);
extern void _LVOText(char *rastPort, const char *text, LONG length);
extern void _LVOSizeWindow(void *window, LONG deltaX, LONG deltaY);
extern void _LVORemakeDisplay(void);
extern void _LVOFreeMem(void *memory, LONG byteSize);

typedef struct ESQ_SecondaryLine {
    UBYTE pad0[2];
    UWORD height2;
    UBYTE pad4;
    UBYTE mode5;
    UBYTE pad6[2];
    LONG freeStart8;
    LONG freeEnd12;
} ESQ_SecondaryLine;

typedef struct ESQ_TopazFontView {
    UBYTE pad0[14];
    UWORD height14;
    UBYTE pad16[0x54 - 16];
    UBYTE rastPort54[0xB8 - 0x54];
    ESQ_SecondaryLine secondaryLine;
} ESQ_TopazFontView;

typedef struct ESQ_WindowView {
    UBYTE pad0[10];
    UWORD height10;
} ESQ_WindowView;

typedef struct ESQ_IntuitionView {
    UBYTE pad0[20];
    UWORD monitorDepth20;
    UBYTE pad22[0x34 - 22];
    ESQ_WindowView *window34;
    ESQ_TopazFontView *topazFont38;
} ESQ_IntuitionView;

void ESQ_CheckTopazFontGuard(void)
{
    ESQ_IntuitionView *intuition;
    ESQ_TopazFontView *topazFont;
    ESQ_WindowView *window;
    ESQ_SecondaryLine *secondaryLine;
    char *rastPort;
    LONG widthSlots;
    LONG freeStart;
    LONG freeEnd;
    LONG freeSize;
    LONG deltaY;

    intuition = (ESQ_IntuitionView *)Global_REF_INTUITION_LIBRARY;
    topazFont = intuition->topazFont38;
    secondaryLine = &topazFont->secondaryLine;

    if (secondaryLine->mode5 != 2) {
        STREAM_BufferedWriteString(Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE);
        BUFFER_FlushAllAndCloseWithCode(0);
        return;
    }

    window = intuition->window34;
    if (intuition->monitorDepth20 <= 33) {
        DOS_Delay(250);

        rastPort = topazFont->rastPort54;
        _LVOSetAPen(rastPort, 2);
        _LVORectFill(rastPort, 0, 0, 639, 255);
        _LVOSetAPen(rastPort, 1);

        _LVOMove(rastPort, 20, 100);
        _LVOText(rastPort, Global_STR_PLEASE_STANDBY_1, 25);

        _LVOMove(rastPort, 20, 113);
        _LVOText(rastPort, Global_STR_ATTENTION_SYSTEM_ENGINEER_1, 26);

        _LVOMove(rastPort, 20, 126);
        _LVOText(rastPort, Global_STR_REPORT_CODE_ER003, 47);

        for (;;) {
        }
    }

    deltaY = 50 - (LONG)(WORD)(window->height10);
    _LVOSizeWindow(window, 0, deltaY);

    DOS_Delay(100);

    topazFont->height14 = 50;
    secondaryLine->height2 = 50;
    secondaryLine->mode5 = 1;

    widthSlots = MATH_Mulu32((LONG)(WORD)(topazFont->height14), 640);
    widthSlots >>= 3;

    freeStart = secondaryLine->freeStart8 + 4000;
    freeEnd = secondaryLine->freeEnd12 + widthSlots;

    secondaryLine->freeEnd12 = 0;

    _LVORemakeDisplay();
    freeSize = freeEnd - freeStart;
    _LVOFreeMem((void *)freeStart, freeSize);
}
