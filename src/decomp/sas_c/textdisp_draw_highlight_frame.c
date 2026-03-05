typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG TEXTDISP_EntryTextBaseWidthPx;
extern LONG WDISP_DisplayContextBase;
extern UWORD WDISP_AccumulatorCaptureActive;
extern UWORD WDISP_AccumulatorFlushPending;
extern UWORD TEXTDISP_LinePenOverrideEnabledFlag;
extern UBYTE CONFIG_LRBN_FlagChar;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void TLIBA3_ClearViewModeRastPort(LONG viewMode, LONG unused);
extern LONG TLIBA3_BuildDisplayContextForViewMode(LONG viewMode, LONG a, LONG b);
extern void WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight(void);
extern LONG MATH_Mulu32(LONG a, LONG b);
extern LONG MATH_DivS32(LONG a, LONG b);
extern void WDISP_JMPTBL_ESQIFF_RunCopperDropTransition(void);
extern void WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples(void);
extern void SCRIPT_BeginBannerCharTransition(LONG bannerChar, LONG duration);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG drawMode);
extern void TLIBA1_DrawFormattedTextBlock(void *rastPort, const char *text, LONG x1, LONG y1, LONG x2, LONG y2);
extern void TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition(void);
extern void TEXTDISP_ResetSelectionState(void *entry);

void TEXTDISP_DrawHighlightFrame(void *entryPtr)
{
    UBYTE *entry;
    LONG *dc;
    void *rastPort;
    LONG widthPx;
    LONG widthMax;
    LONG gridCols;
    LONG yBase;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;

    entry = (UBYTE *)entryPtr;
    if (entry == (UBYTE *)0 || entry[220] == 0) {
        return;
    }

    TLIBA3_ClearViewModeRastPort(8, 0);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(8, 0, 3);
    WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();

    dc = (LONG *)WDISP_DisplayContextBase;
    widthPx = (LONG)(*(UWORD *)((UBYTE *)dc + 4));
    widthMax = TEXTDISP_EntryTextBaseWidthPx - 22;
    gridCols = ((*(UWORD *)((UBYTE *)dc + 0) & (1u << 2)) != 0) ? 2 : 1;
    widthMax = MATH_Mulu32(widthMax, gridCols);
    if (widthPx > widthMax) {
        widthPx = widthMax;
    }

    yBase = (LONG)(*(UWORD *)((UBYTE *)dc + 2));
    WDISP_AccumulatorCaptureActive = 1;
    WDISP_AccumulatorFlushPending = 0;

    rastPort = (void *)((UBYTE *)dc + 2);
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();
    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();

    if (CONFIG_LRBN_FlagChar == 'Y') {
        gridCols = ((*(UWORD *)((UBYTE *)dc + 0) & (1u << 2)) != 0) ? 2 : 1;
        SCRIPT_BeginBannerCharTransition(MATH_DivS32(widthPx, gridCols) + 22, 500);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(3, 0, 0);
    x1 = (yBase - 284) / 2;
    y1 = 0;
    x2 = x1 + 0x11b;
    y2 = widthPx - 1;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    TEXTDISP_LinePenOverrideEnabledFlag = 1;
    TLIBA1_DrawFormattedTextBlock(rastPort, (const char *)(entry + 220), x1, y1, x2, y2);

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(8, 0, 3);
    TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
    TEXTDISP_ResetSelectionState(entry);
}
