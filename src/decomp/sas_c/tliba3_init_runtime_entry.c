typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

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

    vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(idx, 154);

    *(UWORD *)(vm + 0) = (UWORD)regBase;
    *(UWORD *)(vm + 2) = (UWORD)width;
    *(UWORD *)(vm + 4) = (UWORD)height;
    *(UWORD *)(vm + 6) = (UWORD)x;
    *(UWORD *)(vm + 8) = (UWORD)y;

    {
        ULONG *src = (ULONG *)Global_REF_RASTPORT_1;
        ULONG *dst = (ULONG *)(vm + 10);
        for (i = 0; i <= 24; ++i) {
            dst[i] = src[i];
        }
    }

    *(ULONG *)(vm + 14) = (ULONG)(vm + 110);

    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        vm + 110,
        (LONG)(UBYTE)depth,
        (LONG)(UWORD)width,
        (LONG)(UWORD)height);

    for (i = 0; i < 6; ++i) {
        *(ULONG *)(vm + 118 + (i * 4)) = WDISP_DisplayContextPlanePointer0[i];
    }

    *(UWORD *)(vm + 150) = 0;
    *(UWORD *)(vm + 152) = 0;
}
