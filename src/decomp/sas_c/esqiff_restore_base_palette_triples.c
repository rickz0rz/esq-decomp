#include <exec/types.h>
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE ESQFUNC_BasePaletteRgbTriples[];

void ESQIFF_RestoreBasePaletteTriples(void)
{
    UBYTE *dst;
    UBYTE *src;
    WORD i;

    dst = WDISP_PaletteTriplesRBase;
    src = ESQFUNC_BasePaletteRgbTriples;

    for (i = 0; i < 24; i++) {
        *dst = *src;
        dst++;
        src++;
    }
}
