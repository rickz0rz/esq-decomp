#include "esq_types.h"

/*
 * Target 074 GCC trial function.
 * Jump-table stub forwarding to ESQ_ReturnWithStackCode.
 */
s32 ESQ_ReturnWithStackCode(s32 code) __attribute__((noinline));

s32 UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode(s32 code) __attribute__((noinline, used));

s32 UNKNOWN32_JMPTBL_ESQ_ReturnWithStackCode(s32 code)
{
    return ESQ_ReturnWithStackCode(code);
}
