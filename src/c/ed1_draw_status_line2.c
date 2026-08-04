/* RESTORES: ED1_DrawStatusLine2
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * 228 bytes in the original, 236 emitted, 11 differing regions. Sibling of
 * ed1_draw_status_line1.c and shares its shape.
 *
 * Reproduces: the SetRast on the secondary rastport, all three
 * SPrintf-then-DrawCenteredWrappedTextLines pairs at y = 120 / 150 / 180, the
 * sign-extension of every char config value to long before it is pushed, and the
 * second format call's mixed argument list (one extended char followed by two
 * longs) including the stack-slot reuse that puts CONFIG_TimeWindowMinutes back
 * into the slot the previous call left behind.
 *
 * SASC-MISMATCH: lea-vs-adda-for-struct-offset
 *   ref:     41e8000a                   LEA 10(A0),A0
 *   got:     d0fc000a                   ADDA.W #10,A0
 *   summary: Reaching the embedded rastport at DisplayContextBase+10. Both are
 *            four bytes and both leave the same value in A0, so this costs
 *            nothing -- but it recurs at all four sites in this function and is
 *            worth naming rather than leaving as unexplained diff noise.
 *   scope:   every fixed offset applied to a pointer held in an address register.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ffcc 2f02              LINK.W A5,#-52 / MOVE.L D2,-(A7)
 *   got:     9efc0034 48e7...           SUBA.W #52,A7 / MOVEM
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the six cross-unit calls.
 */
#include "esq-graphics.h"

extern void WDISP_SPrintf();
extern void TLIBA3_DrawCenteredWrappedTextLines(void *rp, char *s, long y);
extern void *WDISP_DisplayContextBase;
extern char CONFIG_NicheModeCycleBudget_Y;
extern char CONFIG_NicheModeCycleBudget_Static;
extern char CONFIG_NicheModeCycleBudget_Custom;
extern char CONFIG_ModeCycleEnabledFlag;
extern long CONFIG_ModeCycleGateDuration;
extern long CONFIG_TimeWindowMinutes;
extern char CTASKS_STR_1;
extern char ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D[];
extern char ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR[];
extern char Global_STR_CLOCKCMD_EQUALS_PCT_C[];

void ED1_DrawStatusLine2(void)
{
    char statusLine[51];

    SetRast((struct RastPort *)((char *)WDISP_DisplayContextBase + 10), 2L);

    WDISP_SPrintf(statusLine, ED2_FMT_MR_PCT_D_SBS_PCT_D_SPORT_PCT_D,
                                  (long)CONFIG_NicheModeCycleBudget_Y,
                                  (long)CONFIG_NicheModeCycleBudget_Static,
                                  (long)CONFIG_NicheModeCycleBudget_Custom);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, statusLine, 120);

    WDISP_SPrintf(statusLine,
                                  ED2_FMT_CYCLE_PCT_C_CYCLEFREQ_PCT_D_AFTRORDR,
                                  (long)CONFIG_ModeCycleEnabledFlag,
                                  CONFIG_ModeCycleGateDuration,
                                  CONFIG_TimeWindowMinutes);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, statusLine, 150);

    WDISP_SPrintf(statusLine, Global_STR_CLOCKCMD_EQUALS_PCT_C,
                                  (long)CTASKS_STR_1);
    TLIBA3_DrawCenteredWrappedTextLines(
        (char *)WDISP_DisplayContextBase + 10, statusLine, 180);
}
