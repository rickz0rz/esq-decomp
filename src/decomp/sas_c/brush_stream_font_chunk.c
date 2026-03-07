typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_STATE_FONT_CHUNK_SIZE_OFFSET = 186,
    BRUSH_STREAM_CHUNK_SIZE = 2048
};

extern void *Global_REF_DOS_LIBRARY_2;
LONG _LVORead(LONG fh, void *buf, LONG len);

LONG BRUSH_StreamFontChunk(LONG fh, LONG byte_count, LONG max_bytes, UBYTE *dst, void *state)
{
    LONG remaining;

    (void)Global_REF_DOS_LIBRARY_2;
    if (byte_count > max_bytes) {
        return -1;
    }

    *(LONG *)((UBYTE *)state + BRUSH_STATE_FONT_CHUNK_SIZE_OFFSET) = byte_count;
    remaining = byte_count;

    while (remaining > BRUSH_STREAM_CHUNK_SIZE) {
        if (_LVORead(fh, dst, BRUSH_STREAM_CHUNK_SIZE) != BRUSH_STREAM_CHUNK_SIZE) {
            return -1;
        }
        dst += BRUSH_STREAM_CHUNK_SIZE;
        remaining -= BRUSH_STREAM_CHUNK_SIZE;
    }

    if (_LVORead(fh, dst, remaining) != remaining) {
        return -1;
    }

    return 1;
}
