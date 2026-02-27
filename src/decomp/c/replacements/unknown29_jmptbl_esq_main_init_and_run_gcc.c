#include "esq_types.h"

/*
 * Target 087 GCC trial function.
 * Jump-table stub forwarding to ESQ_MainInitAndRun.
 */
s32 ESQ_MainInitAndRun(s32 argc, u8 **argv) __attribute__((noinline));

s32 UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(s32 argc, u8 **argv) __attribute__((noinline, used));

s32 UNKNOWN29_JMPTBL_ESQ_MainInitAndRun(s32 argc, u8 **argv)
{
    return ESQ_MainInitAndRun(argc, argv);
}
