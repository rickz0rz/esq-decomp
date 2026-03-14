#include <exec/types.h>
extern void GCOMMAND_SetPresetEntry(LONG row, LONG value);

void GCOMMAND_ExpandPresetBlock(UBYTE *packed)
{
    LONG row;

    for (row = 4; row < 8; ++row) {
        LONG col;
        LONG value = 0;

        for (col = 0; col < 3; ++col) {
            LONG shift = (2 - col) << 2;
            LONG nibble = ((LONG)packed[(row * 3) + col] << shift) & (15L << shift);
            value += nibble;
        }

        GCOMMAND_SetPresetEntry(row, (LONG)(unsigned short)value);
    }
}
