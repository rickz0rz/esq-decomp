#include "esq_types.h"

/*
 * Target 702 GCC trial function.
 * Stream font bytes from handle into destination in 2048-byte chunks.
 */
extern void *Global_REF_DOS_LIBRARY_2;

s32 _LVORead(s32 fh, void *buf, s32 len) __attribute__((noinline));

s32 BRUSH_StreamFontChunk(s32 fh, s32 byte_count, s32 max_bytes, u8 *dst, void *state) __attribute__((noinline, used));

s32 BRUSH_StreamFontChunk(s32 fh, s32 byte_count, s32 max_bytes, u8 *dst, void *state)
{
    s32 remaining;

    (void)Global_REF_DOS_LIBRARY_2;
    if (byte_count > max_bytes) {
        return -1;
    }

    *(s32 *)((u8 *)state + 186) = byte_count;
    remaining = byte_count;

    while (remaining > 2048) {
        if (_LVORead(fh, dst, 2048) != 2048) {
            return -1;
        }
        dst += 2048;
        remaining -= 2048;
    }

    if (_LVORead(fh, dst, remaining) != remaining) {
        return -1;
    }

    return 1;
}
