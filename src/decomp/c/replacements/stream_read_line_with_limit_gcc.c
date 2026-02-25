#include "esq_types.h"

/*
 * Target 031 GCC trial function.
 * Read a line into destination with max length and NUL-terminate.
 */
typedef struct StreamBufferState {
    u32 reserved0;
    u8 *read_ptr;
    s32 read_remaining;
} StreamBufferState;

s32 STREAM_BufferedGetc(StreamBufferState *stream);

u8 *STREAM_ReadLineWithLimit(u8 *dst, s32 max_len, StreamBufferState *stream) __attribute__((noinline, used));

u8 *STREAM_ReadLineWithLimit(u8 *dst, s32 max_len, StreamBufferState *stream)
{
    u8 *start = dst;
    s32 limit_minus_nul = max_len - 1;
    s32 slots_left = limit_minus_nul;

    while (slots_left >= 0) {
        s32 c;

        stream->read_remaining -= 1;
        if (stream->read_remaining < 0) {
            c = STREAM_BufferedGetc(stream);
        } else {
            c = (s32)(*stream->read_ptr++);
        }

        if (c == -1) {
            break;
        }

        slots_left -= 1;
        *dst++ = (u8)c;

        if (c == 10) {
            break;
        }
    }

    *dst = 0;
    if (slots_left == limit_minus_nul) {
        return (u8 *)0;
    }
    return start;
}
