typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_IFF_HEADER_SIZE = 6,
    BRUSH_IFF_FORM_TAG_LEN = 4,
    BRUSH_STATUS_OK = 0,
    BRUSH_STATUS_FAIL = 1,
    BRUSH_MAX_DEPTH_DEFAULT = 5,
    BRUSH_MAX_DEPTH_ALT = 4,
    BRUSH_MAX_WIDTH_DEFAULT = 320,
    BRUSH_MAX_WIDTH_ALT = 640,
    BRUSH_ALT_MODE_FLAG_MASK = 0x80U,
    BRUSH_ALT_NODE_TYPE = 11,
    BRUSH_NODE_SIZE = 372,
    BRUSH_DECODE_BUFFER_SIZE = 130000,
    MEMF_PUBLIC_CLEAR = 0x10001UL
};

extern void *AbsExecBase;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern const UBYTE BRUSH_STR_IFF_FORM[];
extern const UBYTE Global_STR_BRUSH_C_10[];
extern const UBYTE Global_STR_BRUSH_C_11[];
extern const UBYTE Global_STR_BRUSH_C_12[];
extern const UBYTE Global_STR_BRUSH_C_13[];
extern const UBYTE Global_STR_BRUSH_C_14[];
extern const UBYTE Global_STR_BRUSH_C_15[];
extern const UBYTE Global_STR_BRUSH_C_16[];
extern LONG BRUSH_PendingAlertCode;
extern LONG BRUSH_SnapshotWidth;
extern LONG BRUSH_SnapshotDepth;
extern UBYTE BRUSH_SnapshotHeader[];

LONG GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const void *name, LONG mode);
LONG GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const void *rhs, LONG n);
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, LONG line, LONG bytes, ULONG flags);
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, LONG line, void *ptr, LONG bytes);
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const void *tag, LONG line, LONG plane_off, LONG w, LONG h);
void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, LONG line, void *r, LONG w, LONG h);
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
    UBYTE *decode_cur;
    UBYTE *node;
    LONG i;
    LONG row_words;

    (void)AbsExecBase;
    (void)Global_REF_DOS_LIBRARY_2;
    (void)Global_REF_GRAPHICS_LIBRARY;
    status_fail = BRUSH_STATUS_FAIL;
    max_depth = BRUSH_MAX_DEPTH_DEFAULT;
    max_width = BRUSH_MAX_WIDTH_DEFAULT;
    decode_buf = (UBYTE *)0;
    decode_cur = (UBYTE *)0;
    node = (UBYTE *)0;

    fh = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(src, 1005);
    if (fh != 0) {
        if (_LVORead(fh, hdr, BRUSH_IFF_HEADER_SIZE) - BRUSH_IFF_HEADER_SIZE == 0 &&
            GROUP_AA_JMPTBL_STRING_CompareN(hdr, BRUSH_STR_IFF_FORM, BRUSH_IFF_FORM_TAG_LEN) == 0) {
            _LVOSeek(fh, 0, -1);
            decode_buf = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
                Global_STR_BRUSH_C_10,
                977,
                BRUSH_DECODE_BUFFER_SIZE,
                MEMF_PUBLIC_CLEAR
            );
            decode_cur = decode_buf;
            if (decode_buf != (UBYTE *)0) {
                if (BITMAP_ProcessIlbmImage(
                        fh,
                        src + 152,
                        src + 32,
                        BRUSH_DECODE_BUFFER_SIZE,
                        decode_buf,
                        src) == 1) {
                    status_fail = BRUSH_STATUS_OK;
                }
            }
        }
        _LVOClose(fh);
    }

    if ((src[150] & BRUSH_ALT_MODE_FLAG_MASK) != 0) {
        max_depth = BRUSH_MAX_DEPTH_ALT;
        max_width = BRUSH_MAX_WIDTH_ALT;
    }
    if ((LONG)(UBYTE)src[136] > max_depth || (LONG)(UWORD)*(UWORD *)(src + 128) > max_width) {
        _LVOForbid();
        BRUSH_PendingAlertCode = ((LONG)(UBYTE)src[136] > max_depth) ? 2 : 3;
        BRUSH_SnapshotWidth = (UWORD)*(UWORD *)(src + 128);
        BRUSH_SnapshotDepth = (UBYTE)src[136];
        {
            UBYTE *d = BRUSH_SnapshotHeader;
            const UBYTE *s = src;
            do {
                *d++ = *s;
            } while (*s++ != 0);
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
        if (node != (UBYTE *)0) {
            UBYTE *d = node;
            const UBYTE *s = src;
            do {
                *d++ = *s;
            } while (*s++ != 0);

            _LVOInitBitMap(node + 136, (UBYTE)node[184], (UWORD)*(UWORD *)(node + 176), (UWORD)*(UWORD *)(node + 178));
            for (i = 0; i < (LONG)(UBYTE)node[184] && i < 5; i++) {
                void *plane = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
                    Global_STR_BRUSH_C_12, 1134, i << 2, (UWORD)*(UWORD *)(node + 176), (UWORD)*(UWORD *)(node + 178));
                *(void **)(node + 0x90 + (i << 2)) = plane;
                if (plane == (void *)0) {
                    _LVOForbid();
                    if (BRUSH_PendingAlertCode == 0) {
                        BRUSH_PendingAlertCode = 1;
                    }
                    _LVOPermit();
                    break;
                }
            }

            if (i != (LONG)(UBYTE)node[184]) {
                while (i < 5) {
                    void *plane = *(void **)(node + 0x90 + (i << 2));
                    if (plane != (void *)0) {
                        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
                            Global_STR_BRUSH_C_13, 1202, plane, (UWORD)*(UWORD *)(node + 176), (UWORD)*(UWORD *)(node + 178));
                    }
                    i++;
                }
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_14, 1205, node, BRUSH_NODE_SIZE);
                node = (UBYTE *)0;
            } else {
                _LVOInitRastPort(node + 36);
                *(void **)(node + 40) = node + 136;
                for (i = 0; i < 96; i++) {
                    node[232 + i] = src[32 + i];
                }

                row_words = GROUP_AG_JMPTBL_MATH_DivS32((UWORD)*(UWORD *)(src + 128) + 15, 16) * 2;
                for (i = 0; i < (LONG)(UWORD)*(UWORD *)(node + 178); i++) {
                    LONG p;
                    for (p = 0; p < (LONG)(UBYTE)src[136]; p++) {
                        decode_cur = ESQ_PackBitsDecode(decode_cur, *(UBYTE **)(node + 0x90 + (p << 2)), row_words);
                    }
                }
            }
        }
    }

    if ((UBYTE)src[190] == BRUSH_ALT_NODE_TYPE) {
        UBYTE *alt = (UBYTE *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(
            Global_STR_BRUSH_C_15,
            1220,
            BRUSH_NODE_SIZE,
            MEMF_PUBLIC_CLEAR);
        if (alt != (UBYTE *)0) {
            node = alt;
        }
    }

    if (decode_buf != (UBYTE *)0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(
            Global_STR_BRUSH_C_16,
            1236,
            decode_buf,
            BRUSH_DECODE_BUFFER_SIZE);
    }

    return node;
}
