#include <graphics/rastport.h>
#include <graphics/text.h>

typedef struct MinList MinList;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern struct RastPort *Global_REF_RASTPORT_1;
extern struct TextFont *Global_HANDLE_PREVUEC_FONT;
extern struct BitMap Global_REF_696_400_BITMAP;

extern WORD COI_AttentionOverlayBusyFlag;
extern WORD ED_DiagnosticsScreenActive;
extern WORD SCRIPT_StatusRefreshHoldFlag;
extern WORD ESQPARS2_EdDiagResetScratchFlag;
extern LONG ED_SaveTextAdsOnExitFlag;
extern BYTE ED_SavedDiagGraphModeChar;
extern BYTE ED_DiagGraphModeChar;
extern LONG LOCAVAIL_FilterPrevClassId;
extern MinList ESQIFF_GAdsBrushListHead;
extern LONG ESQIFF_GAdsBrushListCount;
extern WORD SCRIPT_RuntimeMode;
extern WORD CTRL_BufferedByteCount;
extern WORD CTRL_HPreviousSample;
extern WORD CTRL_H;
extern WORD Global_UIBusyFlag;
extern WORD ESQPARS2_ReadModeFlags;
extern LONG NEWGRID_RefreshStateFlag;
extern LONG NEWGRID_LastRefreshRequest;
extern LONG NEWGRID_MessagePumpSuspendFlag;

extern void _LVOInitBitMap(void *gfxBase, struct BitMap *bm, LONG depth, LONG width, LONG height);
extern void _LVOSetFont(void *gfxBase, struct RastPort *rp, struct TextFont *font);

extern void ED1_JMPTBL_GCOMMAND_ResetHighlightMessages(void);
extern void GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode(void);
extern void ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState(void);
extern void ESQFUNC_UpdateDiskWarningAndRefreshTick(void);
extern void ED1_ClearEscMenuMode(void);
extern void ESQFUNC_UpdateRefreshModeState(LONG suspendFlag, LONG lastRequest);
extern void ED1_JMPTBL_NEWGRID_DrawTopBorderLine(void);
extern LONG ED1_JMPTBL_LADFUNC_SaveTextAdsToFile(void);
extern void ED1_WaitForFlagAndClearBit0(void);
extern void ESQIFF_JMPTBL_BRUSH_FreeBrushList(MinList *head, LONG freePayload);
extern void ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs(void);
extern void ED_DrawBottomHelpBarBackground(void);
extern void ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(LONG mode);
extern void ESQIFF_RunCopperRiseTransition(void);

void ED1_ExitEscMenu(void)
{
    COI_AttentionOverlayBusyFlag = 0;

    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        &Global_REF_696_400_BITMAP,
        3,
        696,
        400);

    _LVOSetFont(
        Global_REF_GRAPHICS_LIBRARY,
        Global_REF_RASTPORT_1,
        Global_HANDLE_PREVUEC_FONT);

    ED1_JMPTBL_GCOMMAND_ResetHighlightMessages();

    ED_DiagnosticsScreenActive = 0;
    SCRIPT_StatusRefreshHoldFlag = 0;
    GROUP_AM_JMPTBL_SCRIPT_PrimeBannerTransitionFromHexCode();

    ESQPARS2_EdDiagResetScratchFlag = 0;
    ESQFUNC_JMPTBL_LADFUNC_UpdateHighlightState();
    ESQFUNC_UpdateDiskWarningAndRefreshTick();

    ED1_ClearEscMenuMode();

    NEWGRID_RefreshStateFlag = 1;
    ESQFUNC_UpdateRefreshModeState(
        NEWGRID_MessagePumpSuspendFlag,
        NEWGRID_LastRefreshRequest);

    ED1_JMPTBL_NEWGRID_DrawTopBorderLine();

    if (ED_SaveTextAdsOnExitFlag == 1) {
        ED1_JMPTBL_LADFUNC_SaveTextAdsToFile();
    }

    LOCAVAIL_FilterPrevClassId = -1;

    if (ED_SavedDiagGraphModeChar != ED_DiagGraphModeChar) {
        if (ED_DiagGraphModeChar != 78 && ED_SavedDiagGraphModeChar == 78) {
            ED1_WaitForFlagAndClearBit0();
        }

        if (ED_DiagGraphModeChar == 78 && ED_SavedDiagGraphModeChar != 78) {
            ESQIFF_JMPTBL_BRUSH_FreeBrushList(&ESQIFF_GAdsBrushListHead, 0);
            ESQIFF_GAdsBrushListCount = 0;
        }
    }

    if (SCRIPT_RuntimeMode != 0) {
        SCRIPT_RuntimeMode = 3;
    }

    CTRL_BufferedByteCount = 0;
    CTRL_HPreviousSample = 0;
    CTRL_H = 0;
    Global_UIBusyFlag = 0;

    ED1_JMPTBL_GCOMMAND_SeedBannerFromPrefs();
    ED_DrawBottomHelpBarBackground();
    ESQFUNC_JMPTBL_TEXTDISP_SetRastForMode(1);
    ESQIFF_RunCopperRiseTransition();

    ESQPARS2_ReadModeFlags = 0;
}
