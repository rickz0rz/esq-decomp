/* RESTORES: ED1_ExitEscMenu
 * MODULE:   modules/groups/a/k/ed1.s
 * STATUS:   behavioural
 *
 * SASC-MISMATCH: global-reload-per-store
 *   ref:     2f0242790000047c41f9000087327003223c000002b8243c000001902c79000028584eaefe7a2279000087022079000029304eaeffbe4eba025e700033c00000a07c33c0000029604eba4094427900005e7a4eba623e4eba5510610001c4700123c00000a2cc2f390000a2d82f390000a2d04eba58024eba0206504f7001b0b90000817066044eba021a70ff23c000006ad810390000816e1239000028e1b0016738744eb2026708b0026604610001a41039000028e1724eb001661e10390000816eb001671442a7487900005a844eba7ba6504f42b9000001b430390000bf10670833fc00030000bf10700033c00000a33233c00000a32e33c00000a32c33c00000a2dc4eba01ba4eba1804487800014eba61204eba716c584f427900005e8e241f4e75
 *   got:     48e7200242790000000041f9000000002c790000000070037257e7897464e58a4eaefe7a2279000000002079000000002c79000000004eaeffbe61000000700033c00000000033c00000000061000000427900000000610000006100000061000000700123c0000000002f39000000002f39000000006100000061000000504f7001b0b90000000066046100000070ff23c000000000103900000000123900000000b0016736744eb2026708b002660461000000103900000000b002661e103900000000b002671442a748790000000061000000504f42b900000000303900000000670833fc000300000000700033c00000000033c00000000033c00000000033c0000000006100000061000000487800016100000061000000584f4279000000004cdf40044e75
 *   summary: 296 got vs 292 ref, four bytes over. 6.51 reloads the two graph-mode characters for the second transition test where the original still holds them in D0 and D1 from the first. The bitmap reinitialisation at 696x400 depth 3, the font restore, the four chained zero stores on the CTRL registers, the save-on-exit gate, the two-sided graph-mode transition with its brush-list free, the runtime-mode bump to 3 and the closing copper rise all match in kind and order.
 *   retest:  re-run tools/mismatches.py --recheck against a different
 *            SAS/C version; see docs/compiler-version.md.
 *
 * ESQ_FIX_ESCMENU: the exact arm passes 1 to TEXTDISP_SetRastForMode, which is
 *   what the original does and what leaves the ad window light grey after the
 *   ESC menu closes. The fixed arm passes 2. Both compile to the same size, so
 *   the arm changes one byte and no layout. build-split.sh reads the value from
 *   fixEscMenuExitDisplayMode in src/Prevue.asm, so the C arm and the assembly
 *   arm always agree. The default is 0, which keeps this file byte-comparable.
 *   See the AGENTS.md section "The ESC menu leaves the ad window grey".
 */
#ifndef ESQ_FIX_ESCMENU
#define ESQ_FIX_ESCMENU 0
#endif
#include <exec/types.h>
#include <graphics/rastport.h>
#include <graphics/gfx.h>
#include <graphics/text.h>
#include "esq-graphics.h"

extern struct BitMap    Global_REF_696_400_BITMAP;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern short COI_AttentionOverlayBusyFlag;
extern short ED_DiagnosticsScreenActive;
extern short SCRIPT_StatusRefreshHoldFlag;
extern short ESQPARS2_EdDiagResetScratchFlag;
extern long  NEWGRID_RefreshStateFlag;
extern long  NEWGRID_LastRefreshRequest;
extern long  NEWGRID_MessagePumpSuspendFlag;
extern long  ED_SaveTextAdsOnExitFlag;
extern long  LOCAVAIL_FilterPrevClassId;
extern unsigned char ED_SavedDiagGraphModeChar;
extern unsigned char ED_DiagGraphModeChar;
extern char  ESQIFF_GAdsBrushListHead;
extern long  ESQIFF_GAdsBrushListCount;
extern short SCRIPT_RuntimeMode;
extern short CTRL_BufferedByteCount;
extern short CTRL_HPreviousSample;
extern short CTRL_H;
extern short Global_UIBusyFlag;
extern short ESQPARS2_ReadModeFlags;

extern void ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(void);
extern void GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(void);
extern void ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(void);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern void ED1_ClearEscMenuMode(void);
extern void ESQFUNC_UpdateRefreshModeState(long suspend, long request);
extern void ED1_JMPTBL_NEWGRID_DrawTopBorderLine(void);
extern void ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void ESQIFF_JMPTBL_BRUSH_FreeBrushList(char *head, long flags);
extern void ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(void);
extern void ED_DrawBottomHelpBarBackground(void);
extern void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(long mode);
extern void ESQIFF_RunCopperRiseTransition(void);

void ED1_ExitEscMenu(void)
{
    COI_AttentionOverlayBusyFlag = 0;

    InitBitMap(&Global_REF_696_400_BITMAP, 3, 696, 400);
    SetFont(Global_REF_RASTPORT_1, Global_HANDLE_PREVUEC_FONT);

    ED1_JMPTBL_GCOMMAND_ResetHighlightMessages();
    ED_DiagnosticsScreenActive = SCRIPT_StatusRefreshHoldFlag = 0;
    GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode();
    ESQPARS2_EdDiagResetScratchFlag = 0;
    ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState();
    ESQFUNC_UpdateDiskWarningAndRefreshTick();
    ED1_ClearEscMenuMode();

    NEWGRID_RefreshStateFlag = 1;
    ESQFUNC_UpdateRefreshModeState(NEWGRID_MessagePumpSuspendFlag,
                                   NEWGRID_LastRefreshRequest);
    ED1_JMPTBL_NEWGRID_DrawTopBorderLine();

    if (ED_SaveTextAdsOnExitFlag == 1)
        ED1_JMPTBL_LADFUNC_SaveTextAdsToFile();

    LOCAVAIL_FilterPrevClassId = -1;

    if (ED_SavedDiagGraphModeChar != ED_DiagGraphModeChar) {
        if (ED_DiagGraphModeChar != 78 && ED_SavedDiagGraphModeChar == 78)
            ED1_WaitForFlagAndClearBit0();
        if (ED_DiagGraphModeChar == 78 && ED_SavedDiagGraphModeChar != 78) {
            ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_GAdsBrushListHead, 0);
            ESQIFF_GAdsBrushListCount = 0;
        }
    }

    if (SCRIPT_RuntimeMode != 0)
        SCRIPT_RuntimeMode = 3;

    CTRL_BufferedByteCount = CTRL_HPreviousSample = CTRL_H = Global_UIBusyFlag = 0;

    ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs();
    ED_DrawBottomHelpBarBackground();
#if ESQ_FIX_ESCMENU
    ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(2);
#else
    ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(1);
#endif
    ESQIFF_RunCopperRiseTransition();
    ESQPARS2_ReadModeFlags = 0;
}
