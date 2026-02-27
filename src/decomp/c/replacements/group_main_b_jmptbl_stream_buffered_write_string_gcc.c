#include "esq_types.h"

/*
 * Target 088 GCC trial function.
 * Jump-table stub forwarding to STREAM_BufferedWriteString.
 */
s32 STREAM_BufferedWriteString(u8 *s) __attribute__((noinline));

s32 GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(u8 *s) __attribute__((noinline, used));

s32 GROUP_MAIN_B_JMPTBL_STREAM_BufferedWriteString(u8 *s)
{
    return STREAM_BufferedWriteString(s);
}
