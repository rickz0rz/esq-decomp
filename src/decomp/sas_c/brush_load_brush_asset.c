#include <exec/types.h>

#define BRUSH_ILBM_PROCESS_OK 1
#define BRUSH_NULL 0
#define BRUSH_PLANE_PTR_SHIFT 2
#define BRUSH_NODE_WIDTH_OFFSET 176
#define BRUSH_NODE_HEIGHT_OFFSET 178
#define BRUSH_NODE_DEPTH_OFFSET 184
#define BRUSH_NODE_PLANE_TABLE_OFFSET 0x90
#define BRUSH_NODE_BITMAP_OFFSET 136
#define BRUSH_NODE_RASTPORT_OFFSET 36
#define BRUSH_NODE_RASTPORT_BITMAPPTR_OFFSET 40
#define BRUSH_NODE_STATE_COPY_DST_OFFSET 232
#define BRUSH_SRC_STATE_BLOCK_OFFSET 32
#define BRUSH_SRC_DECODE_AUX_OFFSET 152
#define BRUSH_SRC_MODE_FLAGS_OFFSET 150
#define BRUSH_SRC_TYPE_OFFSET 190
#define BRUSH_SRC_WIDTH_OFFSET 128
#define BRUSH_SRC_HEIGHT_OFFSET 130
#define BRUSH_SRC_DEPTH_OFFSET 136
#define BRUSH_ROWWORD_ALIGN_ADDEND 15
#define BRUSH_ROWWORD_ALIGN_DIVISOR 16
#define BRUSH_ROWWORD_BYTES_PER_WORD 2
#define BRUSH_RASTPORT_STATE_COPY_BYTES 96
#define BRUSH_MAX_PLANES 5
#define BRUSH_ALERT_ALLOC_FAIL 1
#define BRUSH_ALERT_DEPTH_EXCEEDED 2
#define BRUSH_ALERT_WIDTH_EXCEEDED 3
#define BRUSH_FILE_OPEN_MODE_READ 1005
#define BRUSH_SEEK_OFFSET_START 0
#define BRUSH_SEEK_MODE_BEGIN -1
#define BRUSH_IFF_HEADER_SIZE 6
#define BRUSH_IFF_FORM_TAG_LEN 4
#define BRUSH_STATUS_OK 0
#define BRUSH_STATUS_FAIL 1
#define BRUSH_MAX_DEPTH_DEFAULT 5
#define BRUSH_MAX_DEPTH_ALT 4
#define BRUSH_MAX_WIDTH_DEFAULT 320
#define BRUSH_MAX_WIDTH_ALT 640
#define BRUSH_ALT_MODE_FLAG_MASK 0x80U
#define BRUSH_ALT_NODE_TYPE 11
#define BRUSH_NODE_SIZE 372
#define BRUSH_DECODE_BUFFER_SIZE 130000
#define MEMF_PUBLIC_CLEAR 0x10001UL

extern void *AbsExecBase;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const char BRUSH_STR_IFF_FORM[];
extern const char Global_STR_BRUSH_C_10[];
extern const char Global_STR_BRUSH_C_11[];
extern const char Global_STR_BRUSH_C_12[];
extern const char Global_STR_BRUSH_C_13[];
extern const char Global_STR_BRUSH_C_14[];
extern const char Global_STR_BRUSH_C_15[];
extern const char Global_STR_BRUSH_C_16[];
extern LONG BRUSH_PendingAlertCode;
extern LONG BRUSH_SnapshotWidth;
extern LONG BRUSH_SnapshotDepth;
extern UBYTE BRUSH_SnapshotHeader[];

LONG DOS_OpenFileWithMode(const char *name, LONG mode);
LONG GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const char *rhs, LONG n);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const char *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const char *tag, LONG line, void *ptr, LONG bytes);
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const char *tag, LONG line, LONG plane_off, LONG w, LONG h);
void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const char *tag, LONG line, void *r, LONG w, LONG h);
LONG GROUP_AG_JMPTBL_MATH_DivS32(LONG n, LONG d);
LONG BITMAP_ProcessIlbmImage(LONG first, ...);
UBYTE *ESQ_PackBitsDecode(UBYTE *first, ...);
LONG _LVORead(LONG fh, void *buf, LONG len);
LONG _LVOSeek(LONG fh, LONG pos, LONG mode);
LONG _LVOClose(LONG fh);
void _LVOForbid(void);
void _LVOPermit(void);
void _LVOInitBitMap(void *bm, LONG depth, LONG w, LONG h);
void _LVOInitRastPort(void *rp);

