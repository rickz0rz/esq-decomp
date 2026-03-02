#include "esq_types.h"

/*
 * Target 597 GCC trial function.
 * Parse mode string, open handle, and initialize prealloc node state.
 */
extern u32 Global_DefaultHandleFlags;

typedef struct PreallocHandleNodeLike {
    void *buffer_base;     /* +0 */
    void *buffer_cursor;   /* +4 */
    s32 read_remaining;    /* +8 */
    s32 write_remaining;   /* +12 */
    s32 buffer_capacity;   /* +16 */
    s32 handle_index;      /* +20 */
    u32 open_flags;        /* +24 */
} PreallocHandleNodeLike;

s32 UNKNOWN36_FinalizeRequest(PreallocHandleNodeLike *node) __attribute__((noinline));
s32 HANDLE_OpenEntryWithFlags(u8 *name, u32 flags, s32 size) __attribute__((noinline));

PreallocHandleNodeLike *HANDLE_OpenFromModeString(
    u8 *name,
    const u8 *mode,
    PreallocHandleNodeLike *node
) __attribute__((noinline, used));

PreallocHandleNodeLike *HANDLE_OpenFromModeString(
    u8 *name,
    const u8 *mode,
    PreallocHandleNodeLike *node
)
{
    u32 default_flags = Global_DefaultHandleFlags;
    u32 idx = 1;
    s32 plus;
    s32 open_handle;
    u32 handle_mode_bits;
    u32 final_open_flags_base;

    if (node->open_flags != 0) {
        (void)UNKNOWN36_FinalizeRequest(node);
    }

    if ((u8)mode[idx] == (u8)'b') {
        default_flags = 0x8000u;
        idx++;
    } else if ((u8)mode[idx] == (u8)'a') {
        default_flags = 0u;
        idx++;
    }

    plus = ((u8)mode[idx] == (u8)'+') ? -1 : 0;

    if ((u8)mode[0] == (u8)'a') {
        open_handle = HANDLE_OpenEntryWithFlags(name, 0x8102u, 12);
        if (open_handle == -1) {
            return 0;
        }
        handle_mode_bits = (plus != 0) ? 128u : 2u;
        handle_mode_bits |= 0x4000u;
    } else if ((u8)mode[0] == (u8)'r') {
        u32 flags = ((plus != 0) ? 2u : 0u) | 0x8000u;
        open_handle = HANDLE_OpenEntryWithFlags(name, flags, 12);
        if (open_handle == -1) {
            return 0;
        }
        handle_mode_bits = (plus != 0) ? 128u : 1u;
    } else if ((u8)mode[0] == (u8)'w') {
        u32 flags = ((plus != 0) ? 2u : 1u) | 0x8000u | 0x100u | 0x200u;
        open_handle = HANDLE_OpenEntryWithFlags(name, flags, 12);
        if (open_handle == -1) {
            return 0;
        }
        handle_mode_bits = (plus != 0) ? 128u : 2u;
    } else {
        return 0;
    }

    node->buffer_base = 0;
    node->buffer_capacity = 0;
    node->handle_index = open_handle;
    node->buffer_cursor = node->buffer_base;
    node->write_remaining = 0;
    node->read_remaining = 0;

    final_open_flags_base = (default_flags == 0) ? 0x8000u : 0u;
    node->open_flags = handle_mode_bits | final_open_flags_base;

    return node;
}
