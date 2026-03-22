#include "tliba3_view_mode_types.h"

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

char *TLIBA3_GetViewModeRastPort(LONG viewModeIndex)
{
    TLIBA3_ViewModeRuntimeRasterEntry *viewMode;

    viewMode = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, TLIBA3_VM_RUNTIME_STRIDE));
    return (char *)viewMode->rastPort10;
}
