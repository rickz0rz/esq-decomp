#include "esq_types.h"

/*
 * Target 008 GCC trial function.
 * Resolve a handle index, read through it, and map IO error to -1.
 */
extern u32 Global_DosIoErr;

void *HANDLE_GetEntryByIndex(s32 index);
s32 DOS_ReadWithErrorState(s32 handle, void *buffer, s32 length);

s32 DOS_ReadByIndex(s32 handle_index, void *buffer, s32 length) __attribute__((noinline, used));

s32 DOS_ReadByIndex(s32 handle_index, void *buffer, s32 length)
{
    u8 *entry = (u8 *)HANDLE_GetEntryByIndex(handle_index);
    s32 bytes_read;

    if (entry == 0) {
        return -1;
    }

    bytes_read = DOS_ReadWithErrorState(*(s32 *)(entry + 4), buffer, length);
    if (Global_DosIoErr != 0) {
        return -1;
    }

    return bytes_read;
}
