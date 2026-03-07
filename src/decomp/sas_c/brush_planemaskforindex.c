enum {
    BRUSH_PLANE_INDEX_MIN_EXCLUSIVE = 0,
    BRUSH_PLANE_INDEX_MAX_EXCLUSIVE = 9
};

unsigned long BRUSH_PlaneMaskForIndex(long plane_index)
{
    if (plane_index <= BRUSH_PLANE_INDEX_MIN_EXCLUSIVE) {
        return 0UL;
    }
    if (plane_index >= BRUSH_PLANE_INDEX_MAX_EXCLUSIVE) {
        return 0UL;
    }
    return (1UL << plane_index);
}
