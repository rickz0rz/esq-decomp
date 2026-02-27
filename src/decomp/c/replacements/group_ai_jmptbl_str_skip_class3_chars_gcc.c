#include "esq_types.h"

/*
 * Target 205 GCC trial function.
 * Jump-table stub forwarding to STR_SkipClass3Chars.
 */
void STR_SkipClass3Chars(void) __attribute__((noinline));

void GROUP_AI_JMPTBL_STR_SkipClass3Chars(void) __attribute__((noinline, used));

void GROUP_AI_JMPTBL_STR_SkipClass3Chars(void)
{
    STR_SkipClass3Chars();
}
