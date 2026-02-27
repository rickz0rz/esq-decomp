#include "esq_types.h"

/*
 * Target 091 GCC trial function.
 * Jump-table stub forwarding to BUFFER_FlushAllAndCloseWithCode.
 */
s32 BUFFER_FlushAllAndCloseWithCode(s32 code) __attribute__((noinline));

s32 GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(s32 code) __attribute__((noinline, used));

s32 GROUP_MAIN_B_JMPTBL_BUFFER_FlushAllAndCloseWithCode(s32 code)
{
    return BUFFER_FlushAllAndCloseWithCode(code);
}
