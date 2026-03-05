typedef unsigned char UBYTE;
typedef long LONG;

extern void *Global_REF_DOS_LIBRARY_2;
LONG _LVORead(LONG fh, void *buf, LONG len);

LONG BRUSH_StreamFontChunk(LONG fh, LONG byte_count, LONG max_bytes, UBYTE *dst, void *state)
{
    LONG remaining;

    (void)Global_REF_DOS_LIBRARY_2;
    if (byte_count > max_bytes) {
        return -1;
    }

    *(LONG *)((UBYTE *)state + 186) = byte_count;
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
