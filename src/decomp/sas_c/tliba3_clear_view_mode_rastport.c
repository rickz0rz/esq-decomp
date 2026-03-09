typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UBYTE pad0[10];
    UBYTE rastPort10[1];
} TLIBA3_ViewModeRuntimeEntry;

enum {
    VM_RUNTIME_STRIDE = 154
};

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetRast(void *gfxBase, char *rastPort, LONG pen);

void TLIBA3_ClearViewModeRastPort(LONG viewMode, LONG clearPen)
{
    LONG offset;
    TLIBA3_ViewModeRuntimeEntry *viewRec;

    offset = MATH_Mulu32(viewMode, VM_RUNTIME_STRIDE);
    viewRec = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + offset);
    _LVOSetRast(Global_REF_GRAPHICS_LIBRARY, (char *)viewRec->rastPort10, clearPen);
}
