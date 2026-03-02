#include "esq_types.h"

/*
 * Target 604 GCC trial function.
 * Convert plane index (1..8) to a single-bit mask; out-of-range returns 0.
 */
u32 BRUSH_PlaneMaskForIndex(s32 plane_index) __attribute__((noinline, used));

u32 BRUSH_PlaneMaskForIndex(s32 plane_index)
{
    if (plane_index <= 0) {
        return 0;
    }
    if (plane_index >= 9) {
        return 0;
    }
    return (u32)(1UL << plane_index);
}
