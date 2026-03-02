#include "esq_types.h"

/*
 * Target 260 GCC trial function.
 * Jump-table stub forwarding to FORMAT_RawDoFmtWithScratchBuffer.
 */
void FORMAT_RawDoFmtWithScratchBuffer(void) __attribute__((noinline));

void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void) __attribute__((noinline, used));

void GROUP_AJ_JMPTBL_FORMAT_RawDoFmtWithScratchBuffer(void)
{
    FORMAT_RawDoFmtWithScratchBuffer();
}
