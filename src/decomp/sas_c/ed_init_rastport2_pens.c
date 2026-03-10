typedef signed long LONG;

typedef struct ED_DisplayContext {
    unsigned char pad0[2];
    unsigned char rastPort[1];
} ED_DisplayContext;

extern LONG WDISP_DisplayContextBase;
extern LONG ED_Rastport2PenModeSelector;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);

void ED_InitRastport2Pens(void)
{
    ED_DisplayContext *context = (ED_DisplayContext *)WDISP_DisplayContextBase;
    char *rastPort = (char *)context->rastPort;

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);

    if (ED_Rastport2PenModeSelector == 14) {
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);
    }
}
