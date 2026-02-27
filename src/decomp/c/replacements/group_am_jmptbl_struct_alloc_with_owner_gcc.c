#include "esq_types.h"

/*
 * Target 105 GCC trial function.
 * Jump-table stub forwarding to STRUCT_AllocWithOwner.
 */
void *STRUCT_AllocWithOwner(void *owner, u32 size) __attribute__((noinline));

void *GROUP_AM_JMPTBL_STRUCT_AllocWithOwner(void *owner, u32 size) __attribute__((noinline, used));

void *GROUP_AM_JMPTBL_STRUCT_AllocWithOwner(void *owner, u32 size)
{
    return STRUCT_AllocWithOwner(owner, size);
}
