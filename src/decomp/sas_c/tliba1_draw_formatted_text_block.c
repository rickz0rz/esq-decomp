typedef signed long LONG;
typedef signed short WORD;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

extern WORD TEXTDISP_LinePenOverrideEnabledFlag;
extern UBYTE CLOCK_AlignedInsetRenderGateFlag;
extern UBYTE CLEANUP_AlignedInsetNibblePrimary;
extern void *Global_HANDLE_PREVUE_FONT;
extern char Global_STR_TLIBA1_C_3[];
extern char TLIBA1_STR_TLIBA1_DOT_C[];

extern ULONG MATH_Mulu32(ULONG a, ULONG b);
extern LONG MATH_DivS32(LONG dividend, LONG divisor);
extern void *MEMORY_AllocateMemory(char *owner, LONG line, LONG bytes, ULONG flags);
extern void MEMORY_DeallocateMemory(char *owner, LONG line, void *ptr, ULONG bytes);
extern LONG _LVOTextLength(char *rastPort, char *text, LONG len);
extern void _LVOSetAPen(char *rastPort, LONG pen);
extern void _LVOSetFont(char *rastPort, void *font);
extern void TLIBA1_DrawInlineStyledText(char *rastPort, LONG x, LONG y, char *text);

typedef struct TLIBA1_RastPort {
    UBYTE pad0[25];
    UBYTE fgPen25;
    UBYTE pad26[26];
    void *font52;
} TLIBA1_RastPort;

static LONG TLIBA1_StrLen(const char *s)
{
    LONG n;
    n = 0;
    while (s[n] != 0) {
        ++n;
    }
    return n;
}

void TLIBA1_DrawFormattedTextBlock(
    char *rastPort,
    char *text,
    WORD left,
    WORD top,
    WORD right,
    WORD bottom,
    WORD arg7,
    UBYTE arg8,
    WORD arg9,
    void *arg10,
    void *arg11,
    void *arg12,
    void *arg13,
    WORD arg14,
    WORD arg15,
    WORD arg16,
    WORD arg17)
{
    TLIBA1_RastPort *rp;
    LONG boxW;
    LONG boxH;
    LONG runCount;
    LONG runGate;
    char *p;
    UBYTE savedPen;
    void *savedFont;
    UBYTE *records;
    ULONG allocSize;
    LONG lineWidth;
    LONG x;
    LONG y;

    (void)arg7;
    (void)arg8;
    (void)arg9;
    (void)arg10;
    (void)arg11;
    (void)arg12;
    (void)arg13;
    (void)arg14;
    (void)arg15;
    (void)arg16;
    (void)arg17;

    boxW = (LONG)right - (LONG)left + 1;
    boxH = (LONG)bottom - (LONG)top + 1;
    runCount = 0;
    runGate = 0;
    p = text;
    rp = (TLIBA1_RastPort *)rastPort;
    savedPen = rp->fgPen25;
    savedFont = rp->font52;

    (void)MATH_DivS32(boxH, 1);

    while (*p != 0) {
        UBYTE c;

        c = (UBYTE)*p;
        if (c == 24 || c == 25 || c == 6) {
            if (runGate == 0) {
                runCount += 1;
                runGate = 1;
            }
        } else {
            runGate = 0;
        }
        ++p;
    }

    if (runCount == 0) {
        return;
    }

    allocSize = MATH_Mulu32((ULONG)runCount, 10UL);
    records = (UBYTE *)MEMORY_AllocateMemory(Global_STR_TLIBA1_C_3, 2115, (LONG)allocSize, 0x10001UL);
    if (records == (UBYTE *)0) {
        return;
    }

    if (TEXTDISP_LinePenOverrideEnabledFlag != 0) {
        _LVOSetAPen(rastPort, 0);
    }

    _LVOSetFont(rastPort, Global_HANDLE_PREVUE_FONT);

    lineWidth = _LVOTextLength(rastPort, text, TLIBA1_StrLen(text));
    if (CLOCK_AlignedInsetRenderGateFlag != 0 && CLEANUP_AlignedInsetNibblePrimary != 0xFF) {
        lineWidth += 8;
    }
    if (lineWidth > boxW) {
        lineWidth = boxW;
    }

    {
        LONG dx;
        dx = boxW - lineWidth;
        if (dx < 0) {
            dx += 1;
        }
        x = (LONG)left + (dx >> 1);
    }

    {
        LONG dy;
        dy = boxH - 1;
        if (dy < 0) {
            dy += 1;
        }
        y = (LONG)top + (dy >> 1);
    }

    TLIBA1_DrawInlineStyledText(rastPort, x, y, text);

    _LVOSetAPen(rastPort, (LONG)savedPen);
    _LVOSetFont(rastPort, savedFont);

    MEMORY_DeallocateMemory(TLIBA1_STR_TLIBA1_DOT_C, 2385, records, allocSize);
}
