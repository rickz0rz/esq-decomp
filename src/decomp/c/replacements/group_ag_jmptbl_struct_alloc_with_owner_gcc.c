#include "esq_types.h"

/*
 * Target 098 GCC trial function.
 * Jump-table stub forwarding to STRUCT_AllocWithOwner.
 */
void *STRUCT_AllocWithOwner(void *owner, u32 size) __attribute__((noinline));

void *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, u32 size) __attribute__((noinline, used));

void *GROUP_AG_JMPTBL_STRUCT_AllocWithOwner(void *owner, u32 size)
{
    return STRUCT_AllocWithOwner(owner, size);
}
