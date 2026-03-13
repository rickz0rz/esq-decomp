typedef signed long LONG;
typedef signed char BYTE;

extern LONG WDISP_DisplayContextBase;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern BYTE CONFIG_NicheModeCycleBudget_Y;
extern BYTE CONFIG_NicheModeCycleBudget_Static;
extern BYTE CONFIG_NicheModeCycleBudget_Custom;
extern BYTE CONFIG_ModeCycleEnabledFlag;
extern LONG CONFIG_ModeCycleGateDuration;
extern LONG CONFIG_TimeWindowMinutes;
extern BYTE CTASKS_STR_1;

extern const char ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D[];
extern const char ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR[];
extern const char Global_STR_CLOCKCMD_EQUALS_PCT_C[];

extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern void ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

typedef struct ED1_DisplayContext {
    unsigned char pad0[2];
    unsigned char rastPort[1];
} ED1_DisplayContext;

void ED1_DrawStatusLine2(void)
{
    const LONG PEN_BG = 2;
    ED1_DisplayContext *context;
    char statusLine[51];
    char *rastPort;

    context = (ED1_DisplayContext *)WDISP_DisplayContextBase;
    rastPort = (char *)context->rastPort;

    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rastPort, PEN_BG);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        statusLine,
        ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D,
        (LONG)CONFIG_NicheModeCycleBudget_Y,
        (LONG)CONFIG_NicheModeCycleBudget_Static,
        (LONG)CONFIG_NicheModeCycleBudget_Custom
    );
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, statusLine, 120);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        statusLine,
        ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR,
        (LONG)CONFIG_ModeCycleEnabledFlag,
        CONFIG_ModeCycleGateDuration,
        CONFIG_TimeWindowMinutes
    );
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, statusLine, 150);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        statusLine,
        Global_STR_CLOCKCMD_EQUALS_PCT_C,
        (LONG)CTASKS_STR_1
    );
    ESQFUNC_JMPTBL_TLIBA3_DrawCenteredWrappedTextLines(rastPort, statusLine, 180);
}
