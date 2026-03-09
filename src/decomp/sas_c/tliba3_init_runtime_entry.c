typedef signed long LONG;
typedef unsigned long ULONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

typedef struct TLIBA3_RastPort {
    ULONG longs[25];
} TLIBA3_RastPort;

typedef struct TLIBA3_BitMap {
    UBYTE pad0[8];
    ULONG planePtrs[6];
} TLIBA3_BitMap;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UWORD regBase0;
    UWORD width2;
    UWORD height4;
    UWORD x6;
    UWORD y8;
    TLIBA3_RastPort rastPort10;
    TLIBA3_BitMap *bitmapPtrSlot110;
    TLIBA3_BitMap bitmap114;
    UWORD reserved150;
    UWORD reserved152;
} TLIBA3_ViewModeRuntimeEntry;

enum {
    VM_ZERO = 0,
    VM_RUNTIME_STRIDE = 154,
    VM_PLANE_PTR_COUNT = 6,
    VM_RPORT_COPY_LAST_INDEX = 24
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern char *Global_REF_RASTPORT_1;
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
    TLIBA3_ViewModeRuntimeEntry *vm;
    LONG i;

    vm = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(idx, VM_RUNTIME_STRIDE));

    vm->regBase0 = (UWORD)regBase;
    vm->width2 = (UWORD)width;
    vm->height4 = (UWORD)height;
    vm->x6 = (UWORD)x;
    vm->y8 = (UWORD)y;

    {
        ULONG *src = (ULONG *)Global_REF_RASTPORT_1;
        ULONG *dst = vm->rastPort10.longs;
        for (i = VM_ZERO; i <= VM_RPORT_COPY_LAST_INDEX; ++i) {
            dst[i] = src[i];
        }
    }

    vm->bitmapPtrSlot110 = &vm->bitmap114;

    _LVOInitBitMap(
        Global_REF_GRAPHICS_LIBRARY,
        &vm->bitmap114,
        (LONG)(UBYTE)depth,
        (LONG)(UWORD)width,
        (LONG)(UWORD)height);

    for (i = VM_ZERO; i < VM_PLANE_PTR_COUNT; ++i) {
        vm->bitmap114.planePtrs[i] = WDISP_DisplayContextPlanePointer0[i];
    }

    vm->reserved150 = VM_ZERO;
    vm->reserved152 = VM_ZERO;
}
