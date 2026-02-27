#include "esq_types.h"

/*
 * Target 192 GCC trial function.
 * Jump-table stub forwarding to DOS_SystemTagList.
 */
void DOS_SystemTagList(void) __attribute__((noinline));

void GROUP_AT_JMPTBL_DOS_SystemTagList(void) __attribute__((noinline, used));

void GROUP_AT_JMPTBL_DOS_SystemTagList(void)
{
    DOS_SystemTagList();
}
