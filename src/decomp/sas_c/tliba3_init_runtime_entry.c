typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

enum {
    VM_ZERO = 0,
    VM_RUNTIME_STRIDE = 154,
    VM_REGBASE_OFFSET = 0,
    VM_WIDTH_OFFSET = 2,
    VM_HEIGHT_OFFSET = 4,
    VM_X_OFFSET = 6,
    VM_Y_OFFSET = 8,
    VM_RPORT_COPY_OFFSET = 10,
    VM_BITMAP_PTR_SLOT_OFFSET = 14,
    VM_BITMAP_OFFSET = 110,
    VM_PLANE_PTR_BASE_OFFSET = 118,
    VM_PLANE_PTR_STRIDE = 4,
    VM_PLANE_PTR_COUNT = 6,
    VM_RESERVED0_OFFSET = 150,
    VM_RESERVED1_OFFSET = 152,
    VM_RPORT_COPY_LAST_INDEX = 24
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_RASTPORT_1;
extern ULONG WDISP_DisplayContextPlanePointer0[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOInitBitMap(void *gfxBase, void *bitMap, LONG depth, LONG width, LONG height);

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

    *(UWORD *)(vm + VM_REGBASE_OFFSET) = (UWORD)regBase;
    *(UWORD *)(vm + VM_WIDTH_OFFSET) = (UWORD)width;
    *(UWORD *)(vm + VM_HEIGHT_OFFSET) = (UWORD)height;
    *(UWORD *)(vm + VM_X_OFFSET) = (UWORD)x;
    *(UWORD *)(vm + VM_Y_OFFSET) = (UWORD)y;

    {
        ULONG *src = (ULONG *)Global_REF_RASTPORT_1;
        ULONG *dst = (ULONG *)(vm + VM_RPORT_COPY_OFFSET);
        for (i = VM_ZERO; i <= VM_RPORT_COPY_LAST_INDEX; ++i) {
            dst[i] = src[i];
        }
    }

    *(ULONG *)(vm + VM_BITMAP_PTR_SLOT_OFFSET) = (ULONG)(vm + VM_BITMAP_OFFSET);

    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        vm + VM_BITMAP_OFFSET,
        (LONG)(UBYTE)depth,
        (LONG)(UWORD)width,
        (LONG)(UWORD)height);

    for (i = VM_ZERO; i < VM_PLANE_PTR_COUNT; ++i) {
        *(ULONG *)(vm + VM_PLANE_PTR_BASE_OFFSET + (i * VM_PLANE_PTR_STRIDE)) =
            WDISP_DisplayContextPlanePointer0[i];
    }

    *(UWORD *)(vm + VM_RESERVED0_OFFSET) = VM_ZERO;
    *(UWORD *)(vm + VM_RESERVED1_OFFSET) = VM_ZERO;
}
