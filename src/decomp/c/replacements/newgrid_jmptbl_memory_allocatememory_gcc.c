#include "esq_types.h"

void MEMORY_AllocateMemory(void) __attribute__((noinline));

void NEWGRID_JMPTBL_MEMORY_AllocateMemory(void) __attribute__((noinline, used));

void NEWGRID_JMPTBL_MEMORY_AllocateMemory(void)
{
    MEMORY_AllocateMemory();
}
