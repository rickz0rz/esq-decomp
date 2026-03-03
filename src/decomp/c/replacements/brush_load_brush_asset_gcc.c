#include "esq_types.h"

/*
 * Target 706 GCC trial function.
 * Conservative C lane for BRUSH_LoadBrushAsset call graph and decode/allocation flow.
 */
extern void *AbsExecBase;
extern void *Global_REF_DOS_LIBRARY_2;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern u8 BRUSH_STR_IFF_FORM[];
extern u8 Global_STR_BRUSH_C_10[];
extern u8 Global_STR_BRUSH_C_11[];
extern u8 Global_STR_BRUSH_C_12[];
extern u8 Global_STR_BRUSH_C_13[];
extern u8 Global_STR_BRUSH_C_14[];
extern u8 Global_STR_BRUSH_C_15[];
extern u8 Global_STR_BRUSH_C_16[];
extern s32 BRUSH_PendingAlertCode;
extern s32 BRUSH_SnapshotWidth;
extern s32 BRUSH_SnapshotDepth;
extern u8 BRUSH_SnapshotHeader[];

s32 GROUP_AG_JMPTBL_DOS_OpenFileWithMode(const void *name, s32 mode) __attribute__((noinline));
s32 GROUP_AA_JMPTBL_STRING_CompareN(const void *lhs, const void *rhs, s32 n) __attribute__((noinline));
void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, s32 line, s32 bytes, u32 flags) __attribute__((noinline));
void GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(const void *tag, s32 line, void *ptr, s32 bytes) __attribute__((noinline));
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const void *tag, s32 line, s32 plane_off, s32 w, s32 h) __attribute__((noinline));
void GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(const void *tag, s32 line, void *r, s32 w, s32 h) __attribute__((noinline));
s32 GROUP_AG_JMPTBL_MATH_DivS32(s32 n, s32 d) __attribute__((noinline));
s32 BITMAP_ProcessIlbmImage(s32 first, ...) __attribute__((noinline));
u8 *ESQ_PackBitsDecode(u8 *first, ...) __attribute__((noinline));
s32 _LVORead(s32 fh, void *buf, s32 len) __attribute__((noinline));
s32 _LVOSeek(s32 fh, s32 pos, s32 mode) __attribute__((noinline));
s32 _LVOClose(s32 fh) __attribute__((noinline));
void _LVOForbid(void) __attribute__((noinline));
void _LVOPermit(void) __attribute__((noinline));
void _LVOInitBitMap(void *bm, s32 depth, s32 w, s32 h) __attribute__((noinline));
void _LVOInitRastPort(void *rp) __attribute__((noinline));

void *BRUSH_LoadBrushAsset(u8 *src) __attribute__((noinline, used));

void *BRUSH_LoadBrushAsset(u8 *src)
{
    s32 fh;
    s32 status_fail;
    s32 max_depth;
    s32 max_width;
    u8 hdr[6];
    u8 *decode_buf;
    u8 *decode_cur;
    u8 *node;
    s32 i;
    s32 row_words;

    (void)AbsExecBase;
    (void)Global_REF_DOS_LIBRARY_2;
    (void)Global_REF_GRAPHICS_LIBRARY;
    status_fail = 1;
    max_depth = 5;
    max_width = 320;
    decode_buf = 0;
    decode_cur = 0;
    node = 0;

    fh = GROUP_AG_JMPTBL_DOS_OpenFileWithMode(src, 1005);
    if (fh != 0) {
        if (_LVORead(fh, hdr, 6) - 6 == 0 && GROUP_AA_JMPTBL_STRING_CompareN(hdr, BRUSH_STR_IFF_FORM, 4) == 0) {
            _LVOSeek(fh, 0, -1);
            decode_buf = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_10, 977, 130000, 0x10001u);
            decode_cur = decode_buf;
            if (decode_buf != 0) {
                if (BITMAP_ProcessIlbmImage(fh, src + 152, src + 32, 130000, decode_buf, src) == 1) {
                    status_fail = 0;
                }
            }
        }
        _LVOClose(fh);
    }

    if ((src[150] & 0x80u) != 0) {
        max_depth = 4;
        max_width = 640;
    }
    if ((s32)(u8)src[136] > max_depth || (s32)(u16)*(u16 *)(src + 128) > max_width) {
        _LVOForbid();
        BRUSH_PendingAlertCode = ((s32)(u8)src[136] > max_depth) ? 2 : 3;
        BRUSH_SnapshotWidth = (u16)*(u16 *)(src + 128);
        BRUSH_SnapshotDepth = (u8)src[136];
        {
            u8 *d = BRUSH_SnapshotHeader;
            const u8 *s = src;
            do {
                *d++ = *s;
            } while (*s++ != 0);
        }
        _LVOPermit();
        status_fail = 1;
    }

    if (status_fail == 0) {
        node = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_11, 1064, 372, 0x10001u);
        if (node != 0) {
            u8 *d = node;
            const u8 *s = src;
            do {
                *d++ = *s;
            } while (*s++ != 0);

            _LVOInitBitMap(node + 136, (u8)node[184], (u16)*(u16 *)(node + 176), (u16)*(u16 *)(node + 178));
            for (i = 0; i < (s32)(u8)node[184] && i < 5; i++) {
                void *plane = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
                    Global_STR_BRUSH_C_12, 1134, i << 2, (u16)*(u16 *)(node + 176), (u16)*(u16 *)(node + 178));
                *(void **)(node + 0x90 + (i << 2)) = plane;
                if (plane == 0) {
                    _LVOForbid();
                    if (BRUSH_PendingAlertCode == 0) {
                        BRUSH_PendingAlertCode = 1;
                    }
                    _LVOPermit();
                    break;
                }
            }

            if (i != (s32)(u8)node[184]) {
                while (i < 5) {
                    void *plane = *(void **)(node + 0x90 + (i << 2));
                    if (plane != 0) {
                        GROUP_AB_JMPTBL_GRAPHICS_FreeRaster(
                            Global_STR_BRUSH_C_13, 1202, plane, (u16)*(u16 *)(node + 176), (u16)*(u16 *)(node + 178));
                    }
                    i++;
                }
                GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_14, 1205, node, 372);
                node = 0;
            } else {
                _LVOInitRastPort(node + 36);
                *(void **)(node + 40) = node + 136;
                for (i = 0; i < 96; i++) {
                    node[232 + i] = src[32 + i];
                }

                row_words = GROUP_AG_JMPTBL_MATH_DivS32((u16)*(u16 *)(src + 128) + 15, 16) * 2;
                for (i = 0; i < (s32)(u16)*(u16 *)(node + 178); i++) {
                    s32 p;
                    for (p = 0; p < (s32)(u8)src[136]; p++) {
                        decode_cur = ESQ_PackBitsDecode(decode_cur, *(u8 **)(node + 0x90 + (p << 2)), row_words);
                    }
                }
            }
        }
    }

    if ((u8)src[190] == 11) {
        u8 *alt = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_15, 1220, 372, 0x10001u);
        if (alt != 0) {
            node = alt;
        }
    }

    if (decode_buf != 0) {
        GROUP_AG_JMPTBL_MEMORY_DeallocateMemory(Global_STR_BRUSH_C_16, 1236, decode_buf, 130000);
    }

    return node;
}
