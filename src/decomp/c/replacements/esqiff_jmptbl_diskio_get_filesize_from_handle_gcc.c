#include "esq_types.h"

/*
 * Target 120 GCC trial function.
 * Jump-table stub forwarding to DISKIO_GetFilesizeFromHandle.
 */
s32 DISKIO_GetFilesizeFromHandle(s32 file_handle) __attribute__((noinline));

s32 ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(s32 file_handle) __attribute__((noinline, used));

s32 ESQIFF_JMPTBL_DISKIO_GetFilesizeFromHandle(s32 file_handle)
{
    return DISKIO_GetFilesizeFromHandle(file_handle);
}
