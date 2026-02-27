#include "esq_types.h"

/*
 * Target 196 GCC trial function.
 * Jump-table stub forwarding to FORMAT_RawDoFmtWithScratchBuffer.
 */
void FORMAT_RawDoFmtWithScratchBuffer(void) __attribute__((noinline));

void GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void) __attribute__((noinline, used));

void GROUP_AX_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void)
{
    FORMAT_RawDoFmtWithScratchBuffer();
}
