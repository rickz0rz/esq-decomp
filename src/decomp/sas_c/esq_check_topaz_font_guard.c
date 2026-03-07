typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef signed long LONG;

extern void *Global_REF_INTUITION_LIBRARY;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern UBYTE Global_STR_PLEASE_STANDBY_1[];
extern UBYTE Global_STR_ATTENTION_SYSTEM_ENGINEER_1[];
extern UBYTE Global_STR_REPORT_CODE_ER003[];
extern UBYTE Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE[];

extern void GROUP_MAIN_B_JMPTBL_DOS_Delay(LONG ticks);
extern LONG GROUP_MAIN_B_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern void GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(const UBYTE *text);
extern void GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(LONG code);

extern void _LVOSetAPen(void *rastPort, LONG pen);
extern void _LVORectFill(void *rastPort, LONG minX, LONG minY, LONG maxX, LONG maxY);
extern void _LVOMove(void *rastPort, LONG x, LONG y);
extern void _LVOText(void *rastPort, const UBYTE *text, LONG length);
extern void _LVOSizeWindow(void *window, LONG deltaX, LONG deltaY);
extern void _LVORemakeDisplay(void);
extern void _LVOFreeMem(void *memory, LONG byteSize);

void ESQ_CheckTopazFontGuard(void)
{
    UBYTE *intuition;
    UBYTE *topazFont;
    UBYTE *window;
    UBYTE *secondaryLine;
    UBYTE *rastPort;
    LONG widthSlots;
    LONG freeStart;
    LONG freeEnd;
    LONG freeSize;
    LONG deltaY;

    intuition = (UBYTE *)Global_REF_INTUITION_LIBRARY;
    topazFont = *(UBYTE **)(intuition + 0x38);
    secondaryLine = topazFont + 0xB8;

    if (secondaryLine[5] != 2) {
        GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(Global_STR_YOU_CANNOT_RE_RUN_THE_SOFTWARE);
        GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(0);
        return;
    }

    window = *(UBYTE **)(intuition + 0x34);
    if (*(UWORD *)(intuition + 20) <= 33) {
        GROUP_MAIN_B_JMPTBL_DOS_Delay(250);

        rastPort = topazFont + 0x54;
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

    deltaY = 50 - (LONG)(WORD)(*(UWORD *)(window + 10));
    _LVOSizeWindow(window, 0, deltaY);

    GROUP_MAIN_B_JMPTBL_DOS_Delay(100);

    *(UWORD *)(topazFont + 14) = 50;
    *(UWORD *)(secondaryLine + 2) = 50;
    secondaryLine[5] = 1;

    widthSlots = GROUP_MAIN_B_JMPTBL_MATH_Mulu32((LONG)(WORD)(*(UWORD *)(topazFont + 14)), 640);
    widthSlots >>= 3;

    freeStart = *(LONG *)(secondaryLine + 8) + 4000;
    freeEnd = *(LONG *)(secondaryLine + 12) + widthSlots;

    *(LONG *)(secondaryLine + 12) = 0;

    _LVORemakeDisplay();
    freeSize = freeEnd - freeStart;
    _LVOFreeMem((void *)freeStart, freeSize);
}
