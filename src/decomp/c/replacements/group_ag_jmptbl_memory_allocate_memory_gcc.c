#include "esq_types.h"

/*
 * Target 097 GCC trial function.
 * Jump-table stub forwarding to MEMORY_AllocateMemory.
 */
void *MEMORY_AllocateMemory(u32 byte_size, u32 attributes) __attribute__((noinline));

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(u32 byte_size, u32 attributes) __attribute__((noinline, used));

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(u32 byte_size, u32 attributes)
{
    return MEMORY_AllocateMemory(byte_size, attributes);
}
