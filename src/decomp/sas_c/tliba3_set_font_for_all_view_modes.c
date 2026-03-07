typedef signed long LONG;
typedef unsigned char UBYTE;

enum {
    VM_ZERO = 0,
    VM_RUNTIME_COUNT = 10,
    VM_RUNTIME_STRIDE = 154,
    VM_RASTPORT_OFFSET = 10
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetFont(void *gfxBase, void *rastPort, void *font);

void TLIBA3_SetFontForAllViewModes(void *font)
{
    LONG i;

    for (i = VM_ZERO; i < VM_RUNTIME_COUNT; ++i) {
        UBYTE *vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(i, VM_RUNTIME_STRIDE);
        _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, vm + VM_RASTPORT_OFFSET, font);
    }
}
