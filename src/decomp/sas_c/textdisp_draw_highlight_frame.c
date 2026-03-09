typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TEXTDISP_SelectionEntry {
    char shortName[10];
    char longName[200];
    LONG mode;
    LONG groupIndex;
    UWORD selectionIndex;
    char detailLine[524];
} TEXTDISP_SelectionEntry;

typedef struct TEXTDISP_DisplayContext {
    UWORD flags;
    UWORD yBase;
    UWORD width;
    UBYTE rastPort[1];
} TEXTDISP_DisplayContext;

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
extern void TEXTDISP_ResetSelectionState(TEXTDISP_SelectionEntry *entry);

void TEXTDISP_DrawHighlightFrame(TEXTDISP_SelectionEntry *entryPtr)
{
    const LONG MODE_HIGHLIGHT = 8;
    const LONG MODE_TEXT = 3;
    const LONG ZERO = 0;
    const LONG VIEWCFG_THREE = 3;
    const LONG BIT_SHIFT_DUAL_GRID = 2;
    const LONG GRIDCOLS_SINGLE = 1;
    const LONG GRIDCOLS_DOUBLE = 2;
    const LONG WIDTH_MARGIN = 22;
    const LONG BANNER_DURATION = 500;
    const UBYTE CH_BANNER_YES = 'Y';
    const LONG FRAME_X_BASE = 284;
    const LONG FRAME_X_DIV = 2;
    const LONG FRAME_X_SPAN = 0x11b;
    const LONG DRAWMODE_JAM1 = 0;
    const LONG ONE = 1;
    TEXTDISP_SelectionEntry *entry;
    TEXTDISP_DisplayContext *dc;
    void *rastPort;
    LONG widthPx;
    LONG widthMax;
    LONG gridCols;
    LONG yBase;
    LONG x1;
    LONG y1;
    LONG x2;
    LONG y2;

    entry = entryPtr;
    if (entry == (TEXTDISP_SelectionEntry *)0 || entry->detailLine[0] == ZERO) {
        return;
    }

    TLIBA3_ClearViewModeRastPort(MODE_HIGHLIGHT, ZERO);
    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(MODE_HIGHLIGHT, ZERO, VIEWCFG_THREE);
    WDISP_JMPTBL_ESQ_SetCopperEffect_OnEnableHighlight();

    dc = (TEXTDISP_DisplayContext *)WDISP_DisplayContextBase;
    widthPx = (LONG)dc->width;
    widthMax = TEXTDISP_EntryTextBaseWidthPx - WIDTH_MARGIN;
    gridCols = ((dc->flags & (1u << BIT_SHIFT_DUAL_GRID)) != 0) ? GRIDCOLS_DOUBLE : GRIDCOLS_SINGLE;
    widthMax = MATH_Mulu32(widthMax, gridCols);
    if (widthPx > widthMax) {
        widthPx = widthMax;
    }

    yBase = (LONG)dc->yBase;
    WDISP_AccumulatorCaptureActive = ONE;
    WDISP_AccumulatorFlushPending = ZERO;

    rastPort = (void *)dc->rastPort;
    WDISP_JMPTBL_ESQIFF_RunCopperDropTransition();
    WDISP_JMPTBL_ESQIFF_RestoreBasePaletteTriples();

    if (CONFIG_LRBN_FlagChar == CH_BANNER_YES) {
        gridCols = ((dc->flags & (1u << BIT_SHIFT_DUAL_GRID)) != 0) ? GRIDCOLS_DOUBLE : GRIDCOLS_SINGLE;
        SCRIPT_BeginBannerCharTransition(MATH_DivS32(widthPx, gridCols) + WIDTH_MARGIN, BANNER_DURATION);
    }

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(MODE_TEXT, ZERO, ZERO);
    x1 = (yBase - FRAME_X_BASE) / FRAME_X_DIV;
    y1 = ZERO;
    x2 = x1 + FRAME_X_SPAN;
    y2 = widthPx - ONE;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, DRAWMODE_JAM1);
    TEXTDISP_LinePenOverrideEnabledFlag = ONE;
    TLIBA1_DrawFormattedTextBlock(rastPort, (const char *)entry->detailLine, x1, y1, x2, y2);

    WDISP_DisplayContextBase = TLIBA3_BuildDisplayContextForViewMode(MODE_HIGHLIGHT, ZERO, VIEWCFG_THREE);
    TEXTDISP_JMPTBL_ESQIFF_RunCopperRiseTransition();
    TEXTDISP_ResetSelectionState(entry);
}
