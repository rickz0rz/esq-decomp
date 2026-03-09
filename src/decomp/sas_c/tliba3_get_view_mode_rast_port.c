typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern LONG MATH_Mulu32(LONG a, LONG b);

void *TLIBA3_GetViewModeRastPort(LONG viewModeIndex)
{
    UBYTE *viewMode;

    viewMode = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(viewModeIndex, 154);
    return (void *)(viewMode + 10);
}
