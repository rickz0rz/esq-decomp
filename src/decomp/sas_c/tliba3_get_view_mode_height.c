#include <exec/types.h>
typedef struct TLIBA3_ViewModeRuntimeEntry {
    UBYTE pad0[4];
    WORD height4;
} TLIBA3_ViewModeRuntimeEntry;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG TLIBA3_GetViewModeHeight(LONG viewModeIndex)
{
    TLIBA3_ViewModeRuntimeEntry *viewMode;

    viewMode = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, 154));
    return (LONG)viewMode->height4;
}
