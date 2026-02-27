#include "esq_types.h"

/*
 * Target 204 GCC trial function.
 * Jump-table stub forwarding to FORMAT_FormatToBuffer2.
 */
void FORMAT_FormatToBuffer2(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_FORMAT_FormatToBuffer2(void)
{
    FORMAT_FormatToBuffer2();
}
