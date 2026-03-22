#include "tliba3_view_mode_types.h"

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

void TLIBA3_ClearViewModeRastPort(LONG viewMode, LONG clearPen)
{
    LONG offset;
    TLIBA3_ViewModeRuntimeRasterEntry *viewRec;

    offset = MATH_Mulu32(viewMode, TLIBA3_VM_RUNTIME_STRIDE);
    viewRec = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + offset);
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, (char *)viewRec->rastPort10, clearPen);
}
