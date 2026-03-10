typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef short WORD;
typedef long LONG;

typedef struct CLEANUP_RastPort {
    LONG textWidth0;
    UBYTE pad4[28];
    UWORD flags32;
} CLEANUP_RastPort;

enum {
    RASTPORT_TEXTWIDTH_OFFSET = 0,
    RASTPORT_FLAGS_OFFSET = 32,
    RASTPORT_FLAGMASK_CLEAR_BIT3 = 0xFFF7,
    GRID_TIME_BANNER_WIDTH = 216,
    GRID_TIME_SUFFIX_INDEX = 9
};

extern LONG Global_REF_RASTPORT_1;
extern UBYTE Global_REF_STR_USE_24_HR_CLOCK;
extern WORD Global_WORD_CURRENT_HOUR;
extern WORD CLOCK_CurrentAmPmFlag;
extern WORD Global_WORD_CURRENT_MINUTE;
extern WORD Global_WORD_CURRENT_SECOND;
extern WORD CLOCK_CurrentDayOfWeekIndex;
extern const char Global_STR_GRID_TIME_FORMAT_DUPLICATE[];
extern const char Global_STR_12_44_44_SINGLE_SPACE[];
extern const char Global_STR_12_44_44_PM[];

void _LVOSetAPen(void);
void _LVOSetDrMd(void);
void _LVORectFill(void);
void _LVOTextLength(void);
void _LVOMove(void);
void _LVOText(void);
void ESQ_FormatTimeStamp(char *dst, void *clock_ref);
LONG GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat(LONG hour, LONG ampm);
LONG GROUP_AE_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, LONG a, LONG b, LONG c);
void GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort(void);

void CLEANUP_DrawGridTimeBanner(void)
{
    CLEANUP_RastPort *rp;
    char timeBuffer[32];
    char ampm_suffix;
    LONG sampleWidth;
    LONG textWidth;
    LONG x;

    rp = (CLEANUP_RastPort *)Global_REF_RASTPORT_1;
    ESQ_FormatTimeStamp(timeBuffer, &CLOCK_CurrentDayOfWeekIndex);
    _LVOSetAPen();
    rp->flags32 = (UWORD)(rp->flags32 & RASTPORT_FLAGMASK_CLEAR_BIT3);
    _LVOSetDrMd();
    _LVORectFill();
    _LVOSetAPen();

    ampm_suffix = timeBuffer[GRID_TIME_SUFFIX_INDEX];
    timeBuffer[GRID_TIME_SUFFIX_INDEX] = 0;

    if (Global_REF_STR_USE_24_HR_CLOCK == 'Y') {
        LONG hour = GROUP_AC_JMPTBL_PARSEINI_AdjustHoursTo24HrFormat((LONG)Global_WORD_CURRENT_HOUR, (LONG)CLOCK_CurrentAmPmFlag);
        GROUP_AE_JMPTBL_WDISP_SPrintf(
            timeBuffer,
            Global_STR_GRID_TIME_FORMAT_DUPLICATE,
            hour,
            (LONG)Global_WORD_CURRENT_MINUTE,
            (LONG)Global_WORD_CURRENT_SECOND
        );
    }

    _LVOTextLength();
    sampleWidth = rp->textWidth0;

    if (Global_REF_STR_USE_24_HR_CLOCK == 'N') {
        _LVOTextLength();
        textWidth = rp->textWidth0;
    } else {
        textWidth = sampleWidth;
    }

    x = (GRID_TIME_BANNER_WIDTH - textWidth);
    if (x < 0) {
        x++;
    }
    x >>= 1;

    _LVOMove();
    _LVOText();

    if (Global_REF_STR_USE_24_HR_CLOCK == 'N') {
        char sfx[2];
        sfx[0] = ampm_suffix;
        sfx[1] = 0;
        _LVOMove();
        _LVOText();
    }

    GROUP_AD_JMPTBL_GRAPHICS_BltBitMapRastPort();
}
