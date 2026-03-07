typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_PLANE_PTR_SHIFT = 2,
    BRUSH_META_TABLE_DST_OFFSET = 176,
    BRUSH_META_TABLE_SRC_OFFSET = 128,
    BRUSH_META_TABLE_STRIDE = 4,
    BRUSH_META_COPY_DST_OFFSET = 196,
    BRUSH_META_COPY_SRC_OFFSET = 148,
    BRUSH_NEXT_PTR_OFFSET = 368,
    BRUSH_DST_BLOCK_328_OFFSET = 328,
    BRUSH_SRC_BLOCK_194_OFFSET = 194,
    BRUSH_BLOCK_COPY_STRIDE = 4,
    BRUSH_BLOCK_COPY_COUNT = 5,
    BRUSH_DST_ALIGN_H_OFFSET = 356,
    BRUSH_DST_ALIGN_V_OFFSET = 360,
    BRUSH_SRC_ALIGN_H_OFFSET = 222,
    BRUSH_SRC_ALIGN_V_OFFSET = 226,
    BRUSH_DST_AUX_LIST_OFFSET = 364,
    BRUSH_SRC_AUX_LIST_OFFSET = 230,
    BRUSH_DST_CLIP_W_OFFSET = 348,
    BRUSH_DST_CLIP_H_OFFSET = 352,
    BRUSH_PLANE_PAIR_TABLE_DST_OFFSET = 200,
    BRUSH_PLANE_PAIR_TABLE_SRC_OFFSET = 152,
    BRUSH_PLANE_PAIR_STRIDE = 8,
    BRUSH_PLANE_PAIR_SECOND_WORD_OFFSET = 4,
    BRUSH_LABEL_COPY_SRC_OFFSET = 191,
    BRUSH_LABEL_COPY_DST_OFFSET = 33,
    BRUSH_NODE_BITMAP_OFFSET = 136,
    BRUSH_NODE_WIDTH_OFFSET = 176,
    BRUSH_NODE_HEIGHT_OFFSET = 178,
    BRUSH_NODE_DEPTH_OFFSET = 184,
    BRUSH_NODE_RASTPORT_OFFSET = 36,
    BRUSH_NODE_RASTPORT_BITMAPPTR_OFFSET = 40,
    BRUSH_NODE_PLANE_TABLE_OFFSET = 0x90,
    BRUSH_NODE_STATE_COPY_DST_OFFSET = 232,
    BRUSH_SRC_STATE_COPY_SRC_OFFSET = 32,
    BRUSH_SRC_TYPE_OFFSET = 190,
    BRUSH_SRC_CLIP_W_OFFSET = 214,
    BRUSH_SRC_CLIP_H_OFFSET = 218,
    BRUSH_PENDING_ALERT_SET = 1,
    BRUSH_ALLOC_RECORD_LINE = 1248,
    BRUSH_ALLOC_RASTER_LINE = 1302,
    BRUSH_PLANE_COUNT = 5,
    BRUSH_PLANE_PAIR_COPY_COUNT = 4,
    BRUSH_RASTPORT_COPY_BYTES = 96,
    BRUSH_RECORD_SIZE = 372,
    MEMF_PUBLIC_CLEAR = 0x10001UL
};

extern void *AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const UBYTE Global_STR_BRUSH_C_17[];
extern const UBYTE Global_STR_BRUSH_C_18[];
extern LONG BRUSH_PendingAlertCode;
extern UBYTE BRUSH_SnapshotHeader[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const void *tag, LONG line, LONG plane_off, LONG width, LONG height);
void _LVOInitBitMap(void *bitmap, LONG depth, LONG width, LONG height);
void _LVOInitRastPort(void *rp);
void _LVOForbid(void);
void _LVOPermit(void);

