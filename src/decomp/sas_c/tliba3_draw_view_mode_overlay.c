#include "tliba3_view_mode_types.h"

enum {
    VM_WIDTH_OFFSET = 2,
    VM_HEIGHT_OFFSET = 4,
    VM_PEN_0 = 0,
    VM_PEN_1 = 1,
    VM_TITLE_BUFFER_LEN = 88,
    VM_TITLE_Y = 90
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;
extern void *Global_HANDLE_PREVUEC_FONT;
extern const char TLIBA1_FMT_VIEWMODE_PCT_LD[];

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void _LVOSetFont(void *gfxBase, char *rastPort, void *font);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern void _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern void _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void TLIBA3_DrawViewModeGuides(char *rastPort);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, const char *text, LONG y);

void TLIBA3_DrawViewModeOverlay(LONG viewMode)
{
    TLIBA3_ViewModeRuntimeRasterEntry *vm;
    UBYTE *rp;
    UWORD viewW;
    UWORD viewH;
    char title[VM_TITLE_BUFFER_LEN];

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    viewW = vm->width2;
    viewH = vm->height4;
    (void)viewW;
    (void)viewH;

    rp = vm->rastPort10;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)rp, Global_HANDLE_PREVUEC_FONT);

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    rp = vm->rastPort10;
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_0);

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    rp = vm->rastPort10;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, (char *)rp, 1);

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    rp = vm->rastPort10;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_1);

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    rp = vm->rastPort10;
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_0);

    TLIBA3_DrawViewModeGuides((char *)rp);

    WDISP_SPrintf(title, TLIBA1_FMT_VIEWMODE_PCT_LD, viewMode);

    vm = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE));
    rp = vm->rastPort10;
    TLIBA3_DrawCenteredWrappedTextLines((char *)rp, title, VM_TITLE_Y);
}
