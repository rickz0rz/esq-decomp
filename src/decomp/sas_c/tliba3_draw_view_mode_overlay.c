typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TLIBA3_RastPort {
    UBYTE pad0[100];
} TLIBA3_RastPort;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UBYTE pad0[2];
    UWORD width2;
    UWORD height4;
    UBYTE pad6[4];
    TLIBA3_RastPort rastPort10;
} TLIBA3_ViewModeRuntimeEntry;

enum {
    VM_RUNTIME_STRIDE = 154,
    VM_RASTPORT_OFFSET = 10,
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
extern char TLIBA1_FMT_VIEWMODE_PCT_LD[];

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetFont(void *gfxBase, char *rastPort, void *font);
extern LONG _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetDrMd(void *gfxBase, char *rastPort, LONG mode);
extern LONG _LVOSetAPen(void *gfxBase, char *rastPort, LONG pen);
extern LONG _LVOSetBPen(void *gfxBase, char *rastPort, LONG pen);
extern void TLIBA3_DrawViewModeGuides(char *rastPort);
extern LONG WDISP_SPrintf(char *dst, const char *fmt, LONG value);
extern void TLIBA3_DrawCenteredWrappedTextLines(char *rastPort, char *text, LONG y);

void TLIBA3_DrawViewModeOverlay(LONG viewMode)
{
    TLIBA3_ViewModeRuntimeEntry *vm;
    TLIBA3_RastPort *rp;
    UWORD viewW;
    UWORD viewH;
    char title[VM_TITLE_BUFFER_LEN];

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    viewW = vm->width2;
    viewH = vm->height4;
    (void)viewW;
    (void)viewH;

    rp = &vm->rastPort10;
    _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)rp, Global_HANDLE_PREVUEC_FONT);

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    rp = &vm->rastPort10;
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_0);

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    rp = &vm->rastPort10;
    _LVOSetDrMd(Global_REF_GRAPHICS_LIBRARY, (char *)rp, 1);

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    rp = &vm->rastPort10;
    _LVOSetAPen(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_1);

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    rp = &vm->rastPort10;
    _LVOSetBPen(Global_REF_GRAPHICS_LIBRARY, (char *)rp, VM_PEN_0);

    TLIBA3_DrawViewModeGuides((char *)rp);

    WDISP_SPrintf(title, TLIBA1_FMT_VIEWMODE_PCT_LD, viewMode);

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE));
    rp = &vm->rastPort10;
    TLIBA3_DrawCenteredWrappedTextLines((char *)rp, title, VM_TITLE_Y);
}
