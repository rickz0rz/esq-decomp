typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct WeatherDayEntry {
    LONG unk0;
    LONG brushIndex;
    LONG highTemp;
    LONG lowTemp;
    LONG mode;
} WeatherDayEntry;

extern WeatherDayEntry WDISP_StatusDayEntry0[];
extern ULONG ESQFUNC_STR_I5[];
extern ULONG ESQFUNC_PwBrushListHead;
extern const char Global_STR_PERCENT_D_SLASH[];
extern const char Global_STR_PERCENT_D[];
extern const char WDISP_STR_UNKNOWN_NUM_WITH_SLASH[];
extern const char WDISP_STR_UNKNOWN_NUM[];

extern void *WDISP_JMPTBL_BRUSH_FindBrushByPredicate(void *predicate, void *listHead);
extern void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern void STRING_AppendAtNull(char *dst, const char *src);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);

void WDISP_DrawWeatherStatusDayEntry(void *rastPort, LONG dayIndex, LONG xSpan, LONG ySpan)
{
    WeatherDayEntry *entry;
    LONG brushIndex;
    LONG brushW;
    LONG brushH;
    char hiBuf[24];
    char loBuf[24];

    (void)rastPort;
    (void)xSpan;
    (void)ySpan;

    if (dayIndex < 0 || dayIndex >= 4) {
        return;
    }

    entry = &WDISP_StatusDayEntry0[MATH_Mulu32(dayIndex, 20) / 20];
    brushIndex = entry->brushIndex;

    if (entry->mode != 1 && (brushIndex < 2 || brushIndex > 6)) {
        brushIndex = 2;
    }

    if (WDISP_JMPTBL_BRUSH_FindBrushByPredicate((void *)ESQFUNC_STR_I5[(ULONG)brushIndex],
                                                (void *)&ESQFUNC_PwBrushListHead) != (void *)0) {
        brushW = 1;
        brushH = 1;
    } else {
        brushW = 0;
        brushH = 90;
        WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();
    }
    (void)brushW;
    (void)brushH;

    if (entry->highTemp == -999) {
        hiBuf[0] = (UBYTE)WDISP_STR_UNKNOWN_NUM_WITH_SLASH[0];
        hiBuf[1] = (UBYTE)WDISP_STR_UNKNOWN_NUM_WITH_SLASH[1];
        hiBuf[2] = (UBYTE)WDISP_STR_UNKNOWN_NUM_WITH_SLASH[2];
        hiBuf[3] = 0;
    } else {
        WDISP_SPrintf(hiBuf, Global_STR_PERCENT_D_SLASH, entry->highTemp);
    }

    if (entry->lowTemp == -999) {
        loBuf[0] = (UBYTE)WDISP_STR_UNKNOWN_NUM[0];
        loBuf[1] = (UBYTE)WDISP_STR_UNKNOWN_NUM[1];
        loBuf[2] = (UBYTE)WDISP_STR_UNKNOWN_NUM[2];
        loBuf[3] = 0;
    } else {
        WDISP_SPrintf(loBuf, Global_STR_PERCENT_D, entry->lowTemp);
    }

    STRING_AppendAtNull(hiBuf, loBuf);
}
