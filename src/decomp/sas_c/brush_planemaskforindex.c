#include <exec/types.h>

enum {
    BRUSH_PLANE_INDEX_MIN_EXCLUSIVE = 0,
    BRUSH_PLANE_INDEX_MAX_EXCLUSIVE = 9,
    BRUSH_PLANE_MASK_NONE = 0UL
};

ULONG BRUSH_PlaneMaskForIndex(long planeIndex)
{
    if (planeIndex <= BRUSH_PLANE_INDEX_MIN_EXCLUSIVE) {
        return BRUSH_PLANE_MASK_NONE;
    }
    if (planeIndex >= BRUSH_PLANE_INDEX_MAX_EXCLUSIVE) {
        return BRUSH_PLANE_MASK_NONE;
    }
    return (1UL << planeIndex);
}
