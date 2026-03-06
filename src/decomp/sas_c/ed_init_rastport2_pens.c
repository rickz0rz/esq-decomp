typedef signed long LONG;

extern LONG WDISP_DisplayContextBase;
extern LONG ED_Rastport2PenModeSelector;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);

void ED_InitRastport2Pens(void)
{
    void *rastPort = (void *)((unsigned char *)WDISP_DisplayContextBase + 2);

    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 0);
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);

    if (ED_Rastport2PenModeSelector == 14) {
        _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rastPort, 1);
        _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rastPort, 2);
    }
}
