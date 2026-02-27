#include "esq_types.h"

/*
 * Target 117 GCC trial function.
 * Jump-table stub forwarding to DOS_OpenFileWithMode.
 */
s32 DOS_OpenFileWithMode(const char *name, s32 mode) __attribute__((noinline));

s32 ESQIFF_JMPTBL_DOS_OpenFileWithMode(const char *name, s32 mode) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_DOS_OpenFileWithMode(const char *name, s32 mode)
{
    return DOS_OpenFileWithMode(name, mode);
}
