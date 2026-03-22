#include "tliba3_view_mode_types.h"

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG TLIBA3_GetViewModeHeight(LONG viewModeIndex)
{
    TLIBA3_ViewModeRuntimeRasterEntry *viewMode;

    viewMode = (TLIBA3_ViewModeRuntimeRasterEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, TLIBA3_VM_RUNTIME_STRIDE));
    return (LONG)viewMode->height4;
}
