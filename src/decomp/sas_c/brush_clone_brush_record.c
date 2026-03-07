typedef unsigned char UBYTE;
typedef unsigned short UWORD;
typedef unsigned long ULONG;
typedef long LONG;

enum {
    BRUSH_NULL = 0,
    BRUSH_PENDING_ALERT_SET = 1,
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
        1248,
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
        *(ULONG *)(dst + 176 + (i * 4)) = *(ULONG *)(src + 128 + (i * 4));
    }
    *(ULONG *)(dst + 196) = *(ULONG *)(src + 148);
    *(ULONG *)(dst + 368) = BRUSH_NULL;

    _LVOInitBitMap(dst + 136, (UBYTE)dst[184], (UWORD)*(UWORD *)(dst + 176), (UWORD)*(UWORD *)(dst + 178));

    dst[32] = src[190];
    *(ULONG *)(dst + 328) = *(ULONG *)(src + 194);
    *(ULONG *)(dst + 332) = *(ULONG *)(src + 198);
    *(ULONG *)(dst + 336) = *(ULONG *)(src + 202);
    *(ULONG *)(dst + 340) = *(ULONG *)(src + 206);
    *(ULONG *)(dst + 344) = *(ULONG *)(src + 210);
    *(ULONG *)(dst + 356) = *(ULONG *)(src + 222);
    *(ULONG *)(dst + 360) = *(ULONG *)(src + 226);

    for (i = BRUSH_NULL; i < BRUSH_PLANE_PAIR_COPY_COUNT; i++) {
        *(ULONG *)(dst + 200 + (i * 8) + 0) = *(ULONG *)(src + 152 + (i * 8) + 0);
        *(ULONG *)(dst + 200 + (i * 8) + 4) = *(ULONG *)(src + 152 + (i * 8) + 4);
    }

    s = src + 191;
    d = dst + 33;
    do {
        *d++ = *s;
    } while (*s++ != BRUSH_NULL);

    *(ULONG *)(dst + 364) = *(ULONG *)(src + 230);

    if (*(ULONG *)(src + 214) != BRUSH_NULL) {
        *(ULONG *)(dst + 348) = *(ULONG *)(src + 214);
    } else {
        *(ULONG *)(dst + 348) = (UWORD)*(UWORD *)(dst + 176);
    }

    if (*(ULONG *)(src + 218) != BRUSH_NULL) {
        *(ULONG *)(dst + 352) = *(ULONG *)(src + 218);
    } else {
        *(ULONG *)(dst + 352) = (UWORD)*(UWORD *)(dst + 178);
    }

    for (i = BRUSH_NULL; i < (LONG)(UBYTE)dst[184] && i < BRUSH_PLANE_COUNT; i++) {
        void *p;
        LONG plane_off = i << 2;
        p = GROUP_AA_JMPTBL_GRAPHICS_AllocRaster(
            Global_STR_BRUSH_C_18,
            1302,
            plane_off,
            (UWORD)*(UWORD *)(dst + 176),
            (UWORD)*(UWORD *)(dst + 178));
        *(void **)(dst + 0x90 + plane_off) = p;
        if (p == (void *)BRUSH_NULL) {
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

    if (i == (LONG)(UBYTE)dst[184]) {
        _LVOInitRastPort(dst + 36);
        *(void **)(dst + 40) = dst + 136;
        for (i = BRUSH_NULL; i < BRUSH_RASTPORT_COPY_BYTES; i++) {
            dst[232 + i] = src[32 + i];
        }
    }

    return (void *)dst;
}
