typedef signed long LONG;
typedef unsigned short UWORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID_JMPTBL_MATH_Mulu32(LONG a, LONG b);
extern UWORD GCOMMAND_PresetSeedPackedWordTable[];

void GCOMMAND_InitPresetTableFromPalette(UWORD *presetTable)
{
    LONG row;

    for (row = 0; row < 16; ++row) {
        LONG col;
        UBYTE *rowBase = (UBYTE *)presetTable + (row << 7);
        UBYTE *seedBase = (UBYTE *)GCOMMAND_PresetSeedPackedWordTable + NEWGRID_JMPTBL_MATH_Mulu32(row, 62);

        presetTable[row] = 16;

        for (col = 0; col < (LONG)presetTable[row]; ++col) {
            UWORD *dst = (UWORD *)(rowBase + 32 + (col << 1));
            UWORD *src = (UWORD *)(seedBase + (col << 1));
            *dst = *src;
        }
    }
}
