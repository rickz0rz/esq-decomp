#include "esq_types.h"

/*
 * Target 096 GCC trial function.
 * Jump-table stub forwarding to MEMORY_DeallocateMemory.
 */
void MEMORY_DeallocateMemory(void *memory_block, u32 byte_size) __attribute__((noinline));

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(void *memory_block, u32 byte_size) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(void *memory_block, u32 byte_size)
{
    MEMORY_DeallocateMemory(memory_block, byte_size);
}
