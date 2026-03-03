#include "esq_types.h"

/*
 * Target 704 GCC trial function.
 * Clone brush metadata/raster pointers, allocate planes, and initialize rastport state.
 */
extern void *AbsExecBase;
extern void *Global_REF_GRAPHICS_LIBRARY;
extern u8 Global_STR_BRUSH_C_17[];
extern u8 Global_STR_BRUSH_C_18[];
extern s32 BRUSH_PendingAlertCode;
extern u8 BRUSH_SnapshotHeader[];

void *GROUP_AG_JMPTBL_MEMORY_AllocateMemory(const void *tag, s32 line, s32 bytes, u32 flags) __attribute__((noinline));
void *GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(const void *tag, s32 line, s32 plane_off, s32 width, s32 height) __attribute__((noinline));
void _LVOInitBitMap(void *bitmap, s32 depth, s32 width, s32 height) __attribute__((noinline));
void _LVOInitRastPort(void *rp) __attribute__((noinline));
void _LVOForbid(void) __attribute__((noinline));
void _LVOPermit(void) __attribute__((noinline));

void *BRUSH_CloneBrushRecord(void *src_rec) __attribute__((noinline, used));

void *BRUSH_CloneBrushRecord(void *src_rec)
{
    u8 *src = (u8 *)src_rec;
    u8 *dst;
    s32 i;
    const u8 *s;
    u8 *d;

    (void)AbsExecBase;
    (void)Global_REF_GRAPHICS_LIBRARY;
    dst = (u8 *)GROUP_AG_JMPTBL_MEMORY_AllocateMemory(Global_STR_BRUSH_C_17, 1248, 372, 0x10001u);
    if (dst == 0) {
        return 0;
    }

    s = src;
    d = dst;
    do {
        *d++ = *s;
    } while (*s++ != 0);

    for (i = 0; i <= 4; i++) {
        *(u32 *)(dst + 176 + (i * 4)) = *(u32 *)(src + 128 + (i * 4));
    }
    *(u32 *)(dst + 196) = *(u32 *)(src + 148);
    *(u32 *)(dst + 368) = 0;

    _LVOInitBitMap(dst + 136, (u8)dst[184], (u16)*(u16 *)(dst + 176), (u16)*(u16 *)(dst + 178));

    dst[32] = src[190];
    *(u32 *)(dst + 328) = *(u32 *)(src + 194);
    *(u32 *)(dst + 332) = *(u32 *)(src + 198);
    *(u32 *)(dst + 336) = *(u32 *)(src + 202);
    *(u32 *)(dst + 340) = *(u32 *)(src + 206);
    *(u32 *)(dst + 344) = *(u32 *)(src + 210);
    *(u32 *)(dst + 356) = *(u32 *)(src + 222);
    *(u32 *)(dst + 360) = *(u32 *)(src + 226);

    for (i = 0; i < 4; i++) {
        *(u32 *)(dst + 200 + (i * 8) + 0) = *(u32 *)(src + 152 + (i * 8) + 0);
        *(u32 *)(dst + 200 + (i * 8) + 4) = *(u32 *)(src + 152 + (i * 8) + 4);
    }

    s = src + 191;
    d = dst + 33;
    do {
        *d++ = *s;
    } while (*s++ != 0);

    *(u32 *)(dst + 364) = *(u32 *)(src + 230);

    if (*(u32 *)(src + 214) != 0) {
        *(u32 *)(dst + 348) = *(u32 *)(src + 214);
    } else {
        *(u32 *)(dst + 348) = (u16)*(u16 *)(dst + 176);
    }

    if (*(u32 *)(src + 218) != 0) {
        *(u32 *)(dst + 352) = *(u32 *)(src + 218);
    } else {
        *(u32 *)(dst + 352) = (u16)*(u16 *)(dst + 178);
    }

    for (i = 0; i < (s32)(u8)dst[184] && i < 5; i++) {
        void *p;
        s32 plane_off = i << 2;
        p = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
            Global_STR_BRUSH_C_18,
            1302,
            plane_off,
            (u16)*(u16 *)(dst + 176),
            (u16)*(u16 *)(dst + 178));
        *(void **)(dst + 0x90 + plane_off) = p;
        if (p == 0) {
            _LVOForbid();
            if (BRUSH_PendingAlertCode == 0) {
                const u8 *snap_s = dst;
                u8 *snap_d = BRUSH_SnapshotHeader;
                BRUSH_PendingAlertCode = 1;
                do {
                    *snap_d++ = *snap_s;
                } while (*snap_s++ != 0);
            }
            _LVOPermit();
            break;
        }
    }

    if (i == (s32)(u8)dst[184]) {
        _LVOInitRastPort(dst + 36);
        *(void **)(dst + 40) = dst + 136;
        for (i = 0; i < 96; i++) {
            dst[232 + i] = src[32 + i];
        }
    }

    return dst;
}
