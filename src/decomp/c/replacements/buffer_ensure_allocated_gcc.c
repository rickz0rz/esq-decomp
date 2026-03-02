#include "esq_types.h"

/*
 * Target 600 GCC trial function.
 * Ensure stream buffer is allocated and initialized.
 */
extern u32 Global_StreamBufferAllocSize;
extern u32 Global_AppErrorCode;

s32 ALLOC_AllocFromFreeList(u32 size) __attribute__((noinline));

typedef struct PreallocHandleNodeLike {
    u8 *buffer_base;       /* +0 */
    u8 *buffer_cursor;     /* +4 */
    s32 read_remaining;    /* +8 */
    s32 write_remaining;   /* +12 */
    u32 buffer_capacity;   /* +16 */
    s32 handle_index;      /* +20 */
    u32 open_flags;        /* +24 (overlay with mode/state bytes) */
} PreallocHandleNodeLike;

s32 BUFFER_EnsureAllocated(PreallocHandleNodeLike *node) __attribute__((noinline, used));

s32 BUFFER_EnsureAllocated(PreallocHandleNodeLike *node)
{
    if (node->buffer_capacity != 0 && ((((u8 *)node)[27] & (1u << 3)) == 0)) {
        return 0;
    }

    {
        u8 *buf = (u8 *)(u32)ALLOC_AllocFromFreeList(Global_StreamBufferAllocSize);
        node->buffer_cursor = buf;
        node->buffer_base = buf;
        if (buf == 0) {
            Global_AppErrorCode = 12;
            return -1;
        }
    }

    node->buffer_capacity = Global_StreamBufferAllocSize;
    node->open_flags &= ~12u;
    node->write_remaining = 0;
    node->read_remaining = 0;
    return 0;
}
