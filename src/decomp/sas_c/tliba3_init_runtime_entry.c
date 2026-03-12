typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    VM_ZERO = 0,
    VM_RUNTIME_STRIDE = 154,
    VM_PLANE_PTR_COUNT = 6,
    VM_RPORT_COPY_LAST_INDEX = 24,
    VM_OFFSET_REG_BASE = 0,
    VM_OFFSET_WIDTH = 2,
    VM_OFFSET_HEIGHT = 4,
    VM_OFFSET_X = 6,
    VM_OFFSET_Y = 8,
    VM_OFFSET_RASTPORT = 10,
    VM_OFFSET_RASTPORT_BITMAP_PTR = 14,
    VM_OFFSET_BITMAP = 110,
    VM_OFFSET_BITMAP_PLANES = 118,
    VM_OFFSET_RESERVED150 = 150,
    VM_OFFSET_RESERVED152 = 152
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern char *Global_REF_RASTPORT_1;
extern ULONG WDISP_DisplayContextPlanePointer0[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern void _LVOInitBitMap(void *gfxBase, void *bitMap, LONG depth, LONG width, LONG height);

void TLIBA3_InitRuntimeEntry(
    LONG idx,
    LONG regBase,
    LONG width,
    LONG height,
    LONG x,
    LONG y,
    LONG depth)
{
    UBYTE *vm;
    LONG i;

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(idx, VM_RUNTIME_STRIDE);

    *(UWORD *)(vm + VM_OFFSET_REG_BASE) = (UWORD)regBase;
    *(UWORD *)(vm + VM_OFFSET_WIDTH) = (UWORD)width;
    *(UWORD *)(vm + VM_OFFSET_HEIGHT) = (UWORD)height;
    *(UWORD *)(vm + VM_OFFSET_X) = (UWORD)x;
    *(UWORD *)(vm + VM_OFFSET_Y) = (UWORD)y;

    {
        ULONG *src = (ULONG *)Global_REF_RASTPORT_1;
        ULONG *dst = (ULONG *)(vm + VM_OFFSET_RASTPORT);
        for (i = VM_ZERO; i <= VM_RPORT_COPY_LAST_INDEX; ++i) {
            dst[i] = src[i];
        }
    }

    *(UBYTE **)(vm + VM_OFFSET_RASTPORT_BITMAP_PTR) = vm + VM_OFFSET_BITMAP;

    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        vm + VM_OFFSET_BITMAP,
        (LONG)(UBYTE)depth,
        (LONG)(UWORD)width,
        (LONG)(UWORD)height);

    for (i = VM_ZERO; i < VM_PLANE_PTR_COUNT; ++i) {
        *(ULONG *)(vm + VM_OFFSET_BITMAP_PLANES + (i * sizeof(ULONG))) = WDISP_DisplayContextPlanePointer0[i];
    }

    *(UWORD *)(vm + VM_OFFSET_RESERVED150) = VM_ZERO;
    *(UWORD *)(vm + VM_OFFSET_RESERVED152) = VM_ZERO;
}
