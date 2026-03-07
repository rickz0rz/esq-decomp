typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE TLIBA3_VmArrayRuntimeTable[];
extern void *Global_REF_GRAPHICS_LIBRARY;

extern LONG MATH_Mulu32(LONG left, LONG right);
extern LONG _LVOSetFont(void *gfxBase, void *rastPort, void *font);

void TLIBA3_SetFontForAllViewModes(void *font)
{
    LONG i;

    for (i = 0; i < 10; ++i) {
        UBYTE *vm = TLIBA3_VmArrayRuntimeTable + MATH_Mulu32(i, 154);
        _LVOSetFont(Global_REF_GRAPHICS_LIBRARY, vm + 10, font);
    }
}
