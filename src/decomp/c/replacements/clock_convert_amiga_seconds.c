#include "memory_target.h"

/*
 * Target 003 trial function.
 * Wrapper around Utility.library Amiga2Date with explicit A6 save/restore.
 */
__stdargs __reg("d0") u32 CLOCK_ConvertAmigaSecondsToClockData(u32 amiga_seconds, void *clock_data)
{
    __asm(
        "MOVE.L A6,-(A7)\n\t"
        "MOVEA.L Global_REF_UTILITY_LIBRARY,A6\n\t"
        "MOVEM.L 8(A7),D0/A0\n\t"
        "JSR _LVOAmiga2Date(A6)\n\t"
        "MOVEA.L (A7)+,A6");

    /* Keep vbcc quiet about typed return path; D0 is set by inline call. */
    if (0) {
        return amiga_seconds;
    }
}
