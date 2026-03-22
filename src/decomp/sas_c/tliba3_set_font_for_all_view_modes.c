#include "tliba3_view_mode_types.h"

enum {
    VM_ZERO = 0
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void _LVOSetFont(void *gfxBase, char *rastPort, void *font);

void TLIBA3_SetFontForAllViewModes(void *font)
{
    LONG i;

    for (i = VM_ZERO; i < TLIBA3_VM_RUNTIME_COUNT; ++i) {
        TLIBA3_ViewModeRuntimeRasterEntry *vm =
            (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(i, TLIBA3_VM_RUNTIME_STRIDE));
        _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, (char *)vm->rastPort10, font);
    }
}
