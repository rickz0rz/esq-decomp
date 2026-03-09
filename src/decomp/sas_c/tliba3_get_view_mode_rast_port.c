typedef signed long LONG;
typedef unsigned char UBYTE;

typedef struct TLIBA3_ViewModeRuntimeEntry {
    UBYTE pad0[10];
    char *rastPort10;
} TLIBA3_ViewModeRuntimeEntry;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

char *TLIBA3_GetViewModeRastPort(LONG viewModeIndex)
{
    TLIBA3_ViewModeRuntimeEntry *viewMode;

    viewMode = (TLIBA3_ViewModeRuntimeEntry *)(TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, 154));
    return viewMode->rastPort10;
}
