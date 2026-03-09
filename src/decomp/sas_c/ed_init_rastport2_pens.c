typedef signed long LONG;

typedef struct ED_DisplayContext {
    unsigned char pad0[2];
    unsigned char rastPort[1];
} ED_DisplayContext;

extern LONG WDISP_DisplayContextBase;
extern LONG ED_Rastport2PenModeSelector;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);

void ED_InitRastport2Pens(void)
{
    ED_DisplayContext *context = (ED_DisplayContext *)WDISP_DisplayContextBase;
    void *rastPort = (void *)context->rastPort;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);

    if (ED_Rastport2PenModeSelector == 14) {
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);
    }
}
