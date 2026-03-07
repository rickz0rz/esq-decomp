enum {
    BRUSH_PLANE_INDEX_MIN_EXCLUSIVE = 0,
    BRUSH_PLANE_INDEX_MAX_EXCLUSIVE = 9,
    BRUSH_PLANE_MASK_NONE = 0UL
};

unsigned long BRUSH_PlaneMaskForIndex(long plane_index)
{
    if (plane_index <= BRUSH_PLANE_INDEX_MIN_EXCLUSIVE) {
        return BRUSH_PLANE_MASK_NONE;
    }
    if (plane_index >= BRUSH_PLANE_INDEX_MAX_EXCLUSIVE) {
        return BRUSH_PLANE_MASK_NONE;
    }
    return (1UL << plane_index);
}
