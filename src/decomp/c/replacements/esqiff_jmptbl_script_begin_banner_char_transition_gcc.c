#include "esq_types.h"

/*
 * Target 139 GCC trial function.
 * Jump-table stub forwarding to SCRIPT_BeginBannerCharTransition.
 */
s32 SCRIPT_BeginBannerCharTransition(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline));

s32 ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(s32 arg_1, s32 arg_2, s32 arg_3) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_SCRIPT_BeginBannerCharTransition(s32 arg_1, s32 arg_2, s32 arg_3)
{
    return SCRIPT_BeginBannerCharTransition(arg_1, arg_2, arg_3);
}