void *BRUSH_CloneBrushRecord(void *src_rec)
{
    UBYTE *src = (UBYTE *)src_rec;
    UBYTE *dst;
    LONG i;
    const UBYTE *s;
    UBYTE *d;

    (void)AbsExecBase;
    (void)Global_REF_GRAPHICS_LIBRARY;
    dst = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
        Global_STR_BRUSH_C_17,
        BRUSH_ALLOC_RECORD_LINE,
        BRUSH_RECORD_SIZE,
        MEMF_PUBLIC_CLEAR);
    if (dst == (UBYTE *)BRUSH_NULL) {
        return (void *)BRUSH_NULL;
    }

    s = src;
    d = dst;
    do {
        *d++ = *s;
    } while (*s++ != BRUSH_NULL);

    for (i = BRUSH_NULL; i < BRUSH_PLANE_COUNT; i++) {
        *(ULONG *)(dst + BRUSH_META_TABLE_DST_OFFSET + (i * BRUSH_META_TABLE_STRIDE)) =
            *(ULONG *)(src + BRUSH_META_TABLE_SRC_OFFSET + (i * BRUSH_META_TABLE_STRIDE));
    }
    *(ULONG *)(dst + BRUSH_META_COPY_DST_OFFSET) = *(ULONG *)(src + BRUSH_META_COPY_SRC_OFFSET);
    *(ULONG *)(dst + BRUSH_NEXT_PTR_OFFSET) = BRUSH_NULL;

    _LVOInitBitMap(
        dst + BRUSH_NODE_BITMAP_OFFSET,
        (UBYTE)dst[BRUSH_NODE_DEPTH_OFFSET],
        (UWORD)*(UWORD *)(dst + BRUSH_NODE_WIDTH_OFFSET),
        (UWORD)*(UWORD *)(dst + BRUSH_NODE_HEIGHT_OFFSET));

    dst[BRUSH_SRC_STATE_COPY_SRC_OFFSET] = src[BRUSH_SRC_TYPE_OFFSET];
    for (i = BRUSH_NULL; i < BRUSH_BLOCK_COPY_COUNT; i++) {
        *(ULONG *)(dst + BRUSH_DST_BLOCK_328_OFFSET + (i * BRUSH_BLOCK_COPY_STRIDE)) =
            *(ULONG *)(src + BRUSH_SRC_BLOCK_194_OFFSET + (i * BRUSH_BLOCK_COPY_STRIDE));
    }
    *(ULONG *)(dst + BRUSH_DST_ALIGN_H_OFFSET) = *(ULONG *)(src + BRUSH_SRC_ALIGN_H_OFFSET);
    *(ULONG *)(dst + BRUSH_DST_ALIGN_V_OFFSET) = *(ULONG *)(src + BRUSH_SRC_ALIGN_V_OFFSET);

    for (i = BRUSH_NULL; i < BRUSH_PLANE_PAIR_COPY_COUNT; i++) {
        *(ULONG *)(dst + BRUSH_PLANE_PAIR_TABLE_DST_OFFSET + (i * BRUSH_PLANE_PAIR_STRIDE)) =
            *(ULONG *)(src + BRUSH_PLANE_PAIR_TABLE_SRC_OFFSET + (i * BRUSH_PLANE_PAIR_STRIDE));
        *(ULONG *)(dst + BRUSH_PLANE_PAIR_TABLE_DST_OFFSET + (i * BRUSH_PLANE_PAIR_STRIDE) +
                   BRUSH_PLANE_PAIR_SECOND_WORD_OFFSET) =
            *(ULONG *)(src + BRUSH_PLANE_PAIR_TABLE_SRC_OFFSET + (i * BRUSH_PLANE_PAIR_STRIDE) +
                       BRUSH_PLANE_PAIR_SECOND_WORD_OFFSET);
    }

    s = src + BRUSH_LABEL_COPY_SRC_OFFSET;
    d = dst + BRUSH_LABEL_COPY_DST_OFFSET;
    do {
        *d++ = *s;
    } while (*s++ != BRUSH_NULL);

    *(ULONG *)(dst + BRUSH_DST_AUX_LIST_OFFSET) = *(ULONG *)(src + BRUSH_SRC_AUX_LIST_OFFSET);

    if (*(ULONG *)(src + BRUSH_SRC_CLIP_W_OFFSET) != BRUSH_NULL) {
        *(ULONG *)(dst + BRUSH_DST_CLIP_W_OFFSET) = *(ULONG *)(src + BRUSH_SRC_CLIP_W_OFFSET);
    } else {
        *(ULONG *)(dst + BRUSH_DST_CLIP_W_OFFSET) = (UWORD)*(UWORD *)(dst + BRUSH_NODE_WIDTH_OFFSET);
    }

    if (*(ULONG *)(src + BRUSH_SRC_CLIP_H_OFFSET) != BRUSH_NULL) {
        *(ULONG *)(dst + BRUSH_DST_CLIP_H_OFFSET) = *(ULONG *)(src + BRUSH_SRC_CLIP_H_OFFSET);
    } else {
        *(ULONG *)(dst + BRUSH_DST_CLIP_H_OFFSET) = (UWORD)*(UWORD *)(dst + BRUSH_NODE_HEIGHT_OFFSET);
    }

    for (i = BRUSH_NULL; i < (LONG)(UBYTE)dst[BRUSH_NODE_DEPTH_OFFSET] && i < BRUSH_PLANE_COUNT; i++) {
        void *planeRaster;
        LONG plane_off = i << BRUSH_PLANE_PTR_SHIFT;
        planeRaster = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
            Global_STR_BRUSH_C_18,
            BRUSH_ALLOC_RASTER_LINE,
            plane_off,
            (UWORD)*(UWORD *)(dst + BRUSH_NODE_WIDTH_OFFSET),
            (UWORD)*(UWORD *)(dst + BRUSH_NODE_HEIGHT_OFFSET));
        *(void **)(dst + BRUSH_NODE_PLANE_TABLE_OFFSET + plane_off) = planeRaster;
        if (planeRaster == (void *)BRUSH_NULL) {
            _LVOForbid();
            if (BRUSH_PendingAlertCode == BRUSH_NULL) {
                const UBYTE *snap_s = dst;
                UBYTE *snap_d = BRUSH_SnapshotHeader;
                BRUSH_PendingAlertCode = BRUSH_PENDING_ALERT_SET;
                do {
                    *snap_d++ = *snap_s;
                } while (*snap_s++ != BRUSH_NULL);
            }
            _LVOPermit();
            break;
        }
    }

    if (i == (LONG)(UBYTE)dst[BRUSH_NODE_DEPTH_OFFSET]) {
        _LVOInitRastPort(dst + BRUSH_NODE_RASTPORT_OFFSET);
        *(void **)(dst + BRUSH_NODE_RASTPORT_BITMAPPTR_OFFSET) = dst + BRUSH_NODE_BITMAP_OFFSET;
        for (i = BRUSH_NULL; i < BRUSH_RASTPORT_COPY_BYTES; i++) {
            dst[BRUSH_NODE_STATE_COPY_DST_OFFSET + i] = src[BRUSH_SRC_STATE_COPY_SRC_OFFSET + i];
        }
    }

    return (void *)dst;
}
