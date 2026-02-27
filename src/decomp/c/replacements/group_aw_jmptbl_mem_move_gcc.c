#include "esq_types.h"

/*
 * Target 144 GCC trial function.
 * Jump-table stub forwarding to MEM_Move.
 */
void MEM_Move(void) __attribute__((noinline));

void GROUP_AW_JMPTBL_MEM_Move(void) __attribute__((noinline, used));

void GROUP_AW_JMPTBL_MEM_Move(void)
{
    MEM_Move();
}
