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
    enum {
        READ_TAG_SIZE = 4,
        BMHD_SIZE = 20,
        CRNG_SIZE = 8,
        CRNG_MAX_COUNT = 4,
        STATE_CRNG_COUNT_OFF = 184,
        STATE_CRNG_BASE_OFF = 0x9c,
        STATE_BMHD_BASE_OFF = 128,
        STATE_BMHD_WIDTH_OFF = 128,
        STATE_BMHD_HEIGHT_OFF = 130,
        STATE_CAMG_OFF = 148,
        STATE_MODEFLAG_BYTE_OFF = 151,
        STATE_TYPE_OFF = 190,
        STATE_CRNG_TABLE_OFF = 152,
        MODEFLAG_WIDTH_CLAMP_BIT = 15,
        MODEFLAG_HEIGHT_CLAMP_BIT = 2
    };
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

    *(UWORD *)(state + STATE_CRNG_COUNT_OFF) = 0;
    for (i = 0; i < CRNG_MAX_COUNT; i++) {
        *(UWORD *)(state + STATE_CRNG_BASE_OFF + i * CRNG_SIZE) = 0;
    }

    while (done == 0) {
        if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, &chunkId, READ_TAG_SIZE) != READ_TAG_SIZE) {
            done = 1;
            break;
        }

        if (chunkId == chunk_tag('I', 'L', 'B', 'M')) {
            continue;
        }

        if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, &chunkSize, READ_TAG_SIZE) != READ_TAG_SIZE) {
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
            if (chunkSize != BMHD_SIZE) {
                done = 1;
            }
            if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, state + STATE_BMHD_BASE_OFF, BMHD_SIZE) != BMHD_SIZE) {
                done = 1;
            }
            *(LONG *)(state + STATE_CAMG_OFF) = 0;
            if (*(UWORD *)(state + STATE_BMHD_WIDTH_OFF) > 0x140) {
                *(LONG *)(state + STATE_CAMG_OFF) |= (1L << MODEFLAG_WIDTH_CLAMP_BIT);
            }
            if (*(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) > 0x00c8) {
                state[STATE_MODEFLAG_BYTE_OFF] |= (1u << MODEFLAG_HEIGHT_CLAMP_BIT);
                if (*(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) > 0x00dc) {
                    if (state[STATE_TYPE_OFF] == 5 || state[STATE_TYPE_OFF] == 4) {
                        *(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) = 0x00dc;
                    }
                }
            } else if (*(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) > 110) {
                if (state[STATE_TYPE_OFF] == 5 || state[STATE_TYPE_OFF] == 4) {
                    *(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) = 110;
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
            *(LONG *)(state + STATE_CAMG_OFF) = 0;
            if (chunkSize != READ_TAG_SIZE) {
                done = 1;
            }
            if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, state + STATE_CAMG_OFF, READ_TAG_SIZE) != READ_TAG_SIZE) {
                done = 1;
                *(LONG *)(state + STATE_CAMG_OFF) = 0;
                if (*(UWORD *)(state + STATE_BMHD_WIDTH_OFF) > 0x140) {
                    *(LONG *)(state + STATE_CAMG_OFF) |= (1L << MODEFLAG_WIDTH_CLAMP_BIT);
                }
                if (*(UWORD *)(state + STATE_BMHD_HEIGHT_OFF) > 0x00c8) {
                    *(LONG *)(state + STATE_CAMG_OFF) |= (1L << MODEFLAG_HEIGHT_CLAMP_BIT);
                }
            }
        } else if (chunkId == chunk_tag('C', 'R', 'N', 'G')) {
            UWORD count = *(UWORD *)(state + STATE_CRNG_COUNT_OFF);
            if (count < CRNG_MAX_COUNT && chunkSize == CRNG_SIZE) {
                UBYTE *cr = state + STATE_CRNG_TABLE_OFF + ((LONG)count * CRNG_SIZE);
                if (_LVORead(Global_REF_DOS_LIBRARY_2, fh, cr, CRNG_SIZE) != CRNG_SIZE) {
                    done = 1;
                }
                if (cr[6] > 0x1f) cr[6] = 0;
                if (cr[7] > 0x1f) cr[7] = 0;
                if (*(UWORD *)(cr + 2) <= 0 || *(UWORD *)(cr + 2) == 36 || cr[6] > cr[7]) {
                    *(UWORD *)(state + STATE_CRNG_BASE_OFF + ((LONG)count * CRNG_SIZE)) = 0;
                }
                *(UWORD *)(state + STATE_CRNG_COUNT_OFF) = (UWORD)(count + 1);
            } else {
                _LVOSeek(Global_REF_DOS_LIBRARY_2, fh, chunkSize, 0);
            }
        } else {
            _LVOSeek(Global_REF_DOS_LIBRARY_2, fh, chunkSize, 0);
        }
    }

    return status;
}
