typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct WDISP_RastPortOverlay {
    UBYTE pad0[4];
    void *bitMap;
} WDISP_RastPortOverlay;

typedef struct WDISP_PreviewPanel {
    UBYTE pad0[32];
    LONG dirtyFlag32;
    UBYTE pad24[24];
    WDISP_RastPortOverlay rastPort60;
} WDISP_PreviewPanel;

typedef struct WDISP_BrushNode {
    UBYTE pad0[232];
    UBYTE presetBlock[1];
} WDISP_BrushNode;

extern void *Global_REF_GRAPHICS_LIBRARY;
extern WDISP_RastPortOverlay *Global_REF_RASTPORT_1;

extern void *WDISP_WeatherStatusBrushListHead;
extern LONG P_TYPE_WeatherBrushRefreshPendingFlag;
extern LONG TLIBA1_PreviewSlotRefreshState;
extern LONG TLIBA1_PreviewSlotRenderResult;
extern UBYTE WDISP_WeatherStatusCountdown;
extern UWORD WDISP_WeatherStatusDigitChar;
extern UWORD WDISP_WeatherCycleOffsetCount;

extern void _LVOSetRast(void *gfxBase, WDISP_RastPortOverlay *rastPort, LONG pen);
extern LONG WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(
    WDISP_PreviewPanel *panel,
    void *brushListHead
);
extern void WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(void *presetBlock);
extern void WDISP_JMPTBL_NEWGRID_ResetRowTable(WDISP_PreviewPanel *panel);
extern void WDISP_JMPTBL_BRUSH_FreeBrushList(void **listHead, LONG freePayload);
extern void WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(LONG mode);

LONG WDISP_UpdateSelectionPreviewPanel(void *entryBrushRastPort, WDISP_PreviewPanel *previewPanel)
{
    WDISP_RastPortOverlay *entryRastPort;
    void *savedBitMap;

    entryRastPort = (WDISP_RastPortOverlay *)entryBrushRastPort;

    if (TLIBA1_PreviewSlotRefreshState == 8) {
        TLIBA1_PreviewSlotRefreshState = 0;
        TLIBA1_PreviewSlotRenderResult = 0;
        return 0;
    }

    _LVOSetRast(
        Global_REF_GRAPHICS_LIBRARY,
        &previewPanel->rastPort60,
        7
    );

    savedBitMap = Global_REF_RASTPORT_1->bitMap;
    Global_REF_RASTPORT_1->bitMap = entryRastPort->bitMap;

    if (TLIBA1_PreviewSlotRefreshState == 0) {
        TLIBA1_PreviewSlotRenderResult =
            WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(
                previewPanel,
                WDISP_WeatherStatusBrushListHead
            );

        if (TLIBA1_PreviewSlotRenderResult != 0) {
            TLIBA1_PreviewSlotRefreshState = 7;
        }

        if (WDISP_WeatherStatusBrushListHead != 0) {
            WDISP_JMPTBL_GCOMMAND_ExpandPresetBlock(
                &((WDISP_BrushNode *)WDISP_WeatherStatusBrushListHead)->presetBlock[0]
            );
            WDISP_JMPTBL_NEWGRID_ResetRowTable(previewPanel);
        }
    } else if (TLIBA1_PreviewSlotRefreshState == 7) {
        TLIBA1_PreviewSlotRenderResult =
            WDISP_JMPTBL_ESQIFF_RenderWeatherStatusBrushSlice(
                previewPanel,
                WDISP_WeatherStatusBrushListHead
            );
        previewPanel->dirtyFlag32 = -1;
    }

    if (TLIBA1_PreviewSlotRenderResult == 0) {
        WDISP_JMPTBL_BRUSH_FreeBrushList(&WDISP_WeatherStatusBrushListHead, 0);

        if (WDISP_WeatherStatusDigitChar != 48 &&
            WDISP_WeatherStatusCountdown != 0 &&
            WDISP_WeatherCycleOffsetCount <= 1 &&
            P_TYPE_WeatherBrushRefreshPendingFlag == 0) {
            WDISP_JMPTBL_ESQIFF_QueueIffBrushLoad(2);
        }

        TLIBA1_PreviewSlotRefreshState = 8;
        TLIBA1_PreviewSlotRenderResult = -1;
    }

    Global_REF_RASTPORT_1->bitMap = savedBitMap;

    if (TLIBA1_PreviewSlotRenderResult != 0) {
        return -1;
    }

    return 0;
}
