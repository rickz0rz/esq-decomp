#ifndef TLIBA3_VIEW_MODE_TYPES_H
#define TLIBA3_VIEW_MODE_TYPES_H

#include <exec/types.h>

typedef struct TLIBA3_DimBlock {
    UWORD width;
    UWORD height;
} TLIBA3_DimBlock;

typedef struct TLIBA3_RastPortWrap {
    void *unused0;
    TLIBA3_DimBlock *dims;
} TLIBA3_RastPortWrap;

typedef struct TLIBA3_ViewModeRuntimeRasterEntry {
    UWORD flags0;
    UWORD width2;
    UWORD height4;
    WORD x6;
    UWORD y8;
    UBYTE rastPort10[1];
} TLIBA3_ViewModeRuntimeRasterEntry;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UWORD flags0;
    UWORD width2;
    UWORD height4;
    WORD x6;
    UWORD y8;
    UBYTE rastPort10[100];
    UBYTE bitMap110[8];
    ULONG planePtr118;
    ULONG planePtr122;
    ULONG planePtr126;
    ULONG planePtr130;
    ULONG planePtr134;
    UWORD reserved150;
    UWORD reserved152;
} TLIBA3_ViewModeRuntimeEntry;

enum {
    TLIBA3_VM_PATTERN_STRIDE = 76,
    TLIBA3_VM_RUNTIME_COUNT = 10,
    TLIBA3_VM_RUNTIME_STRIDE = 154
};

#endif
