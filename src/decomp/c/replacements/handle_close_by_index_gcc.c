#include "esq_types.h"

/*
 * Target 067 GCC trial function.
 * Close and clear handle-table entry by index.
 */
extern u32 Global_DosIoErr;

void *HANDLE_GetEntryByIndex(s32 handle_index);
s32 DOS_CloseWithSignalCheck(s32 handle);

s32 HANDLE_CloseByIndex(s32 handle_index) __attribute__((noinline, used));

s32 HANDLE_CloseByIndex(s32 handle_index)
{
    u8 *entry = (u8 *)HANDLE_GetEntryByIndex(handle_index);

    if (entry == (u8 *)0) {
        return -1;
    }

    if ((entry[3] & 0x10u) != 0u) {
        *(u32 *)(entry + 0) = 0;
        return 0;
    }

    DOS_CloseWithSignalCheck((s32)*(u32 *)(entry + 4));
    *(u32 *)(entry + 0) = 0;

    if (Global_DosIoErr != 0) {
        return -1;
    }

    return 0;
}
