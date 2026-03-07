typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    VM_RUNTIME_STRIDE = 154,
    VM_RASTPORT_OFFSET = 10,
    VM_WIDTH_OFFSET = 2,
    VM_HEIGHT_OFFSET = 4,
    VM_PEN_0 = 0,
    VM_PEN_1 = 1,
    VM_DRAWMODE_1 = 1,
    VM_TITLE_BUFFER_LEN = 88,
    VM_TITLE_Y = 90
};

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
    char title[VM_TITLE_BUFFER_LEN];

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    viewW = *(UWORD *)(vm + VM_WIDTH_OFFSET);
    viewH = *(UWORD *)(vm + VM_HEIGHT_OFFSET);
    (void)viewW;
    (void)viewH;

    rp = vm + VM_RASTPORT_OFFSET;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, rp, Global_HANDLE_PREVUEC_FONT);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    rp = vm + VM_RASTPORT_OFFSET;
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, rp, VM_PEN_0);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    rp = vm + VM_RASTPORT_OFFSET;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, rp, VM_DRAWMODE_1);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    rp = vm + VM_RASTPORT_OFFSET;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, rp, VM_PEN_1);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    rp = vm + VM_RASTPORT_OFFSET;
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, rp, VM_PEN_0);

    TLIBA3_DrawViewModeGuides(rp);

    WDISP_SPrintf(title, TLIBA1_FMT_VIEWMODE_PCT_LD, viewMode);

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    rp = vm + VM_RASTPORT_OFFSET;
    TLIBA3_DrawCenteredWrappedTextLines(rp, title, VM_TITLE_Y);
}
