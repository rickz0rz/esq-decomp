#include "esq_types.h"

void MEMORY_AllocateMemory(void) __attribute__((noinline));

void SCRIPT_JMPTBL_MEMORY_AllocateMemory(void) __attribute__((noinline, used));

void SCRIPT_JMPTBL_MEMORY_AllocateMemory(void)
{
    MEMORY_AllocateMemory();
}
