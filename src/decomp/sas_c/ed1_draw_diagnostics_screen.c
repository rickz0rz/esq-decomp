typedef signed long LONG;
typedef signed short WORD;
typedef signed char BYTE;

extern BYTE ED_MenuStateId;
extern WORD ED_DiagnosticsScreenActive;

extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern LONG Global_REF_BAUD_RATE;

extern char ESQ_SelectCodeBuffer[];
extern char WDISP_WeatherStatusLabelBuffer[];
extern LONG ED2_DiagnosticDiskUsagePercent;
extern LONG ED2_DiagnosticDiskSoftErrorCount;

extern const char Global_STR_BAUD_RATE_DIAGNOSTIC_MODE[];
extern const char Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS[];
extern const char Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2[];

extern void ED_DrawBottomHelpBarBackground(void);
extern LONG DISPLIB_DisplayTextAtPosition(void *rastPort, LONG y, LONG x, const char *text);
extern LONG GROUP_AM_JMPTBL_WDISP_SPrintf(char *dst, const char *fmt, ...);
extern LONG DISKIO_QueryDiskUsagePercentAndSetBufferSize(LONG *outPercent);
extern LONG DISKIO_QueryVolumeSoftErrorCount(LONG *outCount);
extern void ED_DrawDiagnosticModeText(void);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);

void ED1_DrawDiagnosticsScreen(void)
{
    char printfResult[41];
    LONG diskUsagePercent;
    LONG diskSoftErrorCount;

    ED_MenuStateId = 7;
    ED_DiagnosticsScreenActive = 1;

    ED_DrawBottomHelpBarBackground();

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 360, ESQ_SelectCodeBuffer);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 210, 360, WDISP_WeatherStatusLabelBuffer);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        printfResult,
        Global_STR_BAUD_RATE_DIAGNOSTIC_MODE,
        Global_REF_BAUD_RATE
    );
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 410, 360, printfResult);

    diskUsagePercent = DISKIO_QueryDiskUsagePercentAndSetBufferSize(&ED2_DiagnosticDiskUsagePercent);
    diskSoftErrorCount = DISKIO_QueryVolumeSoftErrorCount(&ED2_DiagnosticDiskSoftErrorCount);

    GROUP_AM_JMPTBL_WDISP_SPrintf(
        printfResult,
        Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS,
        diskUsagePercent,
        diskSoftErrorCount
    );
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 88, printfResult);

    ED_DrawDiagnosticModeText();

    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 6);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 390, Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