void *BRUSH_LoadBrushAsset(UBYTE *src)
{
    LONG fh;
    LONG status_fail;
    LONG max_depth;
    LONG max_width;
    UBYTE hdr[BRUSH_IFF_HEADER_SIZE];
    UBYTE *decode_buf;
    UBYTE *decodeCursor;
    UBYTE *node;
    LONG i;
    LONG row_words;

    (void)AbsExecBase;
    (void)Global_REF_DOS_LIBRARY_2;
    (void)Global_REF_GRAPHICS_LIBRARY;
    status_fail = BRUSH_STATUS_FAIL;
    max_depth = BRUSH_MAX_DEPTH_DEFAULT;
    max_width = BRUSH_MAX_WIDTH_DEFAULT;
    decode_buf = (UBYTE *)BRUSH_NULL;
    decodeCursor = (UBYTE *)BRUSH_NULL;
    node = (UBYTE *)BRUSH_NULL;

    fh = DOS_OpenFileWithMode(src, BRUSH_FILE_OPEN_MODE_READ);
    if (fh != BRUSH_NULL) {
        if (_LVORead(fh, hdr, BRUSH_IFF_HEADER_SIZE) - BRUSH_IFF_HEADER_SIZE == BRUSH_NULL &&
            GROUP_AA_JMPTBL_STRING_CompareN(hdr, BRUSH_STR_IFF_FORM, BRUSH_IFF_FORM_TAG_LEN) == BRUSH_NULL) {
            _LVOSeek(fh, BRUSH_SEEK_OFFSET_START, BRUSH_SEEK_MODE_BEGIN);
            decode_buf = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_BRUSH_C_10,
                977,
                BRUSH_DECODE_BUFFER_SIZE,
                MEMF_PUBLIC_CLEAR
            );
            decodeCursor = decode_buf;
            if (decode_buf != (UBYTE *)BRUSH_NULL) {
                if (BITMAP_ProcessIlbmImage(
                        fh,
                        src + BRUSH_SRC_DECODE_AUX_OFFSET,
                        src + BRUSH_SRC_STATE_BLOCK_OFFSET,
                        BRUSH_DECODE_BUFFER_SIZE,
                        decode_buf,
                        src) == BRUSH_ILBM_PROCESS_OK) {
                    status_fail = BRUSH_STATUS_OK;
                }
            }
        }
        _LVOClose(fh);
    }

    if ((src[BRUSH_SRC_MODE_FLAGS_OFFSET] & BRUSH_ALT_MODE_FLAG_MASK) != BRUSH_NULL) {
        max_depth = BRUSH_MAX_DEPTH_ALT;
        max_width = BRUSH_MAX_WIDTH_ALT;
    }
    if ((LONG)(UBYTE)src[BRUSH_SRC_DEPTH_OFFSET] > max_depth ||
        (LONG)(UWORD)*(UWORD *)(src + BRUSH_SRC_WIDTH_OFFSET) > max_width) {
        _LVOForbid();
        BRUSH_PendingAlertCode = ((LONG)(UBYTE)src[BRUSH_SRC_DEPTH_OFFSET] > max_depth)
                                     ? BRUSH_ALERT_DEPTH_EXCEEDED
                                     : BRUSH_ALERT_WIDTH_EXCEEDED;
        BRUSH_SnapshotWidth = (UWORD)*(UWORD *)(src + BRUSH_SRC_WIDTH_OFFSET);
        BRUSH_SnapshotDepth = (UBYTE)src[BRUSH_SRC_DEPTH_OFFSET];
        {
            UBYTE *d = BRUSH_SnapshotHeader;
            const UBYTE *s = src;
            do {
                *d++ = *s;
            } while (*s++ != BRUSH_NULL);
        }
        _LVOPermit();
        status_fail = BRUSH_STATUS_FAIL;
    }

    if (status_fail == BRUSH_STATUS_OK) {
        node = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_BRUSH_C_11,
            1064,
            BRUSH_NODE_SIZE,
            MEMF_PUBLIC_CLEAR);
        if (node != (UBYTE *)BRUSH_NULL) {
            UBYTE *d = node;
            const UBYTE *s = src;
            do {
                *d++ = *s;
            } while (*s++ != BRUSH_NULL);

            _LVOInitBitMap(
                node + BRUSH_NODE_BITMAP_OFFSET,
                (UBYTE)node[BRUSH_NODE_DEPTH_OFFSET],
                (UWORD)*(UWORD *)(node + BRUSH_NODE_WIDTH_OFFSET),
                (UWORD)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET));
            for (i = BRUSH_NULL; i < (LONG)(UBYTE)node[BRUSH_NODE_DEPTH_OFFSET] && i < BRUSH_MAX_PLANES; i++) {
                void *plane = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
                    Global_STR_BRUSH_C_12,
                    1134,
                    i << BRUSH_PLANE_PTR_SHIFT,
                    (UWORD)*(UWORD *)(node + BRUSH_NODE_WIDTH_OFFSET),
                    (UWORD)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET));
                *(void **)(node + BRUSH_NODE_PLANE_TABLE_OFFSET + (i << BRUSH_PLANE_PTR_SHIFT)) = plane;
                if (plane == (void *)BRUSH_NULL) {
                    _LVOForbid();
                    if (BRUSH_PendingAlertCode == BRUSH_NULL) {
                        BRUSH_PendingAlertCode = BRUSH_ALERT_ALLOC_FAIL;
                    }
                    _LVOPermit();
                    break;
                }
            }

            if (i != (LONG)(UBYTE)node[BRUSH_NODE_DEPTH_OFFSET]) {
                while (i < BRUSH_MAX_PLANES) {
                    void *plane =
                        *(void **)(node + BRUSH_NODE_PLANE_TABLE_OFFSET + (i << BRUSH_PLANE_PTR_SHIFT));
                    if (plane != (void *)BRUSH_NULL) {
                        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
                            Global_STR_BRUSH_C_13,
                            1202,
                            plane,
                            (UWORD)*(UWORD *)(node + BRUSH_NODE_WIDTH_OFFSET),
                            (UWORD)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET));
                    }
                    i++;
                }
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_14, 1205, node, BRUSH_NODE_SIZE);
                node = (UBYTE *)BRUSH_NULL;
            } else {
                _LVOInitRastPort(node + BRUSH_NODE_RASTPORT_OFFSET);
                *(void **)(node + BRUSH_NODE_RASTPORT_BITMAPPTR_OFFSET) = node + BRUSH_NODE_BITMAP_OFFSET;
                for (i = BRUSH_NULL; i < BRUSH_RASTPORT_STATE_COPY_BYTES; i++) {
                    node[BRUSH_NODE_STATE_COPY_DST_OFFSET + i] = src[BRUSH_SRC_STATE_BLOCK_OFFSET + i];
                }

                row_words = GROUP_AG_JMPTBL_MATH_DivS32(
                                (UWORD)*(UWORD *)(src + BRUSH_SRC_WIDTH_OFFSET) + BRUSH_ROWWORD_ALIGN_ADDEND,
                                BRUSH_ROWWORD_ALIGN_DIVISOR) *
                            BRUSH_ROWWORD_BYTES_PER_WORD;
                for (i = BRUSH_NULL; i < (LONG)(UWORD)*(UWORD *)(node + BRUSH_NODE_HEIGHT_OFFSET); i++) {
                    LONG p;
                    for (p = BRUSH_NULL; p < (LONG)(UBYTE)src[BRUSH_SRC_DEPTH_OFFSET]; p++) {
                        decodeCursor = ESQ_PackBitsDecode(
                            decodeCursor,
                            *(UBYTE **)(node + BRUSH_NODE_PLANE_TABLE_OFFSET + (p << BRUSH_PLANE_PTR_SHIFT)),
                            row_words);
                    }
                }
            }
        }
    }

    if ((UBYTE)src[BRUSH_SRC_TYPE_OFFSET] == BRUSH_ALT_NODE_TYPE) {
        UBYTE *alt = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_BRUSH_C_15,
            1220,
            BRUSH_NODE_SIZE,
            MEMF_PUBLIC_CLEAR);
        if (alt != (UBYTE *)BRUSH_NULL) {
            node = alt;
        }
    }

    if (decode_buf != (UBYTE *)BRUSH_NULL) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_16,
            1236,
            decode_buf,
            BRUSH_DECODE_BUFFER_SIZE);
    }

    return node;
}
