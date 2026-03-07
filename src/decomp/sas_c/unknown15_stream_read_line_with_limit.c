typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned char UBYTE;

typedef struct StreamBufferState {
    ULONG owner_or_link;
    UBYTE *read_ptr;      /* +4 */
    LONG read_remaining;  /* +8 */
} StreamBufferState;

extern LONG STREAM_BufferedGetc(StreamBufferState *stream);

UBYTE *STREAM_ReadLineWithLimit(UBYTE *dst, LONG max_len, StreamBufferState *stream)
{
    UBYTE *start;
    LONG limit_minus_nul;
    LONG slots_left;

    start = dst;
    limit_minus_nul = max_len - 1;
    slots_left = limit_minus_nul;

    while (slots_left >= 0) {
        LONG c;

        stream->read_remaining -= 1;
        if (stream->read_remaining < 0) {
            c = STREAM_BufferedGetc(stream);
        } else {
            c = (LONG)(*stream->read_ptr++);
        }

        if (c == -1) {
            break;
        }

        slots_left -= 1;
        *dst++ = (UBYTE)c;

        if (c == 10) {
            break;
        }
    }

    *dst = 0;
    if (slots_left == limit_minus_nul) {
        return (UBYTE *)0;
    }
    return start;
}
