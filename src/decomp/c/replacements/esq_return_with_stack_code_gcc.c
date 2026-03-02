#include "esq_types.h"

s32 ESQ_ShutdownAndReturn(s32 exit_code) __attribute__((noinline));

s32 ESQ_ReturnWithStackCode(s32 exit_code) __attribute__((noinline, used));

s32 ESQ_ReturnWithStackCode(s32 exit_code)
{
    return ESQ_ShutdownAndReturn(exit_code);
}
