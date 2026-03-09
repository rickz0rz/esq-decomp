typedef signed long LONG;
typedef signed short WORD;
typedef unsigned char UBYTE;

typedef struct NEWGRID_Entry {
    UBYTE pad0[28];
    UBYTE selectionBits[1];
} NEWGRID_Entry;

typedef struct NEWGRID_AuxData {
    UBYTE pad0[7];
    UBYTE rowFlags[49];
    UBYTE pad1[0x38 - 0x38];
    UBYTE *titleTable[49];
} NEWGRID_AuxData;

extern LONG NEWGRID2_JMPTBL_ESQ_TestBit1Based(UBYTE *bitset, LONG bitIndex);

LONG NEWGRID_GetEntryStateCode(UBYTE *gridCtx, UBYTE *entryAuxBase, WORD rowIndex)
{
    NEWGRID_Entry *entry;
    NEWGRID_AuxData *aux;
    LONG row;

    row = (LONG)rowIndex;
    if (gridCtx == 0 || entryAuxBase == 0 || row <= 0 || row >= 49) {
        return 1;
    }

    entry = (NEWGRID_Entry *)gridCtx;
    aux = (NEWGRID_AuxData *)entryAuxBase;

    if (NEWGRID2_JMPTBL_ESQ_TestBit1Based(entry->selectionBits, row) + 1 != 0) {
        return 0;
    }

    if (aux->titleTable[row] == 0) {
        return 3;
    }

    if ((aux->rowFlags[row] & 0x80) == 0) {
        return 2;
    }

    return 3;
}
