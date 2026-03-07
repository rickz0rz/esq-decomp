typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    VM_RUNTIME_STRIDE = 154,
    VM_RASTPORT_OFFSET = 10
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetRast(void *gfxBase, void *rastPort, LONG pen);

void TLIBA3_ClearViewModeRastPort(LONG viewMode, LONG clearPen)
{
    LONG offset;
    UBYTE *viewRec;

    offset = MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    viewRec = TLIBA3_VmArrayRuntimeTable + offset;
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, viewRec + VM_RASTPORT_OFFSET, clearPen);
}
