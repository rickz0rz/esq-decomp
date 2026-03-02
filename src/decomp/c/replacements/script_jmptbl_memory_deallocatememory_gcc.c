#include "esq_types.h"

void MEMORY_DeallocateMemory(void) __attribute__((noinline));

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(void) __attribute__((noinline, used));

void SCRIPT_JMPTBL_MEMORY_DeallocateMemory(void)
{
    MEMORY_DeallocateMemory();
}
