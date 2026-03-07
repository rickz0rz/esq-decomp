typedef unsigned char UBYTE;
typedef long LONG;

enum {
    BRUSH_STATE_FONT_CHUNK_SIZE_OFFSET = 186,
    BRUSH_STREAM_CHUNK_SIZE = 2048,
    BRUSH_STREAM_STATUS_ERROR = -1,
    BRUSH_STREAM_STATUS_OK = 1
};

extern void *Global_REF_DOS_LIBRARY_2;
LONG _LVORead(LONG fh, void *buf, LONG len);

LONG BRUSH_StreamFontChunk(LONG fh, LONG byteCount, LONG maxBytes, UBYTE *dstBuffer, void *state)
{
    LONG bytesRemaining;

    (void)Global_REF_DOS_LIBRARY_2;
    if (byteCount > maxBytes) {
        return BRUSH_STREAM_STATUS_ERROR;
    }

    *(LONG *)((UBYTE *)state + BRUSH_STATE_FONT_CHUNK_SIZE_OFFSET) = byteCount;
    bytesRemaining = byteCount;

    while (bytesRemaining > BRUSH_STREAM_CHUNK_SIZE) {
        if (_LVORead(fh, dstBuffer, BRUSH_STREAM_CHUNK_SIZE) != BRUSH_STREAM_CHUNK_SIZE) {
            return BRUSH_STREAM_STATUS_ERROR;
        }
        dstBuffer += BRUSH_STREAM_CHUNK_SIZE;
        bytesRemaining -= BRUSH_STREAM_CHUNK_SIZE;
    }

    if (_LVORead(fh, dstBuffer, bytesRemaining) != bytesRemaining) {
        return BRUSH_STREAM_STATUS_ERROR;
    }

    return BRUSH_STREAM_STATUS_OK;
}
