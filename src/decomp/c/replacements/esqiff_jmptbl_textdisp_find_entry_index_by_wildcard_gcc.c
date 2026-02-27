#include "esq_types.h"

/*
 * Target 135 GCC trial function.
 * Jump-table stub forwarding to TEXTDISP_FindEntryIndexByWildcard.
 */
s32 TEXTDISP_FindEntryIndexByWildcard(const u8 *pattern_ptr) __attribute__((noinline));

s32 ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(const u8 *pattern_ptr) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_TEXTDISP_FindEntryIndexByWildcard(const u8 *pattern_ptr)
{
    return TEXTDISP_FindEntryIndexByWildcard(pattern_ptr);
}
