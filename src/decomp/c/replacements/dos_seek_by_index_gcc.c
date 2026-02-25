#include "esq_types.h"

/*
 * Target 009 GCC trial function.
 * Resolve a handle index, seek through it, and map IO error to -1.
 */
extern u32 Global_DosIoErr;

void *HANDLE_GetEntryByIndex(s32 index);
s32 DOS_SeekWithErrorState(s32 handle, s32 offset, s32 mode);

s32 DOS_SeekByIndex(s32 handle_index, s32 offset, s32 mode) __attribute__((noinline, used));

s32 DOS_SeekByIndex(s32 handle_index, s32 offset, s32 mode)
{
    u8 *entry = (u8 *)HANDLE_GetEntryByIndex(handle_index);
    s32 seek_result;

    if (entry == 0) {
        return -1;
    }

    seek_result = DOS_SeekWithErrorState(*(s32 *)(entry + 4), offset, mode);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return seek_result;
}
