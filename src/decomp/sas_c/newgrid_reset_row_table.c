#include <exec/types.h>
void NEWGRID_ResetRowTable(UBYTE *gridCtx)
{
    LONG rowIndex;

    rowIndex = 0;
    while (rowIndex < 4) {
        gridCtx[55 + rowIndex] = (UBYTE)(rowIndex + 4);
        *(LONG *)&gridCtx[36 + (rowIndex << 2)] = 0;
        rowIndex++;
    }
}
