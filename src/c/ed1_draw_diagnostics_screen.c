/* RESTORES: ED1_DrawDiagnosticsScreen
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * 252 bytes in the original, 260 emitted, 8 differing regions.
 *
 * Reproduces: the state-id and active-flag writes, all five
 * DisplayTextAtPosition placements with their exact coordinates, both SPrintf
 * calls, and the two-query disk line -- including that the first query's result
 * is parked deep in the stack (MOVE.L D0,64(A7)) across the second call and
 * pushed back afterwards, so the two values reach SPrintf in the right order
 * without a local.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffd0                   LINK.W A5,#-48
 *   got:     9efc002c                   SUBA.W #44,A7
 *   summary: The A5-frame class; the 41-byte format buffer moves to A7-relative.
 *
 * SASC-MISMATCH: a6-preserved-across-libcall
 *   summary: SAS/C adds 48E70302 saving A6 and D2 for the graphics calls; the
 *            original saves nothing at all, having no register variables to keep.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the nine cross-unit calls.
 */
#include "esq-graphics.h"

extern void ED_DrawBottomHelpBarBackground(void);
extern void ED_DrawDiagnosticModeText(void);
extern void DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void GROUP_AM_JMPTBL_WDISP_SPrintf();
extern long DISKIO_QueryDiskUsagePercentAndSetBufferSize(char *unit);
extern long DISKIO_QueryVolumeSoftErrorCount(char *unit);

extern struct RastPort *Global_REF_RASTPORT_1;
extern unsigned char ED_MenuStateId;
extern short ED_DiagnosticsScreenActive;
extern long Global_REF_BAUD_RATE;
extern char ESQ_SelectCodeBuffer[];
extern char WDISP_WeatherStatusLabelBuffer[];
extern char ED2_DiagnosticDiskUsagePercent[];
extern char ED2_DiagnosticDiskSoftErrorCount[];
extern char Global_STR_BAUD_RATE_DIAGNOSTIC_MODE[];
extern char Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS[];
extern char Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2[];

void ED1_DrawDiagnosticsScreen(void)
{
    char printfResult[41];
    long pct;
    long errs;

    ED_MenuStateId = 7;
    ED_DiagnosticsScreenActive = 1;
    ED_DrawBottomHelpBarBackground();

    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 90, 360, ESQ_SelectCodeBuffer);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 210, 360,
                                  WDISP_WeatherStatusLabelBuffer);

    GROUP_AM_JMPTBL_WDISP_SPrintf(printfResult, Global_STR_BAUD_RATE_DIAGNOSTIC_MODE,
                                  Global_REF_BAUD_RATE);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 410, 360, printfResult);

    pct  = DISKIO_QueryDiskUsagePercentAndSetBufferSize(ED2_DiagnosticDiskUsagePercent);
    errs = DISKIO_QueryVolumeSoftErrorCount(ED2_DiagnosticDiskSoftErrorCount);
    GROUP_AM_JMPTBL_WDISP_SPrintf(printfResult,
                                  Global_STR_DISK_0_IS_VAR_FULL_WITH_VAR_ERRORS,
                                  pct, errs);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 40, 88, printfResult);

    ED_DrawDiagnosticModeText();
    SetAPen(Global_REF_RASTPORT_1, 6L);
    DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 175, 390,
                                  Global_STR_PUSH_ANY_KEY_TO_CONTINUE_2);
    SetAPen(Global_REF_RASTPORT_1, 1L);
}
