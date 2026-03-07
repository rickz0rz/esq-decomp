typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitset, LONG bitIndex);

LONG NEWGRID_GetEntryStateCode(UBYTE *gridCtx, UBYTE *entryAuxBase, WORD rowIndex)
{
    LONG row;

    row = (LONG)rowIndex;
    if (gridCtx == 0 || entryAuxBase == 0 || row <= 0 || row >= 49) {
        return 1;
    }

    if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(gridCtx + 28, row) + 1 != 0) {
        return 0;
    }

    if (*(LONG *)(entryAuxBase + 56 + (row << 2)) == 0) {
        return 3;
    }

    if ((entryAuxBase[7 + row] & 0x80) == 0) {
        return 2;
    }

    return 3;
}
