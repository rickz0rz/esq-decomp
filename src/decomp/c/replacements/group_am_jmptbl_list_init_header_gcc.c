#include "esq_types.h"

/*
 * Target 106 GCC trial function.
 * Jump-table stub forwarding to LIST_InitHeader.
 */
void LIST_InitHeader(void *header) __attribute__((noinline));

void GROUP_AM_JMPTBL_LIST_InitHeader(void *header) __attribute__((noinline, used));

void GROUP_AM_JMPTBL_LIST_InitHeader(void *header)
{
    LIST_InitHeader(header);
}
