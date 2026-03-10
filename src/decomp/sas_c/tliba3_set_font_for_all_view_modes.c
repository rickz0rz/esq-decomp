typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UBYTE pad0[10];
    UBYTE rastPort10[1];
} TLIBA3_ViewModeRuntimeEntry;

enum {
    VM_ZERO = 0,
    VM_RUNTIME_COUNT = 10,
    VM_RUNTIME_STRIDE = 154
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void _LVOSetFont(void *gfxBase, char *rastPort, void *font);

void TLIBA3_SetFontForAllViewModes(void *font)
{
    LONG i;

    for (i = VM_ZERO; i < VM_RUNTIME_COUNT; ++i) {
        TLIBA3_ViewModeRuntimeEntry *vm =
            (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(i, VM_RUNTIME_STRIDE));
        _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)vm->rastPort10, font);
    }
}
