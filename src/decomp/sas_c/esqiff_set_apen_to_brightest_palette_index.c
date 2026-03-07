typedef signed long LONG;
typedef unsigned char UBYTE;

extern UBYTE WDISP_PaletteDepthLog2;
extern UBYTE WDISP_PaletteTriplesRBase[];
extern UBYTE WDISP_PaletteTriplesGBase[];
extern UBYTE WDISP_PaletteTriplesBBase[];
extern void *Global_REF_RASTPORT_2;

extern void SetAPen(void *rastPort, LONG pen);

void ESQIFF_SetApenToBrightestPaletteIndex(void)
{
    LONG limit = 1L << WDISP_PaletteDepthLog2;
    LONG bestIndex = 0;
    LONG bestSum = (LONG)WDISP_PaletteTriplesRBase[0]
                 + (LONG)WDISP_PaletteTriplesGBase[0]
                 + (LONG)WDISP_PaletteTriplesBBase[0];
    LONG i;

    for (i = 1; i < limit; ++i) {
        LONG off = i * 3;
        LONG sum = (LONG)WDISP_PaletteTriplesRBase[off]
                 + (LONG)WDISP_PaletteTriplesGBase[off]
                 + (LONG)WDISP_PaletteTriplesBBase[off];
        if (sum > bestSum) {
            bestSum = sum;
            bestIndex = i;
        }
    }

    SetAPen(Global_REF_RASTPORT_2, bestIndex);
}
