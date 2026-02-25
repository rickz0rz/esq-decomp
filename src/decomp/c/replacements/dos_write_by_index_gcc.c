#include "esq_types.h"

/*
 * Target 041 GCC trial function.
 * Resolve a handle index, optionally seek, write through it, and map IO error.
 */
extern u32 Global_DosIoErr;

void *HANDLE_GetEntryByIndex(s32 index);
s32 DOS_SeekByIndex(s32 handle_index, s32 offset, s32 mode);
s32 DOS_WriteWithErrorState(s32 handle, void *buffer, s32 length);

s32 DOS_WriteByIndex(s32 handle_index, void *buffer, s32 length) __attribute__((noinline, used));

s32 DOS_WriteByIndex(s32 handle_index, void *buffer, s32 length)
{
    u8 *entry = (u8 *)HANDLE_GetEntryByIndex(handle_index);
    s32 write_result;

    if (entry == 0) {
        return -1;
    }

    if ((entry[3] & 0x08u) != 0) {
        (void)DOS_SeekByIndex(handle_index, 0, 2);
    }

    write_result = DOS_WriteWithErrorState(*(s32 *)(entry + 4), buffer, length);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return write_result;
}
