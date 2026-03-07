typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern char TLIBA1_FMT_VIEWMODE_PCT_LD[];

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetFont(void *gfxBase, void *rastPort, void *font);
extern LONG _LVOSetRast(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, void *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, void *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, void *rastPort, LONG pen);
extern void TLIBA3_DrawViewModeGuides(void *rastPort);
extern void WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern void TLIBA3_DrawCenteredWrappedTextLines(void *rastPort, char *text, LONG y);

void TLIBA3_DrawViewModeOverlay(LONG viewMode)
{
    UBYTE *vm;
    void *rp;
    UWORD viewW;
    UWORD viewH;
    char title[88];

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    viewW = *(UWORD *)(vm + 2);
    viewH = *(UWORD *)(vm + 4);
    (void)viewW;
    (void)viewH;

    rp = vm + 10;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rp, Global_HANDLE_PREVUEC_FONT);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    rp = vm + 10;
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    rp = vm + 10;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, 1);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    rp = vm + 10;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, 1);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    rp = vm + 10;
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rp, 0);

    TLIBA3_DrawViewModeGuides(rp);

    WDISP_SPrintf(title, TLIBA1_FMT_VIEWMODE_PCT_LD, viewMode);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, 154);
    rp = vm + 10;
    TLIBA3_DrawCenteredWrappedTextLines(rp, title, 90);
}
