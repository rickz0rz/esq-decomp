unsigned long BRUSH_PlaneMaskForIndex(long plane_index)
{
    if (plane_index <= 0) {
        return 0UL;
    }
    if (plane_index >= 9) {
        return 0UL;
    }
    return (1UL << plane_index);
}
