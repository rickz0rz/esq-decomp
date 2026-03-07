typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern void *Global_REF_DOS_LIBRARY_2;

extern LONG _LVORead(void *dosBase, LONG fh, void *buf, LONG len);
extern LONG _LVOSeek(void *dosBase, LONG fh, LONG offset, LONG mode);
extern LONG BRUSH_LoadColorTextFont(LONG fh, LONG byteCount, void *fontCtx, void *state);
extern LONG BRUSH_StreamFontChunk(LONG fh, LONG byteCount, LONG maxBytes, void *dst, void *state);

static LONG chunk_tag(char a, char b, char c, char d)
{
    return ((LONG)(UBYTE)a << 24) | ((LONG)(UBYTE)b << 16) | ((LONG)(UBYTE)c << 8) | (LONG)(UBYTE)d;
}

LONG BITMAP_ProcessIlbmImage(LONG fh, LONG unusedArg, void *fontCtx, LONG maxBytes, void *dst, void *statePtr)
{
    UBYTE *state;
    LONG done;
    LONG status;
    LONG chunkId;
    LONG chunkSize;
    LONG i;

    (void)unusedArg;

    state = (UBYTE *)statePtr;
    done = 0;
    status = -1;

    *(UWORD *)(state + 184) = 0;
    for (i = 0; i < 4; i++) {
        *(UWORD *)(state + 0x9c + i * 8) = 0;
    }

    while (done == 0) {
        if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, &chunkId, 4) != 4) {
            done = 1;
            break;
        }

        if (chunkId == chunk_tag('I', 'L', 'B', 'M')) {
            continue;
        }

        if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, &chunkSize, 4) != 4) {
            done = 1;
            break;
        }
        if (chunkSize <= 0) {
            done = 1;
            break;
        }

        if (chunkId == chunk_tag('F', 'O', 'R', 'M')) {
            continue;
        } else if (chunkId == chunk_tag('B', 'M', 'H', 'D')) {
            if (chunkSize != 20) {
                done = 1;
            }
            if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, state + 128, 20) != 20) {
                done = 1;
            }
            *(LONG *)(state + 148) = 0;
            if (*(UWORD *)(state + 128) > 0x140) {
                *(LONG *)(state + 148) |= (1L << 15);
            }
            if (*(UWORD *)(state + 130) > 0x00c8) {
                state[151] |= (1u << 2);
                if (*(UWORD *)(state + 130) > 0x00dc) {
                    if (state[190] == 5 || state[190] == 4) {
                        *(UWORD *)(state + 130) = 0x00dc;
                    }
                }
            } else if (*(UWORD *)(state + 130) > 110) {
                if (state[190] == 5 || state[190] == 4) {
                    *(UWORD *)(state + 130) = 110;
                }
            }
        } else if (chunkId == chunk_tag('C', 'M', 'A', 'P')) {
            if (BRUSH_LoadColorTextFont(fh, chunkSize, fontCtx, statePtr) != 1) {
                done = 1;
            }
        } else if (chunkId == chunk_tag('B', 'O', 'D', 'Y')) {
            if (BRUSH_StreamFontChunk(fh, chunkSize, maxBytes, dst, statePtr) == 1) {
                status = 1;
            }
            done = 1;
        } else if (chunkId == chunk_tag('C', 'A', 'M', 'G')) {
            *(LONG *)(state + 148) = 0;
            if (chunkSize != 4) {
                done = 1;
            }
            if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, state + 148, 4) != 4) {
                done = 1;
                *(LONG *)(state + 148) = 0;
                if (*(UWORD *)(state + 128) > 0x140) {
                    *(LONG *)(state + 148) |= (1L << 15);
                }
                if (*(UWORD *)(state + 130) > 0x00c8) {
                    *(LONG *)(state + 148) |= (1L << 2);
                }
            }
        } else if (chunkId == chunk_tag('C', 'R', 'N', 'G')) {
            UWORD count = *(UWORD *)(state + 184);
            if (count < 4 && chunkSize == 8) {
                UBYTE *cr = state + 152 + ((LONG)count * 8);
                if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, cr, 8) != 8) {
                    done = 1;
                }
                if (cr[6] > 0x1f) cr[6] = 0;
                if (cr[7] > 0x1f) cr[7] = 0;
                if (*(UWORD *)(cr + 2) <= 0 || *(UWORD *)(cr + 2) == 36 || cr[6] > cr[7]) {
                    *(UWORD *)(state + 0x9c + ((LONG)count * 8)) = 0;
                }
                *(UWORD *)(state + 184) = (UWORD)(count + 1);
            } else {
                _LVOSeek(Global_REF_DOS_LIBRARY_2, fh, chunkSize, 0);
            }
        } else {
            _LVOSeek(Global_REF_DOS_LIBRARY_2, fh, chunkSize, 0);
        }
    }

    return status;
}
