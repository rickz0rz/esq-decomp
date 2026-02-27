#include "esq_types.h"

/*
 * Target 140 GCC trial function.
 * Jump-table stub forwarding to TLIBA3_BuildDisplayContextForViewMode.
 */
s32 TLIBA3_BuildDisplayContextForViewMode(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline));

s32 ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_TLIBA3_BuildDisplayContextForViewMode(s32 arg_1, s32 arg_2, s32 arg_3)
{
    return TLIBA3_BuildDisplayContextForViewMode(arg_1, arg_2, arg_3);
}
