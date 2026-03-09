typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

LONG TLIBA3_GetViewModeHeight(LONG viewModeIndex)
{
    UBYTE *viewMode;

    viewMode = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, 154);
    return (LONG)*(WORD *)(viewMode + 4);
}
