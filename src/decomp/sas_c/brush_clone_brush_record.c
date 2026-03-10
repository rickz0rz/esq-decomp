typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

#define BRUSH_NULL 0
#define BRUSH_PLANE_PTR_SHIFT 2
#define BRUSH_META_TABLE_DST_OFFSET 176
#define BRUSH_META_TABLE_SRC_OFFSET 128
#define BRUSH_META_TABLE_STRIDE 4
#define BRUSH_META_COPY_DST_OFFSET 196
#define BRUSH_META_COPY_SRC_OFFSET 148
#define BRUSH_NEXT_PTR_OFFSET 368
#define BRUSH_DST_BLOCK_328_OFFSET 328
#define BRUSH_SRC_BLOCK_194_OFFSET 194
#define BRUSH_BLOCK_COPY_STRIDE 4
#define BRUSH_BLOCK_COPY_COUNT 5
#define BRUSH_DST_ALIGN_H_OFFSET 356
#define BRUSH_DST_ALIGN_V_OFFSET 360
#define BRUSH_SRC_ALIGN_H_OFFSET 222
#define BRUSH_SRC_ALIGN_V_OFFSET 226
#define BRUSH_DST_AUX_LIST_OFFSET 364
#define BRUSH_SRC_AUX_LIST_OFFSET 230
#define BRUSH_DST_CLIP_W_OFFSET 348
#define BRUSH_DST_CLIP_H_OFFSET 352
#define BRUSH_PLANE_PAIR_TABLE_DST_OFFSET 200
#define BRUSH_PLANE_PAIR_TABLE_SRC_OFFSET 152
#define BRUSH_PLANE_PAIR_STRIDE 8
#define BRUSH_PLANE_PAIR_SECOND_WORD_OFFSET 4
#define BRUSH_LABEL_COPY_SRC_OFFSET 191
#define BRUSH_LABEL_COPY_DST_OFFSET 33
#define BRUSH_NODE_BITMAP_OFFSET 136
#define BRUSH_NODE_WIDTH_OFFSET 176
#define BRUSH_NODE_HEIGHT_OFFSET 178
#define BRUSH_NODE_DEPTH_OFFSET 184
#define BRUSH_NODE_RASTPORT_OFFSET 36
#define BRUSH_NODE_RASTPORT_BITMAPPTR_OFFSET 40
#define BRUSH_NODE_PLANE_TABLE_OFFSET 0x90
#define BRUSH_NODE_STATE_COPY_DST_OFFSET 232
#define BRUSH_SRC_STATE_COPY_SRC_OFFSET 32
#define BRUSH_SRC_TYPE_OFFSET 190
#define BRUSH_SRC_CLIP_W_OFFSET 214
#define BRUSH_SRC_CLIP_H_OFFSET 218
#define BRUSH_PENDING_ALERT_SET 1
#define BRUSH_ALLOC_RECORD_LINE 1248
#define BRUSH_ALLOC_RASTER_LINE 1302
#define BRUSH_PLANE_COUNT 5
#define BRUSH_PLANE_PAIR_COPY_COUNT 4
#define BRUSH_RASTPORT_COPY_BYTES 96
#define BRUSH_RECORD_SIZE 372
static const ULONG MEMF_PUBLIC_CLEAR = 0x10001UL;

extern void *AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char Global_STR_BRUSH_C_17[];
extern const char Global_STR_BRUSH_C_18[];
extern LONG BRUSH_PendingAlertCode;
extern UBYTE BRUSH_SnapshotHeader[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, LONG bytes, ULONG flags);
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const char *tag, LONG line, LONG plane_off, LONG width, LONG height);
void _LVOInitBitMap(void *bitmap, LONG depth, LONG width, LONG height);
void _LVOInitRastPort(void *rp);
void _LVOForbid(void);
void _LVOPermit(void);

void *BRUSH_CloneBrushRecord(void *srcRec)
{
    UBYTE *src = (UBYTE *)srcRec;
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
