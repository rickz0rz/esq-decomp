typedef signed long LONG;

extern void *Global_REF_RASTPORT_1;
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern void ED_DrawCursorChar(void);

void ED_RedrawCursorChar(void)
{
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 5);
    ED_DrawCursorChar();
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, Global_REF_RASTPORT_1, 1);
}
