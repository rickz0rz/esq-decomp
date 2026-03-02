#include "esq_types.h"

/*
 * Target 601 GCC trial function.
 * Flush pending buffered writes for all prealloc nodes, then close with code.
 */
extern u8 Global_PreallocHandleNode0;

s32 DOS_WriteByIndex(s32 handle, const void *buf, s32 len) __attribute__((noinline));
s32 HANDLE_CloseAllAndReturnWithCode(s32 code) __attribute__((noinline));

s32 BUFFER_FlushAllAndCloseWithCode(s32 code) __attribute__((noinline, used));

s32 BUFFER_FlushAllAndCloseWithCode(s32 code)
{
    u8 *node = &Global_PreallocHandleNode0;

    while (node != 0) {
        u8 state = node[27];

        if ((state & (1u << 2)) == 0 && (state & (1u << 1)) != 0) {
            s32 pending = *(u32 *)(node + 4) - *(u32 *)(node + 0);
            if (pending != 0) {
                (void)DOS_WriteByIndex(*(s32 *)(node + 20), (const void *)(*(u32 *)(node + 0)), pending);
            }
        }

        node = (u8 *)(*(u32 *)(node + 32));
    }

    return HANDLE_CloseAllAndReturnWithCode(code);
}
