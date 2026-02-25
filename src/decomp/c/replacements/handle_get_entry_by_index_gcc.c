#include "esq_types.h"

/*
 * Target 036 GCC trial function.
 * Validate handle index and return pointer to handle-table entry.
 */
extern u32 Global_DosIoErr;
extern u32 Global_AppErrorCode;
extern u32 Global_HandleTableCount;
extern u8 Global_HandleTableBase[];

void *HANDLE_GetEntryByIndex(s32 handle_index) __attribute__((noinline, used));

void *HANDLE_GetEntryByIndex(s32 handle_index)
{
    u8 *entry;

    Global_DosIoErr = 0;

    if (handle_index < 0 || (u32)handle_index >= Global_HandleTableCount) {
        Global_AppErrorCode = 9;
        return (void *)0;
    }

    entry = Global_HandleTableBase + ((u32)handle_index << 3);
    if (*(u32 *)(entry + 0) == 0) {
        Global_AppErrorCode = 9;
        return (void *)0;
    }

    return (void *)entry;
}
