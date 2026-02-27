#include "esq_types.h"

/*
 * Target 099 GCC trial function.
 * Jump-table stub forwarding to STRUCT_FreeWithSizeField.
 */
void STRUCT_FreeWithSizeField(void *ptr) __attribute__((noinline));

void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *ptr) __attribute__((noinline, used));

void GROUP_AG_JMPTBL_STRUCT_FreeWithSizeField(void *ptr)
{
    STRUCT_FreeWithSizeField(ptr);
}
