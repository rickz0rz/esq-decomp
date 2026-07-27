/* RESTORES: ESQIFF2_ShowAttentionOverlay
 * MODULE:   modules/groups/a/o/esqiff2.s
 * STATUS:   behavioural
 *
 * 478 bytes in the original and 478 emitted -- a COINCIDENCE, not a near-match.
 * There are 19 differing regions. This is the second restoration to land on the
 * original's exact size by accident (see ed_handle_edit_attributes_menu.c); size
 * equality is not evidence of fidelity and should not be read as such.
 *
 * Reproduces: the busy/diagnostics guard, the five-entry PC-relative jump table
 * mapping input codes 1..5 onto error codes 1, 2, 8, 9 and 10 with anything else
 * leaving the sentinel -1, the <= 0 bail, the Disable/Enable pair around the
 * banner reseed, the save and restore of rp->BitMap around the overlay, the
 * save and restore of rp->DrawMode through a byte local, the four
 * DisplayTextAtPosition calls at y = 90/120/150/180/210, and the errCode 9-or-10
 * branch selecting the wide format string and setting the overlay busy flag.
 *
 * SASC-MISMATCH: no-frame-for-locals
 *   ref:     4e55ff74                   LINK.W A5,#-140
 *   got:     9efc0080                   SUBA.W #128,A7
 *   summary: The A5-frame class, which moves the scratch buffer and the saved
 *            bitmap pointer from -n(A5) to n(A7).
 *
 * SASC-MISMATCH: constant-via-moveq-shift
 *   ref:     7628 4603                  MOVEQ #40,D3 / NOT.B D3   (~40 = 215)
 *   summary: Another sighting of the MOVEQ + NOT.B form recorded in
 *            cleanup_draw_grid_time_banner.c -- the same constant, 215, reached
 *            the same way. Two independent uses of ~40 suggest this is a
 *            genuine code-generator rule rather than a one-off.
 *
 * SASC-MISMATCH: external-call-width
 *   summary: 4EBA against 6100 for the eight cross-unit calls.
 */
#include "esq-exec.h"
#include "esq-graphics.h"

extern void GCOMMAND_SeedBannerFromPrefs(void);
extern void ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(void *rp, long x, long y, char *s);
extern void GROUP_AM_JMPTBL_WDISP_SPrintf();
extern long ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(long depth);
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct BitMap Global_REF_696_400_BITMAP;
extern short Global_UIBusyFlag;
extern short ED_DiagnosticsScreenActive;
extern short ESQPARS2_ReadModeFlags;
extern short COI_AttentionOverlayBusyFlag;
extern long BRUSH_SnapshotDepth;
extern long BRUSH_SnapshotWidth;
extern char BRUSH_SnapshotHeader[];
extern char Global_STR_PLEASE_STANDBY_2[];
extern char Global_STR_ATTENTION_SYSTEM_ENGINEER_2[];
extern char Global_STR_REPORT_ERROR_CODE_FORMATTED[];
extern char Global_STR_FILE_WIDTH_COLORS_FORMATTED[];
extern char Global_STR_FILE_PERCENT_S[];
extern char Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL[];

void ESQIFF2_ShowAttentionOverlay(char code)
{
    char buf[128];
    struct BitMap *savedBitmap;
    register long errCode = -1;
    register char savedDrMd;

    if (Global_UIBusyFlag && ED_DiagnosticsScreenActive == 0)
        return;

    switch (code) {
    case 1: errCode = 1;  break;
    case 2: errCode = 2;  break;
    case 3: errCode = 8;  break;
    case 4: errCode = 9;  break;
    case 5: errCode = 10; break;
    }
    if (errCode <= 0)
        return;

    Disable();
    ESQPARS2_ReadModeFlags = 0x100;
    GCOMMAND_SeedBannerFromPrefs();
    Enable();

    savedBitmap = Global_REF_RASTPORT_1->BitMap;
    Global_REF_RASTPORT_1->BitMap = &Global_REF_696_400_BITMAP;
    ED_DiagnosticsScreenActive = 0;

    SetAPen(Global_REF_RASTPORT_1, 2L);
    RectFill(Global_REF_RASTPORT_1, 0L, 65L, 684L, 215L);
    SetAPen(Global_REF_RASTPORT_1, 3L);
    savedDrMd = Global_REF_RASTPORT_1->DrawMode;
    SetDrMd(Global_REF_RASTPORT_1, 0L);

    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 35, 90,
                                                 Global_STR_PLEASE_STANDBY_2);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 35, 120,
                                                 Global_STR_ATTENTION_SYSTEM_ENGINEER_2);
    GROUP_AM_JMPTBL_WDISP_SPrintf(buf, Global_STR_REPORT_ERROR_CODE_FORMATTED, errCode);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 35, 150, buf);

    if (errCode == 9 || errCode == 10) {
        GROUP_AM_JMPTBL_WDISP_SPrintf(buf, Global_STR_FILE_WIDTH_COLORS_FORMATTED,
                                      BRUSH_SnapshotHeader, BRUSH_SnapshotWidth,
                                      ESQPARS_JMPTBL_BRUSH_PlaneMaskForIndex(BRUSH_SnapshotDepth));
        COI_AttentionOverlayBusyFlag = 1;
    } else {
        GROUP_AM_JMPTBL_WDISP_SPrintf(buf, Global_STR_FILE_PERCENT_S, BRUSH_SnapshotHeader);
    }

    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 35, 180, buf);
    ESQPARS_JMPTBL_DISPLIB_DisplayTextAtPosition(Global_REF_RASTPORT_1, 35, 210,
                                                 Global_STR_PRESS_ESC_TWICE_TO_RESUME_SCROLL);

    SetDrMd(Global_REF_RASTPORT_1, (long)savedDrMd);
    Global_REF_RASTPORT_1->BitMap = savedBitmap;
}
