#include "esq_types.h"

void MEMORY_DeallocateMemory(void) __attribute__((noinline));

void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(void) __attribute__((noinline, used));

void NEWGRID_JMPTBL_MEMORY_DeallocateMemory(void)
{
    MEMORY_DeallocateMemory();
}
