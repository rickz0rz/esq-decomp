typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

extern LONG Global_REF_RASTPORT_1;
extern LONG Global_REF_696_400_BITMAP;
extern char *Global_JMPTBL_SHORT_DAYS_OF_WEEK[];
extern char *Global_JMPTBL_SHORT_MONTHS[];
extern char Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED[];
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern WORD CLOCK_CurrentMonthIndex;
extern WORD CLOCK_CurrentDayOfMonth;

void _LVOSetAPen(void);
void _LVOSetDrMd(void);
void _LVORectFill(void);
void _LVOTextLength(void);
void _LVOMove(void);
void _LVOText(void);
void GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, char *a, char *b, LONG c);
void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void);

void RENDER_SHORT_MONTH_SHORT_DAY_OF_WEEK_DAY(void)
{
    char text[32];
    char *dow;
    char *mon;
    LONG text_w;
    LONG x;

    *(LONG *)(Global_REF_RASTPORT_1 + 4) = (LONG)&Global_REF_696_400_BITMAP;

    dow = Global_JMPTBL_SHORT_DAYS_OF_WEEK[(LONG)CLOCK_CurrentDayOfWeekIndex];
    mon = Global_JMPTBL_SHORT_MONTHS[(LONG)CLOCK_CurrentMonthIndex];
    GROUP_AE_JMPTBL_WDISP_SPrintf(text, Global_STR_SHORT_MONTH_SHORT_DAY_OF_WEEK_FORMATTED, dow, mon, (LONG)CLOCK_CurrentDayOfMonth);

    _LVOSetAPen();
    *(UWORD *)(Global_REF_RASTPORT_1 + 32) = (UWORD)(*(UWORD *)(Global_REF_RASTPORT_1 + 32) & 0xFFF7);
    _LVOSetDrMd();
    _LVORectFill();
    _LVOSetAPen();

    _LVOTextLength();
    text_w = *(LONG *)(Global_REF_RASTPORT_1);
    x = (216 - text_w);
    if (x < 0) {
        x++;
    }
    x >>= 1;

    _LVOMove();
    _LVOText();

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort();
}
